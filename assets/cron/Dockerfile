# Docker Seafile client, help you mount a Seafile library as a volume.
# Copyright (C) 2019, flow.gunso@gmail.com
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

# Prevent the packages installation to halt.
ENV DEBIAN_FRONTEND noninteractive
# Create the seafile client user.
ENV UNAME=seafuser
ENV UID=1000
ENV GID=1000

# Copy over the Docker related files.
COPY utils/build/import-seafile-apt-key.sh /
COPY assets/cron/docker-entrypoint.sh /entrypoint.sh

# Safely import Seafile APT key, then install both seafile-cli and supervisord.
RUN mkdir -p /etc/apt/sources.list.d/ && \
    apt-get update && \
    apt-get install -y gnupg && \
    echo "deb http://deb.seadrive.org buster main" \
        > /etc/apt/sources.list.d/seafile.list && \
    bash /import-seafile-apt-key.sh && \
    apt-get remove -y gnupg && \
    apt-get autoremove -y && \
    apt-get update && \
    apt-get install \
        -o Dpkg::Options::="--force-confold" \
        -y \
            seafile-cli \
            cron && \
    apt-get clean && \
    apt-get autoclean \
        -o APT::Clean-Installed=true && \
    rm \
        -rf \
            /var/log/fsck/*.log \
            /var/log/apt/*.log \
            /var/cache/debconf/*.dat-old \
            /var/lib/apt/lists/* \
            /import-seafile-apt-key.sh && \
    mkdir /volume/ && \
    echo "seafuser" > /etc/cron.allow && \
    echo "*/20 * * * * /bin/bash /home/seafuser/seafile-healthcheck.sh" \
        > /var/spool/cron/crontabs/seafuser && \
    groupadd -g $GID -o $UNAME && \
    useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

# Copy over the required files for Seafile/SupervisorD.
COPY assets/cron/seafile-healthcheck.sh /home/seafuser/seafile-healthcheck.sh
COPY assets/cron/seafile-entrypoint.sh /home/seafuser/entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
