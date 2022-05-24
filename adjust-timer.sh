#!/bin/bash

[[ ! -f /etc/systemd/system/$1.timer ]] && exit 0

sed -i "s/OnBootSec=.*/OnBootSec=$2/g" /etc/systemd/system/$1.timer 
sed -i "s/OnUnitActiveSec=.*/OnUnitInactiveSec=$3/g" /etc/systemd/system/$1.timer 
sed -i "s/OnUnitInactiveSec=.*/OnUnitInactiveSec=$3/g" /etc/systemd/system/$1.timer
