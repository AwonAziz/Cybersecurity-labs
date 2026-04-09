#!/bin/bash

echo "=== Lab 8: Web Reconnaissance with Maltego ==="

# =========================
# System Setup
# =========================
echo "[+] Updating system..."
sudo apt update && sudo apt upgrade -y

echo "[+] Installing Java..."
sudo apt install -y default-jre default-jdk

java -version

# =========================
# Install Maltego
# =========================
echo "[+] Downloading Maltego..."
cd ~/Downloads

wget https://maltego-downloads.s3.us-east-2.amazonaws.com/linux/Maltego.v4.5.0.deb

echo "[+] Installing Maltego..."
sudo dpkg -i Maltego.v4.5.0.deb
sudo apt-get install -f

# =========================
# Install OSINT Tools
# =========================
echo "[+] Installing OSINT tools..."

sudo apt install -y theharvester dnsrecon git python3-pip

# Install Sublist3r
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r
pip3 install -r requirements.txt
cd ~

# Install Recon-ng
git clone https://github.com/lanmaster53/recon-ng.git
cd recon-ng
pip3 install -r REQUIREMENTS
cd ~

# Install Shodan CLI
pip3 install shodan

# =========================
# Run Basic Recon
# =========================
echo "[+] Running theHarvester..."
theharvester -d example.com -l 50 -b google > harvester_results.txt

echo "[+] Running Sublist3r..."
python3 Sublist3r/sublist3r.py -d example.com -o subdomains.txt

echo "[+] Running DNSrecon..."
dnsrecon -d example.com -t std > dns_results.txt

# =========================
# Analyze Results
# =========================
echo "[+] Extracting emails..."
grep -i "@" harvester_results.txt | sort | uniq > emails.txt

echo "[+] Extracting subdomains..."
cat subdomains.txt

echo "Emails found: $(wc -l < emails.txt)"
echo "Subdomains found: $(wc -l < subdomains.txt)"

# =========================
# Launch Maltego
# =========================
echo "[+] Launching Maltego..."
maltego &

echo "[✔] Lab 8 setup complete"
