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
    
    #Checking and appending username
    if [[ "${usernames_tried["$ip"]}" != *"$user"* ]]; then
        usernames_tried["$ip"]+="$user "
    fi

    #Checking first seen
    if [[ -z "${first_seen["$ip"]}" ]]; then
        first_seen["$ip"]="$time"
    fi

    last_seen["$ip"]="$time"
}

print_aggregate() {
    local threshold="$1"

    echo "=== FLAGGED (threshold: $threshold) ==="
    for ip in $(printf "%s\n" "${!attempt_count[@]}" | sort); do
        if is_flagged "$ip" "$threshold"; then
            echo "IP: $ip"
            echo "  Attempts: ${attempt_count["$ip"]}"
            echo "  Usernames tried: ${usernames_tried["$ip"]}"
            echo "  First seen: ${first_seen["$ip"]}"
            echo "  Last seen:  ${last_seen["$ip"]}"

            echo " "
        fi
    done

    echo "=== NORMAL ==="
    for ip in $(printf "%s\n" "${!attempt_count[@]}" | sort); do
        if ! is_flagged "$ip" "$threshold"; then
            echo "IP: $ip"
            echo "  Attempts: ${attempt_count["$ip"]}"
            echo "  Usernames tried: ${usernames_tried["$ip"]}"
            echo "  First seen: ${first_seen["$ip"]}"
            echo "  Last seen:  ${last_seen["$ip"]}"

            echo " "
        fi
    done
}

is_flagged() {
    local ip="$1"
    local threshold="$2"

    if [[ "${attempt_count["$ip"]}" -ge "$threshold" ]]; then
        return 0
    else
        return 1
    fi
}