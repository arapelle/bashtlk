#!/bin/bash

function commandf
{
	local format=$1
	shift
	case "$format" in
		fatal) format="1;39;41";;
		error|red) format="1;31";;
		valid|ok|green) format="1;32";;
		warning|yellow) format="1;33";;
		blue) format="1;34";;
		default) format=${COMMANDF_DEFAULT};;
	esac
  echo -e "\e[${format}m${COMMANDF_PREFIX}$*${COMMANDF_SUFFIX}\e[0m"
  $*
  return $?
}
export COMMANDF_PREFIX="> "
export COMMANDF_SUFFIX=""
export COMMANDF_DEFAULT="1;32"
export -f commandf

function command
{
  commandf default "$*"
  return $?
}
export -f command
