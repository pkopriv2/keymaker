require 'lib/bashum/lang/fail.sh'
require 'lib/commander/cli/console.sh'
require 'lib/keymaker/ssh_key.sh'

key_create_usage() {
    echo "km key create [<name>]"
}

key_create_description() {
    printf "
        Creates an ssh public/private key pair
    "
}

key_create() {
    if (( $# > 1 ))
    then
        error "Too many arguments"
        exit 1
    fi

    local key_name=${1:-"default"}
	info "Creating public/private key pair [$key_name]"

    read -p "Enter a passphrase (or leave empty): " -s key_pass
	echo

    ssh_key_create $key_name $key_pass
    echo "Successfully created key"
}
