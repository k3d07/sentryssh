#!/bin/bash

parse_log() {
    local log_file=$1
    while IFS= read -r line; do
        if [[ "$line" == *"Failed password"* ]]; then
            if [[ "$line" =~ ([A-za-z]{3}[[:space:]]+[0-9]{1,2}[[:space:]]+[0-9:]{8}).*Failed\ password\ for\ (invalid\ user\ )?([^[:space:]]+)\ from\ ([0-9.]+) ]]; then
                printf "IP: ${BASH_REMATCH[4]} | User: ${BASH_REMATCH[3]} | Time: ${BASH_REMATCH[1]}\n"
            fi
        else
            continue
        fi
    done < "$log_file"
}