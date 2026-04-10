Overview

This lab focuses on implementing advanced Linux security controls using multiple layers of defense. It covers firewall configuration, mandatory access control systems, vulnerability assessment, and security monitoring.

The lab emphasizes a defense-in-depth approach using:

iptables and nftables for network security
SELinux and AppArmor for access control
Custom scripts for vulnerability assessment and log analysis
Objectives

By completing this lab, you will be able to:

Configure and manage iptables and nftables
Implement security policies using SELinux and AppArmor
Perform vulnerability assessments on Linux systems
Apply system and network hardening techniques
Analyze logs to identify security threats
Understand how Linux security frameworks interact

Task 1: Network Security
System Enumeration
ip addr show
ss -tuln
sudo iptables -L -v -n
systemctl list-units --type=service --state=running
iptables Configuration
Default deny policy
Allow loopback, SSH, HTTP, HTTPS
Add rate limiting and logging
Block suspicious TCP flags
Persist Rules
sudo apt update
sudo apt install -y iptables-persistent
sudo iptables-save > /etc/iptables/rules.v4
nftables Configuration
Modern firewall replacement
Stateful filtering
Rate-limited SSH access
sudo nft -f /etc/nftables-security.conf
sudo nft list ruleset
sudo systemctl enable nftables
sudo systemctl start nftables
Task 2: Advanced Access Control
SELinux
Check status and mode
View contexts
Create and install custom policy
sestatus
getenforce
ls -Z /etc/passwd
ps -eZ | head
AppArmor
Inspect profiles
Create and enforce custom profile
sudo apparmor_status
sudo aa-status
Security Context Manager

Script checks:

SELinux status
AppArmor status
Process security contexts
Task 3: Vulnerability Assessment
System Assessment
System info
Network configuration
User privileges
File permissions
Running services
Network Scanning
Port scanning with nmap
Service detection
Vulnerability scripts
Log Analysis
Failed logins
Sudo activity
System errors
Firewall logs
Comprehensive Report

Combines:

Vulnerability assessment
Network scan
Log analysis
Verification
Firewall Testing
ssh localhost
curl -I http://localhost
nc -zv localhost 21
AppArmor Testing
/usr/local/bin/testapp
Monitoring
sudo tail -f /var/log/auth.log
sudo tail -f /var/log/syslog
Troubleshooting
Reset iptables
sudo iptables -F
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
SELinux
sudo ausearch -m AVC -ts recent
sudo setenforce 0
sudo setenforce 1
AppArmor
sudo aa-complain /usr/local/bin/testapp
sudo aa-enforce /usr/local/bin/testapp
Conclusion

This lab demonstrates how to secure a Linux system using layered security:

Network protection using firewalls
Process-level control using SELinux and AppArmor
Continuous monitoring through logs
Proactive detection using vulnerability scans

These techniques are widely used in real-world environments such as cloud security, DevSecOps, and SOC operations.
