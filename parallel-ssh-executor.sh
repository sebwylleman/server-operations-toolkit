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

# Parse the options.
while getopts f:nsv OPTION
do
  case ${OPTION} in
    f) SERVER_LIST="${OPTARG}" ;;
    n) DRY_RUN='true' ;;
    s) SUDO='sudo' ;;
    v) VERBOSE='true' ;;
    ?) usage ;;
  esac
done

# Remove the options while leaving the remaining arguments.
shift "$(( OPTIND - 1 ))"

# If the user doesn't supply at least one argument, give them help.
if [[ "${#}" -lt 1 ]]
then
  usage
fi

# Anything that remains on the command line is to be treated as a single command.
COMMAND="${@}"

# Make sure the SERVER_LIST file exists.
if [[ ! -e "${SERVER_LIST}" ]]
then
  echo "Cannot open server list file ${SERVER_LIST}." >&2
  exit 1
fi