
# usage: host_file_api
host_file_api() {
    key() {
        :
    }
}

# usage: host_file_api_unset
host_file_api_unset() {
    unset -f key
}

# usage: host_file_get_key <file>
host_file_get_key() {
    if (( $# != 1 ))
    then
        fail 'usage: host_file_get_key <file>'
    fi

    if [[  ! -f "$1" ]]
    then
        fail "Input [$1] is not a file."
    fi

    host_file_api

    declare local key  
    key() {
        if (( $# != 1 ))
        then
            fail "Usage: key <name>"
        fi

        key=$1
    }

    source $1
    host_file_api_unset

    if [[ -z $key ]]
    then
        fail "Host file is missing a key [$1]"
    fi

    echo $key

}

# usage: host_file_create <file> <key_name>
host_file_create() {
    if (( $# != 2 ))
    then
        fail 'usage: host_file_create <file> <key_name>'
    fi

    echo "key \"$2\"" >> $1
}
