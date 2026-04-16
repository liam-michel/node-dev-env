#!/bin/bash

#this script is responsible for setting up a new project in the dev environment.
#it creates a new directory for the project and copies the template files

PROJECT_NAME=$1
DEV_ENVIRONMENT_DIRECTORY="/home/dev-user/dev-environment"

#if project name not provided, exit with error
if [ -z "$PROJECT_NAME" ]; then
    echo "Error: Project name not provided."
    echo "Usage: $0 <project-name>"
    exit 1
fi

#check if project already exists in dev environment directory
if [ -d "$DEV_ENVIRONMENT_DIRECTORY/$PROJECT_NAME" ]; then
    echo "Error: Project '$PROJECT_NAME' already exists in dev environment."
    exit 1
fi

#create new project directory
mkdir -p "$DEV_ENVIRONMENT_DIRECTORY/$PROJECT_NAME"

#copy template files to new project directory
cp -r $HOME/template/. "$DEV_ENVIRONMENT_DIRECTORY/$PROJECT_NAME/"

echo "Project '$PROJECT_NAME' created successfully in dev environment."

exit 0

