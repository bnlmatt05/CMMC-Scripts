#!/bin/bash

# Script to execute all compliance scripts and consolidate outputs into one HTML file

# Ensure the script is run with root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Define paths to compliance scripts
SCRIPTS=(
    "./AccessControl/AC-Control-Family.sh"
    "./AuditAndAccountability/AU-Control-Family.sh"
    "./IdentificationAndAuthentication/IA-Control-Family.sh"
    "./SystemAndCommunicationsProtection/SC-Control-Family.sh"
    "./SystemAndInformationIntegrity/SI-Control-Family.sh"
)

# Output Directory and Master HTML File
OUTPUT_DIR="/var/log/compliance-checks"
MASTER_HTML_FILE="$OUTPUT_DIR/master_compliance_report.html"

# Prepare output directory
mkdir -p "$OUTPUT_DIR"
echo "Compliance checks will be logged to $OUTPUT_DIR"

# Start the master HTML file
echo "<html>" > "$MASTER_HTML_FILE"
echo "<head><title>Compliance Report</title><style>body { font-family: Arial, sans-serif; } h1 { color: #333; } pre { background: #f4f4f4; padding: 10px; border: 1px solid #ddd; }</style></head>" >> "$MASTER_HTML_FILE"
echo "<body>" >> "$MASTER_HTML_FILE"
echo "<h1>Consolidated Compliance Report</h1>" >> "$MASTER_HTML_FILE"

# Execute each script and collect outputs
for SCRIPT in "${SCRIPTS[@]}"; do
    SCRIPT_NAME=$(basename "$SCRIPT")
    SCRIPT_LOG="$OUTPUT_DIR/${SCRIPT_NAME%.sh}.log"
    
    echo "Executing $SCRIPT..."
    if [[ -f "$SCRIPT" ]]; then
        bash "$SCRIPT" > "$SCRIPT_LOG" 2>&1
        echo "<h2>Report for $SCRIPT_NAME</h2>" >> "$MASTER_HTML_FILE"
        echo "<pre>" >> "$MASTER_HTML_FILE"
        cat "$SCRIPT_LOG" >> "$MASTER_HTML_FILE"
        echo "</pre>" >> "$MASTER_HTML_FILE"
    else
        echo "<h2>Report for $SCRIPT_NAME</h2>" >> "$MASTER_HTML_FILE"
        echo "<pre>Script not found: $SCRIPT</pre>" >> "$MASTER_HTML_FILE"
    fi
done

# Finalize the master HTML file
echo "</body>" >> "$MASTER_HTML_FILE"
echo "</html>" >> "$MASTER_HTML_FILE"

echo "Consolidated compliance report generated at $MASTER_HTML_FILE"