#!/bin/bash
if systemctl is-active --quiet helium; then
    echo "true" > /var/dashboard/statuses/miner
else
    echo "false" > /var/dashboard/statuses/miner
fi

