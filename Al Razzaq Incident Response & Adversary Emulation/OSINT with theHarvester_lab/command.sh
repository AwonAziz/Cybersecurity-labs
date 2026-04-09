#!/bin/bash

echo "=== Lab 7: OSINT with theHarvester ==="

# =========================
# System Setup
# =========================
echo "[+] Updating system..."
sudo apt update

echo "[+] Installing dependencies..."
sudo apt install -y python3 python3-pip git python3-requests python3-beautifulsoup4

# =========================
# Install theHarvester
# =========================
echo "[+] Installing theHarvester..."
cd ~

git clone https://github.com/laramies/theHarvester.git
cd theHarvester

pip3 install -r requirements.txt
chmod +x theHarvester.py

# =========================
# Verify Installation
# =========================
echo "[+] Verifying installation..."
python3 theHarvester.py -h

# =========================
# Basic OSINT Scan
# =========================
echo "[+] Running basic scan..."
python3 theHarvester.py -d example.com -l 50 -b google

# =========================
# Multi-Source Scan
# =========================
echo "[+] Running multi-source scan..."
python3 theHarvester.py -d example.com -l 100 -b google,bing,dnsdumpster,crtsh -f results

# =========================
# Create Automation Script
# =========================
echo "[+] Creating automation script..."

cat > harvester_automation.py << EOF
import subprocess

domain = "example.com"
cmd = ["python3", "theHarvester.py", "-d", domain, "-l", "100", "-b", "google,bing"]

subprocess.run(cmd)
print("Scan completed")
EOF

chmod +x harvester_automation.py

# =========================
# Run Automation Script
# =========================
echo "[+] Running automation script..."
python3 harvester_automation.py

# =========================
# Basic Analysis
# =========================
echo "[+] Extracting emails..."
grep -i "@" *.txt 2>/dev/null | sort | uniq > emails.txt

echo "[+] Extracting subdomains..."
grep -E "([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}" *.txt 2>/dev/null | sort | uniq > subdomains.txt

echo "Emails found: $(wc -l < emails.txt)"
echo "Subdomains found: $(wc -l < subdomains.txt)"

echo "[✔] OSINT Lab Completed"
