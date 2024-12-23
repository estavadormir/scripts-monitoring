#!/bin/bash

PUSH_URL="XXXXXX"

# Cleanup function
cleanup() {
    echo "Cleaning up..."
    pkill -P $$
    exit
}

trap cleanup SIGINT SIGTERM

# Send initial heartbeat
curl "${PUSH_URL}?status=up&msg=SSH-Monitor-Started&ping="

# Start heartbeat in background
while true; do
    curl "${PUSH_URL}?status=up&msg=SSH-Monitor-Active&ping="
    echo "Heartbeat sent"
    sleep 30
done &

tail -f /var/log/auth.log | while read line; do
    if [[ $line == *"Accepted"* ]] && [[ $line == *"ssh"* ]]; then
        ALERT="SSH-Login:$(echo $line | grep -oE 'for .* from' | sed 's/for //;s/ from//')"
        curl "${PUSH_URL}?status=down&msg=$ALERT&ping="
    fi
done
