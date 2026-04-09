Overview

This lab introduces Open-Source Intelligence (OSINT) gathering using theHarvester. You will collect publicly available information such as email addresses and subdomains, automate data processing, and generate structured reports.

The lab also covers the use of OSINT in incident response and adversary emulation scenarios, along with legal and ethical considerations.

Objectives

By the end of this lab, you will:

Understand OSINT fundamentals
Install and configure theHarvester
Gather emails and subdomains from public sources
Analyze OSINT data for security insights
Automate OSINT workflows using Python
Generate structured reports (HTML, JSON, CSV)
Apply OSINT in incident response scenarios

Lab Tasks Summary

Task 1: Installation
Install dependencies
Clone and install theHarvester
Verify installation

Task 2: Basic OSINT Gathering
Collect email addresses
Enumerate subdomains
Perform multi-source scans

Task 3: Advanced Techniques
Use multiple data sources
Configure API keys
Perform passive DNS analysis
Gather social media intelligence

Task 4: Automation Scripts
Create Python automation script
Generate HTML reports
Build advanced data processing scripts
Export CSV and JSON outputs

Task 5: Practical Scenarios
Incident response reconnaissance
Adversary emulation exercises

Task 6: Data Analysis
Extract emails and subdomains manually
Analyze patterns
Generate summary statistics

Task 7: Legal and Ethical Considerations
Follow authorization requirements
Respect privacy and regulations
Apply rate limiting

Key Commands
Basic Scan
python3 theHarvester.py -d example.com -l 100 -b google
Multi-Source Scan
python3 theHarvester.py -d example.com -l 200 -b google,bing,dnsdumpster,crtsh
Save Output
python3 theHarvester.py -d example.com -l 100 -b google -f output_file

Expected Outcomes:

After completing this lab, you will have:

Email and subdomain intelligence data
Automated OSINT scripts
Structured reports (HTML, CSV, JSON)
Practical OSINT workflow experience

Legal Notice

OSINT must only be conducted on:

Domains you own
Systems you are authorized to test

Do not collect or misuse private or restricted data.

Conclusion

This lab provides practical experience in OSINT collection and analysis. You learned how to gather intelligence, automate workflows, and generate reports. These skills are widely used in incident response, threat intelligence, and security assessments.
