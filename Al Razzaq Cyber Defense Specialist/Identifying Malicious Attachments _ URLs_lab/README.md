his lab focuses on analyzing email attachments and URLs for malicious indicators using Python. You will build three security tools:

Attachment Scanner
URL Analyzer
Integrated Email Security Scanner

These tools simulate real-world email security and threat detection systems used in cybersecurity and SOC environments.

Lab Objectives

By completing this lab, you will learn how to:

Analyze email attachments for malicious characteristics
Scan URLs for phishing and malware indicators
Calculate file hashes (MD5, SHA256)
Implement risk scoring methodologies
Generate automated security reports
Build an integrated email security scanner

Task 1 – File Attachment Analysis
Environment Setup

Install required dependencies and create directories.

Create Test Files

You will create sample files including:

Normal text file
Shell script
Suspicious double extension file
Legitimate document file
Attachment Scanner

The attachment scanner will:

Calculate MD5 and SHA256 hashes
Identify file MIME type
Detect suspicious extensions
Detect double extensions
Calculate risk scores
Generate scan reports
Run Attachment Scanner

Single file scan:

python3 ~/malware_lab/attachment_scanner.py ~/malware_lab/samples/script.sh

Directory scan:

python3 ~/malware_lab/attachment_scanner.py ~/malware_lab/samples/
Task 2 – URL Analysis System
URL Analyzer Features

The URL analyzer will:

Extract domains
Detect IP-based URLs
Detect URL shorteners
Analyze URL structure
Fetch webpage content
Detect phishing keywords
Calculate URL risk scores
Generate reports
Run URL Analyzer

Single URL:

python3 ~/malware_lab/url_analyzer.py https://www.google.com

Batch URL scan:

python3 ~/malware_lab/url_analyzer.py ~/malware_lab/test_urls.txt
Task 3 – Integrated Email Security Scanner

This scanner combines:

Attachment scanning
URL analysis
Email content scanning
Overall risk scoring
Final security report
Run Integrated Scanner
python3 ~/malware_lab/integrated_scanner.py ~/malware_lab/sample_email.txt ~/malware_lab/samples/
Expected Outcomes

After completing this lab, you should have:

Functional attachment malware scanner
URL phishing detection tool
Risk scoring system
Automated security report generation
Integrated email security scanner

These tools simulate real SOC and cybersecurity automation workflows.

Troubleshooting
Issue	Solution
Import errors	Install libraries using pip3
Permission denied	Use chmod +x on Python files
Magic library errors	Install libmagic
Network timeout	Increase requests timeout
File not found	Verify file paths

Install Magic library:

sudo apt install libmagic1 python3-magic
Conclusion

In this lab, you built a complete email security analysis system capable of detecting malicious attachments and phishing URLs. These skills are highly relevant in cybersecurity roles such as:

SOC Analyst
Threat Intelligence Analyst
Security Engineer
Incident Responder
Malware Analyst
