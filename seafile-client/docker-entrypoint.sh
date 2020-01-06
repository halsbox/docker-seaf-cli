#!/bin/bash

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

# Check mandatory Seafile configuration have been properly set.
if [ -z $SEAF_SERVER_URL ]; then
    echo "The \$SEAF_SERVER_URL is not defined. Stopping container..."
	exit 1
fi
if [ -z $SEAF_USERNAME ]; then
    echo "The \$SEAF_USERNAME is not defined. Stopping container..."
	exit 1
fi
if [ -z $SEAF_PASSWORD ]; then
    echo "The \$SEAF_PASSWORD is not defined. Stopping container..."
	exit 1
fi
if [ -z $SEAF_LIBRARY_UUID ]; then
    echo "The \$SEAF_LIBRARY_UUID is not defined. Stopping container..."
	exit 1
fi
if [[ -n "$SEAF_UPLOAD_LIMIT"
&& $SEAF_UPLOAD_LIMIT =~ ^[0-9]+$
&& "$SEAF_UPLOAD_LIMIT" -gt 0 ]]; then
    echo "The \$SEAF_UPLOAD_LIMIT is not an integer greater than 0. Stopping container..."
    exit 1
fi
if [[ -n "$SEAF_DOWNLOAD_LIMIT"
&& $SEAF_DOWNLOAD_LIMIT =~ ^[0-9]+$
&& "$SEAF_DOWNLOAD_LIMIT" -gt 0 ]]; then
    echo "The \$SEAF_DOWNLOAD_LIMIT is not an integer greater than 0. Stopping container..."
    exit 1
fi

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
chown $UID.$GID /home/seafuser/healthcheck.sh
chown $UID.$GID /home/seafuser/entrypoint.sh
chown $UID.$GID -R /volume 

# Run the Seafile client as the container user.
su - $UNAME << EO
    export SEAF_SERVER_URL=$SEAF_SERVER_URL
    export SEAF_USERNAME=$SEAF_USERNAME
    export SEAF_PASSWORD=$SEAF_PASSWORD
    export SEAF_LIBRARY_UUID=$SEAF_LIBRARY_UUID
    export SEAF_SKIP_SSL_CERT=$SEAF_SKIP_SSL_CERT
    test -n "$SEAF_UPLOAD_LIMIT" && export SEAF_UPLOAD_LIMIT=$SEAF_UPLOAD_LIMIT
    test -n "$SEAF_DOWNLOAD_LIMIT" && export SEAF_DOWNLOAD_LIMIT=$SEAF_DOWNLOAD_LIMIT
    test -n "$SEAF_2FA_SECRET" && export SEAF_2FA_SECRET=$SEAF_2FA_SECRET
    test -n "$SEAF_LIBRARY_PASSWORD" && export SEAF_LIBRARY_PASSWORD=$SEAF_LIBRARY_PASSWORD
    export UNAME=$UNAME
    /bin/bash /home/seafuser/entrypoint.sh
EO
