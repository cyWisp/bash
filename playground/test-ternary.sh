#!/usr/bin/env bash

var_1="not something"


result=$([ "${var_1}" == "something" ] && echo "is something" || echo "is not something")

echo $result

exit 1