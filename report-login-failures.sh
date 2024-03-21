#/bin/bash

# Run with sudo or root

# This script analyses a log file containing failed login attempts and generates a report summarising potentially suspicious activity.
# If there are any IPs with over max login limit failures, display the count, IP, and location.

MAX_LOGIN_ATTEMPTS='10'
LOG_FILE="${1}"

# Check if a log file was supplied as an argument.
[[ -z "${LOG_FILE}" ]]
then
    echo "Error: Please provide a log file path as an argument." >&2
    exit 1
fi

# Loop through the list of failed attempts and corresponding IP addresses.
grep Failed ${LOG_FILE} | awk '{print $(NF - 3)}' | sort | uniq -c | sort -nr |  while read COUNT IP
do
  # If the number of failed attempts is greater than the limit, display count, IP, and location.
  if [[ "${COUNT}" -gt "${MAX_LOGIN_ATTEMPTS}" ]]
  then
    LOCATION=$(geoiplookup ${IP} | awk -F ', ' '{print $2}')
    echo "${COUNT},${IP},${LOCATION}"
  fi
done
exit 0