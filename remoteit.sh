#!/bin/bash

export R3_BULK_REGISTRATION_CODE=D6323F42-E3A7-1720-906A-27BD07C9342C

OLDHOST=$(hostname)

if [ "$OLDHOST" == "raspberrypi" ]; then
    NEWHOST="p100-$(cat /sys/class/net/eth0/address|tr -d ':')"

    echo $NEWHOST | tee /etc/hostname

    hostnamectl set-hostname $NEWHOST

    sed -i "s/${OLDHOST}/${NEWHOST}/g" /etc/hosts

    systemctl restart avahi-daemon

    export HOSTNAME=$NEWHOST
fi

if [ $(dpkg --list|grep remoteit|wc -l) == 0 ]; then
    sh -c "$(curl -L https://downloads.remote.it/remoteit/install_agent.sh)"
fi

