#!/bin/bash

# Exit on error
set -e

# Variables
APP_DIR="/var/www/backend"
LOG_DIR="/var/log/backend"
NODE_ENV="production"

# Make sure log directory exists
mkdir -p $LOG_DIR

echo ">>> Moving to backend directory..."
cd $APP_DIR

echo ">>> Installing dependencies..."
npm install --production

echo ">>> Starting backend with PM2..."
pm2 delete backend || true
pm2 start app.js --name backend --env $NODE_ENV --log $LOG_DIR/backend.log

echo ">>> Saving PM2 process list..."
pm2 save
pm2 startup systemd -u $USER --hp $HOME

echo ">>> Backend API is running!"
