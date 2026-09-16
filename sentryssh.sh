#!/bin/bash

source lib/parse.sh
source lib/aggregate.sh
source lib/filter.sh
source lib/report.sh

WINDOWS_MINUTE="${1:-60}"
THRESHOLD="${2:-5}"
LOGFILE="tests/sample-auth.log"
REPORT_FILE="reports/sentryssh-report-$(date +%Y%m%d-%H%M%S).txt"
RUNLOG="logs/sentryssh-run.log"

mkdir -p logs

if [[ -f "$LOGFILE" ]]; then
    echo "Found the log file at $LOGFILE"
    parse_log "$LOGFILE" "$WINDOWS_MINUTE"
    print_aggregate "$THRESHOLD"
    generate_report "$THRESHOLD" "$WINDOWS_MINUTE" > "$REPORT_FILE"
    echo "Report written to $REPORT_FILE"

    flagged_count=$(count_flagged "$THRESHOLD")
    run_time=$(date "+%b %d %Y %H:%M:%S")
    echo "["$run_time"] SUCCESS - Lines processed: $TOTAL_LINES | IPs flagged: $flagged_count | Threshold: $THRESHOLD | Window: $WINDOWS_MINUTE" >> "$RUNLOG"
else
    echo "ERROR: could not find $LOGFILE"
    run_time=$(date "+%b %d %Y %H:%M:%S")
    echo "["$run_time"] ERROR - Log file not found: $LOGFILE" >> "$RUNLOG"
fi

exit 0