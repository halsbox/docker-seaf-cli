#!/bin/bash

# Restrict production build to tag matching MAJOR.MINOR.REVISION.
if ! [[ "$CI_COMMIT_TAG" =~ ^[0-9]+[.][0-9]+[.][0-9]+$ ]]; then
    echo "Version number must match major.minor.revision!"
    exit 1
fi

# Define MAJOR, MINOR and REVISION version numbers.
MAJOR_NUMBER=$(echo "$CI_COMMIT_TAG" | awk -F \. {'print $1'})
MINOR_NUMBER=$(echo "$CI_COMMIT_TAG" | awk -F \. {'print $2'})
REVISION_NUMBER=$(echo "$CI_COMMIT_TAG" | awk -F \. {'print $3'})
MAJOR=$MAJOR_NUMBER
MINOR=$MAJOR.$MINOR_NUMBER
REVISION=$MINOR.$REVISION_NUMBER

# Build.
docker build \
    -t $CI_REGISTRY_IMAGE:latest \
    -t $CI_REGISTRY_IMAGE:$MAJOR \
    -t $CI_REGISTRY_IMAGE:$MINOR \
    -t $CI_REGISTRY_IMAGE:$REVISION .

# And push.
docker push $CI_REGISTRY_IMAGE:latest
docker push $CI_REGISTRY_IMAGE:$MAJOR
docker push $CI_REGISTRY_IMAGE:$MINOR
docker push $CI_REGISTRY_IMAGE:$REVISION