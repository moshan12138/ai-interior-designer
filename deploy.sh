#!/bin/bash
set -e

DEPLOY_DIR="$HOME/ai-interior-designer"
REPO_URL="https://github.com/moshan12138/ai-interior-designer.git"

if [ ! -d "$DEPLOY_DIR" ]; then
    echo "Cloning repository..."
    git clone "$REPO_URL" "$DEPLOY_DIR"
    cd "$DEPLOY_DIR"
else
    echo "Updating repository..."
    cd "$DEPLOY_DIR"
    git pull origin main
fi

if [ ! -f .env ]; then
    echo "Warning: .env file not found. Copying from .env.example..."
    cp .env.example .env
    echo "Please edit .env with your actual credentials before running again."
    exit 1
fi

echo "Building and starting services..."
docker compose --env-file .env up -d --build

echo "Cleaning up unused images..."
docker image prune -f

echo "Deployment complete!"
docker compose ps
