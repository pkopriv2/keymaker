
require 'lib/bashum/lang/fail.sh'
require 'lib/keymaker/ssh_key.sh'

export keymaker_home=${keymaker_host_home:-"$HOME/.keymaker"}
export keymaker_host_home=${keymaker_host_home:-$keymaker_home/.hosts}

# usage: host_bootstrap <login> <key>
host_bootstrap() {
    if (( $# != 2 ))
    then
        fail 'usage: host_bootstrap <login> <key>'
    fi

    local login=$(login_normalize $1)

	if ! ssh_key_exchange $login $2
	then
        fail "Error exchanging ssh key [$2] with host [$login]"
	fi

	if ! _file_bootstrap "$login" "$key_name" 
	then
		error "Unable to bootstrap local host file."
		exit 1
	fi
}

host_file_home() {

