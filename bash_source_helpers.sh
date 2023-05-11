#!/bin/bash

function bash_source_path()
{
	local file=$(caller | cut -d' ' -f2)
	readlink -e "$file"
}
export -f bash_source_path

function bash_source_dir()
{
	local file=$(caller | cut -d' ' -f2)
	dirname $(readlink -e "$file")
}
export -f bash_source_dir
