#!/bin/bash

# Just build and push as staging.
docker build -t $CI_REGISTRY_IMAGE:staging .
docker push $CI_REGISTRY_IMAGE:staging