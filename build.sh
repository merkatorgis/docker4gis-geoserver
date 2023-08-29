#!/bin/bash

docker image build \
	--build-arg DOCKER_USER="$DOCKER_USER" \
	--build-arg STABLE_EXTENSIONS="$STABLE_EXTENSIONS" \
	--build-arg COMMUNITY_EXTENSIONS="$COMMUNITY_EXTENSIONS" \
	-t "$IMAGE" . &&
	docker container run --rm \
		--mount src="$(realpath conf/additional_libs)",target=/save_additional_libs/,type=bind \
		"$DOCKER_REGISTRY"/"$DOCKER_USER"/"$DOCKER_REPO" \
		/opt/additional_libs/save_additional_libs.sh
