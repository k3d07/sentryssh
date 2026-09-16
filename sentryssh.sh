#!/bin/bash

source lib/parse.sh
source lib/aggregate.sh
source lib/filter.sh
source lib/report.sh

if [[ -f "config/sentryssh.conf" ]]; then
    source config/sentryssh.conf
fi

REPORT_FILE=""

show_help() {
    echo "Usage: ./sentryssh.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --log PATH        Path to the SSH auth log to analyze (default: $LOGFILE)"
    echo "  --threshold N     Failed attempts before an IP is flagged (default: $THRESHOLD)"
    echo "  --window MINUTES  Only consider activity within this many minutes (default: $WINDOW_MINUTES)"
    echo "  --output PATH     Where to write the report (default: auto-timestamped file in reports/)"
    echo "  --help            Show this help message"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --log)
            LOGFILE="$2"
            shift 2
            ;;
        --threshold)
            THRESHOLD="$2"
            shift 2
            ;;
        --window)
            WINDOW_MINUTES="$2"
            shift 2
            ;;
        --output)
            REPORT_FILE="$2"
            shift 2
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

if [[ -z "$REPORT_FILE" ]]; then
    REPORT_FILE="reports/sentryssh-report-$(date +%Y%m%d-%H%M%S).txt"
fi

RUNLOG="logs/sentryssh-run.log"

mkdir -p logs
mkdir -p reports

if [[ -f "$LOGFILE" ]]; then
    echo "Found the log file at $LOGFILE"
    parse_log "$LOGFILE" "$WINDOW_MINUTES"
    print_aggregate "$THRESHOLD"
    generate_report "$THRESHOLD" "$WINDOW_MINUTES" > "$REPORT_FILE"
    echo "Report written to $REPORT_FILE"

    flagged_count=$(count_flagged "$THRESHOLD")
    run_time=$(date "+%b %d %Y %H:%M:%S")
    echo "["$run_time"] SUCCESS - Lines processed: $TOTAL_LINES | IPs flagged: $flagged_count | Threshold: $THRESHOLD | Window: $WINDOW_MINUTES" >> "$RUNLOG"
else
    echo "ERROR: could not find $LOGFILE"
    run_time=$(date "+%b %d %Y %H:%M:%S")
    echo "["$run_time"] ERROR - Log file not found: $LOGFILE" >> "$RUNLOG"
fi

exit 0