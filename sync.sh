#!/bin/bash

# Read JSON data from file
json_data=$(cat images.json)

# Docker Hub username
username="kubeagi"


# Log in to Docker Hub
echo "$DOCKER_TOKEN" | docker login -u "$username" --password-stdin

# Iterate over each image mapping
echo "$json_data" | jq -c '.[]' | while IFS= read -r mapping; do
  from_image=$(echo "$mapping" | jq -r '.from')
  to_image=$(echo "$mapping" | jq -r '.to')

  echo "sync image from $from_image to $to_image"

  # Pull the "from" image
  docker pull "$from_image"

  # Tag the "from" image with the "to" image name
  docker tag "$from_image" "$to_image"

  # Push the "to" image to Docker Hub
  echo "push to $to_image"
  docker push "$to_image"
done