#!/bin/bash

# Count the number of failed logins by IP address.
# If there are any IPs with over LIMIT failures, display the count, IP, and location.

LIMIT='10'
LOG_FILE="${1}"