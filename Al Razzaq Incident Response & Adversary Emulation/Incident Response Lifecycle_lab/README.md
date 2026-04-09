This lab introduces the Incident Response Lifecycle based on the NIST framework. You will simulate a real security incident and walk through all major phases:

Detection
Containment
Recovery
Documentation

You will also build a hands-on incident response toolkit using Linux-based open-source tools.

Objectives

By the end of this lab, you will:

Understand the phases of the incident response lifecycle
Configure and use incident response tools on Linux
Detect suspicious activity using monitoring and logs
Apply containment strategies to stop threats
Perform recovery and system hardening
Document incidents professionally
Apply the NIST incident response framework

Task 1: Configure IR Tools

You will:

Install monitoring and forensic tools
Create structured directories
Build system monitoring scripts
Configure log collection

Task 2: Detection Phase

You will:

Establish baseline system behavior
Simulate suspicious activity
Detect anomalies (CPU, files, processes)
Build a detection timeline

Task 3: Containment Phase

You will:

Kill malicious processes
Quarantine suspicious files
Preserve forensic evidence
Document containment actions

Task 4: Recovery Phase

You will:

Verify system cleanup

Running the Lab

Run Monitoring
./scripts/system_monitor.sh
Simulate Incident
./scripts/simulate_incident.sh
Run Detection Analysis
cat ~/incident_response/evidence/detection_results.txt
Execute Containment
./scripts/containment_actions.sh
Preserve Evidence
./scripts/preserve_evidence.sh
Verify Recovery
./scripts/recovery_verification.sh
Final Validation
./scripts/final_validation.sh

Expected Outcomes

After completing this lab, you will have:

A complete incident response workflow
Detection and monitoring scripts
Evidence collection artifacts
Containment and recovery procedures
Professional incident reports

Key Skills Gained
Incident detection and analysis
Process and file investigation
Threat containment techniques
Evidence preservation
System recovery and hardening
Security documentation
Harden system security
Implement monitoring scripts
Generate recovery reports
