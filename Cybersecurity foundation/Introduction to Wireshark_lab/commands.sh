```bash
#!/bin/bash

# Lab 10: Introduction to Wireshark

set -e

echo "Updating package repositories..."
sudo apt update

echo "Installing Wireshark and required tools..."
sudo apt install wireshark -y
sudo apt install curl wget dnsutils tshark -y

echo "Configuring Wireshark permissions..."
sudo usermod -a -G wireshark $USER
sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap

echo "Verifying dumpcap capabilities..."
getcap /usr/bin/dumpcap || true

echo "Listing available interfaces..."
ip addr show
ip -s link show
tshark -D || true

echo ""
echo "Start GUI Wireshark manually if desktop is available:"
echo "wireshark &"
echo ""

echo "Capture examples (replace eth0 with your active interface if needed):"
echo "sudo tshark -i eth0 -w capture.pcap"
echo "sudo tshark -i eth0 -c 100 -w capture.pcap"
echo ""

echo "Generating sample network traffic..."
curl -I http://httpbin.org/get || true
curl -I http://example.com || true
nslookup google.com || true
dig facebook.com || true
host github.com || true
curl -I https://www.google.com || true
wget -q --spider https://www.github.com || true
ping -c 10 8.8.8.8 || true

echo "Export examples..."
echo 'tshark -r capture.pcap -Y "http" -w http_traffic.pcap'
echo 'tshark -r capture.pcap -Y "http" -T fields -e frame.number -e ip.src -e ip.dst -e http.host > http_traffic.csv'
echo 'tshark -r capture.pcap -Y "dns" -T fields -e dns.qry.name -e dns.resp.addr'
echo ""

echo "Creating analysis script..."
cat > analyze_capture.sh << 'EOF'
#!/bin/bash

PCAP_FILE="capture.pcap"
REPORT_FILE="network_analysis_report.txt"

echo "Network Traffic Analysis Report" > $REPORT_FILE
echo "Generated on: $(date)" >> $REPORT_FILE
echo "=================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE
echo "1. TOTAL PACKETS CAPTURED:" >> $REPORT_FILE
tshark -r $PCAP_FILE -q -z io,stat,0 >> $REPORT_FILE 2>/dev/null || true

echo "" >> $REPORT_FILE
echo "2. PROTOCOL DISTRIBUTION:" >> $REPORT_FILE
tshark -r $PCAP_FILE -q -z io,phs >> $REPORT_FILE 2>/dev/null || true

echo "" >> $REPORT_FILE
echo "3. TOP CONVERSATIONS:" >> $REPORT_FILE
tshark -r $PCAP_FILE -q -z conv,tcp | head -20 >> $REPORT_FILE 2>/dev/null || true

echo "" >> $REPORT_FILE
echo "4. DNS QUERIES:" >> $REPORT_FILE
tshark -r $PCAP_FILE -Y "dns.flags.response == 0" -T fields -e dns.qry.name 2>/dev/null | sort | uniq -c | sort -nr | head -10 >> $REPORT_FILE || true

echo "" >> $REPORT_FILE
echo "5. HTTP HOSTS:" >> $REPORT_FILE
tshark -r $PCAP_FILE -Y "http" -T fields -e http.host 2>/dev/null | sort | uniq -c | sort -nr >> $REPORT_FILE || true

echo "Analysis complete. Report saved to $REPORT_FILE"
EOF

chmod +x analyze_capture.sh

echo "Creating external IP extraction command example..."
cat > extract_external_ips.sh << 'EOF'
#!/bin/bash
tshark -r capture.pcap -T fields -e ip.src -e ip.dst 2>/dev/null | tr '\t' '\n' | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | grep -v '^192\.168\.' | grep -v '^10\.' | grep -v '^172\.' | sort | uniq > external_ips.txt
echo "External IP addresses found:"
cat external_ips.txt
EOF

chmod +x extract_external_ips.sh

echo ""
echo "Useful display filters:"
echo 'http'
echo 'http.request.method == "GET"'
echo 'http.response'
echo 'tcp'
echo 'tcp.port == 80'
echo 'tcp.flags.syn == 1'
echo 'dns'
echo 'dns.flags.response == 0'
echo 'dns.flags.response == 1'
echo 'http or tls'
echo 'dns or http'
echo ""

echo "Verification commands:"
echo 'ls -la *.pcap'
echo 'tshark -r capture.pcap -c 10'
echo 'tshark -r capture.pcap -Y "http" -c 5'
echo 'tshark -r capture.pcap -Y "dns" -c 5'
echo 'tshark -r capture.pcap -Y "tcp" -c 5'
echo ""

echo "Note: You may need to log out and back in, or run: newgrp wireshark"
echo "Lab 10 setup completed."
