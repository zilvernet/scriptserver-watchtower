#!/bin/bash
docker stop watchtower
docker rm watchtower
docker pull containrrr/watchtower
docker run -d \
    --name watchtower-scheduler \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e TZ=America/New_York \
#    -e WATCHTOWER_NOTIFICATIONS=slack \
#    -e WATCHTOWER_NOTIFICATION_SLACK_HOOK_URL="https://hooks.slack.com/services/{webhookapi}" \
#    -e WATCHTOWER_NOTIFICATION_SLACK_IDENTIFIER={server-identifier} \
#    -e WATCHTOWER_NOTIFICATION_SLACK_CHANNEL=#{slackchannel} \
    containrrr/watchtower \
    --cleanup \
    --label-enable \
    --schedule "0 0 4 * * *" #it runs daily at 4am
