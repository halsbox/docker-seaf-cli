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

# Safely initialise the Seafile client.
seafile_ini=~/.ccnet/seafile.ini
/usr/bin/seaf-cli init -d ~/.seafile
while [ ! -f $seafile_ini ]; do sleep 1; done

# Safely start the Seafile daemon.
seafile_sock=~/.seafile/seafile-data/seafile.sock
/usr/bin/seaf-cli start
while [ ! -S $seafile_sock ]; do sleep 1; done

# Set the disable_verify_certificate key to true only if the environment variable exists.
[[ "$SEAF_SKIP_SSL_CERT" ]] && seaf-cli config -k disable_verify_certificate -v true

# Set the upload/download limits
[[ "$SEAF_UPLOAD_LIMIT" ]] && seaf-cli config -k upload_limit -v $SEAF_UPLOAD_LIMIT
[[ "$SEAF_DOWNLOAD_LIMIT" ]] && seaf-cli config -k download_limit -v $SEAF_DOWNLOAD_LIMIT

# Build the seaf-cli sync command.
cmd="seaf-cli sync -u $SEAF_USERNAME -p $SEAF_PASSWORD -s $SEAF_SERVER_URL -l $SEAF_LIBRARY_UUID -d /volume"
[[ "$SEAF_2FA_SECRET" ]] && cmd+=" -a $(oathtool --base32 --totp $SEAF_2FA_SECRET)"
[[ "$SEAF_LIBRARY_PASSWORD" ]] && cmd+=" -e $SEAF_LIBRARY_PASSWORD"

# Run it.
if ! eval $cmd; then echo "Failed to synchronize."; exit 1; fi

# Continously print the log.
tail -f ~/.ccnet/logs/seafile.log
