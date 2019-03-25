#!/bin/bash

# Docker Seafile client, help you mount a Seafile library as a volume.
# Copyright (C) 2019, flow.gunso@gmail.com
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

# Restrict production build to tag matching MAJOR.MINOR.REVISION.
if ! [[ "$CI_COMMIT_TAG" =~ ^[0-9]+[.][0-9]+[.][0-9]+$ ]]; then
    echo "Version number must match major.minor.revision!"
    exit 1
fi

# When this stage is ran from 'push', the build target is BUILD_LATEST.
# When this stage is ran from 'trigger', the build target must be provided.
# Otherwise, stop the stage. 
if [ $CI_PIPELINE_SOURCE == "push" ]; then
    BUILD_LATEST=true
elif [ $CI_PIPELINE_SOURCE == "trigger" ]; then
    if [ -z $BUILD_LATEST ] && \
    [ -z $BUILD_MAJOR ] && \
    [ -z $BUILD_MINOR ] && \
    [ -z $BUILD_REVISION ]; then
        echo "You must provide build targets to this stage when ran from Pipeline Triggers."
        exit 1
    fi
else
    echo "This stage is restricted to 'push' or 'trigger' Pipeline sources."
    exit 1
fi

# Cascade the builds by inheritance.
if [ $BUILD_LATEST ]; then BUILD_MAJOR=true; BUILD_MINOR=true; BUILD_REVISION=true; fi
if [ $BUILD_MAJOR ]; then BUILD_MINOR=true; BUILD_REVISION=true; fi
if [ $BUILD_MINOR ]; then BUILD_REVISION=true; fi

# Define MAJOR, MINOR and REVISION version numbers.
MAJOR_NUMBER=$(echo "$CI_COMMIT_TAG" | awk -F \. {'print $1'})
MINOR_NUMBER=$(echo "$CI_COMMIT_TAG" | awk -F \. {'print $2'})
REVISION_NUMBER=$(echo "$CI_COMMIT_TAG" | awk -F \. {'print $3'})
MAJOR=$MAJOR_NUMBER
MINOR=$MAJOR.$MINOR_NUMBER
REVISION=$MINOR.$REVISION_NUMBER

# Always build with all tags, there's a single build anyway.
docker build \
    -t index.docker.io/$CI_REGISTRY_IMAGE:latest \
    -t index.docker.io/$CI_REGISTRY_IMAGE:$MAJOR \
    -t index.docker.io/$CI_REGISTRY_IMAGE:$MINOR \
    -t index.docker.io/$CI_REGISTRY_IMAGE:$REVISION .

# Login with Docker Registry.
echo $CI_REGISTRY_BOT_PASSWORD | docker login -u $CI_REGISTRY_BOT_USERNAME docker.io --password-stdin

# Only push requested builds. 
if [ $BUILD_LATEST ]; then docker push index.docker.io/$CI_REGISTRY_IMAGE:latest; fi
if [ $BUILD_MAJOR ]; then docker push index.docker.io/$CI_REGISTRY_IMAGE:$MAJOR; fi
if [ $BUILD_MINOR ]; then docker push index.docker.io/$CI_REGISTRY_IMAGE:$MINOR; fi
if [ $BUILD_REVISION ]; then docker push index.docker.io/$CI_REGISTRY_IMAGE:$REVISION; fi