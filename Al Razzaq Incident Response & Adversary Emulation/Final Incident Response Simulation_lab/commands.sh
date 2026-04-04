#!/bin/bash

echo "[+] Updating system..."
sudo apt update && sudo apt upgrade -y

echo "[+] Installing dependencies..."
sudo apt install -y curl wget gnupg2 software-properties-common apt-transport-https ca-certificates

echo "[+] Creating lab directories..."
mkdir -p ~/incident-response-lab/{logs,scripts,evidence,reports}
cd ~/incident-response-lab

# ================================
# Install Wazuh
# ================================
echo "[+] Installing Wazuh..."

curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo apt-key add -
echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee /etc/apt/sources.list.d/wazuh.list

sudo apt update
sudo apt install -y wazuh-manager wazuh-api wazuh-agent

sudo systemctl enable wazuh-manager wazuh-api wazuh-agent
sudo systemctl start wazuh-manager wazuh-api wazuh-agent

# Configure agent
sudo sed -i 's/<server>.*<\/server>/<server>127.0.0.1<\/server>/' /var/ossec/etc/ossec.conf

# ================================
# Install Suricata
# ================================
echo "[+] Installing Suricata..."

sudo apt install -y suricata
sudo suricata-update

INTERFACE=$(ip route | grep default | awk '{print $5}' | head -1)

sudo sed -i "s/interface: eth0/interface: $INTERFACE/" /etc/suricata/suricata.yaml
sudo sed -i 's/enabled: no/enabled: yes/' /etc/suricata/suricata.yaml

sudo systemctl enable suricata
sudo systemctl start suricata

# ================================
# Install Zeek
# ================================
echo "[+] Installing Zeek..."

sudo apt install -y zeek

echo 'export PATH=/opt/zeek/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

echo "interface=$INTERFACE" | sudo tee /opt/zeek/etc/node.cfg

sudo /opt/zeek/bin/zeekctl install
sudo /opt/zeek/bin/zeekctl start

# ================================
# Log Integration
# ================================
echo "[+] Configuring log integration..."

sudo tee -a /var/ossec/etc/ossec.conf << 'EOF'
<localfile>
  <log_format>json</log_format>
  <location>/var/log/suricata/eve.json</location>
</localfile>

<localfile>
  <log_format>syslog</log_format>
  <location>/opt/zeek/logs/current/conn.log</location>
</localfile>
EOF

sudo systemctl restart wazuh-manager

# ================================
# Run Attack Simulations
# ================================
echo "[+] Running attack simulations..."

bash ~/incident-response-lab/scripts/port_scan_simulation.sh
sleep 5

bash ~/incident-response-lab/scripts/web_attack_simulation.sh
sleep 5

bash ~/incident-response-lab/scripts/malware_simulation.sh
sleep 5

# ================================
# Check Logs
# ================================
echo "[+] Checking alerts..."

sudo tail -20 /var/ossec/logs/alerts/alerts.log
sudo tail -20 /var/log/suricata/fast.log
sudo tail -20 /opt/zeek/logs/current/conn.log

# ================================
# Run IR Phases
# ================================
echo "[+] Running incident response phases..."

bash ~/incident-response-lab/scripts/incident_response_playbook.sh
sudo bash ~/incident-response-lab/scripts/containment_procedures.sh
bash ~/incident-response-lab/scripts/eradication_recovery.sh
bash ~/incident-response-lab/scripts/post_incident_analysis.sh

# ================================
# Verification
# ================================
echo "[+] Verifying security status..."

bash ~/incident-response-lab/scripts/security_verification.sh

# ================================
# Documentation
# ================================
echo "[+] Compiling documentation..."

bash ~/incident-response-lab/scripts/compile_documentation.sh

echo "[✔] Lab completed successfully!"
