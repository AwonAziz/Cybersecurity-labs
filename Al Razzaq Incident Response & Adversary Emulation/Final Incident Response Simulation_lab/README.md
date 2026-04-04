This lab simulates a real-world Security Operations Center (SOC) environment where you will deploy, monitor, and respond to cyber attacks using industry-standard tools:

Wazuh (SIEM & endpoint detection)
Suricata (Intrusion detection)
Zeek (Traffic analysis)

You will go through the complete incident response lifecycle:
Detection → Analysis → Containment → Eradication → Recovery → Reporting

Objectives

By completing this lab, you will:

Build a SOC environment using open-source tools
Detect and analyze simulated attacks
Execute incident response playbooks
Perform containment, eradication, and recovery
Generate professional incident reports

Tasks Breakdown
 Task 1: Environment Setup
Install and configure:
Wazuh Manager + Agent
Suricata IDS
Zeek NSM
Integrate logs into Wazuh
 Task 2: Attack Simulation

Simulate multiple attack types:

 Port Scanning
 Web Attacks (SQLi, XSS, brute-force)
 Malware-like behavior

Analyze logs from:

/var/ossec/logs/alerts/alerts.log
/var/log/suricata/fast.log
/opt/zeek/logs/current/
 Task 3: Incident Response
Phases:
Identification
Containment
Eradication
Recovery
Lessons Learned

You will:

Collect forensic evidence
Block malicious traffic
Remove threats
Restore services
 Task 4: Documentation

Generate:

Detection summary
Incident timeline
Lessons learned
Executive summary
Final documentation package
 Project Structure
incident-response-lab/
│
├── logs/
├── scripts/
├── evidence/
├── reports/
└── final_documentation/
 Key Skills Gained
SIEM configuration and monitoring
Network traffic analysis
Incident response execution
Threat detection and correlation
Security reporting
 Troubleshooting
Issue	Solution
Services not starting	sudo systemctl status <service>
No alerts generated	Check log paths & permissions
Interface errors	Verify using ip route
 Expected Outcomes
Functional SOC environment
Successful detection of simulated attacks
Incident response execution
Complete documentation package
 Ethical Reminder

This lab is for educational purposes only.
Never perform these actions on systems without explicit permission.
