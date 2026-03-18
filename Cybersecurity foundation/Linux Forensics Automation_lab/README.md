This lab focuses on collecting and analyzing forensic evidence from a Linux system. You will gather logs, process information, network data, and system details, then automate collection and analysis using Bash and Python scripts. The lab also includes detection of suspicious activity and generation of forensic reports.

## Objectives
- Extract and analyze Linux system logs, processes, and network information
- Create automated Bash and Python scripts for forensic collection
- Identify unauthorized or suspicious activities from collected data
- Implement repeatable forensic workflows for incident response
- Generate structured forensic reports

## Prerequisites
- Basic Linux command line skills
- Familiarity with file systems and text editors
- Understanding of Linux logs and processes
- Basic Bash and Python scripting knowledge

## Lab Environment
This lab uses a pre-configured Ubuntu Linux environment with:
- Ubuntu Linux
- Root access for system-level operations
- Sample logs and test scenarios
- Forensic utilities available

## Directory Structure
Main working directory:
text
/home/forensics

Important subdirectories:

/home/forensics/logs
/home/forensics/processes
/home/forensics/network
/home/forensics/system_info
/home/forensics/scripts
/home/forensics/analysis
/home/forensics/reports
Tasks Covered

Manual forensic data collection

Automated evidence collection with Bash

Automated analysis with Python

Detection of unauthorized activities

Forensic report generation

Main Scripts

forensic_collector.sh — automated forensic collection

forensic_analyzer.py — analyzes collected logs, processes, and network data

create_test_activities.sh — creates simulated suspicious activity

detect_unauthorized.sh — searches for unauthorized activities

generate_report.sh — generates a forensic report

Key Evidence Sources

/var/log/syslog

/var/log/auth.log

journalctl

ps aux

pstree

lsof

netstat or ss

ip addr, ip route, ip neigh

iptables
