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