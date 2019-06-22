#!/bin/bash

# build
docker build . --tag docker-discord-websocket-bot:develop

# cleanup intermediate images
docker rmi -f $(docker images -q --filter label=stage=intermediate)

# linting
dockle docker-discord-websocket-bot:develop
