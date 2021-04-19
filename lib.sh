#!/bin/bash -eu
#
# Helper functions
#

# Set globals
PATH=../bottle-pi:${PATH}

function usage()
{
	local cmd=${1}
	local args

	args=
	cat <<EOF
Usage: $(basename "${0}") [-l {0,1,2,3,4}] [-q] \
$(target-pi-cli foo bar "${cmd}" -h | head -1 | sed "s,.* ${cmd} ,,")

$(target-pi-cli foo bar ${cmd} -h | tail -n +3)
  -l {0,1,2,3,4}, --log-level {0,1,2,3,4}
                        Set the logging level (0: critical, 1: error, \
2: warning, 3: info, 4: debug), default: 3
  -q, --quiet           Only show criticals and errors (equivalent to \
--log-level=1)
EOF
}

function run_parallel()
{
	local cmd=${1}
	shift

	if [ "${HELP}" -eq 1 ] ; then
		usage "${cmd}"
		exit
	fi

	if [ -t 0 ] ; then
		echo "Unable to read hostname(s) from standard input" >&2
		exit 2
	fi

	# Read the hosts from stdin
	HOSTS=()
	while read -r host ; do
		HOSTS+=("${host}")
		echo "${host}"
	done

	# Run the command in parallel on the provided hosts
	printf "%s\n" "${HOSTS[@]}" | \
		./run-parallel target-pi-cli "${ARGS[@]}" ozzy:5000 {} "${cmd}" \
					   "${SUB_ARGS[@]}" "${@}"
}

# Parse the commandline arguments
HELP=0
ARGS=()
SUB_ARGS=()
while [ ${#} -gt 0 ] ; do
	case "${1}" in
		-h|--help)
			HELP=1
			;;

		# target-pi-cli arguments
		-l|--log-level)
			ARGS+=("${1}")
			shift
			ARGS+=("${1}")
			;;
		-q|--quiet)
			ARGS+=("${1}")
			;;

		# target-pi-cli sub-command arguments
		*)
			SUB_ARGS+=("${1}")
			;;
	esac
	shift
done
