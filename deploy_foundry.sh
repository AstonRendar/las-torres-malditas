#!/bin/bash

# This script automates the deployment of a Foundry VTT game system.
# It builds the game system, copies it to the Foundry VTT systems directory,
# and restarts Foundry VTT to apply the changes.

# Install dependencies and build the game system
#npm install
npm run build

# Retrieve the value of 'id' from system.json
GAME_SYSTEM_ID=$(jq -r '.id' system.json)
echo "Game system ID: $GAME_SYSTEM_ID"


# Load environment variables
source "$(dirname "$0")/.env"


# Check if environment variables are set
if [ -z "$SOURCE_DIR" ] || [ -z "$DEST_DIR" ] || [ -z "$FOUNDRY_PATH" ] || [ -z "$LOG_PATH" ]; then
  echo "One or more environment variables are not set. Please check the .env file."
  exit 1
fi


# Display loaded environment variables
echo "/--------------------------------"
echo "Loaded environment variables:"
echo "  SOURCE_DIR: $SOURCE_DIR"
echo "  DEST_DIR: $DEST_DIR"
echo "  FOUNDRY_PATH: $FOUNDRY_PATH"
echo "  LOG_PATH: $LOG_PATH"
echo "--------------------------------/"


# Copy the contents of the game system folder to the Foundry VTT systems folder
# Make sure the destination directory exists
mkdir -p "$DEST_DIR"
# Check if the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "The source directory ($SOURCE_DIR) does not exist. Please check the path."
  exit 1
fi
# Prepare the destination directory for logs
mkdir -p "$(dirname "$LOG_PATH")"


# If the destination directory already exists, its contents will be overwritten
# You can change the source and destination paths as needed
# Note: Make sure the user running this script has permission to write to the destination directory
cp -r "$SOURCE_DIR"/* "$DEST_DIR/"
# Check if the copy was successful
if [ $? -eq 0 ]; then
  echo "Game system successfully copied to Foundry VTT."
else
  echo "Error copying the game system."
  exit 1
fi
# Restart Foundry VTT so changes take effect
echo "Restarting Foundry VTT..."
pkill -f "foundryvtt" && sleep 2
# Clear the Foundry VTT log
> "$LOG_PATH" 2>&1
# Start Foundry VTT
"$FOUNDRY_PATH" --no-sandbox > "$LOG_PATH" 2>&1 &
# Check if Foundry VTT started successfully
if [ $? -eq 0 ]; then
  echo "Foundry VTT started successfully."
else
  echo "Error starting Foundry VTT."
  exit 1
fi
# End of script
