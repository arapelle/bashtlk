#!/bin/bash

function cmake_test_build
{
	trace_function_start
	# parse opts:
	local sound=false
	local rm_dirs=false
	local OPTIND
	while getopts "rb" opt;
	do
	case $opt in
		r)
			rm_dirs=true
		;;
		b)
			sound=true
		;;
		?)
			echo "ERROR: Unknown option."
			return
		;;
	esac
	done
	shift $((OPTIND-1))
	#
	local source_dir="${PWD}"
	if [ $# -gt 0 ] && [ -d $1 ]
	then
		source_dir="$1"
	fi
	local pname=${source_dir##*/}
	local build_dir=/tmp/local/build/${pname}
	[ $rm_dirs = true ] && command rm -rf $build_dir
	core_count=`cpu_core_count`
	command cmake -S $source_dir -B $build_dir \
	&& command cmake --build $build_dir -j$core_count \
	&& command ls -1 $build_dir
	local return_val=$?
	[ $sound = true ] && (( (($return_val == 0)) && (bell&) ) || (tocsin&) )
	trace_function_end
	return $return_val
}
export -f cmake_test_build

function cmake_test_full_build
{
	trace_function_start
	# parse opts:
	local sound=false
	local rm_dirs=false
	local OPTIND
	while getopts "rb" opt;
	do
	case $opt in
		r)
			rm_dirs=true
		;;
		b)
			sound=true
		;;
		?)
			echo "ERROR: Unknown option."
			return
		;;
	esac
	done
	shift $((OPTIND-1))
	#
	local source_dir="${PWD}"
	if [ $# -gt 0 ] && [ -d $1 ]
	then
		source_dir="$1"
	fi
	local pname=${source_dir##*/}
	local build_dir=/tmp/local/build/${pname}
	[ $rm_dirs = true ] && command rm -rf $build_dir
	core_count=`cpu_core_count`
	command cmake -DBUILD_${pname}_TESTS=On -DBUILD_${pname}_EXAMPLES=On -D${pname}_BUILD_TESTS=On -D${pname}_BUILD_EXAMPLES=On -S $source_dir -B $build_dir \
	&& command cmake --build $build_dir -j$core_count \
	&& command ls -1 $build_dir \
	&& command ctest --progress --output-on-failure --test-dir $build_dir
	local return_val=$?
	[ $sound = true ] && (( (($return_val == 0)) && (bell&) ) || (tocsin&) )
	trace_function_end
	return $return_val
}
export -f cmake_test_full_build

function cmake_test_install
{
	trace_function_start
	# parse opts:
	local sound=false
	local rm_dirs=false
	local OPTIND
	while getopts "rb" opt;
	do
	case $opt in
		r)
			rm_dirs=true
		;;
		b)
			sound=true
		;;
		?)
			echo "ERROR: Unknown option."
			return
		;;
	esac
	done
	shift $((OPTIND-1))
	#
	local source_dir="${PWD}"
	if [ $# -gt 0 ] && [ -d $1 ]
	then
		source_dir="$1"
	fi
	local pname=${source_dir##*/}
	local build_dir=/tmp/local/build/${pname}
	local install_dir=/tmp/local
	[ $rm_dirs = true ] && command rm -rf $build_dir $install_dir
	core_count=`cpu_core_count`
	command cmake -S $source_dir -B $build_dir \
	&& command cmake --build $build_dir -j$core_count \
	&& command cmake --install $build_dir --prefix $install_dir \
	&& command tree -ifF -I 'build' $install_dir/
	local return_val=$?
	[ $sound = true ] && (( (($return_val == 0)) && (bell&) ) || (tocsin&) )
	trace_function_end
	return $return_val
}
export -f cmake_test_install

function cmake_test_full_install
{
	trace_function_start
	# parse opts:
	local sound=false
	local rm_dirs=false
	local OPTIND
	while getopts "rb" opt;
	do
	case $opt in
		r)
			rm_dirs=true
		;;
		b)
			sound=true
		;;
		?)
			echo "ERROR: Unknown option."
			return
		;;
	esac
	done
	shift $((OPTIND-1))
	#
	local source_dir="${PWD}"
	if [ $# -gt 0 ] && [ -d $1 ]
	then
		source_dir="$1"
	fi
	local pname=${source_dir##*/}
	local build_dir=/tmp/local/build/${pname}
	local install_dir=/tmp/local
	[ $rm_dirs = true ] && command rm -rf $build_dir $install_dir
	core_count=`cpu_core_count`
	export CMAKE_PREFIX_PATH=/tmp/local
	command cmake -DBUILD_${pname}_TESTS=On -DBUILD_${pname}_EXAMPLES=On -D${pname}_BUILD_TESTS=On -D${pname}_BUILD_EXAMPLES=On -S $source_dir -B $build_dir \
	&& command cmake --build $build_dir -j$core_count \
	&& command ctest --progress --output-on-failure --test-dir $build_dir \
	&& command cmake --install $build_dir --prefix $install_dir \
	&& command tree -ifF -I 'build' $install_dir/
	local return_val=$?
	if (( $return_val == 0 ))
	then 
		if [[ -d $source_dir/example/basic_cmake_project ]]
		then
			build_dir=${build_dir}/basic_cmake_project
			command cmake -S $source_dir/example/basic_cmake_project -B $build_dir \
			&& command cmake --build $build_dir -j$core_count
			return_val=$?
		fi
	fi
	[ $sound = true ] && (( (($return_val == 0)) && (bell&) ) || (tocsin&) )
	trace_function_end
	return $return_val
}
export -f cmake_test_full_install
