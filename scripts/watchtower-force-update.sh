#!/bin/bash

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
#    -e WATCHTOWER_NOTIFICATIONS=slack \
#    -e WATCHTOWER_NOTIFICATION_SLACK_HOOK_URL="https://hooks.slack.com/services/{webhookapi}"} \
#    -e WATCHTOWER_NOTIFICATION_SLACK_IDENTIFIER={server-identifier} \
#    -e WATCHTOWER_NOTIFICATION_SLACK_CHANNEL=#{slackchannel} \
    --log-driver=syslog \
    --log-opt syslog-address="udp://127.0.0.1:514" \
    --log-opt tag="watchtower" \
    containrrr/watchtower \
    --cleanup \
    --run-once $image
