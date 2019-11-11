from base64 import b64encode
from flask import Flask, jsonify, request
from gevent import subprocess, pywsgi, queue, spawn, lock
from hashlib import sha512
from schema import Schema, And, Use, Optional
from tempfile import mkstemp
import json
import logging
import os

app = Flask(__name__)
log = logging.getLogger(__name__)
rebuild_queue = queue.PriorityQueue()
state_lock = lock.Semaphore(1)


def rebuild_worker():
    while True:
        (pri, cmd) = rebuild_queue.get()
        rebuild_queue.queue.clear()
        try:
            log.info(f"Running (priority {pri}): {cmd!r}")
            subprocess.run(cmd, check=True)
        except Exception as exc:
            log.warning(f"Exception: {exc}")

def rebuild(*args, priority=1):
    """Schedule a rebuild, w/ optional args; the highest priority instance waiting gets executed."""
    rebuild_queue.put((priority, ['sudo', 'nixos-rebuild', 'switch'] + list(args)))


def get_state_path():
    return os.getenv('HPOS_STATE_PATH')


def get_state_data():
    with open(get_state_path(), 'r') as f:
        return json.loads(f.read())


def cas_hash(data):
    dump = json.dumps(data, separators=(',', ':'), sort_keys=True)
    return b64encode(sha512(dump.encode()).digest()).decode()


@app.route('/v1/config', methods=['GET'])
def get_config():
    config = get_state_data()['v1']['config']
    return jsonify(config), 200, {'x-hpos-admin-cas': cas_hash(config)}


def replace_file_contents(path, data):
    fd, tmp_path = mkstemp(dir=os.path.dirname(path))
    with open(fd, 'w') as f:
        f.write(data)
    os.rename(tmp_path, path)


config_schema = Schema({
    'admin': {
        'email':  And(str, lambda s: '@' in s),
        'public_key':  And(str, len),
    },
    Optional('name'): And(str, len),
    Optional('holoportos'): {
        Optional('network'): And(str, Use(str.lower), lambda s: s in ('live', 'dev', 'test')),
        Optional('sshAccess'): bool,
    },
})


def merge(dst, src):
    """Recursively merges src into dst."""
    if not isinstance(dst, dict) or not isinstance(src, dict):
        return src
    for k in src:
        if k in dst:
            dst[k] = merge(dst[k], src[k])
        else:
            dst[k] = src[k]
    return dst


@app.route('/v1/config', methods=['PUT','POST'])
def put_config():
    """Replace current config with complete replacement (PUT), or partial update (POST)"""
    config = request.get_json(force=True)
    with state_lock:
        state = get_state_data()
        if request.headers.get('x-hpos-admin-cas') != cas_hash(state['v1']['config']):
            return '', 409
        if request.method == 'POST':
            config = merge(state['v1']['config'], config)
        state['v1']['config'] = config_schema.validate(config)
        replace_file_contents(get_state_path(), json.dumps(state, indent=2))
    rebuild(priority=5)
    return '', 200


def zerotier_info():
    proc = subprocess.run(['sudo', 'zerotier-cli', '-j', 'info'],
                          capture_output=True, check=True)
    return json.loads(proc.stdout)


@app.route('/v1/status', methods=['GET'])
def status():
    return jsonify({
        'zerotier': zerotier_info()
    })


@app.route('/v1/upgrade', methods=['POST'])
def upgrade():
    rebuild('--upgrade', priority=1)
    return '', 200


if __name__ == '__main__':
    logging.basicConfig(level=logging.WARNING)
    spawn(rebuild_worker)
    pywsgi.WSGIServer(('::1', 5000), app).serve_forever()
