#!/bin/bash

# Script for automating compliance checks for the Identification and Authentication (IA) family
# NIST 800-53 Controls: IA-1 through IA-8, including applicable control enhancements

# Ensure the script is run with root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Logging
LOG_FILE="/var/log/nist-800-53-ia.log"
echo "Starting Identification and Authentication (IA) Compliance Checks" | tee -a $LOG_FILE

# IA-1: Identification and Authentication Policy and Procedures
check_ia1_policy() {
    echo "IA-1: Verifying Identification and Authentication Policy documentation..." | tee -a $LOG_FILE
    if [[ -f "/etc/security/identification_authentication_policy.txt" ]]; then
        echo "Identification and Authentication Policy is documented." | tee -a $LOG_FILE
    else
        echo "Identification and Authentication Policy is NOT documented! Ensure the policy is created and stored in '/etc/security/identification_authentication_policy.txt'." | tee -a $LOG_FILE
    fi
}

# IA-2: Identification and Authentication (Organizational Users)
check_ia2_users() {
    echo "IA-2: Checking for organizational user authentication mechanisms..." | tee -a $LOG_FILE
    grep -q "pam_unix.so" /etc/pam.d/common-auth
    if [[ $? -eq 0 ]]; then
        echo "Organizational user authentication is enabled (e.g., via PAM)." | tee -a $LOG_FILE
    else
        echo "Organizational user authentication is NOT enabled! Ensure that PAM or equivalent is configured for user authentication." | tee -a $LOG_FILE
    fi
}

# IA-2(1): Multi-factor Authentication for Organizational Users
check_ia2_1_mfa() {
    echo "IA-2(1): Checking for multi-factor authentication (MFA) mechanisms..." | tee -a $LOG_FILE
    grep -q "pam_google_authenticator.so" /etc/pam.d/common-auth
    if [[ $? -eq 0 ]]; then
        echo "Multi-factor authentication is enabled (e.g., via Google Authenticator)." | tee -a $LOG_FILE
    else
        echo "Multi-factor authentication is NOT enabled! Ensure that MFA mechanisms are configured in '/etc/pam.d/common-auth'." | tee -a $LOG_FILE
    fi
}

# IA-4: Identifier Management
check_ia4_identifier_management() {
    echo "IA-4: Checking for unique user identifiers..." | tee -a $LOG_FILE
    awk -F: '{ print $1 }' /etc/passwd | sort | uniq -d
    if [[ $? -ne 0 ]]; then
        echo "No duplicate user identifiers found in /etc/passwd." | tee -a $LOG_FILE
    else
        echo "Duplicate user identifiers detected! Ensure all users have unique identifiers in /etc/passwd." | tee -a $LOG_FILE
    fi
}

# IA-5: Authenticator Management
check_ia5_authenticator_management() {
    echo "IA-5: Checking password policy and authenticator management..." | tee -a $LOG_FILE
    grep -E "^minlen" /etc/security/pwquality.conf | grep -q "minlen=12"
    if [[ $? -eq 0 ]]; then
        echo "Password policy enforces a minimum length of 12 characters." | tee -a $LOG_FILE
    else
        echo "Password policy is NOT compliant! Ensure /etc/security/pwquality.conf enforces a minimum password length of 12." | tee -a $LOG_FILE
    fi
}

# IA-5(1): Complexity Requirements for Authenticators
check_ia5_1_complexity() {
    echo "IA-5(1): Checking password complexity requirements..." | tee -a $LOG_FILE
    grep -E "^minclass" /etc/security/pwquality.conf | grep -q "minclass=3"
    if [[ $? -eq 0 ]]; then
        echo "Password policy enforces at least 3 character classes (e.g., uppercase, lowercase, numbers, special characters)." | tee -a $LOG_FILE
    else
        echo "Password complexity requirements are NOT compliant! Ensure /etc/security/pwquality.conf enforces 'minclass=3'." | tee -a $LOG_FILE
    fi
}

# IA-5(2): Password Reuse Restrictions
check_ia5_2_reuse() {
    echo "IA-5(2): Checking password reuse restrictions..." | tee -a $LOG_FILE
    grep -E "^remember" /etc/pam.d/common-password | grep -q "remember=5"
    if [[ $? -eq 0 ]]; then
        echo "Password policy restricts reuse of the last 5 passwords." | tee -a $LOG_FILE
    else
        echo "Password reuse restrictions are NOT compliant! Ensure '/etc/pam.d/common-password' enforces 'remember=5'." | tee -a $LOG_FILE
    fi
}

# IA-5(3): Password Expiration
check_ia5_3_expiration() {
    echo "IA-5(3): Checking password expiration settings..." | tee -a $LOG_FILE
    grep -E "^PASS_MAX_DAYS" /etc/login.defs | grep -q "PASS_MAX_DAYS 90"
    if [[ $? -eq 0 ]]; then
        echo "Password expiration is set to 90 days." | tee -a $LOG_FILE
    else
        echo "Password expiration is NOT compliant! Ensure '/etc/login.defs' enforces 'PASS_MAX_DAYS 90'." | tee -a $LOG_FILE
    fi
}

# IA-8: Identification and Authentication (Non-Organizational Users)
check_ia8_nonorg_users() {
    echo "IA-8: Manual Review Required - Non-Organizational User Identification and Authentication" | tee -a $LOG_FILE
    echo "Verify that non-organizational users are uniquely identified and authenticated before accessing the system. Review access control policies and authentication mechanisms." | tee -a $LOG_FILE
}

# Execute all checks
check_ia1_policy
check_ia2_users
check_ia2_1_mfa
check_ia4_identifier_management
check_ia5_authenticator_management
check_ia5_1_complexity
check_ia5_2_reuse
check_ia5_3_expiration
check_ia8_nonorg_users

echo "Identification and Authentication (IA) Compliance Checks Completed." | tee -a $LOG_FILE