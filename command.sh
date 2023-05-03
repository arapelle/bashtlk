#!/bin/bash

function commandf
{
	local format=$1
	shift
	echofmt "${format}${COMMANDF_PREFIX}$*${COMMANDF_SUFFIX}"
	$*
	return $?
}
export COMMANDF_PREFIX="> "
export COMMANDF_SUFFIX=""
export COMMANDF_DEFAULT="{bold}{green}"
export -f commandf

function command
{
    commandf ${COMMANDF_DEFAULT} "$*"
    return $?
}
export -f command
