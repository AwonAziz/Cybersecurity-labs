#!/bin/bash

echo "=== Lab 18: Digital Forensics with Autopsy ==="

# Update system
sudo apt update

# Install tools
sudo apt install autopsy sleuthkit -y

# Create working directory
mkdir -p ~/forensics_lab
cd ~/forensics_lab

# Create disk image
dd if=/dev/zero of=evidence_usb.img bs=1M count=100

# Setup loop device
LOOP=$(sudo losetup -f)
sudo losetup $LOOP evidence_usb.img

# Format disk
sudo mkfs.fat -F 32 $LOOP

# Mount disk
mkdir -p mount_point
sudo mount $LOOP mount_point

# Create directories
sudo mkdir -p mount_point/{Documents,Pictures,System}

# Create files
echo "Confidential $(date)" | sudo tee mount_point/Documents/confidential.txt
echo "Passwords: admin123" | sudo tee mount_point/Documents/passwords.txt

# Hidden file
echo "Hidden config" | sudo tee mount_point/.hidden_config

# Simulated image files
echo "image data" | sudo tee mount_point/Pictures/photo.jpg

# Create and delete file
echo "delete me" | sudo tee mount_point/deleted_file.txt
sudo rm mount_point/deleted_file.txt

# Unmount
sudo umount mount_point
sudo losetup -d $LOOP

# Generate hashes
md5sum evidence_usb.img > evidence_usb.img.md5
sha256sum evidence_usb.img > evidence_usb.img.sha256

# Start Autopsy
autopsy &

echo "Open: http://localhost:9999/autopsy"

# Generate timeline
fls -r -m / evidence_usb.img > timeline_body.txt
mactime -b timeline_body.txt -d > timeline.txt

# Create report
cat > investigation_report.txt <<EOF
DIGITAL FORENSICS REPORT
========================

Date: $(date)

Evidence: evidence_usb.img

Hash:
$(cat evidence_usb.img.md5)
$(cat evidence_usb.img.sha256)

Findings:
- Hidden file present
- Deleted file detected
- Sensitive data identified

EOF

echo "=== Lab Completed ==="
