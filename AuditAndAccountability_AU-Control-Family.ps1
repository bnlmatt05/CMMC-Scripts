# PowerShell Script for automating compliance checks for the Audit and Accountability (AU) family
# NIST 800-53 Controls: AU-1 through AU-7

# Logging
$LogFile = "C:\ComplianceLogs\AU-Control-Family.log"
New-Item -ItemType File -Force -Path $LogFile | Out-Null
Write-Output "Starting Audit and Accountability (AU) Compliance Checks" | Out-File -FilePath $LogFile -Append

# AU-1: Audit and Accountability Policy and Procedures
function Check-AU1Policy {
    Write-Output "AU-1: Verifying Audit and Accountability Policy documentation..." | Out-File -FilePath $LogFile -Append
    $PolicyFile = "C:\Policies\AuditAndAccountabilityPolicy.txt"
    if (Test-Path -Path $PolicyFile) {
        Write-Output "Audit and Accountability Policy is documented." | Out-File -FilePath $LogFile -Append
    } else {
        Write-Output "Audit and Accountability Policy is NOT documented! Ensure the policy is created at $PolicyFile." | Out-File -FilePath $LogFile -Append
    }
}

# AU-2: Audit Events
function Check-AU2AuditEvents {
    Write-Output "AU-2: Checking for configured audit events..." | Out-File -FilePath $LogFile -Append
    $AuditSettings = AuditPol /get /category:* | Out-String
    if ($AuditSettings) {
        Write-Output "Configured Audit Events:" | Out-File -FilePath $LogFile -Append
        $AuditSettings | Out-File -FilePath $LogFile -Append
    } else {
        Write-Output "No audit events are configured! Ensure audit policies are set using 'AuditPol' or Group Policy." | Out-File -FilePath $LogFile -Append
    }
}

# AU-3: Content of Audit Records
function Check-AU3AuditContent {
    Write-Output "AU-3: Manual Review Required - Content of Audit Records" | Out-File -FilePath $LogFile -Append
    Write-Output "Verify that audit records include sufficient details (e.g., user identity, event type, timestamp). Review audit logs for compliance." | Out-File -FilePath $LogFile -Append
}

# AU-4: Audit Storage Capacity
function Check-AU4AuditStorage {
    Write-Output "AU-4: Checking audit storage capacity..." | Out-File -FilePath $LogFile -Append
    $AuditLogPath = "C:\Windows\System32\LogFiles\WMI\RtBackup"
    $DiskSpace = Get-PSDrive -Name C | Select-Object -ExpandProperty Free
    if ((Test-Path -Path $AuditLogPath) -and ($DiskSpace -gt 1GB)) {
        Write-Output "Sufficient audit storage capacity available." | Out-File -FilePath $LogFile -Append
    } else {
        Write-Output "Insufficient audit storage capacity! Ensure adequate disk space is available for audit logs." | Out-File -FilePath $LogFile -Append
    }
}

# AU-5: Response to Audit Processing Failures
function Check-AU5AuditFailureResponse {
    Write-Output "AU-5: Manual Review Required - Response to Audit Processing Failures" | Out-File -FilePath $LogFile -Append
    Write-Output "Ensure the organization has defined and implemented responses to audit processing failures." | Out-File -FilePath $LogFile -Append
}

# AU-6: Audit Review, Analysis, and Reporting
function Check-AU6AuditReview {
    Write-Output "AU-6: Manual Review Required - Audit Review, Analysis, and Reporting" | Out-File -FilePath $LogFile -Append
    Write-Output "Verify that audit logs are regularly reviewed, analyzed, and reported to detect suspicious activities." | Out-File -FilePath $LogFile -Append
}

# AU-7: Audit Reduction and Report Generation
function Check-AU7AuditReduction {
    Write-Output "AU-7: Checking for audit reduction and reporting tools..." | Out-File -FilePath $LogFile -Append
    if (Get-Command -Name wevtutil -ErrorAction SilentlyContinue) {
        Write-Output "Audit reduction and reporting tools (e.g., wevtutil) are available." | Out-File -FilePath $LogFile -Append
    } else {
        Write-Output "Audit reduction and reporting tools are NOT available! Ensure tools like 'wevtutil' are installed and configured." | Out-File -FilePath $LogFile -Append
    }
}

# Execute all checks
Check-AU1Policy
Check-AU2AuditEvents
Check-AU3AuditContent
Check-AU4AuditStorage
Check-AU5AuditFailureResponse
Check-AU6AuditReview
Check-AU7AuditReduction

Write-Output "Audit and Accountability (AU) Compliance Checks Completed." | Out-File -FilePath $LogFile -Append