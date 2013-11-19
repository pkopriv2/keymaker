require 'lib/bashum/lang/fail.sh'

require 'lib/commander/cli/console.sh'

require 'lib/keymaker/host.sh'
require 'lib/keymaker/host_file.sh'
require 'lib/keymaker/login.sh'
require 'lib/keymaker/ssh.sh'

login_usage() {
    echo "keymaker login <host>"
}

login_description() {
    printf "
        Start an ssh session with the given host
    "
}

login() {
    if (( $# != 1 ))
    then
        error "Must provide a host"
        exit 1
    fi

    local login=$(login_normalize $1)

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

    ssh_login $login $key
}
