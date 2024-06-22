
function pyinstall
{
	local pyinstaller_path="$HOME/projects/dev/python/venv/bin/pyinstaller"

	local name_value=""
	local spec_path_value=""
	local optimize_value="2"
	local install_flag=0
	local clean_opt=""

	local OPTIND
	while getopts "p:n:s:o:ic" opt;
	do
		case $opt in
			p)
				pyinstaller_path="$OPTARG"
				;;
			n)
				name_value="$OPTARG"
				;;
			s)
				spec_path_value="$OPTARG"
				;;
			o)
				optimize_value="$OPTARG"
				;;
			i)
				install_flag=1
				;;
			c)
				clean_opt="--clean"
				;;
			?)
				echo "ERROR: Unknown option."
				;;
		esac
	done
	shift $((OPTIND-1))

	(( $# == 0 )) && echofmt "{red}ERROR: usage:
pyinstall [-i][-c] 
    [-n exe_name]
    [-s spec_path]
    [-o optimize_value]
    /path/to/script.py" \
	&& return 1

	if [[ -z "$name_value" ]]
	then
		name_value="$(filestem $1)"
	fi
	local root_path="/tmp/pyinstall"
	local project_path="$root_path/$name_value"
	local work_path="$project_path/build"
	local dist_path="$project_path/bin"
	if [[ -z "$spec_path_value" ]]
	then
		spec_path_value="$project_path"
	fi

	command $pyinstaller_path -F $clean_opt \
		--optimize $optimize_value \
		--workpath $work_path \
		--specpath $spec_path_value \
	    --distpath $dist_path \
		-n $name_value \
		$1
	
	local install_path="$HOME/.env/bin"
	if (($install_flag == 1)) && [[ -d "$install_path" ]]
	then
		local exe_name="$name_value"
		command cp "$dist_path/$exe_name" "$install_path"
		command ls -l "$install_path/$exe_name"
		command which "$install_path/$exe_name"
	fi
}
export -f pyinstall
