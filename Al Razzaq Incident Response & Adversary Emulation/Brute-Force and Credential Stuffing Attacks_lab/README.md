This lab demonstrates brute-force and credential stuffing attacks against FTP and HTTP authentication services using Hydra and custom automation scripts. The lab also includes defensive countermeasures such as Fail2Ban and rate limiting.

Objectives

By completing this lab, you will:

Understand brute-force and credential stuffing attacks
Use Hydra to test FTP and HTTP authentication security
Create automation scripts for credential attacks
Analyze attack results and password weaknesses
Implement defensive countermeasures
Document security findings professionally

Task 1 – Environment Setup

You will:

Verify Hydra installation
Install and start FTP and HTTP services
Create test users with weak passwords
Configure HTTP Basic Authentication
Create username and password wordlists
Task 2 – Brute-Force Attacks with Hydra

You will perform:

Single credential testing
Full brute-force attacks on FTP
HTTP Basic Authentication brute-force
Multi-threaded and stealth attacks
Save results to output files

Output files:

ftp_results.txt
http_results.txt
Task 3 – Custom Attack Scripts

You will create:

brute_force.sh → Automates Hydra attacks
credential_stuffing.sh → Tests known credential pairs
analyze_results.sh → Parses results and generates report

These scripts should:

Validate inputs
Log results
Generate summaries
Identify weak passwords
Task 4 – Defense Testing

You will:

Test login rate limiting
Configure Fail2Ban
Trigger bans using repeated failed logins
Verify IP blocking
Generate a security assessment report
Deliverables

At the end of the lab, you should have:

Hydra attack result files
Automation scripts
Analysis report
Fail2Ban configuration
Security report (security_report.md)
Security Report Sections

Your report should include:

Executive Summary
Methodology
Findings
Weak Password Analysis
Recommendations
Conclusion
Key Takeaways
Weak passwords are easily compromised
Hydra automates brute-force attacks efficiently
Credential stuffing exploits password reuse
Fail2Ban helps mitigate brute-force attacks
Logging and reporting are essential in security testing
Ethical Reminder

Only perform brute-force or credential stuffing attacks on systems you own or have explicit permission to test.
Unauthorized access is illegal and unethical.
