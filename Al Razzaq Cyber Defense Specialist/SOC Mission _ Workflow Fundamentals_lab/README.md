This lab introduces the fundamental concepts of a Security Operations Center (SOC), including its mission, maturity levels, SIEM deployment, alerting systems, log collection, and SOC operational workflows. Students will deploy a basic SOC environment using the ELK Stack and ElastAlert.

Objectives

By the end of this lab, students will be able to:

Define the mission and purpose of a Security Operations Center (SOC)
Understand SOC maturity levels and their characteristics
Set up and configure a basic SIEM tool using open-source software
Create and configure alerting systems for security monitoring
Implement basic log collection and analysis workflows
Demonstrate understanding of SOC operational procedures

Lab Architecture

This lab sets up a basic SOC environment consisting of:

Elasticsearch – Log storage and search engine
Logstash – Log collection and parsing
Kibana – Log visualization dashboard
ElastAlert – Alerting system
SOC Scripts – Dashboard and operations scripts
SOC Documentation – Mission and incident response procedures
Directory Structure Created
~/soc-lab/
├── documentation/
│   ├── soc-mission.txt
│   └── incident-response.txt
├── scripts/
│   ├── generate-events.sh
│   ├── soc-dashboard.sh
│   └── soc-operations.sh
SOC Mission Summary

The SOC mission includes:

Prevention
Detection
Response
Recovery
Improvement

SOC maturity levels range from:

Level 1 – Initial
Level 2 – Developing
Level 3 – Defined
Level 4 – Managed
Level 5 – Optimizing

This lab environment represents approximately a Level 2 SOC.

Services Installed

The following services are installed and configured:

Service	Purpose
Elasticsearch	Log storage
Logstash	Log ingestion
Kibana	Dashboard
ElastAlert	Alerting
SOC Scripts	Monitoring & Operations
Running the SOC Dashboard
~/soc-lab/scripts/soc-dashboard.sh
Running SOC Operations Menu
~/soc-lab/scripts/soc-operations.sh
Generating Test Security Events
~/soc-lab/scripts/generate-events.sh
Access Kibana

Open in browser:

http://localhost:5601

Create index pattern:

soc-logs-*

Use:

@timestamp
Verification Commands

Check services:

sudo systemctl status elasticsearch
sudo systemctl status logstash
sudo systemctl status kibana

Check Elasticsearch indices:

curl localhost:9200/_cat/indices?v

Check alerts:

tail -f /var/log/elastalert/elastalert.log
What This Lab Demonstrates

This lab simulates a basic SOC workflow:

Logs generated
Logstash collects logs
Elasticsearch stores logs
Kibana visualizes logs
ElastAlert triggers alerts
SOC dashboard monitors environment
Incident response procedures followed
Conclusion

In this lab, we built a basic Security Operations Center environment using open-source tools. We implemented log collection, monitoring, alerting, dashboards, and SOC operational procedures, simulating real-world SOC workflows.

This lab forms the foundation for future SOC, SIEM, threat detection, and incident response labs.
