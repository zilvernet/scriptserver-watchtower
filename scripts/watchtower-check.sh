#!/bin/bash

# remove all files from updates subfolder
rm -f updates/*

# create subdirectory for output files
mkdir -p updates

# run watchtower command and capture output
output=$(docker run --rm \
    --name watchtower-check-updates \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /etc/localtime:/etc/localtime:ro \
    --log-driver=syslog \
    --log-opt syslog-address="udp://127.0.0.1:514" \
    --log-opt tag="watchtower" \
    containrrr/watchtower \
    --interval 1 \
    --run-once \
    --monitor-only \
    --notification-report 2>&1)

# regular expression pattern to extract image names
pattern="Found new (\S+)"

# search for pattern in watchtower output
matches=$(echo "$output" | grep -oE "$pattern" | cut -d " " -f 3)
echo "$matches" | sed -E 's|.*/(.+):.*|\1|' > image_list.txt

# loop through each image name and write its updates to a file
while read -r image_name; do
  # get rule for this image from INI file
  image_rule=$(awk -F= -v image_name="$image_name" '/^\[image-container\]/{f=1; next} /^\[/{f=0} f && $1 == image_name {gsub(/^\s+|\s+$/,"",$2); print $2; exit}' image-container.ini)

  # apply rule if it exists, otherwise use the image name as-is
  if [ -n "$image_rule" ]; then
      image_namefix="$image_rule"
  else
      image_namefix="$image_name"
  fi

  # search for updates for this image and write to a file with the image name
  if [ -n "$image_namefix" ]; then
    echo "$output" | grep "$image_name" | sed -E 's|^[^/]+/(.+)$|\1|' > "updates/$image_namefix"
  fi
done < <(echo "$matches" | sed -E 's|.*/(.+):.*|\1|')

# print message to confirm files were written
if [ -n "$matches" ]; then
    echo "New updates were found:"
    echo "$matches" | sed -E 's|.*/(.+):.*|\1|'
else
    echo "No updates were found."
fi
