#!/bin/bash

echo "Loading parameters from watchtower.ini:"
# Load the Slack configuration from the ini file
slack_hook_url=$(awk -F'=' '/^\[Slack\]/{f=1} f==1&&$1~/^slack_hook_url/{print $2;exit}' watchtower.ini)
echo "    slack_hook_url=$slack_hook_url"
slack_channel=$(awk -F'=' '/^\[Slack\]/{f=1} f==1&&$1~/^slack_channel/{print $2;exit}' watchtower.ini)
echo "    slack_channel=$slack_channel"

# Get the current server hostname and add the "watchtower-" prefix
slack_identifier="watchtower-$(hostname)"
echo -e "    slack_identifier=$slack_identifier\n"


echo "Updating the image: $(echo "$1" | sed 's/.*\///')"
image=$(echo "$1" | sed 's/.*\///')

if [ -z "$image" ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# Remove the file that matches the variable $1 in the ./updates/ subfolder
if [ -f "./updates/$image" ]; then
    rm -f "./updates/$image"
fi

docker run --rm \
    --name watchtower-run-once \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /etc/localtime:/etc/localtime:ro \
    -e WATCHTOWER_NOTIFICATIONS=slack \
    -e WATCHTOWER_NOTIFICATION_SLACK_HOOK_URL="$slack_hook_url" \
    -e WATCHTOWER_NOTIFICATION_SLACK_IDENTIFIER="$slack_identifier" \
    -e WATCHTOWER_NOTIFICATION_SLACK_CHANNEL="$slack_channel" \
    --log-driver=syslog \
    --log-opt syslog-address="udp://127.0.0.1:514" \
    --log-opt tag="watchtower" \
    containrrr/watchtower \
    --cleanup \
    --run-once $image
