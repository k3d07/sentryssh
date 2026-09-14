#!/bin/bash

source lib/parse.sh
source lib/aggregate.sh

LOGFILE="tests/sample-auth.log"

if [[ -f "$LOGFILE" ]]; then
    echo "Found the log file at $LOGFILE"
    parse_log "$LOGFILE"
    print_aggregate
else
    echo "ERROR: could not find $LOGFILE"
fi

exit 0