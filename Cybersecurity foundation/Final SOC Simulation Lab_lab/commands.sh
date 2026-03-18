#!/bin/bash

set -e

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Installing required SOC tools..."
sudo apt install -y suricata fail2ban rsyslog python3-pip jq

echo "Verifying installations..."
suricata --version
fail2ban-client version

echo "Creating SOC directory structure..."
sudo mkdir -p /opt/soc/{logs,scripts,playbooks,alerts,reports}
sudo chown -R $USER:$USER /opt/soc

echo "Configuring centralized logging..."
sudo tee /etc/rsyslog.d/50-soc.conf > /dev/null << 'EOF'
*.* /opt/soc/logs/system.log
auth.* /opt/soc/logs/auth.log
EOF

sudo systemctl restart rsyslog

echo "Configuring Suricata..."
sudo tee /etc/suricata/suricata.yaml > /dev/null << 'EOF'
vars:
  address-groups:
    HOME_NET: "[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"
    EXTERNAL_NET: "!$HOME_NET"

default-log-dir: /opt/soc/logs/

outputs:
  - eve-log:
      enabled: yes
      filename: suricata-eve.json
      types:
        - alert
        - http
        - dns

af-packet:
  - interface: eth0

rule-files:
  - suricata.rules
EOF

echo "Updating and starting Suricata..."
sudo suricata-update || true
sudo systemctl enable suricata
sudo systemctl start suricata || true

echo "Creating custom Suricata rules..."
sudo mkdir -p /etc/suricata/rules
sudo tee /etc/suricata/rules/custom.rules > /dev/null << 'EOF'
alert tcp any any -> $HOME_NET 22 (msg:"SSH Brute Force"; flow:established; threshold:type both, track by_src, count 5, seconds 60; sid:1000001;)

alert http any any -> $HOME_NET any (msg:"Web Shell Detected"; content:"cmd="; http_uri; sid:1000002;)

alert tcp any any -> $HOME_NET any (msg:"Port Scan"; flags:S; threshold:type both, track by_src, count 10, seconds 10; sid:1000003;)
EOF

echo "Adding custom rules include..."
grep -q "custom.rules" /etc/suricata/suricata.yaml || echo "include: /etc/suricata/rules/custom.rules" | sudo tee -a /etc/suricata/suricata.yaml > /dev/null

sudo systemctl restart suricata || true

echo "Configuring Fail2ban..."
sudo tee /etc/fail2ban/jail.local > /dev/null << 'EOF'
[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
findtime = 600
EOF

sudo systemctl enable fail2ban
sudo systemctl restart fail2ban

echo "Creating placeholder script files..."
touch /opt/soc/scripts/log_analyzer.py
touch /opt/soc/scripts/block_ip.sh
touch /opt/soc/scripts/send_alert.py
touch /opt/soc/scripts/response_engine.py
touch /opt/soc/scripts/playbook_tracker.py

chmod +x /opt/soc/scripts/log_analyzer.py
chmod +x /opt/soc/scripts/block_ip.sh
chmod +x /opt/soc/scripts/send_alert.py
chmod +x /opt/soc/scripts/response_engine.py
chmod +x /opt/soc/scripts/playbook_tracker.py

echo "Creating playbook files..."
cat > /opt/soc/playbooks/brute_force_response.md << 'EOF'
# Brute Force Attack Response Playbook

## Classification
- **Type**: Brute Force Authentication Attack
- **Severity**: High
- **MITRE ATT&CK**: T1110

## Detection Indicators
- 5+ failed login attempts from single IP within 5 minutes
- Source: /opt/soc/logs/auth.log, Suricata alerts

## Response Steps

### Immediate Actions (0-15 min)
1. Verify alert authenticity in logs
2. Identify source IP address
3. Block IP using: `/opt/soc/scripts/block_ip.sh <IP> "brute_force"`
4. Check for successful logins from same IP

### Investigation (15-60 min)
1. Analyze full authentication log history
2. Identify targeted user accounts
3. Check for lateral movement indicators
4. Review network traffic from source IP

### Containment (30-90 min)
1. Reset passwords for targeted accounts
2. Enable MFA if not already active
3. Update firewall rules
4. Monitor for continued attacks

### Recovery (1-4 hours)
1. Document incident timeline
2. Update detection rules if needed
3. Brief security team
4. Create incident report
EOF

cat > /opt/soc/playbooks/web_attack_response.md << 'EOF'
# Web Application Attack Response Playbook

## Classification
- **Type**: Web Application Exploitation
- **Severity**: Critical
- **MITRE ATT&CK**: T1190

## Detection Indicators
- Suspicious parameters: cmd=, eval(), system()
- SQL injection patterns
- Directory traversal attempts (../)
- Web shell upload attempts

## Response Steps

### Immediate Actions (0-10 min)
1. Verify alert in web server logs
2. Block source IP immediately
3. Check for successful exploitation
4. Isolate affected web server if compromised

### Investigation (10-45 min)
1. Analyze web server access logs
2. Search for uploaded malicious files
3. Check database for unauthorized changes
4. Review application error logs

### Containment (30-120 min)
1. Remove any malicious files found
2. Patch vulnerable application components
3. Update web application firewall rules
4. Reset application credentials

### Recovery (2-8 hours)
1. Restore from clean backup if needed
2. Implement additional security controls
3. Update application to latest version
4. Monitor for reinfection attempts
EOF

echo "Testing SOC workflow..."
python3 /opt/soc/scripts/log_analyzer.py || true
cat /opt/soc/reports/analysis_report.json | jq '.alerts' 2>/dev/null || true
python3 /opt/soc/scripts/response_engine.py &>/dev/null &

echo "Checking response-related outputs..."
tail -n 20 /opt/soc/logs/response_actions.log 2>/dev/null || true
sudo iptables -L INPUT -n | grep DROP || true
cat /opt/soc/logs/blocked_ips.log 2>/dev/null || true
cat /opt/soc/alerts/all_alerts.log 2>/dev/null || true
sudo fail2ban-client status sshd || true

echo "To simulate brute force attempts manually:"
echo 'for i in {1..6}; do ssh invalid_user@localhost; sleep 2; done'
