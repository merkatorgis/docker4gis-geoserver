FROM docker.osgeo.org/geoserver:2.26.2

# Example plugin use.
# COPY conf/.plugins/bats /tmp/bats
# RUN /tmp/bats/install.sh

ENV SKIP_DEMO_DATA=true
ENV ROOT_WEBAPP_REDIRECT=true
ENV INSTALL_EXTENSIONS=true

ONBUILD COPY conf/geoserver_data/. /opt/geoserver_data

ONBUILD COPY conf/additional_libs/. /opt/additional_libs
ONBUILD COPY conf/additional_fonts/. /opt/additional_fonts

ONBUILD ARG STABLE_EXTENSIONS
ONBUILD ENV STABLE_EXTENSIONS=$STABLE_EXTENSIONS

ONBUILD ARG COMMUNITY_EXTENSIONS
ONBUILD ENV COMMUNITY_EXTENSIONS=$COMMUNITY_EXTENSIONS

ONBUILD RUN /opt/install-extensions.sh

COPY conf/additional_libs/. /opt/additional_libs
COPY conf/additional_fonts/. /opt/additional_fonts

ENV STABLE_EXTENSIONS=css,printing,pyramid
ENV COMMUNITY_EXTENSIONS=

RUN /opt/install-extensions.sh

COPY conf/dg /usr/local/bin

# Allow configuration before things start up.
COPY conf/entrypoint /
ENTRYPOINT ["/entrypoint"]
CMD ["geoserver"]

# Make this image work with dg build & dg push.
COPY conf/.docker4gis /.docker4gis
COPY build.sh run.sh /.docker4gis/

# Set environment variables.
ONBUILD ARG DOCKER_REGISTRY
ONBUILD ENV DOCKER_REGISTRY=$DOCKER_REGISTRY
ONBUILD ARG DOCKER_USER
ONBUILD ENV DOCKER_USER=$DOCKER_USER
ONBUILD ARG DOCKER_REPO
ONBUILD ENV DOCKER_REPO=$DOCKER_REPO

# Make this an extensible base component; see
# https://github.com/merkatorgis/docker4gis/tree/npm-package/docs#extending-base-components.
COPY template /template/
