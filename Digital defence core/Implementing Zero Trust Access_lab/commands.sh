#!/bin/bash

# Create directory structure
mkdir -p ~/zerotrust-lab/{policies,scripts,logs,resources}
cd ~/zerotrust-lab

echo "=== Creating Zero Trust Policy File ==="
cat > policies/access_policy.conf <<EOF
# USER:RESOURCE:PERMISSION:TIME_LIMIT:VERIFICATION_LEVEL
admin:all:rwx:7200:3
user:home:rw:3600:2
guest:public:r:1800:1
EOF

echo "=== Creating Policy Manager Script ==="
cat > scripts/policy_manager.sh <<'EOF'
#!/bin/bash

LOG_FILE="$HOME/zerotrust-lab/logs/access_log.txt"
POLICY_FILE="$HOME/zerotrust-lab/policies/access_policy.conf"

log_activity() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

validate_access() {
    user=$1
    resource=$2
    perm=$3

    if grep -q "^$user:$resource" $POLICY_FILE; then
        policy_perm=$(grep "^$user:$resource" $POLICY_FILE | cut -d: -f3)
        if [[ $policy_perm == *$perm* ]]; then
            echo "Access Granted"
            log_activity "ACCESS GRANTED for $user on $resource"
            return 0
        fi
    fi

    echo "Access Denied"
    log_activity "ACCESS DENIED for $user on $resource"
    return 1
}

add_policy() {
    echo "$1:$2:$3:$4:$5" >> $POLICY_FILE
    log_activity "Policy added for $1"
}

remove_policy() {
    sed -i "/^$1:/d" $POLICY_FILE
    log_activity "Policy removed for $1"
}

show_policies() {
    cat $POLICY_FILE
}

case "$1" in
    validate) validate_access "$2" "$3" "$4" ;;
    add) add_policy "$2" "$3" "$4" "$5" "$6" ;;
    remove) remove_policy "$2" ;;
    show) show_policies ;;
    *) echo "Usage: $0 {validate|add|remove|show}" ;;
esac
EOF

chmod +x scripts/policy_manager.sh

echo "=== Creating Resource Directories ==="
mkdir -p resources/{public,private,restricted,shared}

echo "Public info" > resources/public/readme.txt
echo "Private data" > resources/private/confidential.txt
echo "Top secret" > resources/restricted/classified.txt
echo "Shared project" > resources/shared/project.txt

echo "=== Creating Least Privilege Script ==="
cat > scripts/least_privilege.sh <<'EOF'
#!/bin/bash

BASE_DIR="$HOME/zerotrust-lab/resources"
LOG_FILE="$HOME/zerotrust-lab/logs/privilege_log.txt"

apply_permissions() {
    chmod 755 $BASE_DIR/public
    chmod 644 $BASE_DIR/public/*

    chmod 750 $BASE_DIR/private
    chmod 640 $BASE_DIR/private/*

    chmod 700 $BASE_DIR/restricted
    chmod 600 $BASE_DIR/restricted/*

    chmod 775 $BASE_DIR/shared
    chmod 664 $BASE_DIR/shared/*

    echo "$(date) Permissions applied" >> $LOG_FILE
}

verify_permissions() {
    ls -la $BASE_DIR >> $LOG_FILE
}

generate_report() {
    ls -laR $BASE_DIR
}

case "$1" in
    apply) apply_permissions ;;
    verify) verify_permissions ;;
    report) generate_report ;;
    *) echo "Usage: $0 {apply|verify|report}" ;;
esac
EOF

chmod +x scripts/least_privilege.sh

echo "=== Creating Access Monitor Script ==="
cat > scripts/access_monitor.sh <<'EOF'
#!/bin/bash

MONITOR_LOG="$HOME/zerotrust-lab/logs/monitor_log.txt"
BASELINE_FILE="$HOME/zerotrust-lab/logs/baseline.txt"

create_baseline() {
    find $HOME/zerotrust-lab/resources -exec stat -c "%n %a %U" {} \; > $BASELINE_FILE
}

detect_changes() {
    find $HOME/zerotrust-lab/resources -exec stat -c "%n %a %U" {} \; > current.txt
    diff $BASELINE_FILE current.txt >> $MONITOR_LOG
    rm current.txt
}

log_access_attempt() {
    echo "$(date) - $1 - $2 - $3 - $4" >> $MONITOR_LOG
}

generate_audit_report() {
    cat $MONITOR_LOG
}

case "$1" in
    baseline) create_baseline ;;
    detect) detect_changes ;;
    log) log_access_attempt "$2" "$3" "$4" "$5" ;;
    audit) generate_audit_report ;;
    *) echo "Usage: $0 {baseline|detect|log|audit}" ;;
esac
EOF

chmod +x scripts/access_monitor.sh

echo "=== Creating Integration Test Script ==="
cat > scripts/integration_test.sh <<'EOF'
#!/bin/bash

TEST_LOG="$HOME/zerotrust-lab/logs/test_results.txt"

echo "Running Zero Trust Tests..." > $TEST_LOG

echo "Test Policy Access" >> $TEST_LOG
$HOME/zerotrust-lab/scripts/policy_manager.sh validate admin all r >> $TEST_LOG

echo "Test Permissions" >> $TEST_LOG
$HOME/zerotrust-lab/scripts/least_privilege.sh report >> $TEST_LOG

echo "Test Monitoring" >> $TEST_LOG
$HOME/zerotrust-lab/scripts/access_monitor.sh detect >> $TEST_LOG

echo "Tests Completed" >> $TEST_LOG
EOF

chmod +x scripts/integration_test.sh

echo "=== Creating Compliance Report Script ==="
cat > scripts/compliance_report.sh <<'EOF'
#!/bin/bash

REPORT="$HOME/zerotrust-lab/logs/compliance_report.txt"

echo "Zero Trust Compliance Report" > $REPORT
echo "Generated on $(date)" >> $REPORT
echo "" >> $REPORT

echo "Policies:" >> $REPORT
cat $HOME/zerotrust-lab/policies/access_policy.conf >> $REPORT

echo "" >> $REPORT
echo "Permissions:" >> $REPORT
ls -laR $HOME/zerotrust-lab/resources >> $REPORT

echo "" >> $REPORT
echo "Audit Logs:" >> $REPORT
cat $HOME/zerotrust-lab/logs/monitor_log.txt >> $REPORT

echo "Report Generated at $REPORT"
EOF

chmod +x scripts/compliance_report.sh

echo "=== Zero Trust Lab Setup Completed ==="
echo "Run the following:"
echo "./scripts/least_privilege.sh apply"
echo "./scripts/access_monitor.sh baseline"
echo "./scripts/integration_test.sh"
echo "./scripts/compliance_report.sh"
