In this lab, students learn how to capture, parse, and analyze HTTP and HTTPS traffic using command-line tools such as tcpdump, curl, openssl, grep, awk, and Python. The lab focuses on detecting suspicious web traffic, analyzing HTTPS metadata, and building automated traffic monitoring and alert systems.

This lab simulates real-world web traffic monitoring and intrusion detection tasks performed by SOC analysts and cybersecurity professionals.

Objectives

By the end of this lab, students will be able to:

Capture and analyze HTTP/HTTPS traffic using command-line tools
Parse HTTP headers and identify request/response components
Detect suspicious patterns and anomalies in web traffic
Analyze HTTPS metadata and TLS connection characteristics
Create automated scripts for traffic analysis
Apply traffic analysis techniques for security monitoring

Lab Tasks Summary
Task 1 – HTTP Traffic Capture and Analysis

Students will:

Create a local HTTP server
Capture HTTP traffic using tcpdump
Generate HTTP requests with curl
Extract HTTP requests from packet captures
Analyze HTTP methods and headers
Build a Python HTTP parser
Detect web attack patterns such as:
SQL Injection
XSS
Path Traversal
Command Injection
Task 2 – HTTPS Metadata Analysis

Students will:

Analyze SSL/TLS certificates using OpenSSL
Extract certificate issuer, subject, and expiration
Analyze TLS versions and cipher suites
Measure HTTPS connection timing
Build an HTTPS analyzer in Python
Capture HTTPS flows and analyze traffic metadata
Task 3 – Automated Traffic Monitoring

Students will:

Create real-time traffic monitoring scripts
Monitor HTTP and HTTPS traffic
Detect suspicious traffic patterns
Build a traffic alert system
Generate automated security alerts
Tools Used in This Lab
Tool	Purpose
tcpdump	Packet capture
curl	Generate HTTP/HTTPS requests
OpenSSL	Analyze SSL/TLS certificates
grep	Text filtering
awk	Log and traffic analysis
Python	Traffic parsing and analysis
http.server	Local HTTP test server
Files Created During Lab
File	Description
http_traffic.pcap	Captured HTTP traffic
http_requests.txt	Extracted HTTP requests
http_parser.py	HTTP request parser
test_requests.txt	Sample attack requests
analyze_cert.sh	SSL certificate analyzer
timing_analysis.sh	HTTPS timing analyzer
https_analyzer.py	HTTPS flow analyzer
https_flows.pcap	Captured HTTPS traffic
traffic_monitor.sh	Real-time monitoring script
alert_system.py	Traffic alert system
Skills Learned

After completing this lab, students will be able to:

Capture HTTP and HTTPS traffic
Analyze web requests and headers
Detect web attacks from traffic logs
Analyze TLS certificates and encryption
Monitor network traffic for security threats
Build automated traffic monitoring tools
Implement basic intrusion detection logic

These skills are important for:

SOC Analyst
Network Security Analyst
Incident Responder
Cybersecurity Engineer
Threat Analyst
Expected Outcomes

By the end of this lab, students should have:

Captured HTTP and HTTPS traffic
Parsed HTTP requests and headers
Detected suspicious web traffic patterns
Analyzed TLS certificates and HTTPS timing
Built automated monitoring scripts
Implemented a basic traffic alert system

This lab provided hands-on experience in HTTP and HTTPS traffic analysis, attack detection, TLS metadata analysis, and automated traffic monitoring. These techniques are used in real-world security operations centers (SOC), intrusion detection systems, and incident response investigations.

Understanding web traffic patterns and detecting anomalies is a critical cybersecurity skill and forms the foundation of network security monitoring and threat detection.
