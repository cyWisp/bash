#!/bin/bash

function usage() { echo "Usage: $0 [-s <portal | payload>]" 1>&2; exit 1; }

test=""

while getopts ":hs:" args; do
  case "${args}" in
    s)
      test=$OPTARG
#      (( s == "portal" || s == "payload" )) || usage

      ;;
    h)
      usage
      ;;
    *)
      ;;
  esac
done

echo $test

#shift $((OPTIND - 1))

#if [ -n "${s}" ]; then
#  if [ ${s} = "portal" ]; then
#    echo "Running seeds for portal"
#    exit 0
#  fi
#
#  if [ ${s} = "payload" ]; then
#    echo "Running seeds for payload"
#    exit 0
#  fi
#
#fi
#
#
#echo "seeds option not specified"
