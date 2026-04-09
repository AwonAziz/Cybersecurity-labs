This lab introduces Security Orchestration, Automation, and Response (SOAR) by deploying:

TheHive — Case management & incident tracking
Cortex — Automated threat analysis

You will build automated incident response playbooks for malware and phishing scenarios and integrate them with simulated SIEM alerts.

Objectives

By the end of this lab, you will:

Understand SOAR fundamentals and workflows
Deploy TheHive + Cortex using Docker
Design automated incident response playbooks
Implement containment and remediation logic
Integrate playbooks with simulated SIEM alerts
Test and validate automated response workflows

Task 1: Deploy SOAR Platform

You will:

Create project structure
Configure Docker Compose
Deploy Elasticsearch, TheHive, Cortex
Verify services

Task 2: Malware Response Playbook

You will build a Python playbook that:

Creates incident cases in TheHive
Adds observables (IOCs)
Analyzes file hashes
Isolates infected hosts
Blocks malicious indicators

Task 3: Phishing Response Playbook

You will implement:

Email header analysis (SPF, DKIM, DMARC)
URL extraction and risk scoring
Email quarantine
URL blocking
User notification

Task 4: SIEM Integration

You will create an automation layer that:

Receives alerts
Classifies incident type
Triggers appropriate playbook
Logs response actions


Start SOAR Platform
docker-compose up -d
Verify Services
docker-compose ps
curl http://localhost:9200/_cluster/health
curl http://localhost:9000/api/status
Testing Playbooks
Malware Playbook
python3 playbooks/malware_playbook.py
Phishing Playbook
python3 playbooks/phishing_playbook.py
SIEM Integration
python3 integration/siem_integration.py
Expected Outcomes

After completing this lab, you will have:

A working SOAR platform
Automated malware response playbook
Automated phishing response playbook
SIEM alert integration pipeline
Practical understanding of automation in SOC environments

Key Skills Gained
SOAR platform deployment
Incident response automation
Playbook design and execution
Threat containment workflows
Security orchestration
Integration with SIEM systems
