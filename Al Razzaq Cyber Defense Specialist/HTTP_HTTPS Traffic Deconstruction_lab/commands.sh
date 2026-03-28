#!/bin/bash

echo "=== HTTP/HTTPS Traffic Analysis Lab ==="

echo "Creating working directory..."
mkdir -p ~/http_analysis_lab
cd ~/http_analysis_lab

echo "Creating test HTML file..."
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>HTTP Analysis Lab</title></head>
<body><h1>Test Server</h1></body>
</html>
EOF

echo "Starting local HTTP server..."
python3 -m http.server 8080 &
SERVER_PID=$!
echo "Server PID: $SERVER_PID"

sleep 2

echo "Capturing HTTP traffic..."
sudo tcpdump -i lo -w http_traffic.pcap port 8080 &
TCPDUMP_PID=$!

sleep 2

echo "Generating HTTP requests..."
curl -v http://localhost:8080/
curl -v -H "User-Agent: TestBot/1.0" http://localhost:8080/
curl -v -X POST -d "username=admin&password=test" http://localhost:8080/login
curl -v http://localhost:8080/../../etc/passwd
curl -v "http://localhost:8080/search?q=<script>alert('xss')</script>"

sleep 2

echo "Stopping packet capture..."
sudo kill $TCPDUMP_PID

echo "Extracting HTTP requests..."
tcpdump -r http_traffic.pcap -A -s 0 > http_requests.txt

echo "HTTP Methods Used:"
grep -E "^(GET|POST|PUT|DELETE)" http_requests.txt

echo "User Agents Found:"
grep -i "user-agent:" http_requests.txt

echo "Counting request types..."
grep -E "^(GET|POST)" http_requests.txt | awk '{print $1}' | sort | uniq -c

echo "Creating test request data..."
cat > test_requests.txt << 'EOF'
GET / HTTP/1.1
Host: localhost:8080
User-Agent: Mozilla/5.0

POST /login HTTP/1.1
Host: localhost:8080
User-Agent: AttackBot/1.0
Content-Length: 50

GET /admin' OR '1'='1 HTTP/1.1
Host: localhost:8080

GET /../../../etc/passwd HTTP/1.1
Host: localhost:8080
X-Forwarded-For: 10.0.0.1
EOF

echo "Analyzing SSL certificates..."
echo | openssl s_client -connect www.google.com:443 -servername www.google.com 2>/dev/null | openssl x509 -noout -text | grep -E "(Issuer:|Subject:|Not After)"

echo "Measuring HTTPS connection timing..."
curl -w "\nDNS Lookup: %{time_namelookup}s\nTCP Connect: %{time_connect}s\nTLS Handshake: %{time_appconnect}s\nTotal Time: %{time_total}s\n" -o /dev/null -s https://www.google.com

echo "Capturing HTTPS flows..."
sudo timeout 20 tcpdump -i any -w https_flows.pcap port 443

echo "Analyzing HTTPS flows..."
tcpdump -r https_flows.pcap -n | head -20

echo "Counting HTTPS destinations..."
tcpdump -r https_flows.pcap -n 2>/dev/null | grep -E "\.443" | awk '{print $3, $5}' | sort | uniq -c | sort -rn

echo "Calculating average packet size..."
tcpdump -r https_flows.pcap -n 2>/dev/null | grep -oP 'length \K[0-9]+' | awk '{sum+=$1; count++} END {print "Average packet size:", sum/count, "bytes"}'

echo "Lab Completed."
