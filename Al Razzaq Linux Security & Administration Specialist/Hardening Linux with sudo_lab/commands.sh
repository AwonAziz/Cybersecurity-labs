#!/bin/bash

echo "Starting Lab 5: Hardening Linux with sudo"

# ----------------------------
# Inspect sudo configuration
# ----------------------------
echo "[+] Checking sudo configuration"
sudo --version
sudo -l
ls -la /etc/sudoers
ls -la /etc/sudoers.d/

# ----------------------------
# Backup sudoers file
# ----------------------------
echo "[+] Creating backup"
sudo cp /etc/sudoers /etc/sudoers.backup.$(date +%Y%m%d)

# ----------------------------
# Create users and groups
# ----------------------------
echo "[+] Creating users and groups"

sudo useradd -m -s /bin/bash webadmin
sudo useradd -m -s /bin/bash dbadmin
sudo useradd -m -s /bin/bash developer
sudo useradd -m -s /bin/bash auditor

sudo groupadd web-operators
sudo groupadd db-operators
sudo groupadd dev-team
sudo groupadd audit-team

sudo usermod -aG web-operators webadmin
sudo usermod -aG db-operators dbadmin
sudo usermod -aG dev-team developer
sudo usermod -aG audit-team auditor

# ----------------------------
# Setup logging directories
# ----------------------------
echo "[+] Configuring logging"
sudo mkdir -p /var/log/sudo-io
sudo chmod 750 /var/log/sudo-io
sudo chown root:adm /var/log/sudo-io

# ----------------------------
# Configure rsyslog
# ----------------------------
echo "[+] Configuring rsyslog"

sudo bash -c 'cat > /etc/rsyslog.d/50-sudo.conf << EOF
:programname, isequal, "sudo" /var/log/sudo-commands.log
& stop
EOF'

sudo systemctl restart rsyslog

# ----------------------------
# Create monitoring script
# ----------------------------
echo "[+] Creating sudo monitoring script"

sudo bash -c 'cat > /usr/local/bin/sudo-monitor.sh << EOF
#!/bin/bash

LOG_FILE="/var/log/sudo.log"

if [ -f "$LOG_FILE" ]; then
    tail -n 50 "$LOG_FILE" | grep -E "rm -rf|passwd root|userdel" && \
    logger -p auth.warning "Suspicious sudo activity detected"
fi
EOF'

sudo chmod +x /usr/local/bin/sudo-monitor.sh

# ----------------------------
# Test logging
# ----------------------------
echo "[+] Generating test logs"
sudo ls /root
sudo systemctl status ssh

# ----------------------------
# Display logs
# ----------------------------
echo "[+] Showing recent logs"
sudo tail -10 /var/log/sudo.log

echo "Lab completed"
