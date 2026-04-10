This lab focuses on securing Linux systems using sudo by implementing best practices such as least privilege access control, secure configuration of the sudoers file, and comprehensive logging and monitoring.

You will configure role-based access, enable auditing, and build monitoring mechanisms to detect misuse of elevated privileges.

Objectives

By completing this lab, you will be able to:

Understand the role of sudo in Linux security
Securely configure the sudoers file using visudo
Implement least privilege access for different roles
Configure logging for auditing sudo usage
Apply enterprise-level sudo hardening practices
Troubleshoot sudo-related issues

Task 1: Securing sudo Configuration
Inspect Current Configuration
sudo --version
sudo -l
ls -la /etc/sudoers
ls -la /etc/sudoers.d/
Edit sudoers Safely
sudo visudo
Recommended Security Settings

Add the following:

Defaults env_reset
Defaults mail_badpass
Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
Defaults use_pty
Defaults log_input, log_output
Defaults iolog_dir=/var/log/sudo-io
Defaults logfile=/var/log/sudo.log
Defaults timestamp_timeout=15
Defaults passwd_tries=3
Defaults passwd_timeout=5
Backup Configuration
sudo cp /etc/sudoers /etc/sudoers.backup.$(date +%Y%m%d)
sudo -l

Task 2: Least Privilege Access Control
Create Users and Groups
sudo useradd -m -s /bin/bash webadmin
sudo useradd -m -s /bin/bash dbadmin
sudo useradd -m -s /bin/bash developer
sudo useradd -m -s /bin/bash auditor

sudo groupadd web-operators
sudo groupadd db-operators
sudo groupadd dev-team
sudo groupadd audit-team

sudo usermod -aG web-operators webadmin
sudo usermod -aG db-operators dbadmin
sudo usermod -aG dev-team developer
sudo usermod -aG audit-team auditor
Configure Role-Based sudo Rules

Use:

sudo visudo -f /etc/sudoers.d/<role>
Web Operators
Manage Apache/Nginx
View logs only
DB Operators
Manage MySQL/PostgreSQL
Developers
Limited package management
Restricted destructive commands
Auditors
Read-only access to logs and system info
Test Access Control
su - webadmin
sudo systemctl status apache2

su - dbadmin
sudo systemctl status mysql

su - developer
sudo apt update

su - auditor
sudo tail /var/log/syslog

Task 3: Logging and Monitoring
Enable Logging
sudo mkdir -p /var/log/sudo-io
sudo chmod 750 /var/log/sudo-io
sudo chown root:adm /var/log/sudo-io

Ensure sudoers contains:

Defaults logfile=/var/log/sudo.log
Defaults log_input, log_output
Defaults iolog_dir=/var/log/sudo-io
Defaults syslog=auth
Configure rsyslog
sudo nano /etc/rsyslog.d/50-sudo.conf

Add:

:programname, isequal, "sudo" /var/log/sudo-commands.log
& stop

Restart:

sudo systemctl restart rsyslog
Configure Log Rotation
sudo nano /etc/logrotate.d/sudo

Then test:

sudo logrotate -d /etc/logrotate.d/sudo
Monitor Logs
sudo tail -f /var/log/sudo.log
sudo tail -f /var/log/auth.log
sudo tail -f /var/log/sudo-commands.log
Automated Monitoring Script
sudo /usr/local/bin/sudo-monitor.sh

Schedule with cron:

sudo crontab -e

Add:

*/15 * * * * /usr/local/bin/sudo-monitor.sh
Verification
sudo visudo -c
su - webadmin -c "sudo -l"
su - dbadmin -c "sudo -l"
su - developer -c "sudo -l"
su - auditor -c "sudo -l"

sudo tail -20 /var/log/sudo.log
Troubleshooting
Fix sudoers Issues
sudo visudo
Reset sudo session
sudo -k
Check logs
sudo systemctl status rsyslog
Conclusion

This lab demonstrates how to secure privilege escalation using sudo by implementing:

Least privilege access
Secure configuration practices
Comprehensive logging and auditing
Automated monitoring

These techniques are critical in enterprise environments to prevent privilege abuse and maintain system integrity.
