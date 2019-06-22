#!/bin/bash

# cleanup intermediate images
echo "Cleanup intermediate build caches"
docker rmi -f $(docker images -q --filter label=stage=intermediate)
