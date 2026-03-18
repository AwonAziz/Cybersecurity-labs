```bash
#!/bin/bash

# Lab 9: Basic Threat Simulation

set -e

echo "Updating package list..."
sudo apt update

echo "Installing required packages..."
sudo apt install -y nmap python3-pip jq

echo "Installing Python dependency..."
pip3 install python-nmap

echo "Creating lab directory..."
mkdir -p ~/basic_threat_simulation
cd ~/basic_threat_simulation

echo "Starting local target services..."
sudo systemctl start ssh || true
sudo systemctl start apache2 || true

echo "Checking service status..."
sudo systemctl status ssh --no-pager || true
sudo systemctl status apache2 --no-pager || true

echo "Verifying Nmap installation..."
nmap --version

echo "Running basic Nmap scans..."
nmap 127.0.0.1
nmap -F 127.0.0.1
nmap -p 22,80,443,8080 127.0.0.1
nmap -p- 127.0.0.1

echo "Running TCP/UDP scans..."
nmap -sS 127.0.0.1
sudo nmap -sU 127.0.0.1 || true
sudo nmap -sS -sU 127.0.0.1 || true

echo "Running service and OS detection..."
nmap -sV 127.0.0.1
nmap -sV --version-intensity 9 127.0.0.1
sudo nmap -O 127.0.0.1 || true
sudo nmap -O -sV 127.0.0.1 || true

echo "Running script scans..."
nmap -sC 127.0.0.1
nmap --script http-enum 127.0.0.1 || true
nmap --script vuln 127.0.0.1 || true

echo "Running comprehensive scan and saving output..."
sudo nmap -A 127.0.0.1 -oA comprehensive_scan || true

echo "Make sure these Python files exist before running them:"
echo "  - basic_scanner.py"
echo "  - advanced_scanner.py"
echo "  - generate_dashboard.py"

echo "Making Python scripts executable..."
chmod +x basic_scanner.py 2>/dev/null || true
chmod +x advanced_scanner.py 2>/dev/null || true
chmod +x generate_dashboard.py 2>/dev/null || true

echo "Running basic scanner..."
python3 basic_scanner.py || true

echo "Running advanced scanner..."
python3 advanced_scanner.py || true

echo "Running advanced scanner with custom parameters..."
python3 advanced_scanner.py 127.0.0.1 -p 1-5000 -f csv -v || true

echo "Generating dashboard..."
python3 generate_dashboard.py || true

echo "Validating JSON output if available..."
jq . threat_analysis_*.json 2>/dev/null || true

echo "Lab execution completed."
