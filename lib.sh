#!/bin/bash -eu
#
# Helper functions
#

# Set globals
HERE=$(dirname "$(readlink -f "${0}")")
PATH=${HERE}:${HERE}/../bottle-pi:${PATH}
LOG_DIR=${HOME}/.cache/ppi-cli

function run_parallel()
{
	local args

	args=()
	while [ ${#} -gt 0 ] ; do
		case "${1}" in
			--)
				shift
				break
				;;
			-*)
				args+=("${1}")
				;;
			*)
				echo "Invalid argument: ${1}" >&2
				exit 1
				;;
		esac
		shift
	done

	# Run the command in parallel on the provided hosts
	printf "%s\n" "${HOSTS[@]}" | \
		run-parallel "${args[@]}" -- pi-cli 192.168.99.11:5000 {} "${@}"
}

# -----------------------------------------------------------------------------
# Main entry point

if [ -t 0 ] ; then
	echo "Unable to read hostname(s) from standard input" >&2
	exit 2
fi

# Initialize the log directory
mkdir -p "${LOG_DIR}"

# Read the hosts from stdin
HOSTS=()
while read -r host ; do
	HOSTS+=("${host}")
done
