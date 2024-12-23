#!/bin/bash

PUSH_URL="XXXXX"

# Cleanup function
cleanup() {
    echo "Cleaning up..."
    pkill -P $$
    exit
}

trap cleanup SIGINT SIGTERM

# Send initial status
curl "${PUSH_URL}?status=up&msg=RKHunter-Starting&ping="

# Start heartbeat in background
while true; do
    curl "${PUSH_URL}?status=up&msg=RKHunter-Active&ping="
    echo "Heartbeat sent"
    sleep 30
done &

# Main monitoring loop
while true; do
    # Run RKHunter check
    REPORT=$(rkhunter --check --skip-keypress --report-warnings-only)

    # Check for warnings
    if [ ! -z "$REPORT" ]; then
        # If warnings found, send down status
        curl "${PUSH_URL}?status=down&msg=Warnings-Found&ping="
    else
        # If clean, send up status
        curl "${PUSH_URL}?status=up&msg=All-Clear&ping="
    fi

    # Wait before next check (every hour)
    sleep 3600
done
