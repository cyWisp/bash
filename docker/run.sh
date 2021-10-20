#!/bin/bash

user="<superuser name>"
pw="<superuser pass>"
log_dir="/var/log/pos_api"

docker_img_name="test_pos_api"
docker_img_tag="1.0.0"
docker_img_ver="${docker_img_name}:${docker_img_tag}"
img_id=$(docker images -q "${docker_img_name}")

# Clean up all old images with the same name
function cleanup (){
	echo "Cleaning up old images..."
	if [ -z  $img_id ]; then :;
	else
		docker rmi -f ${img_id}
	fi
}


# Build docker image
function build_image () {
	echo "Building new image"
	DOCKER_IMAGE="$(docker build -f Dockerfile -t ${docker_img_ver} . | awk '/Successfully built/ {print $NF}')"

	echo "Image ID: ${DOCKER_IMAGE}"
	if [ -z ${DOCKER_IMAGE} ]; then
		echo "BUILD FAILED"
		exit 1
	else
		echo "BUILD SUCCESSFUL"
	fi
}

# Configure log directories
function configure_logging () {	
	echo "Configuring log directorie(s)"
	
	if [ -e "${log_dir}" ]; then
		echo "Log directory exists- skipping..."
	else
		echo "Creating ${log_dir}"
		echo ${pw} | sudo -S  mkdir ${log_dir}
		sudo chown -R ${user}:${user} ${log_dir}
	fi
}

# Run test_pos_api container
function run_test () {
	echo "Running test_pos_api"
	docker run \
    	--rm \
    	--net=host \
    	-v "${log_dir}":/logs \
    	-e LOG_LEVEL=DEBUG \
    	-e TARGET_HOST=localhost \
    	-e PRODUCT_QUANTITY=1 \
    	-e UNIT_COST=2.00 \
    	-e ITEM_TOTAL=2 \
    	-e PRODUCT_EVENT_TYPE=Sold \
    	-e STAGE=ORDER_TAKEN \
    	"${docker_img_ver}" > "${log_dir}/results.log"
}

cleanup
build_image
configure_logging
run_test
