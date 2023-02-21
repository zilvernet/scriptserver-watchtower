#!/bin/bash

echo "Loading parameters from watchtower.ini:"
# Load the timezone from the ini file
timezone=$(awk -F'=' '/^\[Timezone\]/{f=1} f==1&&$1~/^timezone/{print $2;exit}' watchtower.ini)
echo "    timezone="$timezone

# Load the cron schedule from the ini file
cron=$(awk -F "=" '/^\[Schedule\]$/{f=1} f==1 && $1=="cron"{gsub(/"/,"",$2); print $2; f=0}' watchtower.ini)
echo "    cron=$cron"

# Load the Slack configuration from the ini file
slack_hook_url=$(awk -F'=' '/^\[Slack\]/{f=1} f==1&&$1~/^slack_hook_url/{print $2;exit}' watchtower.ini)
echo "    slack_hook_url=$slack_hook_url"
slack_channel=$(awk -F'=' '/^\[Slack\]/{f=1} f==1&&$1~/^slack_channel/{print $2;exit}' watchtower.ini)
echo "    slack_channel=$slack_channel"

# Get the current server hostname and add the "watchtower-" prefix
slack_identifier="watchtower-$(hostname)"
echo "    slack_identifier=$slack_identifier"

# Run the Watchtower Scheduler
watchtower=scheduler
echo -e "\nStopping: "
docker stop $watchtower
echo -e "\nRemoving: "
docker rm $watchtower
echo -e "\nStarting: \n$watchtower"
docker pull containrrr/watchtower
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
