#!/bin/bash

files="
core.sh
trace.sh
command.sh
cmake_test_helpers.sh
pass.sh
git.sh
ssh.sh
aliases.sh
"

this_script_dir=$(realpath $( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ))
for file in $files
do
	source ${this_script_dir}/$file
done
