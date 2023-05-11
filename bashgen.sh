#!/usr/bin/env bash

function bashgen_script()
{
  script_path="$1"
  script_dir=$(parentdir $script_path)
  mkdir -p script_dir
  ext=$(fileext $script_path)
  if [ "$ext" != "sh" ]
  then
    script_path="$script_path.sh"
  fi
  touch $script_path
  chmod u+x $script_path
  echo -e "#!/usr/bin/env bash\n" > $script_path
}

function bashgen_getopts
{
	echo \
	"  local OPTIND
  while getopts \"a:f\" opt;
  do
  case \$opt in
    a)
      echo \"OK: arg option enabled.\"
      local value=\$OPTARG
      if [[ \$value =~ ^-?[0-9]+\$ # value is integer
            && \$value -gt 0 ]]
      then
        echo \"OK: arg is a positive integer\"
      else
        echo \"ERROR: arg must be a positive integer.\"
      fi
      ;;
    f)
      echo \"OK: flag option enabled.\"
    ;;
    ?)
      echo \"ERROR: Unknown option.\"
    ;;
  esac
  done
  shift \$((OPTIND-1))"
}
