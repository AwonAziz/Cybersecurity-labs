#!/bin/bash

echo "=== Lab 16: Privilege Escalation with Mimikatz ==="

# =========================
# Verify Tools
# =========================
echo "[+] Checking environment..."

wine --version
pwsh --version
python3 --version

echo "[+] Listing lab tools..."
ls -la /opt/lab-tools/ 2>/dev/null

# =========================
# Setup Working Directory
# =========================
echo "[+] Creating working directory..."
mkdir -p ~/lab16-mimikatz
cd ~/lab16-mimikatz

# =========================
# Download Mimikatz
# =========================
echo "[+] Downloading Mimikatz..."
wget https://github.com/gentilkiwi/mimikatz/releases/download/2.2.0-20220919/mimikatz_trunk.zip

unzip mimikatz_trunk.zip
cd mimikatz_trunk

# =========================
# Configure Wine
# =========================
echo "[+] Configuring Wine..."
winecfg

echo "[+] Installing dependencies..."
winetricks win10
winetricks vcrun2019 dotnet48

# =========================
# Run Mimikatz
# =========================
echo "[+] Launching Mimikatz..."
wine mimikatz.exe

# =========================
# Run PowerShell Assessment
# =========================
echo "[+] Running privilege escalation check..."
pwsh -ExecutionPolicy Bypass -File ~/lab16-mimikatz/privilege_check.ps1 -Export -OutputPath results.json

# =========================
# Run Python Scripts
# =========================
echo "[+] Running credential extraction..."
python3 extract_credentials.py

echo "[+] Running password analysis..."
python3 analyze_passwords.py

echo "[+] Running defensive script..."
python3 implement_defenses.py

echo "[+] Running monitoring script..."
python3 monitor_credential_access.py

echo "[✔] Lab 16 completed"
