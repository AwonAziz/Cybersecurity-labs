This lab introduces basic network reconnaissance and threat simulation using Nmap and Python. You will scan a local target, enumerate services, automate scans, log findings, and generate simple reports and dashboards.

## Objectives
- Perform basic and advanced Nmap scans
- Identify open ports and running services
- Enumerate service and OS information
- Automate scans using Python
- Save scan results in structured formats
- Generate a simple HTML dashboard for reporting

## Prerequisites
- Ubuntu Linux environment
- Nmap installed
- Python 3 and pip
- Basic networking and Linux command-line knowledge
- Administrative privileges for privileged scans

## Lab Environment
This lab uses a single Linux machine with:
- Ubuntu Linux
- Nmap pre-installed or installable
- Python 3
- Local services such as SSH and Apache for testing

## Project Structure
text
~/basic_threat_simulation/
├── basic_scanner.py
├── advanced_scanner.py
├── generate_dashboard.py
├── scan_results_*.json
├── threat_analysis_*.json
├── threat_analysis_*.csv
├── security_report_*.txt
├── threat_scan_*.log
└── threat_dashboard_*.html
Setup

Install required tools and prepare the environment:

sudo apt update
sudo apt install -y nmap python3-pip jq
pip3 install python-nmap
mkdir -p ~/basic_threat_simulation
cd ~/basic_threat_simulation
Workflow

Verify Nmap installation

Start local services for testing

Run basic and advanced Nmap scans

Automate scanning with Python scripts

Save results as JSON or CSV

Generate a text report and HTML dashboard

Key Files

basic_scanner.py — basic Python Nmap wrapper

advanced_scanner.py — advanced scanner with logging and reporting

generate_dashboard.py — HTML dashboard generator

scan_results_*.json — basic scan results

threat_analysis_*.json / *.csv — structured analysis output

security_report_*.txt — security assessment report

threat_dashboard_*.html — visual dashboard

threat_scan_*.log — execution logs

Run Commands

Use the provided commands.sh file or run the commands manually in sequence.

Expected Outcome

By the end of this lab, you should be able to:

Scan localhost using Nmap

Detect open ports and exposed services

Automate scans using Python

Save and review structured findings

Generate simple reports and dashboards for documentation
