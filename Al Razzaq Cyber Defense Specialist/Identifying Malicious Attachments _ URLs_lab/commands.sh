#!/bin/bash

# Create directories
mkdir -p ~/malware_lab/{attachments,urls,samples,reports}
cd ~/malware_lab

echo "Directories created."

# Install Python libraries
pip3 install --user python-magic requests beautifulsoup4

# Install system packages
sudo apt update
sudo apt install -y file libmagic1 python3-magic

echo "Dependencies installed."

# Create sample files
echo "Normal text document content" > ~/malware_lab/samples/document.txt

echo -e "#!/bin/bash\necho 'Script content'" > ~/malware_lab/samples/script.sh
chmod +x ~/malware_lab/samples/script.sh

echo "Test content" > ~/malware_lab/samples/invoice.pdf.exe
echo "Legitimate business document" > ~/malware_lab/samples/report.docx

echo "Sample files created."

# Create test URLs file
cat > ~/malware_lab/test_urls.txt << 'EOF'
https://www.google.com
https://github.com
http://192.168.1.1/admin
https://bit.ly/shortened
https://secure-bank-verify.suspicious.com
https://www.microsoft.com
EOF

echo "Test URLs file created."

# Create sample email
cat > ~/malware_lab/sample_email.txt << 'EOF'
Subject: Urgent Account Verification

Dear Customer,

Your account requires immediate verification. Click here:
https://secure-verify-account.suspicious-site.com/login

Please also review the attached security document.

Regards,
Security Team
EOF

echo "Sample email created."

# Make Python scripts executable
chmod +x ~/malware_lab/attachment_scanner.py
chmod +x ~/malware_lab/url_analyzer.py
chmod +x ~/malware_lab/integrated_scanner.py

echo "Scripts made executable."

echo "========================================"
echo " Lab Setup Complete"
echo "========================================"

echo "Run scanners using:"
echo "python3 attachment_scanner.py samples/"
echo "python3 url_analyzer.py test_urls.txt"
echo "python3 integrated_scanner.py sample_email.txt samples/"
