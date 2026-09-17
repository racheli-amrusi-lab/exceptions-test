import os
import sqlite3
import pickle
import hashlib
import tempfile
import urllib.request
from flask import Flask, request, render_template_string

app = Flask(__name__)

# 1. SQL Injection
@app.route('/user')
def finding_1():
    user_id = request.args.get('id')
    conn = sqlite3.connect('app.db')
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE id = " + user_id)
    return cursor.fetchall()

# 2. Command Injection
@app.route('/ping')
def finding_2():
    host = request.args.get('host')
    os.system("ping -c 1 " + host)

# 3. Reflected Cross-Site Scripting (XSS)
@app.route('/greet')
def finding_3():
    name = request.args.get('name', '')
    return render_template_string('<h1>Hello ' + name + '</h1>')

# 4. Path Traversal
@app.route('/read')
def finding_4():
    filename = request.args.get('file')
    with open("/var/www/uploads/" + filename, "r") as f:
        return f.read()

# 5. Insecure Deserialization
@app.route('/load')
def finding_5():
    data = request.args.get('data')
    return pickle.loads(data.encode())

# 6. Weak Cryptographic Hash Function (MD5)
def finding_6(password):
    return hashlib.md5(password.encode()).hexdigest()

# 7. Server-Side Request Forgery (SSRF)
@app.route('/fetch')
def finding_7():
    url = request.args.get('url')
    response = urllib.request.urlopen(url)
    return response.read()

# 8. Hardcoded Encryption Key
def finding_8():
    SECRET_ENCRYPTION_KEY = b"MySuperSecretKey"
    return SECRET_ENCRYPTION_KEY

# 9. Insecure Temporary File Creation
def finding_9():
    temp_file = tempfile.mktemp()
    with open(temp_file, "w") as f:
        f.write("sensitive data")

# 10. Disabled SSL Verification
def finding_10(target_url):
    import requests
    return requests.get(target_url, verify=False)
