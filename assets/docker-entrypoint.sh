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

# Check mandatory Seafile configuration have been properly set.
if [ -z $SEAF_SERVER_URL ]; then echo "The \$SEAF_SERVER_URL was not defined. Stopping container..."; exit 1; fi
if [ -z $SEAF_USERNAME ]; then echo "The \$SEAF_USERNAME was not defined. Stopping container..."; exit 1; fi
if [ -z $SEAF_PASSWORD ]; then echo "The \$SEAF_PASSWORD was not defined. Stopping container..."; exit 1; fi
if [ -z $SEAF_LIBRARY_UUID ]; then echo "The \$SEAF_LIBRARY_UUID was not defined. Stopping container..."; exit 1; fi

# Update the user ID, if the $UID changed.
if [ "$UID" != "1000" ]; then
    usermod -u $UID $UNAME
    # What if the $UID already exists ?
fi

# Change the group, if the $GID changed.
if [ "$GID" != "1000" ]; then
    getent group | grep ":$GID:" >/dev/null
    if [ $? -eq 0 ]; then
        usermod -g $GID -G 1000 $UNAME
    else
        groupmod -g $GID $UNAME
    fi
fi

# Set the files ownership.
chown $UID.$GID -R /home/seafuser/supervisord.conf
chown $UID.$GID -R /home/seafuser/infinite-seaf-cli-start.sh
chown $UID.$GID -R /home/seafuser/entrypoint.sh

# Run the Seafile client as the container user.
su - $UNAME -c ' \
    export SEAF_SERVER_URL=$SEAF_SERVER_URL ;\
    export SEAF_USERNAME=$SEAF_USERNAME ;\
    export SEAF_PASSWORD=$SEAF_PASSWORD ;\
    export SEAF_LIBRARY_UUID=$SEAF_LIBRARY_UUID ;\
    export UNAME=$UNAME ;\
    /bin/bash /home/seafuser/entrypoint.sh'
