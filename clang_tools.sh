#!/usr/bin/env bash

function clang-format-project
{
  if [[ ! -f .clang-format ]]
  then
    echo "$PWD/.clang-format does not exist."
    return 1
  fi

  for dir_to_format in include source src test tests test_package example examples
  do
    if [[ -d $dir_to_format ]]
    then
      echo "# $dir_to_format"
      find $dir_to_format -name "*.[hc]pp" | xargs clang-format -i -style=file:.clang-format --verbose
    fi
  done
}
export -f clang-format-project
