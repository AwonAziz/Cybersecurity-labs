This lab focuses on capturing and analyzing network traffic using Wireshark and tshark on a Linux system. Students will learn how to monitor DNS, HTTP, and TLS traffic, identify suspicious activity, and generate automated network analysis reports.

Network traffic analysis is a critical cybersecurity skill used for threat detection, incident response, and network monitoring.

Objectives

By the end of this lab, students will be able to:

Install and configure Wireshark on Linux
Capture live network traffic
Analyze DNS traffic for suspicious domains and tunneling
Examine HTTP traffic for anomalies and attacks
Investigate TLS traffic for weak encryption and certificate issues
Apply packet filtering techniques
Detect common network attacks
Generate automated network traffic analysis reports

Lab Tasks Summary
Task 1 – Install and Configure Wireshark
Update system
Install Wireshark, tshark, and networking tools
Configure non-root packet capture
Verify network interfaces
Task 2 – Capture Network Traffic
Capture packets using Wireshark GUI and tshark
Generate DNS, HTTP, and HTTPS traffic
Capture protocol-specific traffic using filters
Task 3 – Analyze DNS Traffic
Filter DNS traffic
Identify suspicious domains
Detect DNS tunneling attempts
Analyze DNS responses and query patterns
Task 4 – Analyze HTTP Traffic
Analyze HTTP methods, headers, and user agents
Detect SQL injection, XSS, and directory traversal attempts
Identify suspicious user agents and abnormal requests
Task 5 – Analyze TLS Traffic
Capture TLS handshake traffic
Identify TLS versions and cipher suites
Detect weak encryption and certificate issues
Check for Perfect Forward Secrecy support
Task 6 – Reporting and Visualization
Generate comprehensive network analysis report
Produce traffic statistics
Export results and capture files
Analysis Scripts Created During Lab

The lab generates the following scripts:

Script	Purpose
analyze_dns.sh	DNS traffic analysis
detect_dns_tunneling.sh	DNS tunneling detection
analyze_http.sh	HTTP traffic analysis
detect_http_anomalies.sh	HTTP attack detection
analyze_tls.sh	TLS traffic analysis
detect_tls_issues.sh	TLS security checks
comprehensive_analysis.sh	Full report generation
traffic_stats.sh	Traffic statistics
export_results.sh	Export analysis results
Output Files Generated

The lab produces:

DNS capture files
HTTP capture files
TLS capture files
Network analysis report
CSV exports
Traffic statistics
Export directory with all results

Location:

/tmp/

Export Directory:

/tmp/wireshark_analysis_export
Skills Gained

After completing this lab, students will be able to:

Perform packet capture and analysis
Detect malicious DNS activity
Identify HTTP-based attacks
Analyze TLS security configurations
Automate traffic analysis with scripts
Generate security reports from packet captures

These are essential skills for:

SOC Analyst
Network Security Analyst
Incident Responder
Cybersecurity Engineer
Conclusion

This lab demonstrated how network traffic analysis can be used to detect security threats, analyze protocols, and investigate suspicious activity. Wireshark and tshark provide powerful tools for deep packet inspection and network security monitoring.

Network traffic analysis is a core skill in cybersecurity and is widely used in SOC environments, penetration testing, and incident response investigations.
