#!/bin/bash

# Exit on error
set -e

# Variables
APP_DIR="/var/www/frontend"
BUILD_DIR="$APP_DIR/build"
NGINX_SITE="/etc/nginx/sites-available/frontend"
NGINX_LINK="/etc/nginx/sites-enabled/frontend"

echo ">>> Moving to frontend directory..."
cd $APP_DIR

echo ">>> Installing dependencies..."
npm install --production

echo ">>> Building frontend..."
npm run build

echo ">>> Setting up Nginx..."
sudo tee $NGINX_SITE > /dev/null <<EOL
server {
    listen 80;
    server_name _;

    root $BUILD_DIR;
    index index.html;

    location / {
        try_files \$uri /index.html;
    }
}
EOL

sudo ln -sf $NGINX_SITE $NGINX_LINK
sudo nginx -t
sudo systemctl restart nginx

echo ">>> Frontend is deployed and running on port 80!"
