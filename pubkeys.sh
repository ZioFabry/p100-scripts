#!/bin/bash

name=$(sudo docker ps -a -f name=miner --format "{{ .Names }}")
data=$(sudo docker exec $name miner print_keys)

if [[ $data =~ animal_name,\"([^\"]*) ]]; then
  match="${BASH_REMATCH[1]}"
  echo "${match//-/ }" > /var/dashboard/statuses/animal_name
fi

if [[ $data =~ pubkey,\"([^\"]*) ]]; then
  match="${BASH_REMATCH[1]}"
  echo $match > /var/dashboard/statuses/pubkey
fi
