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

FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN mkdir /.seafile ;\
    mkdir /.supervisord ;\
    mkdir /volume

COPY assets/seafile.list /etc/apt/sources.list.d/
COPY assets/supervisord.conf /.supervisord/
COPY assets/infinite-seaf-cli-start.sh /
COPY entrypoint.sh /

RUN apt-key adv \
        --keyserver hkp://keyserver.ubuntu.com:80 \
        --recv-keys 8756C4F765C9AC3CB6B85D62379CE192D401AB61
RUN apt-get update ;\
    apt-get install -o Dpkg::Options::="--force-confold" -y seafile-cli supervisor

ENV UNAME=seafuser
ENV UID=1000
ENV GID=1000
RUN groupadd -g $GID -o $UNAME ;\
    useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME ;\
    chown $UID.$GID -R /.seafile ;\
    chown $UID.$GID -R /.supervisord ;\
    chown $UID.$GID -R /volume ;\
    chown $UID.$GID /entrypoint.sh ;\
    chown $UID.$GID /infinite-seaf-cli-start.sh
USER $UNAME

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]