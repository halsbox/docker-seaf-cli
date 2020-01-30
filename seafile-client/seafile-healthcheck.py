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

# Given a path to a valid Seafile confdir and a repository, check the
# synchronization status and otherwise the transfer status of that
# repository.

import argparse
import os
import sys

import seafile


if __name__ == "__main__":
    # Parse Seafile's confdir and repository ID to check.
    parser = argparse.ArgumentParser(description="Check the status of a synced repository.")
    parser.add_argument('repository_id',  type=str, help="Repository ID to check the status of.")
    parser.add_argument('-c', '--confdir', type=str, required=True, help="Seafile configuration directory to load the Socket from.")
    args = parser.parse_args()

    # Instanciate Seafile RPC.
    seafile_socket = os.path.join(args.confdir, "seafile.sock")
    if not os.path.exists(seafile_socket):
        raise Exception("Could not find a Seafile socket at {}".format(args.confdir))
    seafile_rpc = seafile.RpcClient(os.path.join(args.confdir, "seafile.sock"))

    # Fetch the sync task of the repository.
    repository_sync_task = seafile_rpc.get_repo_sync_task(args.repository_id)
    if repository_sync_task is not None:
        sync_state = repository_sync_task.state
        msg = "Repository synchronization state: {}".format(sync_state)
        if sync_state == "error":
            raise Exception(msg)
        else:
            print(msg)
            sys.exit(0)

    # Fetch the transfer task of the repository.
    repository_transfer_task = seafile_rpc.find_transfer_task(args.repository_id)
    if repository_transfer_task is not None:
        transfer_state = repository_transfer_task.state
        msg = "Repository transfer state: {}".format(transfer_state)
        if transfer_state == "error":
            raise Exception(msg)
        else:
            print(msg)
            sys.exit(0)

    raise Exception("Could not find any information about any repository synchronization or transfer tasks.")
