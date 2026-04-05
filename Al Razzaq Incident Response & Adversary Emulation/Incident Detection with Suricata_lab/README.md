This lab focuses on installing, configuring, and using Suricata as a Network Intrusion Detection System (NIDS). You will create custom detection rules, generate test traffic, analyze logs, and perform basic incident response actions based on Suricata alerts.

This lab simulates real-world Security Operations Center (SOC) activities where analysts monitor network traffic and investigate suspicious activity.

Objectives

By the end of this lab, students will be able to:

Install and configure Suricata NIDS
Create and customize Suricata detection rules
Generate simulated attack traffic
Analyze Suricata logs
Interpret alerts and threat indicators
Perform basic incident response actions

Task 1 — Install and Configure Suricata

You will:

Update system packages
Install Suricata
Configure network interface
Update Suricata rules
Create custom detection rules
Test Suricata configuration
Task 2 — Generate and Analyze Test Traffic

You will:

Start Suricata in detection mode
Generate ICMP traffic
Generate HTTP traffic
Simulate SSH brute force attempts
Generate DNS queries
Analyze Suricata logs
Create log analysis and monitoring scripts
Task 3 — Advanced Traffic Analysis & Incident Response

You will:

Simulate attack scenarios
Create incident response scripts
Monitor Suricata performance
Optimize detection rules
Task 4 — Log Analysis and Reporting

You will:

Create advanced log parser (Python)
Create alert dashboard
Monitor alerts in real-time
Task 5 — Rule Optimization and Custom Detection

You will:

Create advanced detection rules
Test custom rules
Analyze rule performance
Optimize detection efficiency
Expected Outcomes

After completing this lab, you should be able to:

Deploy Suricata NIDS
Write custom intrusion detection rules
Analyze network security logs
Identify attack patterns
Perform incident response procedures
Monitor IDS performance
Optimize detection rules

These skills are essential for:

SOC Analyst
Incident Response Analyst
Security Engineer
Threat Hunter
Network Security Analyst
Log Files Location

Suricata logs are stored in:

/var/log/suricata/

Important files:

fast.log      → Quick alerts
eve.json      → Detailed JSON logs
stats.log     → Performance statistics
suricata.log  → System logs
Useful Analysis Commands
sudo tail -f /var/log/suricata/fast.log
sudo tail -f /var/log/suricata/eve.json
sudo cat /var/log/suricata/eve.json | jq 'select(.event_type=="alert")'
sudo systemctl status suricata
Conclusion

In this lab, you implemented a Network Intrusion Detection System using Suricata, created custom detection rules, simulated attacks, analyzed logs, and built incident response tools. These tasks replicate real-world SOC operations and incident detection workflows used in enterprise cybersecurity environments.
