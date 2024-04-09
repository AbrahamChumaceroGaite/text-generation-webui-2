#! /usr/bin/env bash

# check to see if yq is installed
if ! [ -x "$(command -v yq)" ]; then
  VERSION=v4.2.0
  BINARY=yq_linux_amd64
  sudo wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY} -O /usr/bin/yq &&\
  sudo chmod +x /usr/bin/yq
fi

full_image_name=$(yq e '.services.textgen.image' docker-compose.yml)
image_name_without_tag=$(echo $full_image_name | cut -d: -f1)
docker tag $full_image_name $image_name_without_tag:latest
docker push $image_name_without_tag:latest