#!/bin/bash

set -e

echo "Checking local network interfaces..."
ip addr show || true
ifconfig 2>/dev/null || true

echo
echo "Checking listening services..."
netstat -tuln 2>/dev/null || true
ss -tuln || true

echo
echo "Checking Nmap installation..."
if ! command -v nmap >/dev/null 2>&1; then
    echo "Nmap not found. Installing..."
    sudo apt update
    sudo apt install nmap -y
fi
nmap --version

echo
echo "Running basic localhost scans..."
nmap 127.0.0.1 || true
nmap -p 1-1000 127.0.0.1 || true
nmap -sV 127.0.0.1 || true

echo
echo "Running detailed enumeration..."
nmap -sV -O 127.0.0.1 || true
nmap -A 127.0.0.1 || true
nmap -p- 127.0.0.1 || true

echo
echo "Running UDP scans..."
sudo nmap -sU 127.0.0.1 || true
sudo nmap -sU -p 53,67,68,123,161 127.0.0.1 || true

echo
echo "Running advanced Nmap techniques..."
sudo nmap -sS 127.0.0.1 || true
nmap -sT 127.0.0.1 || true
sudo nmap -sA 127.0.0.1 || true

echo
echo "Running Nmap scripts..."
nmap -sC 127.0.0.1 || true
nmap --script-help all | head -20 || true
nmap --script vuln 127.0.0.1 || true
nmap --script http-enum 127.0.0.1 || true

echo
echo "Saving scan output..."
nmap -oN scan_results.txt 127.0.0.1 || true
nmap -oX scan_results.xml 127.0.0.1 || true
nmap -oG scan_results.gnmap 127.0.0.1 || true
nmap -oA complete_scan 127.0.0.1 || true
cat scan_results.txt 2>/dev/null || true

echo
echo "Checking Netcat installation..."
if ! command -v nc >/dev/null 2>&1; then
    echo "Netcat not found. Installing..."
    sudo apt install netcat-openbsd -y
fi
nc -h 2>&1 | head -20 || true

echo
echo "Testing connections with Netcat..."
nc -zv 127.0.0.1 22 || true
nc -zv 127.0.0.1 20-25 || true
timeout 5 nc -zv 127.0.0.1 80 || true

echo
echo "Attempting banner grabbing..."
timeout 5 bash -c 'echo | nc 127.0.0.1 22' || true
timeout 5 bash -c 'echo -e "GET / HTTP/1.1\r\nHost: localhost\r\n\r\n" | nc 127.0.0.1 80' || true
timeout 5 nc -C 127.0.0.1 22 || true

echo
echo "Creating a simple Netcat listener test..."
( timeout 10 nc -l -p 1234 > /tmp/nc_listener_output.txt 2>/dev/null & )
sleep 2
echo "Hello from client" | nc 127.0.0.1 1234 || true
sleep 1
cat /tmp/nc_listener_output.txt 2>/dev/null || true

echo
echo "Creating identify_services.sh..."
cat > identify_services.sh << 'EOF'
#!/bin/bash

echo "=== Service Identification Report ==="
echo "Date: $(date)"
echo "Host: $(hostname)"
echo "IP: $(hostname -I)"
echo

echo "=== Open TCP Ports ==="
nmap -sT 127.0.0.1 | grep "open"

echo
echo "=== Service Versions ==="
nmap -sV 127.0.0.1 | grep -E "(open|Service Info)"

echo
echo "=== Listening Services ==="
ss -tuln | grep LISTEN

echo
echo "=== Process Information ==="
sudo netstat -tulnp | grep LISTEN
EOF

chmod +x identify_services.sh
./identify_services.sh || true

echo
echo "Creating analyze_ports.sh..."
cat > analyze_ports.sh << 'EOF'
#!/bin/bash

echo "=== Port Analysis ==="

declare -A common_ports=(
    [22]="SSH"
    [23]="Telnet"
    [25]="SMTP"
    [53]="DNS"
    [80]="HTTP"
    [110]="POP3"
    [143]="IMAP"
    [443]="HTTPS"
    [993]="IMAPS"
    [995]="POP3S"
)

open_ports=$(nmap -p- --open 127.0.0.1 2>/dev/null | grep "^[0-9]" | cut -d'/' -f1)

echo "Open ports found:"
for port in $open_ports; do
    service=${common_ports[$port]:-"Unknown"}
    echo "Port $port: $service"
done
EOF

chmod +x analyze_ports.sh
./analyze_ports.sh || true

echo
echo "Running security assessment scans..."
nmap --script vuln 127.0.0.1 || true
nmap --script auth 127.0.0.1 || true
nmap --script discovery 127.0.0.1 || true

echo
echo "Creating security_report.sh..."
cat > security_report.sh << 'EOF'
#!/bin/bash

REPORT_FILE="security_report_$(date +%Y%m%d_%H%M%S).txt"

{
    echo "=== SECURITY ASSESSMENT REPORT ==="
    echo "Generated: $(date)"
    echo "Target: localhost (127.0.0.1)"
    echo "Assessed by: $(whoami)"
    echo
    
    echo "=== OPEN PORTS ==="
    nmap --open 127.0.0.1
    echo
    
    echo "=== SERVICE VERSIONS ==="
    nmap -sV 127.0.0.1
    echo
    
    echo "=== VULNERABILITY SCAN ==="
    nmap --script vuln 127.0.0.1
    echo
    
    echo "=== RECOMMENDATIONS ==="
    echo "1. Close unnecessary ports"
    echo "2. Update services to latest versions"
    echo "3. Configure firewall rules"
    echo "4. Monitor for unauthorized services"
    echo "5. Regular security assessments"
    
} > "$REPORT_FILE"

echo "Security report saved to: $REPORT_FILE"
cat "$REPORT_FILE"
EOF

chmod +x security_report.sh
./security_report.sh || true

echo
echo "Verification commands..."
nmap --version && nmap 127.0.0.1 || true
(echo "test" | nc -l -p 9999 >/tmp/nc_verify.txt 2>/dev/null &) || true
sleep 2
echo "hello" | nc 127.0.0.1 9999 || true
ls -la *.sh || true
./identify_services.sh || true

echo
echo "Lab 6 setup completed."
