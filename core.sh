#!/bin/bash

function script_dir
{
	# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
	echo $(realpath $( cd -- "$( dirname -- "${BASH_SOURCE[1]}" )" &> /dev/null && pwd ))
}
export -f script_dir

function bell
{
	local background=false

	local OPTIND
	while getopts "b" opt;
	do
		case $opt in
			b) background=true;;
		  	?) echo "ERROR: Unknown option.";;
		esac
	done
	shift $((OPTIND-1))

	# /udata/Documents/ubuntu_install/finished.wav
	local sound_path=/udata/.env/sounds/bell.wav
	# if $background
	# then
	# 	(aplay -q $sound_path &)
	# else
	# 	aplay -q $sound_path
	# fi
	return 0
}
export -f bell

function tocsin
{
	local background=false

	local OPTIND
	while getopts "b" opt;
	do
		case $opt in
			b) background=true;;
		  	?) echo "ERROR: Unknown option.";;
		esac
	done
	shift $((OPTIND-1))

	local sound_path=/udata/.env/sounds/tocsin.wav
	# if $background
	# then
	# 	(aplay -q $sound_path &)
	# else
	# 	aplay -q $sound_path
	# fi
	return 0
}
export -f tocsin

function echofmt
{
	local format_str=$1
	shift
	echo -e "\e[${format_str}m$*\e[0m"
}

function cpu_core_count
{
	count=`lscpu | grep "Core.* per socket" | cut -d':' -f2`
	count=$((count))
	echo $count
}
export -f cpu_core_count
