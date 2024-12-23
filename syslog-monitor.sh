#!/bin/bash

PUSH_URL="XXXXXX"

# Cleanup function
cleanup() {
    echo "Cleaning up..."
    pkill -P $$
    exit
}

trap cleanup SIGINT SIGTERM

# Send initial status
curl "${PUSH_URL}?status=up&msg=Syslog-Monitor-Starting&ping="

# Start heartbeat in background
while true; do
    curl "${PUSH_URL}?status=up&msg=Syslog-Monitor-Active&ping="
    echo "Heartbeat sent"
    sleep 30
done &

# Main monitoring loop
tail -f /var/log/syslog | while read line; do
    if [[ $line == *"error"* ]] || [[ $line == *"critical"* ]] || [[ $line == *"failed"* ]]; then
        # Send down status when issues found
        ALERT="System-Alert:$(echo $line | tr ' ' '-')"
        curl "${PUSH_URL}?status=down&msg=$ALERT&ping="
    fi
done
