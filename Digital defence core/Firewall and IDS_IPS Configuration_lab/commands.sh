#!/bin/bash

# Update system
sudo apt update

# Install Fail2Ban and UFW
sudo apt install fail2ban ufw net-tools curl -y

# Start and enable Fail2Ban
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

# Configure Fail2Ban
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

sudo bash -c 'cat > /etc/fail2ban/jail.local <<EOF
[DEFAULT]
bantime = 600
findtime = 600
maxretry = 3
ignoreip = 127.0.0.1/8 ::1

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 600
EOF'

# Restart Fail2Ban
sudo systemctl restart fail2ban

# Show Fail2Ban status
sudo fail2ban-client status
sudo fail2ban-client status sshd

echo "=== Configuring UFW Firewall ==="

# Enable firewall
sudo ufw --force enable

# Default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow services
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Allow port range
sudo ufw allow 8000:8010/tcp

# Show firewall status
sudo ufw status numbered

echo "=== Creating Test Scripts ==="

# Fail2Ban test script
cat > test_fail2ban.sh <<EOF
#!/bin/bash
echo "Testing Fail2Ban"
sudo fail2ban-client status sshd
logger -p auth.info "sshd[12345]: Failed password for testuser from 192.168.100.100 port 22 ssh2"
logger -p auth.info "sshd[12346]: Failed password for testuser from 192.168.100.100 port 22 ssh2"
logger -p auth.info "sshd[12347]: Failed password for testuser from 192.168.100.100 port 22 ssh2"
sleep 5
sudo fail2ban-client status sshd
EOF

chmod +x test_fail2ban.sh

# Firewall test script
cat > test_firewall.sh <<EOF
#!/bin/bash
echo "=== UFW Status ==="
sudo ufw status numbered

echo "Testing HTTP connection:"
curl -I http://www.google.com 2>/dev/null | head -1

echo "Testing HTTPS connection:"
curl -I https://www.google.com 2>/dev/null | head -1

echo "Open ports:"
netstat -tuln | head
EOF

chmod +x test_firewall.sh

# Security monitor script
cat > security_monitor.sh <<EOF
#!/bin/bash
echo "=== Security Monitoring ==="
date
echo "Fail2Ban Status:"
sudo fail2ban-client status
echo ""
echo "Recent Failed Logins:"
sudo tail -10 /var/log/auth.log | grep "Failed password"
echo ""
echo "UFW Status:"
sudo ufw status numbered
EOF

chmod +x security_monitor.sh

# Security check script
cat > security_check.sh <<EOF
#!/bin/bash
echo "=== Security Check ==="

if systemctl is-active --quiet fail2ban; then
    echo "Fail2Ban running"
else
    echo "Fail2Ban not running"
fi

if sudo ufw status | grep -q "active"; then
    echo "UFW active"
else
    echo "UFW not active"
fi

echo "Open Ports:"
netstat -tuln | grep LISTEN
EOF

chmod +x security_check.sh

# Final verification script
cat > final_verification.sh <<EOF
#!/bin/bash
echo "=== Final Verification ==="

if systemctl is-active --quiet fail2ban; then
    echo "PASS: Fail2Ban running"
else
    echo "FAIL: Fail2Ban not running"
fi

if sudo ufw status | grep -q "Status: active"; then
    echo "PASS: UFW active"
else
    echo "FAIL: UFW not active"
fi

if sudo ufw status | grep -q "22/tcp"; then
    echo "PASS: SSH rule exists"
else
    echo "FAIL: SSH rule missing"
fi

echo "Verification complete"
EOF

chmod +x final_verification.sh

echo "=== Lab 9 Setup Completed ==="
echo "Run the following scripts to test:"
echo "./test_fail2ban.sh"
echo "./test_firewall.sh"
echo "./security_monitor.sh"
echo "./security_check.sh"
echo "./final_verification.sh"
