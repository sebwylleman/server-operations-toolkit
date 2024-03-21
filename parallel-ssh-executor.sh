#!/bin/bash

# This script executes a single command on a list of servers. 
# It provides options for specifying a server list file, dry run mode, using sudo, and verbosity.

# Server list file location (default: /vagrant/servers)
SERVER_FILE='/vagrant/servers'

# Options for the ssh command (e.g., connection timeout)
SSH_FLAGS='-o ConnectTimeout=2'

# Function to display usage information and exit
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
if [[ "${UID}" -eq 0 ]]; then
  echo 'Do not execute this script as root. Use the -s option instead.' >&2
  usage
fi

# Parse the options.
while getopts f:nsv OPTION; do
  case ${OPTION} in
    f) SERVER_FILE="${OPTARG}" ;;
    n) DRY_RUN='true' ;;
    s) SUDO='sudo' ;;
    v) VERBOSE='true' ;;
    ?) usage ;;
  esac
done

# Remove the options while leaving the remaining arguments.
shift "$(( OPTIND - 1 ))"

# If the user doesn't supply at least one argument, give them help.
if [[ "${#}" -lt 1 ]]; then
  usage
fi

# Anything that remains on the command line is to be treated as a single command.
COMMAND="${@}"

# Make sure the SERVER_FILE file exists.
if [[ ! -e "${SERVER_FILE}" ]]; then
  echo "Cannot open server list file ${SERVER_FILE}." >&2
  exit 1
fi

# Expect the best, prepare for the worst.
EXIT_STATUS='0'

# Loop through the SERVER_LIST
for SERVER in $(cat ${SERVER_FILE}); do
  if [[ "${VERBOSE}" = 'true' ]]; then
    echo "${SERVER}"
  fi

  SSH_COMMAND="ssh ${SSH_FLAGS} ${SERVER} ${SUDO} ${COMMAND}"

  # If it's a dry run, don't execute anything, just echo it.
  if [[ "${DRY_RUN}" = 'true' ]]; then
    echo "DRY RUN: ${SSH_COMMAND}"
  else
    ${SSH_COMMAND}
    SSH_EXIT_STATUS="${?}"

    # Capture any non-zero exit status from the SSH_COMMAND and report to the user.
    if [[ "${SSH_EXIT_STATUS}" -ne 0 ]]; then
      EXIT_STATUS=${SSH_EXIT_STATUS}
      echo "Execution on ${SERVER} failed." >&2
    fi
  fi
done

exit ${EXIT_STATUS}
