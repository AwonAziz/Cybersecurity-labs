This lab brings together core SOC operations in a single environment. You will configure monitoring tools, analyze logs, create detection and response scripts, build incident response playbooks, and test automated containment actions.

## Objectives
- Configure and integrate SOC monitoring components
- Implement automated threat detection rules
- Analyze logs from multiple security sources
- Build and use incident response playbooks
- Automate threat containment and remediation actions

## Prerequisites
- Basic Linux command-line skills
- Understanding of networking and security fundamentals
- Familiarity with log analysis
- Basic Python or Bash scripting knowledge
- Awareness of common cyber attack techniques

## Lab Environment
This lab uses an Ubuntu 20.04+ cloud machine with:
- Minimum 4 GB RAM
- Minimum 20 GB disk space
- Internet connectivity
- Python 3, rsyslog, and iptables available

## Project Structure
```text
/opt/soc/
├── logs/
├── scripts/
├── playbooks/
├── alerts/
└── reports/
Setup

Install the required tools and create the SOC workspace:

sudo apt update && sudo apt upgrade -y
sudo apt install -y suricata fail2ban rsyslog python3-pip jq
sudo mkdir -p /opt/soc/{logs,scripts,playbooks,alerts,reports}
sudo chown -R $USER:$USER /opt/soc
Workflow

Install and verify SOC tools

Configure centralized logging

Configure Suricata and custom detection rules

Create analysis and response scripts

Build incident response playbooks

Simulate attacks and verify automated detection and response

Key Files

/opt/soc/logs/system.log — centralized system logs

/opt/soc/logs/auth.log — authentication logs

/opt/soc/logs/suricata-eve.json — Suricata EVE alerts

/opt/soc/scripts/log_analyzer.py — log analysis script

/opt/soc/scripts/block_ip.sh — IP blocking automation

/opt/soc/scripts/send_alert.py — alert notification script

/opt/soc/scripts/response_engine.py — automated response engine

/opt/soc/scripts/playbook_tracker.py — playbook execution tracker

/opt/soc/playbooks/brute_force_response.md — brute force response playbook

/opt/soc/playbooks/web_attack_response.md — web attack response playbook

/opt/soc/reports/analysis_report.json — generated analysis output
