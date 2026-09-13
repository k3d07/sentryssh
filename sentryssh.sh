#!/bin/bash

LOGFILE="tests/sample-auth.log"

if [[ -f "$LOGFILE" ]]; then
    echo "Found the log file at $LOGFILE"
else
    echo "ERROR: could not find $LOGFILE"
fi

exit 0