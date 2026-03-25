#!/bin/bash

echo "=== Lab 11: SQL Injection Mitigation ==="

# Create project directory
mkdir -p ~/sqli_lab
cd ~/sqli_lab

# Install dependencies
pip3 install flask requests

echo "=== Creating Vulnerable Application ==="
cat > vulnerable_app.py << 'EOF'
#!/usr/bin/env python3
from flask import Flask, request, render_template_string
import sqlite3

app = Flask(__name__)

def init_db():
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    cursor.execute("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, username TEXT, password TEXT, email TEXT)")
    cursor.execute("INSERT INTO users (username, password, email) VALUES ('admin','admin123','admin@test.com')")
    cursor.execute("INSERT INTO users (username, password, email) VALUES ('john','pass123','john@test.com')")
    cursor.execute("INSERT INTO users (username, password, email) VALUES ('jane','secret456','jane@test.com')")
    conn.commit()
    conn.close()

@app.route('/')
def home():
    return '''
    <h2>Vulnerable Login</h2>
    <form method="POST" action="/login">
    Username: <input name="username"><br>
    Password: <input name="password"><br>
    <input type="submit">
    </form>
    <hr>
    <form method="GET" action="/search">
    Search: <input name="query">
    <input type="submit">
    </form>
    '''

@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    query = f"SELECT * FROM users WHERE username='{username}' AND password='{password}'"
    result = cursor.execute(query).fetchone()
    conn.close()
    return f"Query: {query}<br>Login {'Success' if result else 'Failed'}"

@app.route('/search')
def search():
    query_param = request.args.get('query','')
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    query = f"SELECT username,email FROM users WHERE username LIKE '%{query_param}%'"
    results = cursor.execute(query).fetchall()
    conn.close()
    return f"Query: {query}<br>Results: {results}"

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5000)
EOF

chmod +x vulnerable_app.py

echo "=== Creating SQL Injection Detector ==="
cat > sqli_detector.py << 'EOF'
#!/usr/bin/env python3
import requests

payloads = [
    "'",
    "' OR '1'='1",
    "admin'--",
    "' UNION SELECT 1,2,3--"
]

base_url = "http://localhost:5000"

print("SQL Injection Scanner")
print("="*40)

for payload in payloads:
    r = requests.get(base_url + "/search", params={"query": payload})
    if "Results" in r.text:
        print(f"Possible SQL Injection with payload: {payload}")

with open("sqli_report.txt","w") as f:
    f.write("SQL Injection Scan Completed\n")
EOF

chmod +x sqli_detector.py

echo "=== Creating Secure Application ==="
cat > secure_app.py << 'EOF'
#!/usr/bin/env python3
from flask import Flask, request
import sqlite3
import hashlib

app = Flask(__name__)

def init_db():
    conn = sqlite3.connect('secure_users.db')
    cursor = conn.cursor()
    cursor.execute("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, username TEXT, password_hash TEXT, email TEXT)")
    
    password = hashlib.sha256("admin123".encode()).hexdigest()
    cursor.execute("INSERT INTO users (username,password_hash,email) VALUES (?,?,?)", ("admin",password,"admin@test.com"))
    
    conn.commit()
    conn.close()

@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = hashlib.sha256(request.form['password'].encode()).hexdigest()
    
    conn = sqlite3.connect('secure_users.db')
    cursor = conn.cursor()
    query = "SELECT * FROM users WHERE username=? AND password_hash=?"
    result = cursor.execute(query,(username,password)).fetchone()
    conn.close()
    
    return "Login Success" if result else "Login Failed"

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5001)
EOF

chmod +x secure_app.py

echo "=== Creating Test Script ==="
cat > test_secure_app.py << 'EOF'
#!/usr/bin/env python3
import requests

url = "http://localhost:5001/login"

payloads = [
    "admin'--",
    "' OR '1'='1",
    "' UNION SELECT 1,2,3--"
]

for payload in payloads:
    r = requests.post(url, data={"username": payload, "password": "test"})
    print(payload, r.text)
EOF

chmod +x test_secure_app.py

echo "=== Setup Completed ==="
echo "Run vulnerable app:"
echo "python3 vulnerable_app.py &"
echo "Run scanner:"
echo "python3 sqli_detector.py"
echo "Run secure app:"
echo "python3 secure_app.py &"
echo "Test secure app:"
echo "python3 test_secure_app.py"
