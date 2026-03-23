#!/bin/bash

# Update system
sudo apt update

# Install required packages
sudo apt install -y python3-pip python3-venv unattended-upgrades apt-listchanges lynis

# Install Python packages
pip3 install pyyaml schedule psutil requests

# Create project directory
mkdir -p ~/patch-management-lab
cd ~/patch-management-lab

# Create directories
mkdir -p scripts configs logs reports

# Create configuration file
cat > configs/patch_config.yaml <<EOF
patch_settings:
  auto_reboot: false
  maintenance_window: "02:00-04:00"
  excluded_packages: []
  security_only: true

notification:
  email_enabled: false
  webhook_url: null

logging:
  level: INFO
  file: logs/patch_activity.log
EOF

echo "=== Creating Patch Manager Script ==="
cat > scripts/patch_manager.py <<'EOF'
#!/usr/bin/env python3
import os
import subprocess
import json
import yaml
import logging
import datetime

class PatchManager:
    def __init__(self, config_file="configs/patch_config.yaml"):
        self.config_file = config_file
        self.config = self.load_config()
        self.setup_logging()

    def load_config(self):
        if not os.path.exists(self.config_file):
            return {}
        with open(self.config_file, 'r') as f:
            return yaml.safe_load(f)

    def setup_logging(self):
        log_file = self.config.get("logging", {}).get("file", "logs/patch.log")
        os.makedirs(os.path.dirname(log_file), exist_ok=True)
        logging.basicConfig(filename=log_file, level=logging.INFO)

    def get_available_updates(self):
        subprocess.run(["sudo", "apt", "update"])
        result = subprocess.run(["apt", "list", "--upgradable"], capture_output=True, text=True)
        return result.stdout

    def install_updates(self):
        result = subprocess.run(["sudo", "apt", "upgrade", "-y"], capture_output=True, text=True)
        return result.stdout

    def create_system_snapshot(self):
        snapshot = {
            "date": str(datetime.datetime.now()),
            "packages": subprocess.getoutput("dpkg -l"),
            "os": subprocess.getoutput("cat /etc/os-release")
        }
        filename = f"reports/snapshot_{int(datetime.datetime.now().timestamp())}.json"
        with open(filename, "w") as f:
            json.dump(snapshot, f)
        return filename
EOF

chmod +x scripts/patch_manager.py

echo "=== Creating Vulnerability Scanner Script ==="
cat > scripts/vulnerability_scanner.py <<'EOF'
#!/usr/bin/env python3
import subprocess
import json
import datetime

class VulnerabilityScanner:
    def run_lynis_scan(self):
        subprocess.run(["sudo", "lynis", "audit", "system", "--quiet"])
        log = subprocess.getoutput("cat /var/log/lynis.log | tail -20")
        return log

    def check_open_ports(self):
        return subprocess.getoutput("ss -tuln")

    def run_scan(self):
        results = {
            "date": str(datetime.datetime.now()),
            "ports": self.check_open_ports(),
            "lynis": self.run_lynis_scan()
        }
        filename = f"reports/scan_{int(datetime.datetime.now().timestamp())}.json"
        with open(filename, "w") as f:
            json.dump(results, f)
        return filename
EOF

chmod +x scripts/vulnerability_scanner.py

echo "=== Creating Automated Patcher Script ==="
cat > scripts/automated_patcher.py <<'EOF'
#!/usr/bin/env python3
from patch_manager import PatchManager
from vulnerability_scanner import VulnerabilityScanner

class AutomatedPatcher:
    def __init__(self):
        self.pm = PatchManager()
        self.vs = VulnerabilityScanner()

    def run_patch_cycle(self):
        print("Running vulnerability scan...")
        scan_report = self.vs.run_scan()

        print("Creating system snapshot...")
        snapshot = self.pm.create_system_snapshot()

        print("Installing updates...")
        updates = self.pm.install_updates()

        print("Patch cycle completed")
        return {
            "scan_report": scan_report,
            "snapshot": snapshot,
            "updates": updates
        }
EOF

chmod +x scripts/automated_patcher.py

echo "=== Creating Patch Cycle Runner ==="
cat > scripts/run_patch_cycle.py <<'EOF'
#!/usr/bin/env python3
from automated_patcher import AutomatedPatcher

def main():
    patcher = AutomatedPatcher()
    result = patcher.run_patch_cycle()
    print(result)

if __name__ == "__main__":
    main()
EOF

chmod +x scripts/run_patch_cycle.py

echo "=== Creating Dashboard Generator ==="
cat > scripts/generate_dashboard.py <<'EOF'
#!/usr/bin/env python3
import os

def generate_dashboard():
    reports = os.listdir("reports")
    with open("reports/dashboard.html", "w") as f:
        f.write("<html><body><h1>Patch Management Dashboard</h1><ul>")
        for report in reports:
            f.write(f"<li>{report}</li>")
        f.write("</ul></body></html>")
    print("Dashboard generated at reports/dashboard.html")

if __name__ == "__main__":
    generate_dashboard()
EOF

chmod +x scripts/generate_dashboard.py

echo "=== Patch Management Lab Setup Completed ==="
echo "Run patch cycle with:"
echo "python3 scripts/run_patch_cycle.py"
echo "Generate dashboard:"
echo "python3 scripts/generate_dashboard.py"
