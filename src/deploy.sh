#!/bin/bash
set -e  # Exit immediately if a command fails
set -o pipefail

# ------------------------------------------
# Deployment script for Lycosidae project
# ------------------------------------------

# Load environment variables from .env
ENV_FILE=".env"
if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: $ENV_FILE not found!"
  exit 1
fi
export $(grep -v '^#' $ENV_FILE | xargs)

echo "------------------------------------------"
echo "Deploying Lycosidae Docker Compose stack"
echo "Using env file: $ENV_FILE"
echo "------------------------------------------"

# Stop and remove old containers (optional)
echo "Stopping and removing old containers..."
docker compose down

# Build and start services in detached mode
echo "Building and starting services..."
docker compose up --build -d

# Show status
echo "Deployment complete! Current containers:"
docker compose ps

echo "You can view logs with: docker compose logs -f"
