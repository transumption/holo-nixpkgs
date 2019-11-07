from base64 import b64encode
from flask import Flask, jsonify, request
from hashlib import sha512
import json
import os
import subprocess

app = Flask(__name__)


def get_state_path():
    return os.getenv('HPOS_STATE_PATH')


def get_state_data():
    with open(get_state_path(), 'r') as f:
        return json.loads(f.read())


@app.route('/v1/config', methods=['GET'])
def get_config():
    return jsonify(get_state_data()['v1']['config'])


def cas_hash(data):
    dump = json.dumps(data, separators=(',', ':'), sort_keys=True)
    return b64encode(sha512(dump.encode()).digest())


@app.route('/v1/config', methods=['PUT'])
def put_config():
    state = get_state_data()
    if request.headers['x-hpos-admin-cas'] == cas_hash(state['v1']['config']):
        state['v1']['config'] = request.get_json(force=True)
        with open(get_state_path() + '.tmp', 'w') as f:
            f.write(json.dumps(state, indent=2))
            os.rename(f.name, get_state_path())
        subprocess.Popen(['sudo', 'nixos-rebuild', 'switch'])
        return '', 200
    else:
        return '', 409


def zerotier_info():
    proc = subprocess.run(['sudo', 'zerotier-cli', '-j',
                           'info'], capture_output=True)
    return json.loads(proc.stdout)


@app.route('/v1/status', methods=['GET'])
def status():
    return jsonify({
        'zerotier': zerotier_info()
    })


@app.route('/v1/upgrade', methods=['POST'])
def upgrade():
    subprocess.Popen(['sudo', 'nixos-rebuild', '--upgrade', 'switch'])
    return '', 200


if __name__ == '__main__':
    from gevent.pywsgi import WSGIServer
    WSGIServer(('::1', 5000), app).serve_forever()
