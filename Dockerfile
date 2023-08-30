FROM docker.osgeo.org/geoserver:2.23.2

# Allow configuration before things start up.
COPY conf/entrypoint /
ENTRYPOINT ["/entrypoint"]
CMD ["geoserver"]

# Example plugin use.
# COPY conf/.plugins/bats /tmp/bats
# RUN /tmp/bats/install.sh

# This may come in handy.
ONBUILD ARG DOCKER_USER
ONBUILD ENV DOCKER_USER=$DOCKER_USER

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

# Extension template, as required by `dg component`.
COPY template /template/
# Make this an extensible base component; see
# https://github.com/merkatorgis/docker4gis/tree/npm-package/docs#extending-base-components.
COPY conf/.docker4gis /.docker4gis
COPY build.sh /.docker4gis/build.sh
COPY run.sh /.docker4gis/run.sh
ONBUILD COPY conf /tmp/conf
ONBUILD RUN touch /tmp/conf/args
ONBUILD RUN cp /tmp/conf/args /.docker4gis
