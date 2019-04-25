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

FROM debian:jessie-slim

# Prevent the packages installation to halt.
ENV DEBIAN_FRONTEND noninteractive
# Specify the user running Seafile.
ENV UNAME=seafuser
ENV UID=1000
ENV GID=1000

# Copy over the Docker related files.
COPY utils/build/import-seafile-apt-key.sh /
COPY assets/docker-bash-entrypoint.sh /entrypoint.sh

# Safely import Seafile APT key, then install both seafile-cli and supervisord.
RUN mkdir -p /etc/apt/sources.list.d/ ;\
    echo "deb http://deb.seadrive.org jessie main" \
        > /etc/apt/sources.list.d/seafile.list ;\
    /bin/bash /import-seafile-apt-key.sh ;\
    apt-get update ;\
    apt-get install \
        -o Dpkg::Options::="--force-confold" \
        -y seafile-cli ;\
    apt-get clean ;\
    apt-get autoclean \
        -o APT::Clean-Installed=true ;\
    rm \
        -f \
            /var/log/fsck/*.log \
            /var/log/apt/*.log \
            /var/cache/debconf/*.dat-old \
            /import-seafile-apt-key.sh ;\
    mkdir /volume ;\
    groupadd -g $GID -o $UNAME ;\
    useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

# Copy over the required files for Seafile/SupervisorD.
COPY assets/supervisord.conf assets/infinite-seaf-cli-start.sh /home/seafuser/
COPY assets/seafile-bash-entrypoint.sh /home/seafuser/entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
