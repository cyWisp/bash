#!/usr/bin/env bash


test_content="$(cat <<EOF
this is test content to be written to
a file. I am not sure if it is going
to work, but we will see
EOF
)"


printf '%s' "${test_content}" > test_file.txt

