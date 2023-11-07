#!/bin/bash

function cmakegen_uninstall_script()
{
    (( $# == 0 )) && echofmt "{red}ERROR: Right call: cmakegen_uninstall_script path_to_install_manifest" && return 1

    local install_manifest_path="$1"
    [[ ! -f $install_manifest_path ]] && echofmt "{red}ERROR: Bad path to install_manifest.txt: $install_manifest_path" && return 1

    local installed_file=`grep -n ".*\.cmake" install_manifest.txt | tail -1 | cut -d':' -f2`
    local output_dir=`parentdir $installed_file`
    [[ ! -d $output_dir ]] && echofmt "{red}ERROR: Bad path to pagkage install dir: $output_dir" && return 1

    local output_file="$output_dir/uninstall.cmake"

    env_is_ubuntu && command sudo touch $output_file && command sudo chmod 666 $output_file
    echo "set(files_to_remove " > $output_file
    cat $install_manifest_path >> $output_file
    cat >> $output_file <<EOL

$output_dir/uninstall.cmake
)

message(STATUS "Uninstall...")
foreach(file \${files_to_remove})
    while(NOT \${file} STREQUAL /usr/local)
        if(EXISTS \${file} OR IS_SYMLINK \${file})
            if(IS_DIRECTORY \${file})
                file(GLOB dir_files \${file}/*)
                list(LENGTH dir_files number_of_files)
                if(\${number_of_files} EQUAL 0)
                    message(STATUS "Removing  dir: \${file}")
                    file(REMOVE_RECURSE \${file})
                endif()
            else()
                message(STATUS "Removing file: \${file}")
                file(REMOVE \${file})
            endif()
        endif()
        get_filename_component(file \${file} DIRECTORY)
    endwhile()
endforeach()
EOL
   env_is_ubuntu && command sudo chmod 644 $output_file
}
export -f cmakegen_uninstall_script
