#!/bin/bash

declare -A attempt_count
declare -A usernames_tried
declare -A first_seen
declare -A last_seen

aggregate_entry() {
    local ip="$1"
    local user="$2"
    local time="$3"

    #Counting of attempt per IP
    attempt_count["$ip"]=$(( ${attempt_count[$ip]:-0} + 1 ))
    
    if [[ "${usernames_tried["$ip"]}" != *"$user"* ]]; then
        usernames_tried["$ip"]+="$user "
    fi

    if [[ -z "${first_seen["$ip"]}" ]]; then
        first_seen["$ip"]="$time"
    fi

    last_seen["$ip"]="$time"
}

print_aggregate() {
    for ip in $(printf "%s\n" "${!attempt_count[@]}" | sort); do
        echo "IP: $ip"
        echo "  Attempts: ${attempt_count["$ip"]}"
        echo "  Usernames tried: ${usernames_tried["$ip"]}"
        echo "  First seen: ${first_seen["$ip"]}"
        echo "  Last seen:  ${last_seen["$ip"]}"
    done
}
