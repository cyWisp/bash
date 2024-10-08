#!/bin/bash

usage() { echo "Usage: $0 [-s <45|90>] [-p <string>]" 1>&2; exit 1; }

while getopts ":s:p:" o; do
    case "${o}" in
        s)
            s=${OPTARG}
            ((s == 45 || s == 90)) || usage
            ;;
        p)
            p=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${s}" ] || [ -z "${p}" ]; then
    usage
fi

echo "s = ${s}"
echo "p = ${p}"


# Example:

#$ ./myscript.sh
#Usage: ./myscript.sh [-s <45|90>] [-p <string>]
#
#$ ./myscript.sh -h
#Usage: ./myscript.sh [-s <45|90>] [-p <string>]
#
#$ ./myscript.sh -s "" -p ""
#Usage: ./myscript.sh [-s <45|90>] [-p <string>]
#
#$ ./myscript.sh -s 10 -p foo
#Usage: ./myscript.sh [-s <45|90>] [-p <string>]
#
#$ ./myscript.sh -s 45 -p foo
#s = 45
#p = foo
#
#$ ./myscript.sh -s 90 -p bar
#s = 90
#p = bar