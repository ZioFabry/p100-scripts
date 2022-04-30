#!/bin/bash

if [ "$HOSTNAME" = "rasberrypi" ]; then
    hostnamectl set-hostname "p100-$(cat /sys/class/net/eth0/address|tr -d ':')"
fi

export R3_BULK_REGISTRATION_CODE=D6323F42-E3A7-1720-906A-27BD07C9342C
sh -c "$(curl -L https://downloads.remote.it/remoteit/install_agent.sh)"
