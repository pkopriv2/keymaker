
require 'lib/bashum/lang/fail.sh'
require 'lib/keymaker/login.sh'

export keymaker_home=${keymaker_ssh_key_home:-"$HOME/.keymaker"}
export keymaker_ssh_key_home=${keymaker_ssh_key_home:-$keymaker_home/.keys}

# ensure the key repo
[[ -d $keymaker_ssh_key_home ]] || mkdir -p $keymaker_ssh_key_home


# usage: ssh_key_get_private_file <name> 
ssh_key_get_private_file() {
    if (( $# != 1 ))
    then
        fail 'usage: ssh_key_get_private_file <name>'
    fi

    echo $keymaker_ssh_key_home/id_rsa.$1
}

# usage: ssh_key_get_public_file <name> 
ssh_key_get_public_file() {
    if (( $# != 1 ))
    then
        fail 'usage: ssh_key_get_public_file <name>'
    fi

    echo $keymaker_ssh_key_home/id_rsa."$1".pub
}

# usage: ssh_key_get_public_key <name> 
ssh_key_get_public_key() {
    if (( $# != 1 ))
    then
        fail 'usage: ssh_key_get_public_key <name>'
    fi

    local file=$(ssh_key_get_public_file $1)
    if [[ ! -f $file ]]
    then
        fail "No public key file for key [$1]"
    fi

    cat $file
}

# usage: ssh_key_create <name> [<passphrase>]
ssh_key_create() {
    if (( $# < 1 )) || (( $# > 2 )) 
    then
        fail 'usage: ssh_key_create <name> [<passphrase>]'
    fi

    local ssh_key_file=$(ssh_key_get_private_file $1)
	if [[ -f $ssh_key_file ]]
	then
        fail "Key [$1] already exists"
	fi

    if ! ssh-keygen -t rsa -f $ssh_key_file -N "$2" 2>&1 >/dev/null
    then
        fail "Error creating key [$ssh_key_file]"
    fi
}

# usage: ssh_key_exchange <login> <name> 
ssh_key_exchange() {
    if (( $# != 2 ))
    then
        fail 'usage: ssh_key_exchange <login> <name>'
    fi

    declare local user
	if ! user=$(login_get_user "$1")
    then
        fail "Unable to get user from login [$1]"
    fi

    declare local key
    if ! key=$(ssh_key_get_public_key $2)
    then
        fail "Unable to get public key [$2]"
    fi

	ssh $1 "bash -s" 2>&1 > /dev/null <<EOH
		user_home=\$(eval "echo ~$user")
		if [[ ! -d \$user_home/.ssh ]]
		then
			mkdir \$user_home/.ssh
		fi

		if [[ ! -f \$user_home/.ssh/authorized_keys ]]
		then
			touch \$user_home/.ssh/authorized_keys
		fi

		if ! grep "$key" \$user_home/.ssh/authorized_keys
		then
			echo $key >> \$user_home/.ssh/authorized_keys
		fi 
EOH
}



# Given a key name determine the keyfile and
# add it to the ssh connection agent. This
# will set the following global attributes:
#
# 	- ssh_key_file
#
# @param 1 - The name of the key
#
_source_key() {
	ssh_key_file=$rr_ssh_key_home/id_rsa.$1

	if [[ ! -f $ssh_key_file ]] 
	then 
		fail "That key file [$ssh_key_file] doesn't exist!"
	fi
	
	if ! ssh-add $ssh_key_file &> /dev/null
	then
		fail "Unable to source the key file [$ssh_key_file]"
	fi 
}


# Get the value of a public key
#
# @param name The name of the key [default="default"]
ssh_key_show() {
	local ssh_key_name=${1:-"default"}
	local ssh_key_file=$rr_ssh_key_home/id_rsa.$ssh_key_name.pub
	if [[ ! -f $ssh_key_file ]]
	then
		error "Unable to locate public key [$ssh_key_file]"
		exit 1
	fi

	cat $ssh_key_file
}



# Get the value of a public key
#
# @param name The name of the key [default="default"]
ssh_key_delete() {
	local ssh_key_name=${1:-"default"}

	info "Deleting key [$ssh_key_name]"
	printf "%s" "Are you sure (y|n):"
	read answer

	if [[ "$answer" != "y" ]]
	then
		echo "Aborted."
		exit 0
	fi

	local ssh_key_file=$rr_ssh_key_home/id_rsa.$ssh_key_name
	if [[ ! -f $ssh_key_file ]]
	then
		error "Unable to locate public key [$ssh_key_file]"
		exit 1
	fi

	rm -f $ssh_key_file*
}

# Get a list of all the available keys
# 
#
ssh_key_list() {
	info "SSH Keys:"

	local list=($(builtin cd "$rr_ssh_key_home" ; find . -maxdepth 1 -mindepth 1 -name 'id_rsa.*.pub' -print | sed 's|\.\/id_rsa\.\([^\.]*\)\.pub|\1|' | sort ))
	for file in "${list[@]}"
	do
		echo "   - $file"
	done
}

