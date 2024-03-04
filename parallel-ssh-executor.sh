#!/bin/bash

# A list of servers, one per line.
SERVER_FILE='/vagrant/servers'  # Changed from SERVER_LIST for clarity

# Options for the ssh command.
SSH_FLAGS='-o ConnectTimeout=2'  # Changed from SSH_OPTIONS for consistency with flags

usage() {
  # Display the usage and exit.
  echo "Usage: ${0} [-nsv] [-f FILE] COMMAND" >&2
  echo 'Executes COMMAND as a single command on every server.' >&2
  echo "  -f FILE  Use FILE for the list of servers. Default: ${SERVER_FILE}." >&2
  echo '  -n      Dry run mode. Display the COMMAND that would have been executed and exit.' >&2
  echo '  -s      Execute the COMMAND using sudo on the remote server.' >&2
  echo '  -v      Verbose mode. Displays the server name before executing COMMAND.' >&2
  exit 1
}
# Make sure the script is not being executed with superuser privileges.
if [[ "${UID}" -eq 0 ]]
then
  echo 'Do not execute this script as root. Use the -s option instead.' >&2
  usage
fi