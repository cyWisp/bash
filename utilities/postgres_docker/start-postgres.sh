#!/usr/bin/env bash

DEFAULT_IMAGE_NAME='postgres:16-bookworm'
DEFAULT_VOLUME_NAME='pgdata'
DEFAULT_CONTAINER_NAME='postgres-test'
DEFAULT_PASSWORD='password'
DEFAULT_PORT=5432


function log () {
  echo "$(date '+%d-%m-%Y %H:%M:%S'): ${1}"
}

function usage () {
  echo -e "Usage: $0\n\
  [-n <container name <string>>]\n\
  [-v <volume name <string>>]\n\
  [-i <image name <string>>]\n\
  [-w <password <string>>]\n\
  [-p <port <integer>>]\n\
  [-g <generate config <yes | no>>]\n" 1>&2; exit 1;
}

function check_error () {
  if [ $1 -ne 0 ]; then
    log "[x]" "Previous operation returned a non-zero status - exiting..."
    log "[x]" "Failed at ${2}."
    exit 1
  fi
}

function pull_image () {
  image_name=""

  [[ -n $i ]] && image_name="$i" || image_name=$DEFAULT_IMAGE_NAME

  log "Pulling ${image_name}."
  docker pull "$image_name"

  check_error $? "pull_image"
}


function create_volume () {
  volume_name=""

  [[ -n $v ]] && volume_name="$v" || volume_name=$DEFAULT_VOLUME_NAME

  log "Creating volume ${volume_name}."
  docker volume create "$volume_name"

  check_error $? "create_volume"
  verify_volume
}


function verify_volume () {
  volume_created="$(docker volume ls | grep $volume_name | awk -F ' ' '{print $1}')"

  if [ -z "${volume_created}" ]; then
    log "Failed to create volume ${volume_name}"
    log "Exiting."
    exit 1
  else
    log "Volume created successfully."
  fi
}


function create_and_run_container () {
  container_name=""
  postgres_password=""
  postgres_port=0000

  [[ -n $n ]] && container_name="$n" || container_name=$DEFAULT_CONTAINER_NAME
  [[ -n $w ]] && postgres_password="$w" || postgres_password=$DEFAULT_PASSWORD
  [[ -n $p ]] && postgres_port="$p" || postgres_port=$DEFAULT_PORT

  log "Creating and running container."
  docker run --name $container_name \
  -e POSTGRES_PASSWORD=$postgres_password \
  -v "${volume_name}:/var/lib/postgresql/data" \
  -p "${postgres_port}:5432" \
  -d \
  "${image_name}"
}


function generate_config_file () {
  if [[ "$g" == "yes" || "$g" == "y" ]]; then
    echo "Generating a (.env) configuration file."

    config=$(cat << EOF
POSTGRES_USER=postgres
POSTGRES_PASSWORD=$postgres_password
POSTGRES_DB=test
POSTGRES_HOST=localhost
POSTGRES_PORT=$postgres_port

EOF
)
    printf '%s' "${config}" > .env
  fi
}


while getopts ":n:v:i:w:p:g:h:" o; do
    case "${o}" in
        n)
            n=${OPTARG}
            ;;
        v)
            v=${OPTARG}
            ;;
        i)
            i=${OPTARG}
            ;;
        w)
            w=${OPTARG}
            ;;
        p)
            p=${OPTARG}
            ;;
        g)
            g=${OPTARG}
            ;;
        h)
            usage
            ;;
        *)
            usage
            ;;
    esac
done

shift $((OPTIND-1))


pull_image
create_volume
create_and_run_container
generate_config_file
