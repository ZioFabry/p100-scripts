#!/bin/bash
name=$(sudo docker ps -a -f name=miner --format "{{ .Names }}")
if [[ $(ps -ef|grep "docker exec $name miner"|grep -v grep) -eq 0 ]]; then
    height=$(sudo docker exec $name miner info height |awk '{print $NF;}')
    if [[ $? -eq 0 ]]; then
        echo $height > /var/dashboard/statuses/infoheight
    fi
fi
