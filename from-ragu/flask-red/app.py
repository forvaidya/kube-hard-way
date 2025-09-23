# app.py
from flask import Flask
import os
from markupsafe import escape

app = Flask(__name__)

@app.route("/")
def hello():
    message = os.getenv("HELLO_MSG", "Hello World")
    return f"<h1 style='color:red'>{escape(message)}</h1>"
