#!/bin/bash

function commandf
{
	local format=$1
	shift
	format=${format//\{\*\}/$*}
	echofmt $format
	$*
	return $?
}
export -f commandf

export COMMAND_DEFAULT_FORMAT="{bold}{green}> {*}"
function command
{
    commandf "${COMMAND_DEFAULT_FORMAT}" "$*"
    return $?
}
export -f command

export SUBCOMMAND_DEFAULT_FORMAT="{bold}{blue}>> {*}"
function subcommand
{
    commandf "${SUBCOMMAND_DEFAULT_FORMAT}" "$*"
    return $?
}
export -f subcommand
