# PowerShell Script for automating compliance checks for the Identification and Authentication (IA) family
# NIST 800-53 Controls: IA-1 through IA-8

# Logging
$LogFile = "C:\ComplianceLogs\IA-Control-Family.log"
New-Item -ItemType File -Force -Path $LogFile | Out-Null
Write-Output "Starting Identification and Authentication (IA) Compliance Checks" | Out-File -FilePath $LogFile -Append

# IA-1: Policy and Procedures
function Check-IA1Policy {
    Write-Output "IA-1: Verifying Identification and Authentication Policy documentation..." | Out-File -FilePath $LogFile -Append
    $PolicyFile = "C:\Policies\IdentificationAndAuthenticationPolicy.txt"
    if (Test-Path -Path $PolicyFile) {
        Write-Output "Identification and Authentication Policy is documented." | Out-File -FilePath $LogFile -Append
    } else {
        Write-Output "Identification and Authentication Policy is NOT documented! Ensure the policy is created at $PolicyFile." | Out-File -FilePath $LogFile -Append
    }
}

# IA-2: Identification and Authentication (Organizational Users)
function Check-IA2OrganizationalUsers {
    Write-Output "IA-2: Checking for local user accounts requiring passwords..." | Out-File -FilePath $LogFile -Append
    $Accounts = Get-LocalUser | Where-Object { $_.PasswordRequired -eq $True }
    if ($Accounts) {
        Write-Output "Found the following accounts requiring passwords:" | Out-File -FilePath $LogFile -Append
        $Accounts | Format-Table | Out-String | Out-File -FilePath $LogFile -Append
    } else {
        Write-Output "No accounts requiring passwords found! Ensure all accounts have strong authentication mechanisms." | Out-File -FilePath $LogFile -Append
    }
}

# IA-3: Device Identification and Authentication
function Check-IA3DeviceAuthentication {
    Write-Output "IA-3: Manual Review Required - Device Identification and Authentication" | Out-File -FilePath $LogFile -Append
    Write-Output "Verify that devices connecting to the network are authenticated and identified before gaining access." | Out-File -FilePath $LogFile -Append
}

# IA-4: Identifier Management
function Check-IA4IdentifierManagement {
    Write-Output "IA-4: Checking for identifier management practices..." | Out-File -FilePath $LogFile -Append
    $ExpiredAccounts = Get-LocalUser | Where-Object { $_.AccountExpires -and $_.AccountExpires -lt (Get-Date) }
    if ($ExpiredAccounts) {
        Write-Output "Found expired accounts that need to be removed or updated:" | Out-File -FilePath $LogFile -Append
        $ExpiredAccounts | Format-Table | Out-String | Out-File -FilePath $LogFile -Append
    } else {
        Write-Output "No expired accounts found. Identifier management practices appear compliant." | Out-File -FilePath $LogFile -Append
    }
}

# IA-5: Authenticator Management
function Check-IA5AuthenticatorManagement {
    Write-Output "IA-5: Checking for password policy settings..." | Out-File -FilePath $LogFile -Append
    $PasswordPolicy = Get-LocalUser | Select-Object Name, PasswordLastSet
    if ($PasswordPolicy) {
        Write-Output "Password policy settings detected:" | Out-File -FilePath $LogFile -Append
        $PasswordPolicy | Format-Table | Out-String | Out-File -FilePath $LogFile -Append
    } else {
        Write-Output "No password policy detected! Ensure password policies are enforced." | Out-File -FilePath $LogFile -Append
    }
}

# IA-6: Authenticator Feedback
function Check-IA6AuthenticatorFeedback {
    Write-Output "IA-6: Manual Review Required - Authenticator Feedback" | Out-File -FilePath $LogFile -Append
    Write-Output "Verify that authentication mechanisms do not provide feedback that could be used to compromise security (e.g., error messages revealing credentials)." | Out-File -FilePath $LogFile -Append
}

# IA-7: Cryptographic Module Authentication
function Check-IA7CryptographicAuthentication {
    Write-Output "IA-7: Manual Review Required - Cryptographic Module Authentication" | Out-File -FilePath $LogFile -Append
    Write-Output "Ensure that cryptographic modules used for authentication meet organization-defined requirements." | Out-File -FilePath $LogFile -Append
}

# IA-8: Identification and Authentication (Non-Organizational Users)
function Check-IA8NonOrganizationalUsers {
    Write-Output "IA-8: Manual Review Required - Identification and Authentication (Non-Organizational Users)" | Out-File -FilePath $LogFile -Append
    Write-Output "Verify that non-organizational users (e.g., contractors, vendors) are identified and authenticated before being granted access." | Out-File -FilePath $LogFile -Append
}

# Execute all checks
Check-IA1Policy
Check-IA2OrganizationalUsers
Check-IA3DeviceAuthentication
Check-IA4IdentifierManagement
Check-IA5AuthenticatorManagement
Check-IA6AuthenticatorFeedback
Check-IA7CryptographicAuthentication
Check-IA8NonOrganizationalUsers

Write-Output "Identification and Authentication (IA) Compliance Checks Completed." | Out-File -FilePath $LogFile -Append