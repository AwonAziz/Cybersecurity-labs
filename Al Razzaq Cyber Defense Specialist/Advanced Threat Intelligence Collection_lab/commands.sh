#!/bin/bash

echo "=== Lab 14: Advanced Threat Intelligence Collection ==="

# Create project directories
mkdir -p ~/threat_intel/{scripts,data,reports,config,logs}
cd ~/threat_intel

echo "=== Creating Configuration File ==="
cat > config/sources.json << 'EOF'
{
    "data_sources": {
        "local_feeds": ["malware_domains.txt", "suspicious_ips.txt"],
        "api_endpoints": {
            "virustotal": "https://www.virustotal.com/api/v3/",
            "abuseipdb": "https://api.abuseipdb.com/api/v2/"
        }
    },
    "thresholds": {
        "high_risk": 80,
        "medium_risk": 60,
        "low_risk": 40
    }
}
EOF

echo "=== Creating Sample Threat Data ==="
cat > data/malware_domains.txt << 'EOF'
malicious-site.com
phishing-example.net
suspicious-domain.org
threat-actor.info
EOF

cat > data/suspicious_ips.txt << 'EOF'
192.168.1.100
203.0.113.10
198.51.100.20
EOF

echo "=== Creating threat_collector.py ==="
cat > scripts/threat_collector.py << 'EOF'
#!/usr/bin/env python3

import json
import hashlib
import ipaddress
import logging
from datetime import datetime

class ThreatCollector:
    def __init__(self, config_file="config/sources.json"):
        self.config = self.load_config(config_file)
        self.collected_data = []
        self.setup_logging()

    def load_config(self, config_file):
        with open(config_file, 'r') as f:
            return json.load(f)

    def setup_logging(self):
        logging.basicConfig(
            filename='logs/collection.log',
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s'
        )

    def validate_ip(self, ip_string):
        try:
            ipaddress.ip_address(ip_string)
            return True
        except:
            return False

    def validate_domain(self, domain_string):
        return "." in domain_string

    def validate_hash(self, hash_string):
        if len(hash_string) == 32:
            return "MD5"
        elif len(hash_string) == 40:
            return "SHA1"
        elif len(hash_string) == 64:
            return "SHA256"
        return None

    def collect_from_file(self, filename, indicator_type):
        indicators = []
        with open("data/" + filename, 'r') as f:
            for line in f:
                value = line.strip()
                indicators.append({
                    "indicator": value,
                    "type": indicator_type,
                    "collected": str(datetime.now())
                })
        self.collected_data.extend(indicators)

    def save_collected_data(self):
        filename = "data/collected_" + datetime.now().strftime("%Y%m%d%H%M%S") + ".json"
        with open(filename, 'w') as f:
            json.dump(self.collected_data, f, indent=4)
        print("Saved collected data to", filename)

    def run_collection(self):
        self.collect_from_file("malware_domains.txt", "domain")
        self.collect_from_file("suspicious_ips.txt", "ip")
        self.save_collected_data()

def main():
    print("Threat Intelligence Collector")
    collector = ThreatCollector()
    collector.run_collection()

if __name__ == "__main__":
    main()
EOF

chmod +x scripts/threat_collector.py

echo "=== Creating data_normalizer.py ==="
cat > scripts/data_normalizer.py << 'EOF'
#!/usr/bin/env python3

import json
import glob

def normalize():
    files = glob.glob("data/collected_*.json")
    if not files:
        print("No collected data found")
        return

    with open(files[-1], 'r') as f:
        data = json.load(f)

    for item in data:
        item["confidence"] = 50
        item["severity"] = "MEDIUM"

    output = "data/normalized_data.json"
    with open(output, 'w') as f:
        json.dump(data, f, indent=4)

    print("Normalized data saved to", output)

if __name__ == "__main__":
    normalize()
EOF

chmod +x scripts/data_normalizer.py

echo "=== Creating report_generator.py ==="
cat > scripts/report_generator.py << 'EOF'
#!/usr/bin/env python3

import json
from datetime import datetime

def generate_report():
    with open("data/normalized_data.json", 'r') as f:
        data = json.load(f)

    report_file = "reports/threat_report_" + datetime.now().strftime("%Y%m%d%H%M%S") + ".txt"

    with open(report_file, 'w') as f:
        f.write("Threat Intelligence Report\n")
        f.write("=========================\n")
        f.write("Total Indicators: " + str(len(data)) + "\n")

        for item in data:
            f.write(str(item) + "\n")

    print("Report generated:", report_file)

if __name__ == "__main__":
    generate_report()
EOF

chmod +x scripts/report_generator.py

echo "=== Creating Pipeline Script ==="
cat > scripts/run_pipeline.sh << 'EOF'
#!/bin/bash

echo "Starting Threat Intelligence Pipeline"

echo "[1/3] Collecting data..."
python3 scripts/threat_collector.py

echo "[2/3] Normalizing data..."
python3 scripts/data_normalizer.py

echo "[3/3] Generating report..."
python3 scripts/report_generator.py

echo "Pipeline Completed"
EOF

chmod +x scripts/run_pipeline.sh

echo "=== Setup Complete ==="
echo "Run pipeline with:"
echo "./scripts/run_pipeline.sh"
