#!/bin/bash

function cmake_test_build
{
	trace_function_start
	local source_dir="${PWD}"
	if [ $# -gt 0 ] && [ -d $1 ]
	then
		source_dir="$1"
	fi
	local pname=${source_dir##*/}
	local build_dir=/tmp/local/build/${pname}
	core_count=`cpu_core_count`
	echo "* Building in $build_dir" \
	&& command cmake -S $source_dir -B $build_dir \
	&& command cmake --build $build_dir -j$core_count \
	&& command ls -1 $build_dir
	trace_function_end
}
export -f cmake_test_build

function cmake_test_full_build
{
	trace_function_start
	local source_dir="${PWD}"
	if [ $# -gt 0 ] && [ -d $1 ]
	then
		source_dir="$1"
	fi
	local pname=${source_dir##*/}
	local build_dir=/tmp/local/build/${pname}
	core_count=`cpu_core_count`
	echo "* Building in $build_dir" \
	&& command cmake -D${pname}_BUILD_TESTS=On -D${pname}_BUILD_EXAMPLES=On -S $source_dir -B $build_dir \
	&& command cmake --build $build_dir -j$core_count \
	&& command ls -1 $build_dir
	trace_function_end
}
export -f cmake_test_full_build

function cmake_test_install
{
	trace_function_start
	local source_dir="${PWD}"
	if [ $# -gt 0 ] && [ -d $1 ]
	then
		source_dir="$1"
	fi
	local pname=${source_dir##*/}
	local build_dir=/tmp/local/build/${pname}
	local install_dir=/tmp/local
	core_count=`cpu_core_count`
	echo "* Building in $build_dir" \
	&& command cmake -S $source_dir -B $build_dir \
	&& command cmake --build $build_dir -j$core_count \
	&& echo "* Installing in $install_dir" \
	&& command cmake --install $build_dir --prefix $install_dir \
	&& command tree -ifF -I 'build' $install_dir/
	trace_function_end
}
export -f cmake_test_install

function cmake_test_full_install
{
	trace_function_start
	local source_dir="${PWD}"
	if [ $# -gt 0 ] && [ -d $1 ]
	then
		source_dir="$1"
	fi
	local pname=${source_dir##*/}
	local build_dir=/tmp/local/build/${pname}
	local install_dir=/tmp/local
	core_count=`cpu_core_count`
	echo "* Building in $build_dir" \
	&& command cmake -DBUILD_${pname}_TESTS=On -DBUILD_${pname}_EXAMPLES=On -D${pname}_BUILD_TESTS=On -D${pname}_BUILD_EXAMPLES=On -S $source_dir -B $build_dir \
	&& command cmake --build $build_dir -j$core_count \
	&& echo "* Installing in $install_dir" \
	&& command cmake --install $build_dir --prefix $install_dir \
	&& command tree -ifF -I 'build' $install_dir/
	if (( $? == 0 )) && [[ -d $source_dir/example/basic_cmake_project ]]
	then
		echo "* Building $pname basic_cmake_project"
		build_dir=${build_dir}/basic_cmake_project
		command cmake -S $source_dir/example/basic_cmake_project -B $build_dir \
		&& command cmake --build $build_dir -j$core_count
	fi
	trace_function_end
}
export -f cmake_test_full_install
