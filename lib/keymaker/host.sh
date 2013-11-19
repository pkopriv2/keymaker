export keymaker_home=${keymaker_home:-"$HOME/.keymaker"}
export keymaker_host_home=${keymaker_host_home:-"$keymaker_home/hosts"}

# ensure the key repo
[[ -d $keymaker_host_home ]] || mkdir -p $keymaker_host_home

# usage: host_file_get_home <login>
host_file_get_home() {
    if (( $# != 1 ))
    then
        fail 'usage: host_file_get_home <login>'
    fi

    echo $keymaker_host_home/$1
}

# usage: host_get_all
host_get_all() {
    if (( $# != 0 ))
    then
        fail 'usage: host_get_all'
    fi

	for file in $keymaker_host_home/*
	do
        if [[ -f $file ]]
        then
            echo "$(basename $file)"
        fi
	done
}

# usage: host_match <regexp>
host_match() {
    if (( $# != 1 ))
    then
        fail 'usage: host_match <regexp>'
    fi

    _IFS=$IFS; IFS=$'\n'
	local list=( $(host_get_all) )
	for host in "${list[@]}"
	do
		if expr "$host" : ".*$1" &> /dev/null
		then
			echo $host	
		fi
	done
    IFS=$_IFS
}
