#!/bin/bash
if systemctl is-active --quiet helium; then
    echo "true" > /var/dashboard/statuses/miner
else
    echo "false" > /var/dashboard/statuses/miner
fi

/etc/helium_gateway/helium_gateway --version > /var/dashboard/statuses/current_miner_version
