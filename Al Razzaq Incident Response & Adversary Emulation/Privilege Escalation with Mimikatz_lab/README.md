Overview

This lab focuses on credential extraction and privilege escalation techniques using Mimikatz in a controlled environment. Since the lab runs on Linux, Windows behavior is simulated using Wine and custom scripts.

You will explore how credentials are stored in memory, how attackers extract them, and how to implement defensive measures against such attacks.

Objectives

By the end of this lab, you will:

Understand Windows credential storage mechanisms
Use Mimikatz in a controlled simulation
Automate credential extraction workflows
Analyze password and hash security
Perform privilege escalation assessments with PowerShell
Implement defensive measures against credential theft

Lab Tasks Summary

Task 1: Environment Setup
Verify installed tools
Download and extract Mimikatz
Configure Wine environment
Create simulated credential environment

Task 2: Credential Extraction
Explore Mimikatz modules
Build credential extraction scripts
Parse Mimikatz output
Extract hashes and passwords

Task 3: Privilege Escalation Checks
Create PowerShell enumeration script
Identify privilege escalation vectors
Analyze system security configuration

Task 4: Defensive Measures
Disable insecure authentication mechanisms
Enable protections such as LSA Protection
Implement monitoring and logging
Build detection scripts

Key Commands:

Run Mimikatz (via Wine)
wine mimikatz.exe
Example Commands inside Mimikatz
privilege::debug
sekurlsa::logonpasswords
lsadump::sam
exit
PowerShell Execution
pwsh -File privilege_check.ps1 -Export -OutputPath results.json
Expected Outcomes

After completing this lab, you will have:

Simulated credential extraction results
Automated credential parsing scripts
Privilege escalation assessment output
Password and hash analysis reports
Security hardening recommendations
Monitoring and detection scripts

Security Concepts Covered:

LSASS memory credential storage
NTLM hash exposure
Credential dumping techniques
Privilege escalation vectors
Defensive security configurations

Defensive Measures:

Disable WDigest authentication
Enable LSA Protection
Use Credential Guard
Implement LAPS
Configure audit logging
Monitor LSASS access

Legal and Ethical Notice

This lab is for educational purposes only.
Credential extraction techniques must only be used in:

Authorized penetration tests
Controlled lab environments

Unauthorized use is illegal and unethical.

Conclusion

This lab demonstrates how attackers extract credentials from memory and how defenders can prevent it. Understanding both offensive and defensive perspectives is essential for modern security roles such as SOC analyst, incident responder, and red teamer.
