#!/usr/bin/env bash


function log () {
    echo "${BASHPID} $(date '+%d-%m-%Y %H:%M:%S'): $1"
}


function test () {
    log "Value of argument: ${1}"
    function_args=("$2")

    if [ $1 -lt 1 ]; then
        log "Please provide at least one argument."
    else
        printf "Arguments: "

        for arg in "${function_args[@]}"; do
            printf "%s " $arg
        echo ""
        done
    fi

}

args_arr=$@

echo $#
test $# "${args_arr[@]}"
#
#for i in "$@"; do
#    echo $i
#done