#!/bin/bash

export COMMAND_SIMULATION=0

export COMMAND_DEFAULT_FORMAT="{bold}{green}> {*}"
function command
{
	local format="${COMMAND_DEFAULT_FORMAT}"
	local simulation=${COMMAND_SIMULATION:-0}
	local OPTIND
	while getopts "sf:" opt;
	do
	case $opt in
		f)
			format="$OPTARG"
			;;
		s)
			simulation=1
			;;
		?)
			echo "ERROR: Unknown option."
			;;
	esac
	done
	shift $((OPTIND-1))

	format=${format//\{\*\}/$*}
	echofmt "$format"
	(( $simulation == 0 )) && $*
	return $?
}
export -f command

export SUBCOMMAND_DEFAULT_FORMAT="{bold}{blue}>> {*}"
function subcommand
{
	local format="${SUBCOMMAND_DEFAULT_FORMAT}"
	local simulation=""
	local OPTIND
	while getopts "sf:" opt;
	do
	case $opt in
		f)
			format="$OPTARG"
			;;
		s)
			simulation="-s"
			;;
		?)
			echo "ERROR: Unknown option."
			;;
	esac
	done
	shift $((OPTIND-1))

    command ${simulation} -f "${format}" -- "$*"
    return $?
}
export -f subcommand
