#!/bin/bash
set -e

echo "🔧 Building user-service..."
cd ../user-service
make docker

echo "🔧 Building friend-service..."
cd ../friend-service
make docker

echo "🔧 Building push-service..."
cd ../push-service
make docker

echo "🚀 Starting all services with docker-compose..."
cd ../MY-CHAT
docker-compose up -d