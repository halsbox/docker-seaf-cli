#!/bin/bash

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

seafile_ini=~/.ccnet/seafile.ini
seafile_sock=/.seafile/seafile-data/seafile.sock
supervisord_conf=/.supervisord/supervisord.conf
supervisord_pid=/.supervisord/supervisord.pid
supervisord_log=/.supervisord/supervisord.log

# Safely initialize Seafile.
/usr/bin/seaf-cli init -d /.seafile
while [ ! -f $seafile_ini ]; do sleep 1; done
# Safely start the Seafile daemon.
/usr/bin/seaf-cli start
while [ ! -S $seafile_sock ]; do sleep 1; done
# Start the synchronisation.
/usr/bin/seaf-cli sync -u $SEAF_USERNAME -p $SEAF_PASSWORD -s $SEAF_SERVER_URL -l $SEAF_LIBRARY_UUID -d /volume
# Start the supervisord.
/usr/bin/supervisord -u $UNAME -c $supervisord_conf -j $supervisord_pid -l $supervisord_log