#!/bin/bash

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Installing Suricata and dependencies..."
sudo apt install suricata suricata-update jq curl nmap dnsutils -y

echo "Checking Suricata version..."
suricata --version

echo "Updating Suricata rules..."
sudo suricata-update

echo "Creating custom rules directory..."
sudo mkdir -p /etc/suricata/rules/custom

echo "Testing Suricata configuration..."
sudo suricata -T -c /etc/suricata/suricata.yaml -v

echo "Starting Suricata..."
sudo systemctl start suricata
sudo systemctl enable suricata

echo "Generating ICMP traffic..."
ping -c 5 8.8.8.8

echo "Generating HTTP traffic..."
curl -s "http://httpbin.org/get?malware=test" > /dev/null

echo "Simulating SSH brute force attempts..."
for i in {1..6}; do
    timeout 2 nc -z 127.0.0.1 22
    sleep 1
done

echo "Generating DNS queries..."
dig @8.8.8.8 malicious.example.com
dig @8.8.8.8 test-malware.com

echo "Checking Suricata alerts..."
sudo tail -20 /var/log/suricata/fast.log

echo "Checking Suricata JSON logs..."
sudo tail -20 /var/log/suricata/eve.json | jq '.'

echo "Counting alert signatures..."
sudo cat /var/log/suricata/eve.json | jq -r 'select(.event_type=="alert") | .alert.signature' | sort | uniq -c

echo "Lab Completed."
