#!/bin/bash
DOCKER_IMAGE_NAME=mika-sandbox/docker-discord-websocket-bot

# build
echo "Building Docker image for this repository"
docker build . --tag $DOCKER_IMAGE_NAME:develop $*

# linting
echo "Linting Dockerfile"
dockle $DOCKER_IMAGE_NAME:develop
