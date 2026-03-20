By the end of this lab, you will be able to:

Install and configure Autopsy on Linux

Create and analyze disk images

Extract digital evidence from file systems

Identify deleted files, hidden files, and metadata

Perform timeline analysis

Generate forensic reports

Understand chain of custody and evidence integrity

Prerequisites

Basic Linux command-line knowledge

Understanding of file systems (FAT32, NTFS, ext4)

Basic knowledge of file metadata and timestamps

Lab Environment

Ubuntu Linux

Autopsy 4.20+

Sleuth Kit tools

Pre-configured cloud machine

Task Summary
Task 1: Setup & Evidence Creation

Verify Autopsy installation

Create disk image

Mount and populate with files

Create hidden & deleted files

Generate hash values

Task 2: Autopsy Analysis

Start Autopsy

Create new case

Add disk image

Run analysis modules

Task 3: Artifact Analysis

Analyze file system

Identify hidden & deleted files

Perform keyword search

Generate timeline

Task 4: Reporting

Document findings

Export evidence

Generate report

Verify integrity

Key Commands Overview
Autopsy
autopsy
Disk Image Creation
dd if=/dev/zero of=evidence_usb.img bs=1M count=100
Mounting Image
sudo losetup /dev/loop0 evidence_usb.img
sudo mount /dev/loop0 mount_point
Hashing
md5sum evidence_usb.img
sha256sum evidence_usb.img
Timeline Analysis
fls -r -m / evidence_usb.img > timeline_body.txt
mactime -b timeline_body.txt -d > timeline.txt
Verification Checklist

 Autopsy installed and running

 Disk image created

 Hash values generated

 Evidence added to Autopsy

 Hidden file identified

 Deleted file recovered

 Timeline generated

 Report created
