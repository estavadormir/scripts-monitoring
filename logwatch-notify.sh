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
curl "${PUSH_URL}?status=up&msg=Logwatch-Starting&ping="

# Start heartbeat in background
while true; do
    curl "${PUSH_URL}?status=up&msg=Logwatch-Active&ping="
    echo "Heartbeat sent"
    sleep 30
done &

# Main monitoring loop
while true; do
    # Run logwatch check
    OUTPUT=$(sudo logwatch --detail Low --range today --output stdout)

    # Check for issues
    if echo "$OUTPUT" | grep -iE 'error|warning|critical|fail'; then
        curl "${PUSH_URL}?status=down&msg=Issues-Found-Check-Logs&ping="
    else
        curl "${PUSH_URL}?status=up&msg=All-Clear&ping="
    fi

    # Wait before next check (every hour)
    sleep 3600
done
