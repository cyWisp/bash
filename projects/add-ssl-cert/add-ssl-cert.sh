#!/usr/bin/env bash


CERT_DIR="/mnt/c/Lab/certs"
CERT_STORE_DIR="/usr/local/share/ca-certificates/"

function log () {
            echo "${BASHPID} $(date '+%d-%m-%Y %H:%M:%S'): $1"
        }

function check_root () {
    if [ "$EUID" -ne 0 ]
        then log "Please run as root"
        exit
    fi
}

function get_target_url () {
    printf "Target URL: %s\n" $1
     TARGET_URL=$1
    
}

function generate_site_certificate () {
    local url_and_port="$1:443"
    local name="$(echo $1 | awk -F '.' '{print $1}')"

    ORIGINATING_CERT="${CERT_DIR}/${name}-self-signed.crt"

    log "Generating self-signed certificate for ${url_and_port} at ${ORIGINATING_CERT}"

    echo -n | openssl s_client -connect $url_and_port 2>/dev/null </dev/null |\
    sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > "${ORIGINATING_CERT}"
}

function copy_cert_and_update_cert_store () {
    log "Copy certificate to certificate store directory at ${CERT_STORE_DIR}"
    cp $ORIGINATING_CERT $CERT_STORE_DIR

    log "Updating certificate store."
    sudo update-ca-certificates
}

check_root
get_target_url $1
generate_site_certificate $TARGET_URL
copy_cert_and_update_cert_store