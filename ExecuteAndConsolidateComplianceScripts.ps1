# PowerShell Script to Execute All Compliance Scripts and Consolidate Outputs into a Master HTML File

# Define paths to compliance scripts
$scripts = @(
    ".\AccessControl\AC-Control-Family.ps1",
    ".\AuditAndAccountability\AU-Control-Family.ps1",
    ".\IdentificationAndAuthentication\IA-Control-Family.ps1",
    ".\SystemAndCommunicationsProtection\SC-Control-Family.ps1",
    ".\SystemAndInformationIntegrity\SI-Control-Family.ps1"
)

# Output Directory and Master HTML File
$outputDir = "C:\ComplianceChecks\Logs"
$masterHtmlFile = "$outputDir\MasterComplianceReport.html"

# Prepare output directory
if (-Not (Test-Path -Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

Write-Host "Compliance checks will be logged to $outputDir"

# Start the master HTML file
@"
<html>
<head>
    <title>Compliance Report</title>
    <style>
        body { font-family: Arial, sans-serif; }
        h1 { color: #333; }
        pre { background: #f4f4f4; padding: 10px; border: 1px solid #ddd; }
    </style>
</head>
<body>
    <h1>Consolidated Compliance Report</h1>
"@ | Out-File -FilePath $masterHtmlFile -Encoding UTF8

# Execute each script and collect outputs
foreach ($script in $scripts) {
    $scriptName = Split-Path -Path $script -Leaf
    $scriptLog = "$outputDir\$($scriptName -replace '\.ps1$', '.log')"
    
    Write-Host "Executing $script..."
    if (Test-Path -Path $script) {
        try {
            # Redirect script output to log file
            powershell -File $script *>&1 | Out-File -FilePath $scriptLog -Encoding UTF8
            Add-Content -Path $masterHtmlFile -Value "
                <h2>Report for $scriptName</h2>
                <pre>$(Get-Content -Path $scriptLog -Raw)</pre>
            "
        } catch {
            Add-Content -Path $masterHtmlFile -Value "
                <h2>Report for $scriptName</h2>
                <pre>Failed to execute script: $($_.Exception.Message)</pre>
            "
        }
    } else {
        Add-Content -Path $masterHtmlFile -Value "
            <h2>Report for $scriptName</h2>
            <pre>Script not found: $script</pre>
        "
    }
}

# Finalize the master HTML file
@"
</body>
</html>
"@ | Add-Content -Path $masterHtmlFile

Write-Host "Consolidated compliance report generated at $masterHtmlFile"