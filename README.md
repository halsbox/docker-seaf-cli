[![0.9.1 status](https://gitlab.com/flwgns-docker/docker-seafile-client/badges/0.9.1/pipeline.svg)](https://gitlab.com/flwgns-docker/docker-seafile-client/commits/0.9.1)

# Available tags.

[`0`](https://gitlab.com/flwgns-docker/docker-seafile-client/tags/0.9.1),
[`0.9`](https://gitlab.com/flwgns-docker/docker-seafile-client/tags/0.9.1),
[`0.9.1`](https://gitlab.com/flwgns-docker/docker-seafile-client/tags/0.9.1),
[`latest`](https://gitlab.com/flwgns-docker/docker-seafile-client/tags/0.9.1) (see tag/release [0.9.1](https://gitlab.com/flwgns-docker/docker-seafile-client/tags/0.9.1))


# Purpose
Docker Seafile Client allow you to sync a Seafile library within a container. Essentially, you have the ability to:
* **Share** data from a **Seafile library** as a volume to **other containers**.
## Seafile?
[Seafile is a cloud storage software](https://www.seafile.com/).


# Usage
The *Seafile* daemon is running from `/.seafile/` and `~/.ccnet`.
The library is synced at `/volume/`.

The *Seafile* daemon is managed with *supervisord* since it can't run as a foreground process.
The *supervisord* is running from `/.supervisord/`, the `supervisord.conf`, `supervisord.log` and `supervisord.pid` can be found there.
*supervisord* also manage a shell script, `/seaf-cli-start.sh` which run `seaf-cli start` every hour: the synchronisation might not work properly if the previously is not run from times to times, for an unresolved reason.
## Examples
You would have to share the path `/volume/` to other containers, with the following approaches:
### Docker CLI
`docker run `
### docker-compose
```yaml
version: "3.4"

services:
  seafile-sync:
    image: registry.gitlab.com/flwgns-docker/docker-seafile-client:latest
    volumes:
      - your_shared_volume:/volume
    environment:
      - SEAF_SERVER_URL=    # The URL to your Seafile server.
      - SEAF_USERNAME=      # Your Seafile username.
      - SEAF_PASSWORD=      # Your Seafile password
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
## SEAF_SERVER_URL
The URL to your Seafile server.
## SEAF_USERNAME
Your Seafile account's username.
## SEAF_PASSWORD
Your Seafile account's password.
## SEAF_LIBRARY_UUID
The Seafile library UUID you want to use.

## User permissions
This Docker is **not running as `root` but as `seafuser`**. You can override the user/group ID used with:
### UID
The user ID defaults to `1000`. You may want to override this variable to prevent permission issues.
### GID
The group ID defaults to `1000`. Similarly, you may want to override this variable to prevent permission issues.

# Source code
This Docker image is licensed under GPLv3.  
The source code is available in [gitlab.com/flwgns-docker/docker-seafile-client](https://gitlab.com/flwgns-docker/docker-seafile-client/).