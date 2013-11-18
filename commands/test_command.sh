test_command_usage() {
    echo "test_command [option]*"
}

test_command_description() {
    printf "
        test command
    "
}

test_command_options() {
	echo "option1   An option"
	echo "option2   Another option"
}

test_command() {
	echo "success"
	return 0
}
