#!/bin/bash

# Update system

sudo apt update

# Install Java

sudo apt install -y openjdk-11-jdk

# Add Elasticsearch repository

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list

sudo apt update

# Install ELK Stack

sudo apt install -y elasticsearch kibana logstash

# Configure Elasticsearch

sudo sed -i 's/#network.host: 192.168.0.1/network.host: localhost/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#http.port: 9200/http.port: 9200/' /etc/elasticsearch/elasticsearch.yml

# Start services

sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

sudo systemctl enable kibana
sudo systemctl start kibana

sudo systemctl enable logstash
sudo systemctl start logstash

sleep 30

# Install ElastAlert

sudo apt install -y python3-pip
sudo pip3 install elastalert

# Create directories

mkdir -p ~/soc-lab/documentation
mkdir -p ~/soc-lab/scripts
sudo mkdir -p /etc/elastalert/rules
sudo mkdir -p /var/log/elastalert

# Create SOC Mission File

cat > ~/soc-lab/documentation/soc-mission.txt << 'EOF'
SOC Mission: Monitor, Detect, Respond, Recover, Improve security operations.
SOC Maturity Level: Level 2 - Developing
EOF

# Create Incident Response File

cat > ~/soc-lab/documentation/incident-response.txt << 'EOF'
Incident Response Phases:

1. Preparation
2. Identification
3. Containment
4. Eradication
5. Recovery
6. Lessons Learned
   EOF

# Create Log Generator Script

cat > ~/soc-lab/scripts/generate-events.sh << 'EOF'
#!/bin/bash
logger -p auth.warning "Failed password for invalid user admin"
logger -p daemon.warning "UFW BLOCK suspicious connection"
echo "Security events generated"
EOF

chmod +x ~/soc-lab/scripts/generate-events.sh

# Create SOC Dashboard Script

cat > ~/soc-lab/scripts/soc-dashboard.sh << 'EOF'
#!/bin/bash
echo "SOC Dashboard"
systemctl is-active elasticsearch
systemctl is-active kibana
systemctl is-active logstash
tail -5 /var/log/auth.log
EOF

chmod +x ~/soc-lab/scripts/soc-dashboard.sh

echo "======================================"
echo "SOC LAB SETUP COMPLETE"
echo "======================================"
echo "Run dashboard:"
echo "~/soc-lab/scripts/soc-dashboard.sh"
echo ""
echo "Generate events:"
echo "~/soc-lab/scripts/generate-events.sh"
