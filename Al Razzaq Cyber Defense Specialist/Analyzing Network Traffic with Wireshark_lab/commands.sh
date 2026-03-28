#!/bin/bash

echo "=== Lab 3: Network Traffic Analysis with Wireshark ==="

echo "Updating system..."
sudo apt update

echo "Installing Wireshark and networking tools..."
sudo apt install -y wireshark tshark curl wget dnsutils

echo "Adding user to wireshark group..."
sudo usermod -a -G wireshark $USER
newgrp wireshark

echo "Configuring Wireshark for non-root capture..."
sudo dpkg-reconfigure wireshark-common
sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap

echo "Listing network interfaces..."
ip link show
tshark -D

echo "Starting DNS traffic capture..."
sudo tshark -i eth0 -f "port 53" -w /tmp/dns_traffic.pcap -c 50

echo "Generating DNS traffic..."
nslookup google.com
nslookup facebook.com
nslookup suspicious.example.com
nslookup malware.test.com

echo "Capturing HTTP traffic..."
sudo tshark -i eth0 -f "port 80" -w /tmp/http_traffic.pcap -c 50

echo "Generating HTTP traffic..."
curl -v http://httpbin.org/get
curl -v http://httpbin.org/user-agent

echo "Capturing HTTPS/TLS traffic..."
sudo tshark -i eth0 -f "port 443" -w /tmp/tls_traffic.pcap -c 50

echo "Generating HTTPS traffic..."
curl -v https://www.google.com
curl -v https://httpbin.org/get
curl -k -v https://self-signed.badssl.com/

echo "Running DNS analysis..."
/tmp/analyze_dns.sh 2>/dev/null

echo "Running HTTP analysis..."
/tmp/analyze_http.sh 2>/dev/null

echo "Running TLS analysis..."
/tmp/analyze_tls.sh 2>/dev/null

echo "Generating comprehensive report..."
/tmp/comprehensive_analysis.sh 2>/dev/null

echo "Generating traffic statistics..."
/tmp/traffic_stats.sh 2>/dev/null

echo "Exporting results..."
/tmp/export_results.sh 2>/dev/null

echo "=== Lab Completed ==="
