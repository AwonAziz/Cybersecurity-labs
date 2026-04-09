#!/bin/bash

echo "=== Lab 19: SOAR Playbooks Setup ==="

# =========================
# Create Project Structure
# =========================
mkdir -p ~/soar-lab/{thehive,cortex,data,playbooks,integration}
cd ~/soar-lab

echo "[+] Project structure created"

# =========================
# Create Docker Compose File
# =========================
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.17.9
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
      - ES_JAVA_OPTS=-Xms256m -Xmx256m
    ports:
      - "9200:9200"

  cortex:
    image: thehiveproject/cortex:3.1.7
    ports:
      - "9001:9001"

  thehive:
    image: thehiveproject/thehive4:4.1.24
    ports:
      - "9000:9000"
    command: --no-config-secret
EOF

echo "[+] Docker Compose configured"

# =========================
# Set Permissions
# =========================
sudo chown -R 1000:1000 data/
chmod -R 755 data/

# =========================
# Start SOAR Platform
# =========================
echo "[+] Starting SOAR services..."
docker-compose up -d

echo "[+] Waiting for services..."
sleep 120

# =========================
# Verify Services
# =========================
echo "[+] Checking services..."
docker-compose ps

echo "[+] Checking Elasticsearch..."
curl http://localhost:9200/_cluster/health

echo "[+] Checking TheHive..."
curl http://localhost:9000/api/status

# =========================
# Run Playbooks
# =========================
echo "[+] Running Malware Playbook..."
python3 playbooks/malware_playbook.py

echo "[+] Running Phishing Playbook..."
python3 playbooks/phishing_playbook.py

echo "[+] Running SIEM Integration..."
python3 integration/siem_integration.py

echo "[✔] Lab 19 setup and execution complete!"
