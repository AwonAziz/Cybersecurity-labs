#!/bin/bash

# ----------------------------
# System Enumeration
# ----------------------------
echo "[+] System Enumeration"
ip addr show
ss -tuln
sudo iptables -L -v -n
systemctl list-units --type=service --state=running

# ----------------------------
# Install Required Tools
# ----------------------------
echo "[+] Installing dependencies"
sudo apt update
sudo apt install -y iptables-persistent nftables \
nmap netcat-openbsd selinux-utils selinux-basics \
policycoreutils-dev apparmor-utils

# ----------------------------
# Configure iptables
# ----------------------------
echo "[+] Configuring iptables"

sudo bash -c 'cat > /etc/iptables-security.sh << EOF
#!/bin/bash

iptables -F
iptables -X
iptables -t nat -F

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

iptables -A INPUT -j LOG --log-prefix "DROP: "
iptables -A INPUT -j DROP
EOF'

sudo chmod +x /etc/iptables-security.sh
sudo /etc/iptables-security.sh
sudo iptables-save > /etc/iptables/rules.v4

# ----------------------------
# Configure nftables
# ----------------------------
echo "[+] Configuring nftables"

sudo bash -c 'cat > /etc/nftables-security.conf << EOF
flush ruleset

table inet filter {
 chain input {
  type filter hook input priority 0;
  policy drop;

  iif lo accept
  ct state established,related accept
  tcp dport 22 accept
  tcp dport {80,443} accept
 }

 chain forward {
  type filter hook forward priority 0;
  policy drop;
 }

 chain output {
  type filter hook output priority 0;
  policy accept;
 }
}
EOF'

sudo nft -f /etc/nftables-security.conf
sudo systemctl enable nftables
sudo systemctl start nftables

# ----------------------------
# Vulnerability Assessment Script
# ----------------------------
echo "[+] Creating vulnerability assessment script"

cat << 'EOF' > ~/vulnerability-assessment.sh
#!/bin/bash
echo "System Info:"
uname -a
echo "Open Ports:"
ss -tuln
echo "Users:"
cat /etc/passwd
echo "SUID Files:"
find / -perm -4000 2>/dev/null | head -10
EOF

chmod +x ~/vulnerability-assessment.sh
~/vulnerability-assessment.sh

# ----------------------------
# Network Scan
# ----------------------------
echo "[+] Running Nmap scan"
nmap -sS localhost

# ----------------------------
# Log Check
# ----------------------------
echo "[+] Checking logs"
sudo tail -10 /var/log/auth.log

echo "Lab completed"
