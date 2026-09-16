#!/bin/bash

generate_report() {
    local threshold="$1"
    local windows_minute="$2"
    local generated_at=$(date "+%b %d %Y %H:%M:%S")

    echo "SentrySSH Report"
    echo "Generated: $generated_at"
    echo "Threshold: $threshold"
    echo "Windows: $windows_minute minutes"
    echo "========================================"
    for ip in $(printf "%s\n" "${!attempt_count[@]}" | sort); do
        if is_flagged "$ip" "$threshold"; then
            echo "IP: $ip"
            echo "  Attempts: ${attempt_count["$ip"]}"
            echo "  Usernames tried: ${usernames_tried["$ip"]}"
            echo "  First seen: ${first_seen["$ip"]}"
            echo "  Last seen:  ${last_seen["$ip"]}"
        fi
    done

}