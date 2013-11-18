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

_km_complete() {
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
            COMPREPLY=( $( compgen -W 'run login host key' -- $cur ) )
            ;;
		:login|:run)
            local hosts=( $(_km_hosts_list) )
			COMPREPLY=( $( compgen -W '${hosts[@]}' -- $cur ) )
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

complete -F _km_complete km 
complete -F _kmr_complete kmr 
complete -F _kmr_complete kml
