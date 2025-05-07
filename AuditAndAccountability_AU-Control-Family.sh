#!/bin/bash

# Script for automating compliance checks for the Audit and Accountability (AU) family
# NIST 800-53 Controls: AU-1 through AU-12

# Ensure the script is run with root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Logging
LOG_FILE="/var/log/nist-800-53-au.log"
echo "Starting Audit and Accountability (AU) Compliance Checks" | tee -a $LOG_FILE

# AU-1: Audit Policies and Procedures
check_au1_policy() {
    echo "AU-1: Checking for audit policies and procedures documentation..." | tee -a $LOG_FILE
    if [[ -f "/etc/security/audit_policy.txt" ]]; then
        echo "Audit policy is documented." | tee -a $LOG_FILE
    else
        echo "Audit policy is NOT documented! Please ensure that an audit policy is created and stored in '/etc/security/audit_policy.txt'." | tee -a $LOG_FILE
    fi
}

# AU-2: Audit Records
check_au2_audit_records() {
    echo "AU-2: Checking for audit record generation..." | tee -a $LOG_FILE
    if [[ -f "/var/log/audit/audit.log" ]]; then
        echo "Audit records are being generated." | tee -a $LOG_FILE
    else
        echo "Audit records are NOT being generated! Ensure that the auditd service is installed and running." | tee -a $LOG_FILE
    fi
}

# AU-3: Content of Audit Records
check_au3_audit_content() {
    echo "AU-3: Verifying content of audit records..." | tee -a $LOG_FILE
    grep -q "type=SYSCALL" /var/log/audit/audit.log
    if [[ $? -eq 0 ]]; then
        echo "Audit records include syscall information." | tee -a $LOG_FILE
    else
        echo "Audit records do NOT include sufficient information! Update audit rules to capture syscall data." | tee -a $LOG_FILE
    fi
}

# AU-4: Audit Storage Capacity
check_au4_storage_capacity() {
    echo "AU-4: Checking audit storage capacity..." | tee -a $LOG_FILE
    local AUDIT_DIR="/var/log/audit"
    local CAPACITY_THRESHOLD=80
    local usage=$(df "$AUDIT_DIR" | awk 'NR==2 {print $5}' | sed 's/%//')
    if [[ $usage -lt $CAPACITY_THRESHOLD ]]; then
        echo "Audit storage capacity is sufficient ($usage% used)." | tee -a $LOG_FILE
    else
        echo "Audit storage capacity is LOW ($usage% used)! Consider increasing storage for $AUDIT_DIR." | tee -a $LOG_FILE
    fi
}

# AU-5: Response to Audit Processing Failures
check_au5_audit_failures() {
    echo "AU-5: Manual Review Required - Response to Audit Processing Failures" | tee -a $LOG_FILE
    echo "Ensure that the system is configured to alert administrators and take appropriate actions (e.g., halt system processes) in case of audit failures. Document actions taken in organizational compliance records." | tee -a $LOG_FILE
}

# AU-6: Audit Review, Analysis, and Reporting
check_au6_review_analysis_reporting() {
    echo "AU-6: Manual Review Required - Audit Review, Analysis, and Reporting" | tee -a $LOG_FILE
    echo "Ensure audit logs are regularly reviewed and analyzed by authorized personnel. Summarize findings in periodic reports and maintain evidence of reviews." | tee -a $LOG_FILE
}

# AU-7: Audit Reduction and Report Generation
check_au7_report_generation() {
    echo "AU-7: Manual Review Required - Audit Reduction and Report Generation" | tee -a $LOG_FILE
    echo "Ensure mechanisms are in place to reduce and generate reports from audit logs. Verify that tools such as ausearch or aureport are configured and operational." | tee -a $LOG_FILE
}

# AU-8: Time Stamps
check_au8_time_stamps() {
    echo "AU-8: Checking system time synchronization..." | tee -a $LOG_FILE
    timedatectl | grep -q "NTP synchronized: yes"
    if [[ $? -eq 0 ]]; then
        echo "System time is synchronized with NTP." | tee -a $LOG_FILE
    else
        echo "System time is NOT synchronized with NTP! Ensure NTP or equivalent is configured and running." | tee -a $LOG_FILE
    fi
}

# AU-9: Protection of Audit Information
check_au9_protection() {
    echo "AU-9: Checking protection of audit records..." | tee -a $LOG_FILE
    local AUDIT_FILES=("/var/log/audit/audit.log")
    for file in "${AUDIT_FILES[@]}"; do
        if [[ $(stat -c "%U" "$file") == "root" ]]; then
            echo "Audit file $file is protected (owned by root)." | tee -a $LOG_FILE
        else
            echo "Audit file $file is NOT protected! Ensure ownership is restricted to root." | tee -a $LOG_FILE
        fi
    done
}

# AU-10: Non-repudiation
check_au10_non_repudiation() {
    echo "AU-10: Manual Review Required - Non-repudiation" | tee -a $LOG_FILE
    echo "Ensure mechanisms are in place to associate audit records with the identity of the user performing the action. This may involve reviewing system configurations and authentication logs." | tee -a $LOG_FILE
}

# AU-11: Audit Record Retention
check_au11_retention() {
    echo "AU-11: Checking audit record retention..." | tee -a $LOG_FILE
    local RETENTION_PERIOD_DAYS=90
    grep -q "max_log_file_action" /etc/audit/auditd.conf
    if [[ $? -eq 0 ]]; then
        echo "Audit record retention is configured (review retention period in /etc/audit/auditd.conf)." | tee -a $LOG_FILE
    else
        echo "Audit record retention is NOT configured! Update /etc/audit/auditd.conf to specify retention settings." | tee -a $LOG_FILE
    fi
}

# AU-12: Audit Generation
check_au12_audit_generation() {
    echo "AU-12: Checking audit generation configuration..." | tee -a $LOG_FILE
    auditctl -l | grep -q "audit"
    if [[ $? -eq 0 ]]; then
        echo "Audit generation is enabled and rules are in place." | tee -a $LOG_FILE
    else
        echo "Audit generation is NOT enabled! Configure and enable audit rules using auditctl or equivalent." | tee -a $LOG_FILE
    fi
}

# Execute all checks
check_au1_policy
check_au2_audit_records
check_au3_audit_content
check_au4_storage_capacity
check_au5_audit_failures
check_au6_review_analysis_reporting
check_au7_report_generation
check_au8_time_stamps
check_au9_protection
check_au10_non_repudiation
check_au11_retention
check_au12_audit_generation

echo "Audit and Accountability (AU) Compliance Checks Completed." | tee -a $LOG_FILE