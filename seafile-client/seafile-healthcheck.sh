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

# `seaf-cli status` output csv-like information with tabulates as separators and columns named in comment lines.
# The Seafile client should not be restarted while some statuses are occuring, such as "downloading" or "committing".
#
# This script grabs the output while ignoring the comments to iterate over the informations set to their columns,
# then it compares the statuses, when not empty, to the ones that do not require a restart. Finally either restart or don't.

seaf=/usr/bin/seaf-cli
dont_restart_on=("downloading" "committing")
restart=true

while IFS=$'\t' read -r name status progress; do
    if [ $status ]; then
        for dont_restart_on_status in "${dont_restart_on[@]}"; do
            if [ "$status" == "$dont_restart_on_status" ]; then
                restart=false; break; break
            fi
        done
    fi
done < <($seaf status | grep -v "^#")

if $restart; then
    $seaf stop
    $seaf start
fi
