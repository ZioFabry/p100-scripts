#!/bin/bash
if [[ $(ps -ef|grep 'docker exec miner miner'|grep -v grep) -eq 0 ]]; then
    height=$(sudo docker exec miner miner info height |awk '{print $NF;}')
    if [[ $? -eq 0 ]]; then
        echo $height > /var/dashboard/statuses/infoheight
    fi
fi
