#!/bin/bash

# https://misc.flogisoft.com/bash/tip_colors_and_formatting
# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux

#----------------
# ECHOFMT_COLORS:
#----------------
# declare -A ECHOFMT_COLORS
export ECHOFMT_COLORS_black="$(tput setaf 0)"
export ECHOFMT_COLORS_red="$(tput setaf 1)"
export ECHOFMT_COLORS_green="$(tput setaf 2)"
export ECHOFMT_COLORS_yellow="$(tput setaf 3)"
export ECHOFMT_COLORS_blue="$(tput setaf 4)"
export ECHOFMT_COLORS_magenta="$(tput setaf 5)"
export ECHOFMT_COLORS_cyan="$(tput setaf 6)"
export ECHOFMT_COLORS_grey="$(tput setaf 7)"
#----------------
export ECHOFMT_COLORS_BLACK="$(tput setab 0)"
export ECHOFMT_COLORS_RED="$(tput setab 1)"
export ECHOFMT_COLORS_GREEN="$(tput setab 2)"
export ECHOFMT_COLORS_YELLOW="$(tput setab 3)"
export ECHOFMT_COLORS_BLUE="$(tput setab 4)"
export ECHOFMT_COLORS_MAGENTA="$(tput setab 5)"
export ECHOFMT_COLORS_CYAN="$(tput setab 6)"
export ECHOFMT_COLORS_GREY="$(tput setab 7)"
#----------------
export ECHOFMT_COLORS_bold="$(tput bold)"
export ECHOFMT_COLORS_underline="$(tput sgr 0 1)"
export ECHOFMT_COLORS_reset="$(tput sgr0)"
# export ECHOFMT_COLORS
#----------------

function echofmt_str
{
	local pattern="${*}{reset}"

	while [[ $pattern =~ (^|[^\\])\{([a-zA-Z0-9_]+)\} ]]
	do
		local chp=${BASH_REMATCH[1]}
		local color_id=${BASH_REMATCH[2]}
		local color_var_name=ECHOFMT_COLORS_${color_id}
		local color=${!color_var_name}
		pattern=${pattern//${chp}\{${color_id}\}/${chp}${color}}
	done
	pattern=${pattern//\\\{/\{}
	pattern=${pattern//\\\}/\}}
	echo "$pattern"
}

function echofmt
{
	local pattern=$(echofmt_str "$*")
	echo -e "$pattern"
}

export -f echofmt_str
export -f echofmt

# echofmt "{red}Force Rouge"
# echofmt "{green}Force Verte"
# echofmt "{blue}Force Bleue"
# echofmt "{underline}{grey}{BLACK}Force Grise {bold}Trop la classe"
# echofmt "{underline}{grey}{BLACK}Force Grise {bold\\}Trop la classe"
