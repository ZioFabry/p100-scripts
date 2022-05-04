#!/bin/bash
sudo docker exec miner miner info height |awk '{print $NF;}' | sudo tee /var/dashboard/statuses/infoheight
