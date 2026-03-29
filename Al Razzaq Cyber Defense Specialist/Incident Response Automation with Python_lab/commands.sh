#!/bin/bash

# Create directory structure
mkdir -p ~/incident_response/{scripts,logs,reports,config,alerts}
cd ~/incident_response

mkdir -p logs/{system,security,application}
mkdir -p scripts/{collection,analysis,response}
mkdir -p reports/incidents

echo "Directory structure created."

# Create sample system logs
cat > logs/system/syslog.log << 'EOF'
2024-01-15 10:30:15 server01 sshd[5678]: Failed password for root from 192.168.1.100 port 22
2024-01-15 10:31:20 server01 sshd[5679]: Failed password for admin from 192.168.1.100 port 22
2024-01-15 10:32:25 server01 sshd[5680]: Failed password for root from 192.168.1.100 port 22
2024-01-15 10:33:30 server01 kernel: CPU usage spike detected: 95% utilization
2024-01-15 10:34:35 server01 firewall: BLOCKED connection from 10.0.0.50 to port 443
EOF

# Create auth logs
cat > logs/security/auth.log << 'EOF'
2024-01-15 10:30:00 server01 login: FAILED LOGIN FROM 192.168.1.200 FOR user1
2024-01-15 10:30:05 server01 login: FAILED LOGIN FROM 192.168.1.200 FOR user1
2024-01-15 10:30:10 server01 login: FAILED LOGIN FROM 192.168.1.200 FOR user1
2024-01-15 10:30:15 server01 sudo: user2 : USER=root ; COMMAND=/bin/rm -rf /tmp/test
2024-01-15 10:30:20 server01 login: ROOT LOGIN ON tty1
EOF

# Create application logs
cat > logs/application/webapp.log << 'EOF'
2024-01-15 10:29:45 [ERROR] SQL injection attempt: SELECT * FROM users WHERE id='1 OR 1=1--'
2024-01-15 10:30:50 [WARN] Multiple failed auth from IP: 203.0.113.45
2024-01-15 10:31:55 [ERROR] Path traversal attempt: ../../../etc/passwd
2024-01-15 10:32:00 [INFO] User admin logged in successfully
2024-01-15 10:33:05 [ERROR] XSS attempt detected: <script>alert('XSS')</script>
EOF

echo "Sample logs created."

# Create configuration file
cat > config/response_config.json << 'EOF'
{
  "email": {
    "smtp_server": "localhost",
    "smtp_port": 587,
    "recipients": ["admin@company.com", "security@company.com"]
  },
  "blocking": {
    "use_iptables": true,
    "block_duration": 3600,
    "whitelist_ips": ["127.0.0.1", "192.168.1.1"]
  },
  "thresholds": {
    "failed_login_count": 3,
    "time_window_seconds": 300
  }
}
EOF

echo "Configuration file created."

# Make scripts executable
chmod +x scripts/collection/log_collector.py 2>/dev/null
chmod +x scripts/analysis/log_analyzer.py 2>/dev/null
chmod +x scripts/response/incident_responder.py 2>/dev/null
chmod +x scripts/automated_response.py 2>/dev/null

echo "Scripts permissions set."

echo "========================================"
echo " Setup Complete"
echo "========================================"

echo "Run the following:"
echo "python3 scripts/collection/log_collector.py"
echo "python3 scripts/analysis/log_analyzer.py"
echo "python3 scripts/response/incident_responder.py"
echo "python3 scripts/automated_response.py"
