#!/usr/bin/env bash

#this will store the hostname in the variable "SERVER_NAME"
SERVER_NAME=$(hostname)

#variables can be used in output with either $VAR or ${VAR}
echo "You are running this script on ${SERVER_NAME}."
