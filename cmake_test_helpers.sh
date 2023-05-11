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
	local return_val=$?
	trace_function_end
	return $return_val
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
	&& command cmake -DBUILD_${pname}_TESTS=On -DBUILD_${pname}_EXAMPLES=On -D${pname}_BUILD_TESTS=On -D${pname}_BUILD_EXAMPLES=On -S $source_dir -B $build_dir \
	&& command cmake --build $build_dir -j$core_count \
	&& command ls -1 $build_dir \
	&& command ctest --progress --test-dir $build_dir
	local return_val=$?
	trace_function_end
	return $return_val
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
	local return_val=$?
	trace_function_end
	return $return_val
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
	export CMAKE_PREFIX_PATH=/tmp/local
	command cmake -DBUILD_${pname}_TESTS=On -DBUILD_${pname}_EXAMPLES=On -D${pname}_BUILD_TESTS=On -D${pname}_BUILD_EXAMPLES=On -S $source_dir -B $build_dir \
	&& command cmake --build $build_dir -j$core_count \
	&& command ctest --progress --test-dir $build_dir \
	&& echo "* Installing in $install_dir" \
	&& command cmake --install $build_dir --prefix $install_dir \
	&& command tree -ifF -I 'build' $install_dir/
	local return_val=$?
	if (( $return_val != 0 ))
	then 
		return $return_val
	fi
	if [[ -d $source_dir/example/basic_cmake_project ]]
	then
		echo "* Building $pname basic_cmake_project"
		build_dir=${build_dir}/basic_cmake_project
		command cmake -S $source_dir/example/basic_cmake_project -B $build_dir \
		&& command cmake --build $build_dir -j$core_count
		return_val=$?
	fi
	trace_function_end
	return $return_val
}
export -f cmake_test_full_install
