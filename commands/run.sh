require 'lib/bashum/lang/fail.sh'

require 'lib/commander/cli/console.sh'

require 'lib/keymaker/host.sh'
require 'lib/keymaker/host_file.sh'
require 'lib/keymaker/login.sh'
require 'lib/keymaker/ssh.sh'

run_usage() {
    echo "km run <host regexp> <cmd>"
}

run_description() {
    printf "
        Run the given command on the hosts matched by the host regexp
    "
}

run() {
    if (( $# != 2 ))
    then
        error "Wrong number of arguments"
        exit 1
    fi

    local regexp=$1
    
    local logins=( $(host_match $1) )
    if (( ${#logins[@]} == 0 ))
    then
        error "No hosts matched regexp"
        exit 1
    fi

    declare local login
    for login in "${logins[@]}"
    do
        local login=$(login_normalize $login)
        local host_file=$(host_file_get_home $login)
        if [[ ! -f $host_file ]]
        then
            error "Host must be bootstrapped [$login]"
            exit 1
        fi

        declare local key
        if ! key=$(host_file_get_key $host_file)
        then
            error "Error getting key from host file [$host_file]"
            exit 1
        fi

        ssh_run $login $key "$2"
    done
}
