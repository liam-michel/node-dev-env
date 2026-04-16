# node-dev-env

A containerised Node.js/TypeScript development environment. Handles dependencies, tooling, and runtime so you can focus on writing code.

## Quickstart

```bash
/bin/bash -c "$(curl -fsSL https://github.com/liam-michel/node-dev-env/releases/latest/download/start.sh)"
```

This will:
- Pull the latest release
- Build the Docker image
- Start the container and drop you into a shell

## Requirements

- Docker

## Usage

Once inside the container, create a new project:

```bash
newproject <project-name>
```

This scaffolds a new TypeScript/Bun project into `~/.dev/dev-environment/<project-name>` on your host machine. Your projects persist outside the container, so they're safe across rebuilds.

To run your project:

```bash
cd <project-name>
bun run start
```

To debug (attach via VS Code or Chrome DevTools on `localhost:9229`):

```bash
bun run debug
```

## Project structure

```
~/.dev/
└── dev-environment/
    └── <your-projects>/
```

## Development

To work on the environment itself, use the dev setup:

```bash
cd dev/
./start.sh
```
