require 'lib/bashum/lang/fail.sh'

require 'lib/commander/cli/console.sh'

require 'lib/keymaker/host.sh'

host_list_usage() {
    echo "km host list"
}

host_list_description() {
    printf "
        Lists the bootstrapped hosts.
    "
}

host_list() {
    if (( $# != 0 )) 
    then
        error "Wrong number of arguments"
        exit 1
    fi

    info "Hosts:"
    echo

    local hosts=( $(host_get_all) )

    declare local host
    for host in ${hosts[@]}
    do
        echo "    - $host"
    done
}
