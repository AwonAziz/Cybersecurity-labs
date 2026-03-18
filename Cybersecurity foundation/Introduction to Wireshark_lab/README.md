This lab introduces packet capture and traffic analysis using Wireshark and Tshark on Linux. You will install Wireshark, capture live traffic, apply protocol filters, inspect suspicious patterns, export relevant data, and generate a simple analysis report.

## Objectives
- Install and configure Wireshark on Linux
- Capture live network traffic
- Filter and analyze HTTP, TCP, and DNS packets
- Identify basic anomalies and suspicious activity
- Export captured traffic for reporting
- Understand the fundamentals of packet analysis for cybersecurity

## Prerequisites
- Basic understanding of IP addresses, ports, and protocols
- Familiarity with the Linux command line
- Knowledge of HTTP, TCP, and DNS
- Basic cybersecurity awareness

## Lab Environment
This lab uses an Ubuntu-based cloud machine with:
- Linux operating system
- Network connectivity for traffic generation
- Administrative privileges for packet capture

## Key Tools
- Wireshark
- Tshark
- Curl
- Wget
- Dig / Nslookup / Host

## Workflow
1. Install Wireshark and supporting tools
2. Configure capture permissions
3. Identify the active network interface
4. Capture live traffic
5. Generate HTTP, DNS, HTTPS, and ICMP traffic
6. Apply filters for protocol analysis
7. Export filtered traffic and generate a report

## Important Filters
text
http
http.request.method == "GET"
http.response
tcp
tcp.port == 80
tcp.flags.syn == 1
dns
dns.flags.response == 0
dns.flags.response == 1
http or tls
dns or http
Key Files

capture.pcap — main packet capture file

http_traffic.pcap — filtered HTTP capture

http_traffic.csv — exported HTTP packet data

external_ips.txt — extracted public IP list

analyze_capture.sh — report generation script

network_analysis_report.txt — generated report

Verification

At the end of the lab, confirm that:

Wireshark or Tshark is installed

A packet capture file was created

HTTP, DNS, and TCP traffic can be filtered

Exported files were generated successfully

A basic traffic analysis report was produced
