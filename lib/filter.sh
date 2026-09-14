#!/bin/bash

is_within_window() {

    local timestamp="$1"
    local windows_minutes="$2"

    local ts_epoch
    ts_epoch=$(date -d "$timestamp" +%s)

    local cutoff_epoch
    cutoff_epoch=$(date -d "-${windows_minutes} minutes" +%s)

    if [[ "$ts_epoch" -ge "$cutoff_epoch" ]]; then
        return 0
    else
        return 1
    fi
}