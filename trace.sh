#!/bin/bash

function trace_script_start
{
	file=$(caller | cut -d' ' -f2)
	file=$(readlink -e "$file")
	echofmt "$TRACE_SCRIPT_FORMAT" "[${file}: START (`date`)]"
}
export TRACE_SCRIPT_FORMAT="{bold}"
export -f trace_script_start

function trace_script_end
{
	local OPTIND
	while getopts "bt" opt;
	do
		case $opt in
			b) bell -b;;
		  t) tocsin -b;;
		  ?) echo "ERROR: Unknown option.";;
		esac
	done
	shift $((OPTIND-1))

	file=$(caller | cut -d' ' -f2)
	file=$(readlink -e "$file")
	echofmt "$TRACE_SCRIPT_FORMAT" "[${file}: END (`date`)]"
}
export -f trace_script_end

function trace_function_start
{
	echofmt "$TRACE_FUNCTION_FORMAT" "# ${FUNCNAME[1]}: START (`date`)"
}
export TRACE_FUNCTION_FORMAT="{bold}"
export -f trace_function_start

function trace_function_end
{
	local OPTIND
	while getopts "bt" opt;
	do
		case $opt in
			b) bell -b;;
		  t) tocsin -b;;
		  ?) echo "ERROR: Unknown option.";;
		esac
	done
	shift $((OPTIND-1))

	echofmt "$TRACE_FUNCTION_FORMAT" "# ${FUNCNAME[1]}: END (`date`)"
}
export -f trace_function_end
