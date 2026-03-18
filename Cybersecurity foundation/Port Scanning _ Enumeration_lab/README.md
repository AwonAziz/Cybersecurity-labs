This lab introduces the fundamentals of port scanning and service enumeration on a Linux system using Nmap, Netcat, netstat, and ss. You will scan localhost, identify open ports and services, test connectivity, perform basic banner grabbing, and generate simple security assessment reports in a controlled lab environment.

## Objectives
- Understand port scanning and network enumeration basics
- Use Nmap to discover open ports and services on localhost
- Use Netcat for connection testing and banner grabbing
- Identify listening services on a Linux system
- Interpret scan results to assess security posture
- Practice ethical hacking principles in a controlled environment

## Prerequisites
- Basic understanding of IP addresses, ports, and protocols
- Familiarity with Linux command-line basics
- Knowledge of TCP/IP fundamentals
- Awareness of common services like SSH, HTTP, FTP, and DNS
- Basic cybersecurity awareness and ethics

## Lab Environment
This lab runs entirely on a single Al Nafi Linux cloud machine.

Tools used:
- Nmap
- Netcat
- netstat
- ss

## Tasks Covered
1. Examine local network interfaces
2. Check currently listening services
3. Perform basic and advanced Nmap scans
4. Use Netcat for connection testing and banner grabbing
5. Identify services and analyze open ports
6. Generate a security assessment report

## Key Commands
- `ip addr show`
- `ss -tuln`
- `netstat -tuln`
- `nmap 127.0.0.1`
- `nmap -sV 127.0.0.1`
- `nmap -A 127.0.0.1`
- `sudo nmap -sU 127.0.0.1`
- `nc -zv 127.0.0.1 22`
- `nc 127.0.0.1 22`

## Scripts Created
- `identify_services.sh`
- `analyze_ports.sh`
- `security_report.sh`

## Expected Outcome
By the end of this lab, you should be able to:
- Discover open TCP and UDP ports on localhost
- Identify services and their versions
- Verify ports using Netcat
- Capture simple service banners
- Run basic Nmap scripts
- Produce a local security assessment report
