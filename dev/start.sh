#!/bin/bash

DEV_DIRECTORY="$HOME/dev-env"
DEV_ENVIRONMENT_DIRECTORY="$HOME/.dev/dev-environment"

DOCKER_COMPOSE_FILE_LOCATION=$DEV_DIRECTORY/dev/docker-compose.yml


#check if docker daemon is running
if ! docker info > /dev/null 2>&1; then 
    echo "Docker daemon is not running. Please start the Docker daemon and try again."
    exit 1
fi

#setup required directories on host machine
directories=($DEV_DIRECTORY $DEV_ENVIRONMENT_DIRECTORY)

for dir in "${directories[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "Created directory: $dir"
    fi
done

#stop any running container if any
docker-compose -f $DOCKER_COMPOSE_FILE_LOCATION down || true
docker rm -f dev-env 2>/dev/null || true

#run docker-compose to start the container

USER_ID=$(id -u) GROUP_ID=$(id -g) docker-compose -f $DOCKER_COMPOSE_FILE_LOCATION up --build --detach dev-env

#display latest logs
docker-compose -f $DOCKER_COMPOSE_FILE_LOCATION logs dev-env
#attach to the container
docker attach dev-env

