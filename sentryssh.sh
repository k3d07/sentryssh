#!/bin/bash

source lib/parse.sh
source lib/aggregate.sh
source lib/filter.sh

WINDOWS_MINUTE="${1:-60}"
THRESHOLD="${2:-5}"
LOGFILE="tests/sample-auth.log"

if [[ -f "$LOGFILE" ]]; then
    echo "Found the log file at $LOGFILE"
    parse_log "$LOGFILE" "$WINDOWS_MINUTE"
    print_aggregate "$THRESHOLD"
else
    echo "ERROR: could not find $LOGFILE"
fi

exit 0