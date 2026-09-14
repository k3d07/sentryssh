#!/bin/bash

source lib/aggregate.sh

parse_log() {
    local log_file="$1"
    while IFS= read -r line; do
        if [[ "$line" == *"Failed password"* ]]; then
            if [[ "$line" =~ ([A-Za-z]{3}[[:space:]]+[0-9]{1,2}[[:space:]]+[0-9:]{8}).*Failed\ password\ for\ (invalid\ user\ )?([^[:space:]]+)\ from\ ([0-9.]+) ]]; then
                ip="${BASH_REMATCH[4]}"
                user="${BASH_REMATCH[3]}"
                time="${BASH_REMATCH[1]}"
                aggregate_entry "$ip" "$user" "$time"
            fi
        fi
    done < "$log_file"
}