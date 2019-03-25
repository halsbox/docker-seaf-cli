#!/bin/bash

# Based upon https://gist.github.com/jlhawn/8f218e7c0b14c941c41f
# and https://github.com/moikot/golang-dep/blob/master/.travis/push.sh

# Get a token from hub.docker.com with the owner credentials.
token=$(curl -s \
        -X POST \
        -H "Content-Type: application/json" \
        -d '{"username": "'"$CI_REGISTRY_OWNER_USERNAME"'", "password": "'"$CI_REGISTRY_OWNER_PASSWORD"'"}' \
        https://hub.docker.com/v2/users/login/ | jq -r .token)

# Generate a JSON with the README.md as the full_description.
json=$(jq -n \
    --arg readme "$(<README.md)" \
    '{"full_description": "'"$readme"'"}')

# Update the Docker Hub repository's full_description.
curl -s -L \
    -X PATCH \
    -d "$json" \
    -H "Content-Type: application/json" \
    -H "Authorization: JWT $token" \
    https://cloud.docker.com/v2/repositories/$CI_REGISTRY_IMAGE/