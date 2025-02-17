#!/bin/bash
set -e

GEOSERVER_XMS=${GEOSERVER_XMS:-${XMS:-256m}}
GEOSERVER_XMX=${GEOSERVER_XMX:-${XMX:-2g}}
EXTRA_JAVA_OPTS="-Xms$GEOSERVER_XMS -Xmx$GEOSERVER_XMX"

default_logging_profile=PRODUCTION_LOGGING
[ "$DOCKER_ENV" = DEVELOPMENT ] && default_logging_profile=DEFAULT_LOGGING
GEOSERVER_LOGGING_PROFILE=${GEOSERVER_LOGGING_PROFILE:-$default_logging_profile}

GEOSERVER_PORT=$(docker4gis/port.sh "${GEOSERVER_PORT:-58080}")

docker container run --restart "$RESTART" --name "$DOCKER_CONTAINER" \
	--env-file "$ENV_FILE" \
	--env EXTRA_JAVA_OPTS="$EXTRA_JAVA_OPTS" \
	--env GEOSERVER_LOGGING_PROFILE="$GEOSERVER_LOGGING_PROFILE" \
	--publish "$GEOSERVER_PORT":8080 \
	--network "$DOCKER_NETWORK" \
	--detach "$DOCKER_IMAGE" geoserver "$@"
