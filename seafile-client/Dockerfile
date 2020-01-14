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

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL maintainer="flow.gunso@gmail.com" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="Seafile Docker client" \
    org.label-schema.description="Sync Seafile librairies within Docker containers." \
    org.label-schema.url=$PROJECT_URL \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url=$PROJECT_URL \
    org.label-schema.vendor="flow.gunso@gmail.com" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0"

# Install seaf-cli and oathtool, prepare the user.
ENV DEBIAN_FRONTEND=noninteractive
ENV UNAME=seafuser UID=1000 GID=1000
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
            oathtool && \
    apt-get clean && apt-get autoclean && \
    rm -rf \
        /var/log/fsck/*.log \
        /var/log/apt/*.log \
        /var/cache/debconf/*.dat-old \
        /var/lib/apt/lists/* \
        /import-seafile-apt-key.sh && \
    mkdir /library/ && \
    groupadd -g $GID -o $UNAME && \
    useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME && \
    mkdir /home/$UNAME/.seafile && \
    chown $UNAME:$GID /home/$UNAME/.seafile 

# Copy over the assets.
COPY docker-entrypoint.sh /entrypoint.sh
COPY docker-healthcheck.sh /healthcheck.sh
COPY seafile-entrypoint.sh /home/seafuser/entrypoint.sh
#COPY seafile-healthcheck.sh /home/seafuser/healthcheck.sh
COPY tests /tests

ENTRYPOINT ["/bin/bash", "--"]
CMD ["/entrypoint.sh"]
HEALTHCHECK --start-period=20s --retries=1 CMD ["su", "-", "${UNAME}", "-c", "/healthcheck.sh"]