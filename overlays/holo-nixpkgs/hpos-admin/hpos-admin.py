from flask import Flask, jsonify, request
import json
import os
import subprocess

STATE_PATH = 'hpos-state.json'
app = Flask(__name__)


def get_state_data():
    with open(STATE_PATH, 'r') as f:
        return json.loads(f.read())


@app.route('/v1/config', methods=['GET'])
def get_config():
    return jsonify(get_state_data()['v1']['config'])


# TODO: handle x-hpos-admin-cas header
@app.route('/v1/config', methods=['PUT'])
def put_config():
    state = get_state_data()
    state['v1']['config'] = request.get_json(force=True)
    with open(STATE_PATH + '.tmp', 'w') as f:
        f.write(json.dumps(state, indent=2))
        os.rename(f.name, STATE_PATH)
    return ("", 200)


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
    return ("", 200)


if __name__ == '__main__':
    from gevent.pywsgi import WSGIServer
    WSGIServer(('::1', 5000), app).serve_forever()
