#!/usr/bin/env bash

function log () {
    echo "${BASHPID} $(date '+%d-%m-%Y %H:%M:%S'): $1"
}

function check-root () {
    if [ "$EUID" -ne 0 ]; then
        echo "[x] This script must run as root."
        exit
    fi
}

function download_and_verify_kubectl () {
	log "[*] Downloading the kubectl binary."
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

	log "[*] Verifying binary release."
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

	echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
}

function install_kubectl () {
	log "[*] Installing kubectl."
	install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
}

function verify_kubectl_is_installed () {
	log "[*] Verifying installation."
	kubectl version --client
}

function download_and_install_minikube () {
	log "[*] Downloading and installing minikube."
	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

	install minikube-linux-amd64 /usr/local/bin/minikube
	
	log "[*] Installing appropriate version of kubectl for minikube installation."
	minikube kubectl -- get po -A

	log "[*] Adding alias for ease of use."
	echo "alias kubectl=\"minikube kubectl --\"" >> .bash_aliases
}


download_and_verify_kubectl
install_kubectl
verify_kubectl_is_installed
download_and_install_minikube



