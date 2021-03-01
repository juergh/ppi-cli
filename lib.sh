#!/bin/bash -eu
#
# Helper functions
#

function do_run_parallel()
{
	printf "%s\n" "${HOSTS[@]}" | ./run-parallel "${@}"
}

function usage()
{
	cat <<EOF
Usage: $(basename "${0}") [-h] [-l LEVEL] [-q] [-t SECS]
EOF
}

# Set globals
# shellcheck disable=SC2034
RPI_MASTER=rpi-master:5000
PATH=../bottle-pi:${PATH}

# Parse the commandline arguments
ARGS=()
SUB_ARGS=()
while [ ${#} -gt 0 ] ; do
	case "${1}" in
		-h|--help)
			usage
			exit
			;;
		-l|--log-level)
			ARGS+=("${1}")
			shift
			ARGS+=("${1}")
			;;
		-q|--quiet)
			ARGS+=("${1}")
			;;
		-t|--timeout)
			SUB_ARGS+=("${1}")
			shift
			SUB_ARGS+=("${1}")
			;;
		*)
			break
			;;
	esac
	shift
done

# Read the hostnames from stdin
HOSTS=()
while read -r host ; do
	HOSTS+=("${host}")
done
