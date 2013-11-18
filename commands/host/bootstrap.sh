require 'lib/bashum/lang/fail.sh'

require 'lib/commander/cli/console.sh'

require 'lib/keymaker/host.sh'
require 'lib/keymaker/host_file.sh'
require 'lib/keymaker/login.sh'
require 'lib/keymaker/ssh.sh'

host_bootstrap_usage() {
    echo "km host bootstrap <login> [<key>]"
}

host_bootstrap_description() {
    printf "
        Performs a public ssh key exchange with the given host.
    "
}

host_bootstrap() {
    if (( $# < 1 )) || (( $# > 2 ))
    then
        error "Wrong number of arguments"
        exit 1
    fi

    local login=$(login_normalize $1)
    local key=${2:-"default"}

	info "Exchanging key [$key] with host [$login]"

    local login=$(login_normalize $1)
	if ! ssh_key_exchange $login $key
	then
        error "Error exchanging ssh key [$key] with host [$login]"
        exit 1
	fi

    local host_file=$(host_file_get_home $login)
    if ! host_file_create $host_file $key
	then
        error "Error creating host fiele [$host_file]"
        exit 1
	fi

    echo "Successfully exchanged key"
}
