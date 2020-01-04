# Docker Seafile client, help you mount a Seafile library as a volume.
# Copyright (C) 2019-2020, flow.gunso@gmail.com
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

FROM debian:buster-slim

# For MicroBadger.
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="Seafile Docker client" \
    org.label-schema.description="Sync Seafile librairies within Docker containers." \
    org.label-schema.url=$CI_PROJECT_URL \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url=$CI_PROJECT_URL \
    org.label-schema.vendor="flow.gunso@gmail.com" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0"

# Prevent the packages installation to halt.
ENV DEBIAN_FRONTEND noninteractive
# Create the Seafile client's user.
ENV UNAME=seafuser
ENV UID=1000
ENV GID=1000
# Seafile optional configuration.
ENV SEAF_SKIP_SSL_CERT=1

# Safely import Seafile APT key, then install both seafile-cli and supervisord.
COPY import-seafile-apt-key.sh /
RUN apt-get update && apt-get install -y gnupg && \
    mkdir -p /etc/apt/sources.list.d/ && \
    echo "deb http://deb.seadrive.org buster main" > /etc/apt/sources.list.d/seafile.list && \
    bash /import-seafile-apt-key.sh && \
    apt-get purge --yes gnupg && apt-get autoremove --yes && \
    apt-get update && apt-get install \
        --no-install-recommends \
        --yes \
            seafile-cli \
            oathtool \
            cron && \
    apt-get clean && apt-get autoclean && \
    rm -rf \
        /var/log/fsck/*.log \
        /var/log/apt/*.log \
        /var/cache/debconf/*.dat-old \
        /var/lib/apt/lists/* \
        /import-seafile-apt-key.sh && \
    mkdir /volume/ && \
    echo "seafuser" > /etc/cron.allow && \
    echo "*/20 * * * * /bin/bash /home/seafuser/healthcheck.sh" \
        > /var/spool/cron/crontabs/seafuser && \
    groupadd -g $GID -o $UNAME && \
    useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

# Copy over the entrypoints, healthchecks and tests.
COPY docker-entrypoint.sh /entrypoint.sh
COPY seafile-healthcheck.sh /home/seafuser/healthcheck.sh
COPY seafile-entrypoint.sh /home/seafuser/entrypoint.sh
COPY tests /tests

# Set bash as the entrypoint and run the entrypoint script from that.
ENTRYPOINT ["/bin/bash"]
CMD ["/entrypoint.sh"]