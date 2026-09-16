#!/bin/bash

source lib/parse.sh
source lib/aggregate.sh
source lib/filter.sh
source lib/report.sh

WINDOWS_MINUTE="${1:-60}"
THRESHOLD="${2:-5}"
LOGFILE="tests/sample-auth.log"
REPORT_FILE="reports/sentryssh-report-$(date +%Y%m%d-%H%M%S).txt"

if [[ -f "$LOGFILE" ]]; then
    echo "Found the log file at $LOGFILE"
    parse_log "$LOGFILE" "$WINDOWS_MINUTE"
    print_aggregate "$THRESHOLD"
    generate_report "$THRESHOLD" "$WINDOWS_MINUTE" > "$REPORT_FILE"
    echo "Report written to $REPORT_FILE"
else
    echo "ERROR: could not find $LOGFILE"
fi

exit 0