#!/bin/bash
set -e

VENV_DIR="venv"
FLASK_PORT=5000
APP_NAME="app.py"
LOG_FILE="flask.log"
PID_FILE="flask.pid"

echo "Deploying Flask application..."

source "$VENV_DIR/bin/activate"

if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    if ps -p "$OLD_PID" > /dev/null 2>&1; then
        echo "Stopping previous instance (PID $OLD_PID)..."
        kill "$OLD_PID"
        sleep 1
    fi
    rm -f "$PID_FILE"
fi

echo "Starting Flask app on port $FLASK_PORT..."
setsid nohup python "$APP_NAME" > "$LOG_FILE" 2>&1 < /dev/null &
disown
NEW_PID=$!
echo "$NEW_PID" > "$PID_FILE"

sleep 2

if ps -p "$NEW_PID" > /dev/null 2>&1; then
    echo "Deployment successful. App running with PID $NEW_PID."
else
    echo "Deployment failed — check $LOG_FILE for details."
    exit 1
fi
