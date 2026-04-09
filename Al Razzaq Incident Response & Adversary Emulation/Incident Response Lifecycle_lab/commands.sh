#!/bin/bash

echo "=== Lab 1: Incident Response Lifecycle ==="

# =========================
# System Setup
# =========================
echo "[+] Updating system..."
sudo apt update && sudo apt upgrade -y

echo "[+] Installing IR tools..."
sudo apt install -y htop iotop netstat-nat tcpdump tshark chkrootkit rkhunter aide fail2ban rsyslog logwatch git curl wget unzip

# =========================
# Create Directory Structure
# =========================
echo "[+] Creating directories..."
mkdir -p ~/incident_response/{logs,evidence,reports,tools,scripts}
cd ~/incident_response

mkdir -p logs/{system,network,application}
mkdir -p evidence/{volatile,non-volatile,timeline}
mkdir -p reports/{initial,detailed,final}

# =========================
# Run Monitoring
# =========================
echo "[+] Running system monitoring..."
bash scripts/system_monitor.sh

# =========================
# Simulate Incident
# =========================
echo "[+] Simulating incident..."
bash scripts/simulate_incident.sh

# =========================
# Detection Phase
# =========================
echo "[+] Running detection..."
top -bn1 | head -20 > evidence/detection_results.txt
ps aux >> evidence/detection_results.txt
netstat -tuln >> evidence/detection_results.txt

# =========================
# Containment
# =========================
echo "[+] Running containment..."
bash scripts/containment_actions.sh

# =========================
# Evidence Preservation
# =========================
echo "[+] Preserving evidence..."
bash scripts/preserve_evidence.sh

# =========================
# Recovery
# =========================
echo "[+] Running recovery verification..."
bash scripts/recovery_verification.sh

echo "[+] Applying system hardening..."
bash scripts/system_hardening.sh

# =========================
# Final Validation
# =========================
echo "[+] Running final validation..."
bash scripts/final_validation.sh

echo "[✔] Incident Response Lifecycle Lab Completed!"
