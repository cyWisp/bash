#!/bin/zsh

# Dependencies:
# 1. aws cli: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
# 2. aws-adfs: https://github.com/venth/aws-adfs

ADFS_HOST="sts.qualnet.org"
REGION="us-east-1"

function log () {
  echo "${BASHPID} $(date '+%d-%m-%Y %H:%M:%S'): $1 $2"
}

function log_in () {
  log "Logging with profile ${1}."
  aws-adfs login --profile $1 --region $REGION --adfs-host $ADFS_HOST

  log "Verifying profile ${1}."
  aws sts --profile $1 get-caller-identity
}

log_in $1