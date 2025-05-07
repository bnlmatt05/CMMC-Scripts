#!/bin/bash

# Script for automating compliance checks for the System and Information Integrity (SI) family
# NIST 800-53 Controls: SI-1 through SI-7 (initial subset; extendable as needed)

# Ensure the script is run with root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Logging
LOG_FILE="/var/log/nist-800-53-si.log"
echo "Starting System and Information Integrity (SI) Compliance Checks" | tee -a $LOG_FILE

# SI-1: System and Information Integrity Policy and Procedures
check_si1_policy() {
    echo "SI-1: Verifying System and Information Integrity Policy documentation..." | tee -a $LOG_FILE
    if [[ -f "/etc/security/system_information_integrity_policy.txt" ]]; then
        echo "System and Information Integrity Policy is documented." | tee -a $LOG_FILE
    else
        echo "System and Information Integrity Policy is NOT documented! Ensure the policy is created and stored in '/etc/security/system_information_integrity_policy.txt'." | tee -a $LOG_FILE
    fi
}

# SI-2: Flaw Remediation
check_si2_flaw_remediation() {
    echo "SI-2: Checking system for recent software updates..." | tee -a $LOG_FILE
    if [[ $(find /var/log/apt/history.log -mtime -30 | wc -l) -gt 0 ]]; then
        echo "System software updates have been applied in the last 30 days." | tee -a $LOG_FILE
    else
        echo "System software updates have NOT been applied recently! Ensure that updates are applied regularly." | tee -a $LOG_FILE
    fi
}

# SI-3: Malicious Code Protection
check_si3_malware_protection() {
    echo "SI-3: Checking for anti-malware software..." | tee -a $LOG_FILE
    if command -v clamscan &> /dev/null; then
        echo "Anti-malware software (ClamAV) is installed." | tee -a $LOG_FILE
    else
        echo "Anti-malware software is NOT installed! Ensure ClamAV or equivalent is installed and configured." | tee -a $LOG_FILE
    fi
}

# SI-4: Information System Monitoring
check_si4_system_monitoring() {
    echo "SI-4: Manual Review Required - Information System Monitoring" | tee -a $LOG_FILE
    echo "Verify that the organization monitors the information system to detect attacks and indicators of potential attacks. Review monitoring configurations and logs." | tee -a $LOG_FILE
}

# SI-5: Security Alerts, Advisories, and Directives
check_si5_security_alerts() {
    echo "SI-5: Checking for security alert subscriptions..." | tee -a $LOG_FILE
    if [[ -f "/etc/security/security_alerts_subscription.txt" ]]; then
        echo "Security alerts subscription is documented." | tee -a $LOG_FILE
    else
        echo "Security alerts subscription is NOT documented! Ensure the organization subscribes to relevant security alert services." | tee -a $LOG_FILE
    fi
}

# SI-6: Security Function Verification
check_si6_security_verification() {
    echo "SI-6: Manual Review Required - Security Function Verification" | tee -a $LOG_FILE
    echo "Verify that the organization tests the security functions of the system to ensure proper operation. Review test results and system configurations." | tee -a $LOG_FILE
}

# SI-7: Software, Firmware, and Information Integrity
check_si7_integrity_verification() {
    echo "SI-7: Checking for integrity verification mechanisms..." | tee -a $LOG_FILE
    if command -v tripwire &> /dev/null; then
        echo "Integrity verification tool (Tripwire) is installed." | tee -a $LOG_FILE
    else
        echo "Integrity verification tool is NOT installed! Ensure Tripwire or equivalent is installed and configured." | tee -a $LOG_FILE
    fi
}

# Execute all checks
check_si1_policy
check_si2_flaw_remediation
check_si3_malware_protection
check_si4_system_monitoring
check_si5_security_alerts
check_si6_security_verification
check_si7_integrity_verification

echo "System and Information Integrity (SI) Compliance Checks Completed." | tee -a $LOG_FILE