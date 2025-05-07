#!/bin/bash

# Script for automating compliance checks for the Access Control (AC) family
# NIST 800-53 Controls: AC-1 through AC-20

# Ensure the script is run with root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Logging
LOG_FILE="/var/log/nist-800-53-ac.log"
echo "Starting Access Control (AC) Compliance Checks" | tee -a $LOG_FILE

# AC-1: Access Control Policy
check_ac1_policy() {
    echo "AC-1: Verifying Access Control Policy documentation..." | tee -a $LOG_FILE
    if [[ -f "/etc/security/access_control_policy.txt" ]]; then
        echo "Access Control policy is documented." | tee -a $LOG_FILE
    else
        echo "Access Control policy is NOT documented! Please ensure that an organizational Access Control policy is created and stored in '/etc/security/access_control_policy.txt'." | tee -a $LOG_FILE
    fi
}

# AC-2: Account Management
check_ac2_account_management() {
    echo "AC-2: Checking for inactive user accounts..." | tee -a $LOG_FILE
    local THRESHOLD_DAYS=30
    awk -F: '{ print $1, $6 }' /etc/passwd | while read -r user home_dir; do
        if [[ -d "$home_dir" ]]; then
            inactivity_days=$(passwd -S $user | awk '{ print $3 }')
            if [[ $inactivity_days -gt $THRESHOLD_DAYS ]]; then
                echo "User $user is inactive for $inactivity_days days. Consider disabling or reviewing this account." | tee -a $LOG_FILE
            fi
        fi
    done
}

# AC-3: Access Enforcement
check_ac3_access_enforcement() {
    echo "AC-3: Checking access enforcement mechanisms..." | tee -a $LOG_FILE
    if [[ -f "/etc/security/access_enforcement_rules.conf" ]]; then
        echo "Access enforcement mechanisms are in place." | tee -a $LOG_FILE
    else
        echo "Access enforcement mechanisms are NOT in place! Please configure and document enforcement rules in '/etc/security/access_enforcement_rules.conf'." | tee -a $LOG_FILE
    fi
}

# AC-4: Information Flow Enforcement
check_ac4_information_flow() {
    echo "AC-4: Checking information flow control..." | tee -a $LOG_FILE
    iptables -L | grep -q "DROP"
    if [[ $? -eq 0 ]]; then
        echo "Information flow is controlled using iptables." | tee -a $LOG_FILE
    else
        echo "Information flow is NOT controlled! Ensure iptables or equivalent is set up to regulate data flow." | tee -a $LOG_FILE
    fi
}

# AC-5: Separation of Duties
check_ac5_separation_of_duties() {
    echo "AC-5: Manual Review Required - Separation of Duties" | tee -a $LOG_FILE
    echo "Review roles and responsibilities to ensure no single individual has conflicting duties. Document your findings in your organizational compliance records." | tee -a $LOG_FILE
}

# AC-6: Least Privilege
check_ac6_least_privilege() {
    echo "AC-6: Checking least privilege enforcement..." | tee -a $LOG_FILE
    local FILES=("/etc/shadow" "/etc/passwd")
    for file in "${FILES[@]}"; do
        if [[ $(stat -c "%U" "$file") != "root" ]]; then
            echo "File $file is NOT restricted to root!" | tee -a $LOG_FILE
        else
            echo "File $file is properly restricted to root." | tee -a $LOG_FILE
        fi
    done
}

# AC-7: Unsuccessful Login Attempts
check_ac7_login_attempts() {
    echo "AC-7: Checking unsuccessful login attempt logging..." | tee -a $LOG_FILE
    grep -q "auth.*pam_tally2" /etc/pam.d/common-auth
    if [[ $? -eq 0 ]]; then
        echo "Unsuccessful login attempts are logged using pam_tally2." | tee -a $LOG_FILE
    else
        echo "Unsuccessful login attempts are NOT logged! Please configure pam_tally2 or equivalent in '/etc/pam.d/common-auth'." | tee -a $LOG_FILE
    fi
}

# AC-8: System Use Notification
check_ac8_system_use_notification() {
    echo "AC-8: Checking system use notification banner..." | tee -a $LOG_FILE
    grep -q "Authorized users only" /etc/issue
    if [[ $? -eq 0 ]]; then
        echo "System use notification banner is configured." | tee -a $LOG_FILE
    else
        echo "System use notification banner is NOT configured! Add a banner message in '/etc/issue'." | tee -a $LOG_FILE
    fi
}

# AC-9: Previous Logon Notification
check_ac9_previous_logon_notification() {
    echo "AC-9: Checking previous logon notification..." | tee -a $LOG_FILE
    lastlog | grep -q "$(whoami)"
    if [[ $? -eq 0 ]]; then
        echo "Previous logon notification is enabled." | tee -a $LOG_FILE
    else
        echo "Previous logon notification is NOT enabled! Configure your system to display the last login information." | tee -a $LOG_FILE
    fi
}

# AC-10: Concurrent Session Control
check_ac10_concurrent_session() {
    echo "AC-10: Checking concurrent session control..." | tee -a $LOG_FILE
    grep -q "maxlogins" /etc/security/limits.conf
    if [[ $? -eq 0 ]]; then
        echo "Concurrent session control is configured." | tee -a $LOG_FILE
    else
        echo "Concurrent session control is NOT configured! Update '/etc/security/limits.conf' to set session restrictions." | tee -a $LOG_FILE
    fi
}

# AC-11 to AC-20: Placeholder for additional controls
# Each control should have automated checks where feasible or clear narrative guidance for manual review.

# Execute all checks
check_ac1_policy
check_ac2_account_management
check_ac3_access_enforcement
check_ac4_information_flow
check_ac5_separation_of_duties
check_ac6_least_privilege
check_ac7_login_attempts
check_ac8_system_use_notification
check_ac9_previous_logon_notification
check_ac10_concurrent_session

echo "Access Control (AC) Compliance Checks Completed." | tee -a $LOG_FILE