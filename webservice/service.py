from flask import Flask, jsonify 
from flask import request
from flask import make_response
from flask import redirect
from flask_cors import CORS, cross_origin
import subprocess
import os

app = Flask(__name__)
CORS(app)

@app.route('/')
def Main():
    return 'online'

@app.route('/addqueue/', methods=['GET'])
def add():
    command = 'pueue add "docker run -v /var/bigbluebutton/:/var/bigbluebutton/ -v /usr/local/bigbluebutton/core/scripts/:/usr/local/bigbluebutton/core/scripts/ bedrettinyuce/bbbrecorder-s3 -p ' + request.values.get('playback') + ' -m ' + request.values.get('externalId') + '"'
    p = subprocess.Popen(command, stdout=subprocess.PIPE, shell=True)
    out = p.communicate()[0]
    #app.logger.info(out)
    if out.find('added') != -1:
        status = 'queued'
    else:
        status = 'failed'
    params = {
        'status': status,
        'playback': request.values.get('playback'),
        'externalId': request.values.get('externalId')
    }
    return jsonify(params)
if __name__ == "__main__":
    app.run(threaded=True, debug = True, host = "0.0.0.0")
