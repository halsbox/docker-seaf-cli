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

# Restrict to pipeline triggered by pushes.
if [ $CI_PIPELINE_SOURCE != "push" ]; then
    echo "This must be only ran from pushes."
    exit 1
fi

# Login with Docker Registry.
echo $CI_REGISTRY_BOT_PASSWORD | docker login -u $CI_REGISTRY_BOT_USERNAME docker.io --password-stdin

# Build and push as staging.
docker build -t index.docker.io/$CI_REGISTRY_IMAGE:staging-supervisord Dockerfile.supervisord
docker build -t index.docker.io/$CI_REGISTRY_IMAGE:staging-cron Dockerfile.cron
docker push index.docker.io/$CI_REGISTRY_IMAGE:staging-supervisord
docker push index.docker.io/$CI_REGISTRY_IMAGE:staging-cron