#!/bin/bash

# ========================
# Configuration Variables
# ========================

timezone="America/New_York"
cron="0 0 4 * * *"
slack_hook_url="https://hooks.slack.com/services/TOKEN"
slack_channel="#channel"
slack_identifier="watchtower-$(hostname)"
watchtower="scheduler"

# ========================
# Start Script
# ========================

echo "Using configuration:"
echo "    timezone=$timezone"
echo "    cron=$cron"
echo "    slack_hook_url=$slack_hook_url"
echo "    slack_channel=$slack_channel"
echo "    slack_identifier=$slack_identifier"

echo -e "\nStopping existing container (if any):"
docker stop "$watchtower"

echo -e "\nRemoving existing container (if any):"
docker rm "$watchtower"

echo -e "\nPulling latest Watchtower image:"
docker pull containrrr/watchtower

echo -e "\nStarting Watchtower container..."
docker run -d \
    --name "$watchtower" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e TZ="$timezone" \
    -e WATCHTOWER_NOTIFICATIONS=slack \
    -e WATCHTOWER_NOTIFICATION_SLACK_HOOK_URL="$slack_hook_url" \
    -e WATCHTOWER_NOTIFICATION_SLACK_IDENTIFIER="$slack_identifier" \
    -e WATCHTOWER_NOTIFICATION_SLACK_CHANNEL="$slack_channel" \
    containrrr/watchtower \
    --cleanup \
    --label-enable \
    --schedule "$cron"
