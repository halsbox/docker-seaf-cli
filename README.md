[![1.2.1 build status](https://gitlab.com/flwgns-docker/seafile-client/badges/1.2.1/pipeline.svg)](https://gitlab.com/flwgns-docker/seafile-client/commits/1.2.1)
[![Docker pulls](https://img.shields.io/docker/pulls/flowgunso/seafile-client.svg)](https://hub.docker.com/r/flowgunso/seafile-client)
[![Licensed under GPLv3](https://img.shields.io/badge/License-GPLv3-red.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![@gitlab.com/flwgns-docker/seafile-client](https://img.shields.io/badge/Source%20code-GitLab-red.svg)](https://gitlab.com/flwgns-docker/seafile-client/)

# Available tags

Weekly stable release are built every Monday at 6AM UTC+2.  
Permanent stable releases will not be built again.

## Weekly stable releases.
[`1`](https://gitlab.com/flwgns-docker/seafile-client/tags/1.2.1),
[`1.2`](https://gitlab.com/flwgns-docker/seafile-client/tags/1.2.1),
[`1.2.1`](https://gitlab.com/flwgns-docker/seafile-client/tags/1.2.1),
[`latest`](https://gitlab.com/flwgns-docker/seafile-client/tags/1.2.1)

## Developmental releases.
[`staging`](https://gitlab.com/flwgns-docker/seafile-client/tree/staging):
The purpose of this release is to test feature and make them available to anyone.

# Purpose
Docker Seafile Client allow you to sync a Seafile library within a container.

**Essentially, you can share a Seafile library as a volume to other containers**.

## Seafile?
[Seafile is a cloud storage software](https://www.seafile.com/).


# Usage
The *Seafile* daemon is running as the user `seafuser` from it's directories `~/.seafile/` and `~/.ccnet`.

The library is synced at `/volume/`.

The *Seafile* daemon is managed with *supervisord* since it can't run as a foreground process.
The *supervisord* is running from `~/.supervisord/`, the `supervisord.conf`, `supervisord.log` and `supervisord.pid` can be found there.  
*supervisord* also manage a shell script, `~/infinite-seaf-cli-start.sh` which stop then start the Seafile daemon every 20 minutes: the synchronisation might not work properly if the Seafile daemon is not restarted from times to times, for an unresolved reason.
## Examples
You would have to share the path `/volume/` to other containers, with the following approaches:
### Docker CLI
```
docker run \ 
    -e SEAF_SERVER_URL= \   # The URL to your Seafile server.
    -e SEAF_USERNAME= \     # Your Seafile username.
    -e SEAF_PASSWORD= \     # Your Seafile password
    -e SEAF_LIBRARY_UUID= \ # The Seafile library UUID you want to sync with.
    -e UID= \               # Default is 1000.
    -e GID= \               # Default is 1000.
    -v your/shared/volume:/volume \
    flowgunso/seafile-client:latest
```
### docker-compose
```yaml
version: "3.4"

services:
  seafile-client:
    image: flowgunso/seafile-client:latest
    restart: on-failure
    volumes:
      - your_shared_volume:/volume
    environment:
      - SEAF_SERVER_URL=    # The URL to your Seafile server.
      - SEAF_USERNAME=      # Your Seafile username.
      - SEAF_PASSWORD=      # Your Seafile password.
      - SEAF_LIBRARY_UUID=  # The Seafile library UUID you want to sync with.
      - UID=                # Default is 1000.
      - GID=                # Default is 1000.

volumes:
  your_shared_volume:
```


# Environment variables
The following environment variable are available.

## Seafile
This Docker **must be configured with the following**, **otherwise** it **will not run**:
### SEAF_SERVER_URL
The URL to your Seafile server.
### SEAF_USERNAME
Your Seafile account's username.
### SEAF_PASSWORD
Your Seafile account's password.
### SEAF_LIBRARY_UUID
The Seafile library UUID you want to use.

## User permissions
This Docker is **not running as `root` but as `seafuser`**. You can override the user/group ID used with:
### UID
The user ID defaults to `1000`. You may want to override this variable to prevent permission issues.
### GID
The group ID defaults to `1000`. Similarly, you may want to override this variable to prevent permission issues.

# Source code
This Docker image is licensed under GPLv3.  
The source code is available in [gitlab.com/flwgns-docker/seafile-client](https://gitlab.com/flwgns-docker/seafile-client/).