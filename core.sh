#!/bin/bash

function env_is_mingw
{
	[[ -n "${MINGW_CHOST}" ]]
}
export -f env_is_mingw

function env_is_msys
{
	[[ "${OSTYPE}" == "msys" ]]
}
export -f env_is_msys

function env_is_ubuntu
{
	[[ "${PLATFORM}" == "ubuntu" ]]
}
export -f env_is_ubuntu

function env_is_windows
{
	[[ $WINDIR =~ windows ]]
}
export -f env_is_windows

function playsound
{
	if env_is_windows
	then
		python -c "
from playsound import playsound
playsound('$1')
"
	else
		aplay -q $1
	fi
}
export -f playsound

export bell_wav_path="$(bash_source_dir)/rsc/sounds/bell.wav"
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

	local sound_path=$bell_wav_path
	if $background
	then
		(playsound $sound_path &)
	else
		playsound $sound_path
	fi
	return 0
}
export -f bell

export tocsin_wav_path="$(bash_source_dir)/rsc/sounds/tocsin.wav"
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

	local sound_path=$tocsin_wav_path
	if $background
	then
		(playsound $sound_path &)
	else
		playsound $sound_path
	fi
	return 0
}
export -f tocsin

function cpu_core_count
{
	local count=0
	if env_is_windows
	then
		# https://stackoverflow.com/questions/2619198/how-to-get-number-of-cores-in-win32
		count=`WMIC CPU Get /Format:List | grep "NumberOfCores" | cut -d'=' -f2`
	else
		count=`lscpu | grep "Core.* per socket" | cut -d':' -f2`
	fi
	count=$((count))
	echo $count
}
export -f cpu_core_count

if env_is_msys
then
	function cclip()
	{
		clip $*
	}
	export -f cclip
elif env_is_ubuntu
then
	function cclip()
	{
		xclip -selection c $*
	}
	export -f cclip
fi
