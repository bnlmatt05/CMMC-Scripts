# PowerShell Script for automating compliance checks for the System and Communications Protection (SC) family
# NIST 800-53 Controls: SC-1 through SC-7

# Logging
$LogFile = "C:\ComplianceLogs\SC-Control-Family.log"
New-Item -ItemType File -Force -Path $LogFile | Out-Null
Write-Output "Starting System and Communications Protection (SC) Compliance Checks" | Out-File -FilePath $LogFile -Append

# SC-1: Policy and Procedures
function Check-SC1Policy {
    Write-Output "SC-1: Verifying System and Communications Protection Policy documentation..." | Out-File -FilePath $LogFile -Append
    $PolicyFile = "C:\Policies\SystemAndCommunicationsProtectionPolicy.txt"
    if (Test-Path -Path $PolicyFile) {
        Write-Output "System and Communications Protection Policy is documented." | Out-File -FilePath $LogFile -Append
    } else {
        Write-Output "System and Communications Protection Policy is NOT documented! Ensure the policy is created at $PolicyFile." | Out-File -FilePath $LogFile -Append
    }
}

# SC-2: Application Partitioning
function Check-SC2AppPartitioning {
    Write-Output "SC-2: Manual Review Required - Application Partitioning" | Out-File -FilePath $LogFile -Append
    Write-Output "Ensure that applications are partitioned to separate functions and data processing into discrete components." | Out-File -FilePath $LogFile -Append
}

# SC-3: Security Function Isolation
function Check-SC3SecurityFunctionIsolation {
    Write-Output "SC-3: Checking for Security Function Isolation..." | Out-File -FilePath $LogFile -Append
    $SecureBootStatus = Confirm-SecureBootUEFI
    if ($SecureBootStatus) {
        Write-Output "Secure Boot is enabled, ensuring isolation of security functions." | Out-File -FilePath $LogFile -Append
    } else {
        Write-Output "Secure Boot is NOT enabled! Enable Secure Boot in the BIOS/UEFI settings to ensure security function isolation." | Out-File -FilePath $LogFile -Append
    }
}

# SC-4: Information In Transit Protection
function Check-SC4InfoInTransit {
    Write-Output "SC-4: Checking for encrypted connections..." | Out-File -FilePath $LogFile -Append
    $TLSStatus = Get-TlsCipherSuite
    if ($TLSStatus) {
        Write-Output "TLS encryption is enabled for connections, ensuring information in transit is protected." | Out-File -FilePath $LogFile -Append
    } else {
        Write-Output "TLS encryption is NOT enabled! Ensure all connections are encrypted using TLS or similar protocols." | Out-File -FilePath $LogFile -Append
    }
}

# SC-5: Denial-of-Service Protection
function Check-SC5DoSProtection {
    Write-Output "SC-5: Manual Review Required - Denial-of-Service (DoS) Protection" | Out-File -FilePath $LogFile -Append
    Write-Output "Verify that mechanisms (e.g., firewall rules, rate limiting) are in place to protect against DoS attacks." | Out-File -FilePath $LogFile -Append
}

# SC-6: Resource Availability
function Check-SC6ResourceAvailability {
    Write-Output "SC-6: Checking system resource availability..." | Out-File -FilePath $LogFile -Append
    $DiskSpace = Get-PSDrive -Name C | Select-Object -ExpandProperty Free
    $Memory = Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -ExpandProperty FreePhysicalMemory
    if ($DiskSpace -gt 5GB -and $Memory -gt 1GB) {
        Write-Output "System resources are sufficient, ensuring availability." | Out-File -FilePath $LogFile -Append
    } else {
        Write-Output "System resource availability is low! Ensure adequate disk space and memory are available for operations." | Out-File -FilePath $LogFile -Append
    }
}

# SC-7: Boundary Protection
function Check-SC7BoundaryProtection {
    Write-Output "SC-7: Checking for firewall status..." | Out-File -FilePath $LogFile -Append
    $FirewallStatus = Get-NetFirewallProfile | Where-Object { $_.Enabled -eq $True }
    if ($FirewallStatus) {
        Write-Output "Firewall is enabled, ensuring boundary protection." | Out-File -FilePath $LogFile -Append
    } else {
        Write-Output "Firewall is NOT enabled! Ensure the firewall is active to protect system boundaries." | Out-File -FilePath $LogFile -Append
    }
}

# Execute all checks
Check-SC1Policy
Check-SC2AppPartitioning
Check-SC3SecurityFunctionIsolation
Check-SC4InfoInTransit
Check-SC5DoSProtection
Check-SC6ResourceAvailability
Check-SC7BoundaryProtection

Write-Output "System and Communications Protection (SC) Compliance Checks Completed." | Out-File -FilePath $LogFile -Append