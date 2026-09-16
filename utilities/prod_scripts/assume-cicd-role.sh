#!/usr/bin/env zsh

TEMP_FILE_NAME="temp.json"

typeset -A profiles
profiles["dev"]=""
profiles["impl"]=""
profiles["preprod"]=""
profiles["prod"]=""


function log () {
  echo "${BASHPID} $(date '+%d-%m-%Y %H:%M:%S'): $1 $2"
}

function assume_role () {
  declare role_arn=$1
  declare profile=$2

  aws sts assume-role \
    --role-arn $role_arn \
    --role-session-name "${profile}-admin" \
    >> $TEMP_FILE_NAME
}

function export_credentials () {
  access_key_id=$(jq '.Credentials.AccessKeyId' temp.json)
  secret_access_key=$(jq '.Credentials.SecretAccessKey' temp.json)
  session_token=$(jq '.Credentials.SessionToken' temp.json)

  log "AccessKeyId: ${access_key_id} | SecretAccessKey: ${secret_access_key} | SessionToken: ${session_token}"

  echo
  echo "export AWS_ACCESS_KEY_ID=${access_key_id} \
  export AWS_SECRET_ACCESS_KEY=${secret_access_key} \
  export AWS_SESSION_TOKEN=$session_token" | pbcopy

  echo
  echo "You can copy these values into your IDE config:"
  echo "AWS_ACCESS_KEY_ID=${access_key_id}"
  echo "AWS_SECRET_ACCESS_KEY=${secret_access_key}"
  echo "AWS_SESSION_TOKEN=$session_token"
  
  echo
  echo "The export commands have been copied to your clipboard.
Please paste them into your terminal to set the environment variables."

}

function cleanup () {
  rm -f $TEMP_FILE_NAME
}


assume_role "${profiles["${1}"]}" $1
export_credentials
cleanup
