#!/bin/bash

echo "=== Lab 3: Memory Forensics with Volatility ==="

# =========================
# System Setup
# =========================
echo "[+] Updating system..."
sudo apt update

echo "[+] Installing dependencies..."
sudo apt install -y python3 python3-pip git build-essential python3-dev libssl-dev \
volatility volatility-tools linux-headers-$(uname -r) strings netcat curl

# =========================
# Install Volatility 3
# =========================
echo "[+] Installing Volatility 3..."
mkdir -p ~/forensics-tools
cd ~/forensics-tools

git clone https://github.com/volatilityfoundation/volatility3.git
cd volatility3

pip3 install -r requirements.txt
chmod +x vol.py

sudo ln -sf $(pwd)/vol.py /usr/local/bin/vol3

# =========================
# Create Lab Environment
# =========================
echo "[+] Creating lab environment..."
mkdir -p ~/memory-forensics-lab
cd ~/memory-forensics-lab

# Start test processes
python3 -m http.server 8080 &
nc -l -p 9999 &

echo "[+] Creating suspicious script..."
cat > suspicious_script.py << EOF
import time
while True:
    time.sleep(5)
EOF

python3 suspicious_script.py &

# =========================
# Create Memory Dump
# =========================
echo "[+] Creating memory dump..."
mkdir -p ~/memory-dumps
cd ~/memory-dumps

sudo dd if=/proc/kcore of=memory-dump.lime bs=1M count=512

# =========================
# Basic Analysis
# =========================
echo "[+] Running basic analysis..."

vol3 -f memory-dump.lime linux.banner.Banner
vol3 -f memory-dump.lime linux.pslist.PsList > process-list.txt
vol3 -f memory-dump.lime linux.netstat.Netstat > network.txt
vol3 -f memory-dump.lime linux.lsmod.Lsmod > modules.txt

# =========================
# String Analysis
# =========================
echo "[+] Running string analysis..."
strings memory-dump.lime > memory-strings.txt
grep -i "http" memory-strings.txt | head

# =========================
# Extract Executables
# =========================
mkdir -p extracted-files
vol3 -f memory-dump.lime linux.elfs.Elfs --output-dir extracted-files/

# =========================
# Generate Summary
# =========================
echo "[+] Generating summary..."

echo "Processes: $(wc -l < process-list.txt)"
echo "Connections: $(wc -l < network.txt)"
echo "Modules: $(wc -l < modules.txt)"

echo "[✔] Memory Forensics Lab Completed"
