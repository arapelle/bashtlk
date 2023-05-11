#!/usr/bin/env bash

function parentdir()
{
  if (($# == 1))
  then
    path=$(realpath "$1")
    path=$(dirname $path)
    echo "${path}"
  else
    echofmt "{red}ERROR: One argument is expected. ($# provided)"
    return 1
  fi
}
export -f parentdir

function filename()
{
  if (($# == 1))
  then
    filename=$(basename -- "$1")
    echo "${filename}"
  else
    echofmt "{red}ERROR: One argument is expected. ($# provided)"
    return 1
  fi
}
export -f filename

function filestem()
{
  if (($# == 1))
  then
    filename=$(basename -- "$1")
    echo "${filename%%.*}"
  else
    echofmt "{red}ERROR: One argument is expected. ($# provided)"
    return 1
  fi
}
export -f filestem

function fileexts()
{
  if (($# == 1))
  then
    if [[ "$1" == *.* ]]
    then
      filename=$(basename -- "$1")
      echo "${filename#*.}"
    else
      echo ""
    fi
  else
    echofmt "{red}ERROR: One argument is expected. ($# provided)"
    return 1
  fi
}
export -f fileexts

function fileext()
{
  if (($# == 1))
  then
    if [[ "$1" == *.* ]]
    then
      filename=$(basename -- "$1")
      echo "${filename##*.}"
    else
      echo ""
    fi
  else
    echofmt "{red}ERROR: One argument is expected. ($# provided)"
    return 1
  fi
}
export -f fileext
