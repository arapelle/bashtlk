#!/bin/bash

# https://misc.flogisoft.com/bash/tip_colors_and_formatting
# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux

#----------------
# ECHOFMT_COLORS:
#----------------
declare -A ECHOFMT_COLORS
ECHOFMT_COLORS[black]="$(tput setaf 0)"
ECHOFMT_COLORS[red]="$(tput setaf 1)"
ECHOFMT_COLORS[green]="$(tput setaf 2)"
ECHOFMT_COLORS[yellow]="$(tput setaf 3)"
ECHOFMT_COLORS[blue]="$(tput setaf 4)"
ECHOFMT_COLORS[magenta]="$(tput setaf 5)"
ECHOFMT_COLORS[cyan]="$(tput setaf 6)"
ECHOFMT_COLORS[grey]="$(tput setaf 7)"
#----------------
ECHOFMT_COLORS[BLACK]="$(tput setab 0)"
ECHOFMT_COLORS[RED]="$(tput setab 1)"
ECHOFMT_COLORS[GREEN]="$(tput setab 2)"
ECHOFMT_COLORS[YELLOW]="$(tput setab 3)"
ECHOFMT_COLORS[BLUE]="$(tput setab 4)"
ECHOFMT_COLORS[MAGENTA]="$(tput setab 5)"
ECHOFMT_COLORS[CYAN]="$(tput setab 6)"
ECHOFMT_COLORS[GREY]="$(tput setab 7)"
#----------------
ECHOFMT_COLORS[bold]="$(tput bold)"
ECHOFMT_COLORS[underline]="$(tput sgr 0 1)"
ECHOFMT_COLORS[reset]="$(tput sgr0)"
export ECHOFMT_COLORS
#----------------

function echofmt_str
{
	local pattern="${*}{reset}"

	while [[ $pattern =~ (^|[^\\])\{([a-zA-Z0-9_]+)\} ]]
	do
		local chp=${BASH_REMATCH[1]}
		local color_id=${BASH_REMATCH[2]}
		local color=${ECHOFMT_COLORS[${color_id}]}
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
