import functools

from flask import (render_template, request, session, g, redirect,
                   url_for, abort, jsonify)

from qciweb import app
from models import User, Group, Node, Session

MODEL_MAP = { "user": User, "group": Group, "node": Node }

## Database Cleanup
@app.after_request
def shutdown_session(response):
    Session.remove()
    return response

## User Views

def node_list():
    pass

def node_detail():
    pass

def location_view():
    pass

## API Views

@app.route('/api/<type>/<id>')
def api(type, id=None):
    if id:
        return jsonify(MODEL_MAP[type].query.get(id).flat())
    return jsonify(MODEL_MAP[type].listing())
