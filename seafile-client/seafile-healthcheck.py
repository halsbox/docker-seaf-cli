#!/usr/bin/env python2

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

import argparse
import os
import sys

import seafile


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Check the status of a synced repository.")
    parser.add_argument('repository_id',  type=str, help="Repository ID to check the status of.")
    parser.add_argument('-c', '--confdir', type=str, required=True, help="Seafile configuration directory to load the Socket from.")
    args = parser.parse_args()

    seafile_socket = os.path.join(args.confdir, "seafile.sock")
    if not os.path.exists(seafile_socket):
        raise Exception("Could not find a Seafile socket at {}".format(args.confdir))

    seafile_rpc = seafile.RpcClient(os.path.join(args.confdir, "seafile.sock"))
    repo_sync_task = seafile_rpc.get_repo_sync_task(args.repository_id)
    if repo_sync_task is None:
        raise Exception("Unable to fetch task informations for repository {}".format(args.repository_id))
    
    if repo_sync_task.state == "error":
        raise Exception("The repository {} is in an error state.".format(args.repository_id))
