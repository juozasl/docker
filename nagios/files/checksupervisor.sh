#!/bin/bash

function check_supervisor() {

    check_command=$(supervisorctl status | egrep '(STOPPED)|(STARTING)|(BACKOFF)|(STOPPING)|(EXITED)|(FATAL)|(UNKNOWN)' | wc -l)

    if (( $check_command != 0 )); then
	echo "CRITICAL - One or more of your programs are not running!"
	exit
    else
	echo "OK - All of your programs are running!"
	exit
    fi
}

# --------------------------------------------------------------------
# startup checks
# --------------------------------------------------------------------

if [ $# -eq 0 ]; then
    check_supervisor
fi
