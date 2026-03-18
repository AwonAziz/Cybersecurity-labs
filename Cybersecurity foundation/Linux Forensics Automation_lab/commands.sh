#!/bin/bash

set -e

echo "Creating forensic directory structure..."
mkdir -p /home/forensics/{logs,processes,network,scripts,analysis,reports,system_info}
mkdir -p /home/forensics/logs/{system,auth,application}
mkdir -p /home/forensics/processes/{running,historical}
mkdir -p /home/forensics/network/{connections,traffic}

echo "Verifying directory structure..."
tree /home/forensics 2>/dev/null || ls -R /home/forensics

echo "Collecting system logs..."
cd /home/forensics/logs/system
echo "=== LOG EXTRACTION: $(date) ===" > extraction_log.txt
cp /var/log/syslog ./syslog_backup.log 2>/dev/null || echo "Syslog not found"
cp /var/log/kern.log ./kernel_backup.log 2>/dev/null || echo "Kernel log not found"
tail -n 1000 /var/log/syslog > recent_syslog.txt 2>/dev/null || true
journalctl --since "24 hours ago" > systemd_journal_24h.txt 2>/dev/null || true

echo "Collecting authentication logs..."
cd /home/forensics/logs/auth
cp /var/log/auth.log ./auth_backup.log 2>/dev/null || echo "Auth log not found"
grep "Failed password" /var/log/auth.log > failed_logins.txt 2>/dev/null || echo "No failed logins" > failed_logins.txt
grep "Accepted password" /var/log/auth.log > successful_logins.txt 2>/dev/null || echo "No successful logins" > successful_logins.txt
grep "sudo:" /var/log/auth.log > sudo_usage.txt 2>/dev/null || echo "No sudo usage" > sudo_usage.txt

echo "Collecting process information..."
cd /home/forensics/processes/running
ps aux > running_processes_$(date +%Y%m%d_%H%M%S).txt
pstree -p > process_tree.txt 2>/dev/null || true
ps -eo pid,ppid,cmd,etime,user,group > detailed_processes.txt
ps aux --sort=-%cpu > processes_by_cpu.txt
ps aux --sort=-%mem > processes_by_memory.txt
netstat -tulpn > network_processes.txt 2>/dev/null || ss -tulpn > network_processes.txt
lsof > open_files.txt 2>/dev/null || echo "lsof not available" > open_files.txt

echo "Collecting network information..."
cd /home/forensics/network/connections
netstat -an > all_connections.txt 2>/dev/null || ss -an > all_connections.txt
netstat -tln > listening_tcp.txt 2>/dev/null || ss -tln > listening_tcp.txt
netstat -uln > listening_udp.txt 2>/dev/null || ss -uln > listening_udp.txt
route -n > routing_table.txt 2>/dev/null || ip route > routing_table.txt
arp -a > arp_table.txt 2>/dev/null || ip neigh > arp_table.txt
ifconfig > interface_config.txt 2>/dev/null || ip addr show > interface_config.txt
iptables -L -n -v > firewall_rules.txt 2>/dev/null || echo "Firewall not accessible" > firewall_rules.txt

echo "Collecting system information..."
cd /home/forensics/system_info
{
    echo "=== SYSTEM INFORMATION ==="
    echo "Hostname: $(hostname)"
    echo "Kernel: $(uname -a)"
    echo "OS: $(grep PRETTY_NAME /etc/os-release 2>/dev/null)"
    echo "Uptime: $(uptime)"
    echo "Date: $(date)"
} > system_overview.txt

{
    echo "=== USER INFORMATION ==="
    echo "Current users:"
    who
    echo ""
    echo "Last logins:"
    last | head -20
} > user_info.txt

{
    echo "=== HARDWARE INFO ==="
    echo "CPU:"
    lscpu | head -10
    echo ""
    echo "Memory:"
    free -h
    echo ""
    echo "Disk:"
    df -h
} > hardware_info.txt

echo "Creating forensic_collector.sh..."
cd /home/forensics/scripts
cat > forensic_collector.sh << 'EOF'
#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FORENSIC_DIR="/home/forensics/automated_collection_$TIMESTAMP"

print_status "Starting forensic collection - $TIMESTAMP"

mkdir -p "$FORENSIC_DIR"/{system_info,logs,processes,network,users}

{
    echo "Hostname: $(hostname)"
    echo "Kernel: $(uname -a)"
    echo "Uptime: $(uptime)"
    echo "Date: $(date)"
} > "$FORENSIC_DIR/system_info/system_overview.txt"

{
    echo "Current users:"
    who
    echo ""
    echo "Recent logins:"
    last | head -20
    echo ""
    echo "Local accounts:"
    cat /etc/passwd
} > "$FORENSIC_DIR/users/user_info.txt"

ps aux > "$FORENSIC_DIR/processes/ps_aux.txt"
pstree -p > "$FORENSIC_DIR/processes/process_tree.txt" 2>/dev/null || true
lsof > "$FORENSIC_DIR/processes/open_files.txt" 2>/dev/null || echo "lsof unavailable" > "$FORENSIC_DIR/processes/open_files.txt"

netstat -an > "$FORENSIC_DIR/network/all_connections.txt" 2>/dev/null || ss -an > "$FORENSIC_DIR/network/all_connections.txt"
arp -a > "$FORENSIC_DIR/network/arp_table.txt" 2>/dev/null || ip neigh > "$FORENSIC_DIR/network/arp_table.txt"
ifconfig > "$FORENSIC_DIR/network/interface_config.txt" 2>/dev/null || ip addr show > "$FORENSIC_DIR/network/interface_config.txt"

cp /var/log/auth.log "$FORENSIC_DIR/logs/auth.log" 2>/dev/null || true
cp /var/log/syslog "$FORENSIC_DIR/logs/syslog" 2>/dev/null || true
journalctl --since "24 hours ago" > "$FORENSIC_DIR/logs/journal_24h.txt" 2>/dev/null || true

FILE_COUNT=$(find "$FORENSIC_DIR" -type f | wc -l)
TOTAL_SIZE=$(du -sh "$FORENSIC_DIR" | awk '{print $1}')

{
    echo "Forensic Collection Summary"
    echo "Date: $(date)"
    echo "System: $(hostname)"
    echo "Files Collected: $FILE_COUNT"
    echo "Total Size: $TOTAL_SIZE"
} > "$FORENSIC_DIR/summary.txt"

tar -czf "/home/forensics/forensic_collection_$TIMESTAMP.tar.gz" -C /home/forensics "automated_collection_$TIMESTAMP"

print_status "Collection completed: $FORENSIC_DIR"
EOF
chmod +x forensic_collector.sh

echo "Creating forensic_analyzer.py..."
cat > forensic_analyzer.py << 'EOF'
#!/usr/bin/env python3

import os
import re
import json
import datetime
from collections import defaultdict

class LinuxForensicAnalyzer:
    def __init__(self, data_directory):
        self.data_dir = data_directory
        self.analysis_results = {}
        self.suspicious_activities = []

    def analyze_auth_logs(self, auth_log_path):
        print("[INFO] Analyzing authentication logs...")
        if not os.path.exists(auth_log_path):
            return

        failed_logins = defaultdict(int)
        successful_logins = []
        sudo_usage = []

        with open(auth_log_path, 'r', errors='ignore') as f:
            for line in f:
                if 'Failed password' in line:
                    match = re.search(r'from (\d+\.\d+\.\d+\.\d+)', line)
                    if match:
                        failed_logins[match.group(1)] += 1
                elif 'Accepted password' in line:
                    successful_logins.append(line.strip())
                elif 'sudo:' in line:
                    sudo_usage.append(line.strip())

        for ip, count in failed_logins.items():
            if count > 10:
                self.suspicious_activities.append({
                    'type': 'brute_force',
                    'ip': ip,
                    'attempts': count,
                    'severity': 'high'
                })

        self.analysis_results['authentication'] = {
            'failed_logins': dict(failed_logins),
            'successful_logins': successful_logins[:20],
            'sudo_usage': sudo_usage[:20]
        }

    def analyze_processes(self, process_file_path):
        print("[INFO] Analyzing process information...")
        if not os.path.exists(process_file_path):
            return

        suspicious_processes = []
        high_cpu_processes = []
        high_memory_processes = []
        suspicious_names = ['nc', 'netcat', 'ncat', 'socat', 'wget', 'curl']

        with open(process_file_path, 'r', errors='ignore') as f:
            lines = f.readlines()[1:]

        for line in lines:
            parts = line.split(None, 10)
            if len(parts) < 11:
                continue
            user, pid, cpu, mem = parts[0], parts[1], parts[2], parts[3]
            command = parts[10]

            try:
                cpu_val = float(cpu)
                mem_val = float(mem)
            except ValueError:
                continue

            if cpu_val > 80:
                high_cpu_processes.append(line.strip())
            if mem_val > 50:
                high_memory_processes.append(line.strip())
            if any(name in command for name in suspicious_names):
                suspicious_processes.append(line.strip())

        self.analysis_results['processes'] = {
            'suspicious_processes': suspicious_processes[:20],
            'high_cpu_processes': high_cpu_processes[:20],
            'high_memory_processes': high_memory_processes[:20]
        }

    def analyze_network_connections(self, network_file_path):
        print("[INFO] Analyzing network connections...")
        if not os.path.exists(network_file_path):
            return

        listening_ports = []
        suspicious_ports = ['4444', '5555', '6666', '1234', '31337']

        with open(network_file_path, 'r', errors='ignore') as f:
            for line in f:
                if 'LISTEN' in line or 'LISTENING' in line:
                    listening_ports.append(line.strip())
                    if any(port in line for port in suspicious_ports):
                        self.suspicious_activities.append({
                            'type': 'suspicious_port',
                            'evidence': line.strip(),
                            'severity': 'high'
                        })

        self.analysis_results['network'] = {
            'listening_ports': listening_ports[:50]
        }

    def generate_report(self, output_file):
        print("[INFO] Generating forensic analysis report...")
        report = {
            'analysis_timestamp': datetime.datetime.now().isoformat(),
            'data_directory': self.data_dir,
            'analysis_results': self.analysis_results,
            'suspicious_activities': self.suspicious_activities
        }

        with open(output_file, 'w') as f:
            json.dump(report, f, indent=2)

        text_file = output_file.replace('.json', '.txt')
        with open(text_file, 'w') as f:
            f.write("Linux Forensic Analysis Report\n")
            f.write("=" * 40 + "\n")
            f.write(f"Generated: {report['analysis_timestamp']}\n")
            f.write(f"Data Directory: {self.data_dir}\n\n")
            f.write("Suspicious Activities:\n")
            for item in self.suspicious_activities:
                f.write(f"- {item}\n")

def main():
    print("=== Linux Forensic Data Analyzer ===")
    forensic_base = "/home/forensics"
    collections = [d for d in os.listdir(forensic_base) if d.startswith('automated_collection_')]
    if not collections:
        print("No collection directories found.")
        return

    latest = sorted(collections)[-1]
    data_dir = os.path.join(forensic_base, latest)

    analyzer = LinuxForensicAnalyzer(data_dir)
    analyzer.analyze_auth_logs(os.path.join(data_dir, 'logs', 'auth.log'))
    analyzer.analyze_processes(os.path.join(data_dir, 'processes', 'ps_aux.txt'))
    analyzer.analyze_network_connections(os.path.join(data_dir, 'network', 'all_connections.txt'))
    analyzer.generate_report(os.path.join(forensic_base, 'analysis', 'forensic_analysis_report.json'))

if __name__ == "__main__":
    main()
EOF
chmod +x forensic_analyzer.py

echo "Creating create_test_activities.sh..."
cat > create_test_activities.sh << 'EOF'
#!/bin/bash

echo "Creating simulated suspicious activities..."

for i in {1..15}; do
    echo "$(date) sshd[$$]: Failed password for invalid user admin from 192.168.1.100 port 22" >> /tmp/test_auth.log
done

nc -l 4444 &
NC_PID=$!
echo "Created netcat on port 4444 (PID: $NC_PID)"

mkdir -p /tmp/suspicious_test
echo "test backdoor" > /tmp/suspicious_test/backdoor.sh
chmod +x /tmp/suspicious_test/backdoor.sh

echo "Test activities created"
echo "Cleanup: kill $NC_PID && rm -rf /tmp/suspicious_test /tmp/test_auth.log"
EOF
chmod +x create_test_activities.sh

echo "Creating detect_unauthorized.sh..."
cat > detect_unauthorized.sh << 'EOF'
#!/bin/bash

ANALYSIS_DIR="/home/forensics/unauthorized_analysis_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$ANALYSIS_DIR"

echo "=== UNAUTHORIZED ACTIVITY DETECTION ===" | tee "$ANALYSIS_DIR/findings.txt"
echo "" >> "$ANALYSIS_DIR/findings.txt"

FAILED_COUNT=$(grep -c "Failed password" /var/log/auth.log 2>/dev/null || echo 0)
if [ "$FAILED_COUNT" -gt 20 ]; then
    echo "[HIGH] Potential brute force detected: $FAILED_COUNT failed logins" | tee -a "$ANALYSIS_DIR/findings.txt"
fi

echo "" >> "$ANALYSIS_DIR/findings.txt"
echo "Suspicious processes:" >> "$ANALYSIS_DIR/findings.txt"
ps aux | grep -E "nc|netcat|ncat|socat" | grep -v grep >> "$ANALYSIS_DIR/findings.txt" || echo "None found" >> "$ANALYSIS_DIR/findings.txt"

echo "" >> "$ANALYSIS_DIR/findings.txt"
echo "Suspicious listening ports:" >> "$ANALYSIS_DIR/findings.txt"
(netstat -tln 2>/dev/null || ss -tln) | grep -E "4444|5555|6666|1234|31337" >> "$ANALYSIS_DIR/findings.txt" || echo "None found" >> "$ANALYSIS_DIR/findings.txt"

echo "" >> "$ANALYSIS_DIR/findings.txt"
echo "Suspicious files in /tmp:" >> "$ANALYSIS_DIR/findings.txt"
find /tmp -type f \( -iname "*backdoor*" -o -iname "*malicious*" -o -iname "*exploit*" \) >> "$ANALYSIS_DIR/findings.txt" 2>/dev/null || echo "None found" >> "$ANALYSIS_DIR/findings.txt"

echo "" >> "$ANALYSIS_DIR/findings.txt"
echo "Analysis completed: $ANALYSIS_DIR" | tee -a "$ANALYSIS_DIR/findings.txt"
EOF
chmod +x detect_unauthorized.sh

echo "Creating generate_report.sh..."
cat > generate_report.sh << 'EOF'
#!/bin/bash

REPORT_DIR="/home/forensics/reports"
mkdir -p "$REPORT_DIR"
REPORT_FILE="$REPORT_DIR/forensic_report_$(date +%Y%m%d_%H%M%S).txt"

{
    echo "Linux Forensic Report"
    echo "====================="
    echo "Report Date: $(date)"
    echo "System Name: $(hostname)"
    echo "Analyst Name: Student"
    echo ""
    echo "Executive Summary"
    echo "-----------------"
    echo "This report summarizes suspicious findings from Linux forensic data collection."
    echo ""
    echo "Detailed Findings"
    echo "-----------------"
    find /home/forensics -name "findings.txt" -exec cat {} \; 2>/dev/null
    echo ""
    echo "Recommendations"
    echo "---------------"
    echo "1. Review failed login sources"
    echo "2. Investigate suspicious processes"
    echo "3. Close unauthorized listening ports"
    echo "4. Remove suspicious files from temporary directories"
    echo "5. Preserve forensic evidence for incident response"
} > "$REPORT_FILE"

echo "Report generated: $REPORT_FILE"
EOF
chmod +x generate_report.sh

echo "Lab 16 setup completed."

echo ""
echo "Run these in order:"
echo "cd /home/forensics/scripts"
echo "./forensic_collector.sh"
echo "python3 forensic_analyzer.py"
echo "./create_test_activities.sh"
echo "./detect_unauthorized.sh"
echo "./generate_report.sh"
