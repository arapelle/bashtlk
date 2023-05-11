#!/bin/bash

files="
bash_source_helpers.sh
core.sh
echofmt.sh
trace.sh
command.sh
path.sh
cmake_test_helpers.sh
pass.sh
git.sh
ssh.sh
bashgen.sh
aliases.sh
"

# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
this_script_dir=$(realpath $( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ))
for file in $files
do
	source ${this_script_dir}/$file
done

# function ftest
# {
# 	trace_function_start
# 	command echo message
# 	trace_function_end
# }
# trace_script_start
# if env_is_mingw
# then
# 	echo "MINGW"
# fi
# if env_is_msys
# then
# 	echo "MSYS"
# fi
# if env_is_windows
# then
# 	echo "WINDOWS"
# fi
# ftest
# trace_script_end
