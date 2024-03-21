#!/bin/bash

# This script requires root privileges to run geoiplookup for location data. Run with sudo or root.

# Analyzes a log file containing failed login attempts and generates a report.
# The report summarizes potentially suspicious activity by identifying IPs with an unusually high number of failures exceeding a predefined limit.

MAX_LOGIN_ATTEMPTS=10  # Set the maximum allowed failed login attempts

# Script expects a log file path as the first argument
LOG_FILE="$1"

# Check if a log file argument was provided
if [[ -z "$LOG_FILE" ]]; then
  echo "Error: Please provide a log file path as the first argument." >&2
  exit 1
fi

# Process the log file
grep 'Failed' "$LOG_FILE" | awk '{print $NF-3}' | sort | uniq -c | sort -nr | while read -r COUNT IP; do
  # Check if login attempts exceed the limit
  if [[ "$COUNT" -gt "$MAX_LOGIN_ATTEMPTS" ]]; then
    # Use geoiplookup to find the IP's location (requires geoiplookup tool)
    LOCATION=$(geoiplookup "$IP" | awk -F ', ' '{print $2}')
    # Report: Count, IP address, and location
    echo "$COUNT,$IP,$LOCATION"
  fi
done

exit 0