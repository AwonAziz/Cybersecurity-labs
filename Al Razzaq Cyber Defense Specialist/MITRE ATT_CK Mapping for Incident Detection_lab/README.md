This lab introduces the MITRE ATT&CK framework and demonstrates how it can be used to map security incidents to known adversary techniques and tactics. Students will parse MITRE ATT&CK data, analyze system logs, detect attack techniques, and generate incident reports with proper MITRE classifications.

Objectives

By the end of this lab, students will be able to:

Understand the MITRE ATT&CK framework structure
Map security incidents to ATT&CK techniques and tactics
Analyze Windows, Linux, and network logs
Create automated detection rules
Generate incident reports with ATT&CK classifications

Task 1 – Setup MITRE ATT&CK Environment

Steps:

Create directory structure
Download MITRE ATT&CK dataset
Install required Python libraries
Create sample log files

Commands:

mkdir -p ~/mitre-lab/{data,scripts,logs,reports}
cd ~/mitre-lab

wget https://raw.githubusercontent.com/mitre/cti/master/enterprise-attack/enterprise-attack.json -O data/enterprise-attack.json

pip3 install requests pandas stix2 pyyaml
Task 2 – MITRE ATT&CK Parser

Script:

scripts/mitre_parser.py

This script:

Loads MITRE ATT&CK JSON data
Parses techniques
Parses tactics
Allows searching techniques by ID or keyword

Run parser:

cd ~/mitre-lab/scripts
python3 mitre_parser.py

Expected output:

Number of techniques loaded
Number of tactics loaded
Task 3 – Log Analyzer

Script:

scripts/log_analyzer.py

This script:

Reads log files
Matches log patterns to MITRE techniques
Assigns severity levels
Generates JSON report

Run analyzer:

python3 log_analyzer.py

View results:

python3 view_results.py
Task 4 – Automated Incident Mapping

Script:

scripts/auto_mapper.py

This script:

Maps indicators to MITRE techniques
Generates incident reports
Provides security recommendations

Run auto mapper:

python3 auto_mapper.py
Task 5 – Custom Detection Rules

File:

scripts/custom_rules.yaml

Students can define custom detection rules such as:

Suspicious PowerShell execution
File deletion activity
Process injection
Scheduled tasks

This lab demonstrated how the MITRE ATT&CK framework can be used to classify and analyze security incidents. Students built tools to parse ATT&CK data, analyze logs, map incidents to techniques, and generate structured reports. These skills are important for detection engineering, threat intelligence, and incident response.
