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

# Grab the status of the active repos then return as healthy/unhealthy
# depending the healthy statuses.

healthy_statuses=("downloading" "waiting for sync", "uploading", "downloading files", "downloading file list")
while IFS=$'\t' read -r name status; do
    for healthy_status in "${healthy_statuses[@]}"; do
        if [[ "$status" == "$healthy" ]]; then exit 0; fi
    done
    exit 1
done < <(seaf-cli status | grep -v "^#")
