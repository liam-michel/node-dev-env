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

#update package.json name to match project name
sed -i "s/\"name\": \"code\"/\"name\": \"$PROJECT_NAME\"/" "$DEV_ENVIRONMENT_DIRECTORY/$PROJECT_NAME/package.json"

#update launch.json remoteRoot to match project path
sed -i "s|\"remoteRoot\": \"/home/dev-user/dev-environment\"|\"remoteRoot\": \"/home/dev-user/dev-environment/$PROJECT_NAME\"|" "$DEV_ENVIRONMENT_DIRECTORY/$PROJECT_NAME/.vscode/launch.json"

echo "Project '$PROJECT_NAME' created successfully in dev environment."

exit 0

