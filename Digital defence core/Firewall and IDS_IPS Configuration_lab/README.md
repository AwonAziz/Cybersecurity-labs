This lab focuses on implementing basic network security using UFW firewall and Fail2Ban intrusion prevention system. You will configure firewall rules, monitor security logs, test intrusion detection, and create automated security monitoring scripts.

Objectives

By the end of this lab, you will be able to:

Understand firewall and IDS/IPS concepts

Install and configure Fail2Ban

Configure firewall rules using UFW

Monitor authentication and firewall logs

Test firewall and intrusion detection rules

Apply basic Linux security hardening practices

Prerequisites

Basic Linux command line knowledge

Familiarity with nano or vim

Basic networking knowledge (IP, ports, protocols)

Understanding SSH and remote access

Knowledge of Linux log files

Lab Environment

The lab environment includes:

Ubuntu 20.04 or newer

Root/sudo access

Networking tools

Internet connectivity

Tasks Covered

Install and configure Fail2Ban

Configure SSH protection using Fail2Ban

Test Fail2Ban intrusion detection

Configure UFW firewall

Create firewall rules

Test firewall rules

Create security monitoring scripts

Perform security verification checks

Key Commands
sudo apt update
sudo apt install fail2ban ufw
sudo systemctl status fail2ban
sudo ufw status
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo fail2ban-client status
netstat -tuln
Expected Output Files
test_fail2ban.sh
test_firewall.sh
security_monitor.sh
security_check.sh
final_verification.sh
Learning Outcomes

After completing this lab, you should be able to:

Configure Fail2Ban for SSH protection

Configure UFW firewall rules

Monitor authentication logs

Detect brute force attacks

Implement firewall security policies

Create automated security monitoring scripts

Perform system security checks
