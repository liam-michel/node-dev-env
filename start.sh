#!/bin/bash

REPO="liam-michel/node-dev-env"
INSTALL_DIR="$HOME/.dev"
DEV_ENVIRONMENT_DIRECTORY="$INSTALL_DIR/dev-environment"

# check if docker daemon is running
if ! docker info > /dev/null 2>&1; then
    echo "Docker daemon is not running. Please start the Docker daemon and try again."
    exit 1
fi

# setup required directories
mkdir -p "$INSTALL_DIR" "$DEV_ENVIRONMENT_DIRECTORY"

# download Dockerfile and docker-compose from latest release
RELEASE_URL="https://api.github.com/repos/$REPO/releases/latest"
LATEST_TAG=$(curl -s "$RELEASE_URL" | grep '"tag_name"' | cut -d'"' -f4)
if [ -z "$LATEST_TAG" ]; then
    echo "Error: Could not resolve latest release version."
    exit 1
fi

BASE_URL="https://github.com/$REPO/releases/download/$LATEST_TAG"
echo "Downloading release $LATEST_TAG..."
curl -fsSL "$BASE_URL/Dockerfile.release" -o "$INSTALL_DIR/Dockerfile.release"
curl -fsSL "$BASE_URL/docker-compose.release.yml" -o "$INSTALL_DIR/docker-compose.release.yml"

# stop any running container
docker-compose -f "$INSTALL_DIR/docker-compose.release.yml" down || true
docker rm -f dev-env 2>/dev/null || true

# build and start
USER_ID=$(id -u) GROUP_ID=$(id -g) \
    docker-compose -f "$INSTALL_DIR/docker-compose.release.yml" up --build --detach dev-env

# display logs and attach
docker-compose -f "$INSTALL_DIR/docker-compose.release.yml" logs dev-env
docker attach dev-env
