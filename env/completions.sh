export bashum_repo=${bashum_repo:-$HOME/.bashum_repo}
export keymaker_home=${keymaker_home:-"$HOME/.keymaker"}
export keymaker_host_home=${keymaker_host_home:-"$keymaker_home/hosts"}

_km_hosts_list() {
	for file in $keymaker_host_home/*
	do
        if [[ -f $file ]]
        then
            echo "$(basename $file)"
        fi
	done
}

_km_next_complete() {
    for file in $bashum_repo/packages/keymaker/commands/$1/*
    do
        if [[ -f $file ]]
        then
            echo $(basename ${file%%.sh})
            continue
        fi

        if [[ -d $file ]]
        then
            echo $(basename $file)
            continue
        fi
    done
}


_km_complete() {
	local cur=${COMP_WORDS[COMP_CWORD]}
	local cmd=""
	local index=1

	while (( index < COMP_CWORD )) 
	do
		cmd+="/${COMP_WORDS[index]}"
		(( index++ ))
	done

	case "$cmd" in
		/login|/run)
            local hosts=( $(_km_hosts_list) )
			COMPREPLY=( $( compgen -W '${hosts[@]}' -- $cur ) )
			;;
		/host/bootstrap)
            if [ ${#COMPREPLY[@]} -eq 0 ] && [[ "$1" == *@* ]]; then
                h=${1%%@*}
                t=${1#*@}
                COMPREPLY=( $( compgen -A hostname -P "${h}@" $t ) )
            fi
			;;
        *) 
            local files=( $(_km_next_complete $cmd) )
            COMPREPLY=( $( compgen -W '${files[@]}' -- $cur ) )
            ;;
	esac
	return 0
}

_kmr_complete() {
	local cur=${COMP_WORDS[COMP_CWORD]}
	local cmd=""
	local index=1

	while (( index < COMP_CWORD )) 
	do
		cmd+=":${COMP_WORDS[index]}"
		(( index++ ))
	done

	COMPREPLY=()   

	case "$cmd" in
        "") 
            local hosts=( $(_km_hosts_list) )
			COMPREPLY=( $( compgen -W '${hosts[@]}' -- $cur ) )
            ;;
	esac
	return 0
}

complete -F _km_complete keymaker
complete -F _kmr_complete kmr 
complete -F _kmr_complete kml
