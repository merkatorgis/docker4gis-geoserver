#!/bin/bash
set -e

IMAGE=$IMAGE
CONTAINER=$CONTAINER
DOCKER_ENV=$DOCKER_ENV
RESTART=$RESTART
NETWORK=$NETWORK

GEOSERVER_XMS=${GEOSERVER_XMS:-${XMS:-256m}}
GEOSERVER_XMX=${GEOSERVER_XMX:-${XMX:-2g}}
EXTRA_JAVA_OPTS="-Xms$GEOSERVER_XMS -Xmx$GEOSERVER_XMX"

default_logging_profile=PRODUCTION_LOGGING
[ "$DOCKER_ENV" = DEVELOPMENT ] && default_logging_profile=DEFAULT_LOGGING
GEOSERVER_LOGGING_PROFILE=${GEOSERVER_LOGGING_PROFILE:-$default_logging_profile}

GEOSERVER_PORT=$(docker4gis/port.sh "${GEOSERVER_PORT:-58080}")

docker container run --restart "$RESTART" --name "$CONTAINER" \
	--env DOCKER_ENV="$DOCKER_ENV" \
	--env CONTAINER="$CONTAINER" \
	--env EXTRA_JAVA_OPTS="$EXTRA_JAVA_OPTS" \
	--env GEOSERVER_LOGGING_PROFILE="$GEOSERVER_LOGGING_PROFILE" \
	-p "$GEOSERVER_PORT":8080 \
	--network "$NETWORK" \
	-d "$IMAGE" geoserver "$@"
