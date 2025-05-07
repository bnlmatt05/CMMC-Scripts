# PowerShell Script for automating compliance checks for the Access Control (AC) family
# NIST 800-53 Controls: AC-1 through AC-8

# Logging
$LogFile = "C:\ComplianceLogs\AC-Control-Family.log"
New-Item -ItemType File -Force -Path $LogFile | Out-Null
Write-Output "Starting Access Control (AC) Compliance Checks" | Out-File -FilePath $LogFile -Append

# AC-1: Access Control Policy and Procedures
function Check-AC1Policy {
    Write-Output "AC-1: Verifying Access Control Policy documentation..." | Out-File -FilePath $LogFile -Append
    $PolicyFile = "C:\Policies\AccessControlPolicy.txt"
    if (Test-Path -Path $PolicyFile) {
        Write-Output "Access Control Policy is documented." | Out-File -FilePath $LogFile -Append
    } else {
        Write-Output "Access Control Policy is NOT documented! Ensure the policy is created at $PolicyFile." | Out-File -FilePath $LogFile -Append
    }
}

# AC-2: Account Management
function Check-AC2AccountManagement {
    Write-Output "AC-2: Checking for account management mechanisms..." | Out-File -FilePath $LogFile -Append
    $Accounts = Get-LocalUser
    if ($Accounts) {
        Write-Output "Found the following local accounts:" | Out-File -FilePath $LogFile -Append
        $Accounts | Format-Table | Out-String | Out-File -FilePath $LogFile -Append
    } else {
        Write-Output "No local accounts found. Ensure account management is properly configured." | Out-File -FilePath $LogFile -Append
    }
}

# AC-3: Access Enforcement
function Check-AC3AccessEnforcement {
    Write-Output "AC-3: Manual Review Required - Access Enforcement" | Out-File -FilePath $LogFile -Append
    Write-Output "Verify that access enforcement mechanisms (e.g., file and folder permissions) are implemented and reviewed." | Out-File -FilePath $LogFile -Append
}

# AC-4: Information Flow Enforcement
function Check-AC4InformationFlow {
    Write-Output "AC-4: Manual Review Required - Information Flow Enforcement" | Out-File -FilePath $LogFile -Append
    Write-Output "Ensure that information flow (e.g., between network segments) is restricted by policies and enforced by firewalls or equivalent mechanisms." | Out-File -FilePath $LogFile -Append
}

# AC-5: Separation of Duties
function Check-AC5SeparationOfDuties {
    Write-Output "AC-5: Manual Review Required - Separation of Duties" | Out-File -FilePath $LogFile -Append
    Write-Output "Ensure that critical duties are divided among different roles to prevent conflicts of interest." | Out-File -FilePath $LogFile -Append
}

# AC-6: Least Privilege
function Check-AC6LeastPrivilege {
    Write-Output "AC-6: Checking for least privilege enforcement..." | Out-File -FilePath $LogFile -Append
    $PrivilegedAccounts = Get-LocalGroupMember -Group "Administrators"
    if ($PrivilegedAccounts) {
        Write-Output "Found the following privileged accounts:" | Out-File -FilePath $LogFile -Append
        $PrivilegedAccounts | Format-Table | Out-String | Out-File -FilePath $LogFile -Append
    } else {
        Write-Output "No privileged accounts found. Verify least privilege is enforced." | Out-File -FilePath $LogFile -Append
    }
}

# AC-7: Unsuccessful Login Attempts
function Check-AC7LoginAttempts {
    Write-Output "AC-7: Checking for unsuccessful login attempt policies..." | Out-File -FilePath $LogFile -Append
    $AuditPolicy = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "MaxFailedLogonAttempts" -ErrorAction SilentlyContinue
    if ($AuditPolicy) {
        Write-Output "Policy for unsuccessful login attempts is configured: $AuditPolicy" | Out-File -FilePath $LogFile -Append
    } else {
        Write-Output "No policy for unsuccessful login attempts found! Configure it in the system security settings." | Out-File -FilePath $LogFile -Append
    }
}

# AC-8: System Use Notification
function Check-AC8SystemNotification {
    Write-Output "AC-8: Checking for system use notification banner..." | Out-File -FilePath $LogFile -Append
    $NotificationBanner = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LegalNoticeText" -ErrorAction SilentlyContinue
    if ($NotificationBanner) {
        Write-Output "System use notification banner is configured." | Out-File -FilePath $LogFile -Append
    } else {
        Write-Output "System use notification banner is NOT configured! Ensure a banner is set in the system security settings." | Out-File -FilePath $LogFile -Append
    }
}

# Execute all checks
Check-AC1Policy
Check-AC2AccountManagement
Check-AC3AccessEnforcement
Check-AC4InformationFlow
Check-AC5SeparationOfDuties
Check-AC6LeastPrivilege
Check-AC7LoginAttempts
Check-AC8SystemNotification

Write-Output "Access Control (AC) Compliance Checks Completed." | Out-File -FilePath $LogFile -Append