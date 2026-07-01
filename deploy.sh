#!/bin/bash
set -e

echo "Deploying Flask application via systemd..."
sudo systemctl restart flaskapp
sleep 2

if systemctl is-active --quiet flaskapp; then
    echo "Deployment successful. flaskapp service is running."
else
    echo "Deployment failed — check: journalctl -u flaskapp -n 50"
    exit 1
fi
