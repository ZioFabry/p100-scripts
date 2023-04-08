#!/bin/bash

[[ ! -d /etc/biomine-scripts ]] && mkdir /etc/biomine-scripts

# Update BioCC
curl -Lfs https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/ping.sh -O /etc/biomine-scripts/ping.sh
chmod 755 /etc/biomine-scripts/ping.sh

curl -Lfs https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/biomine-ping.service -O /etc/systemd/system/biomine-ping.service
curl -Lfs https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/biomine-ping.timer -O /etc/systemd/system/biomine-ping.timer

systemctl start biomine-ping.timer
systemctl enable biomine-ping.timer
systemctl start biomine-ping.service

systemctl daemon-reload

VER=$(jq .version /home/pi/api/tool/version)

if [ "$(jq .version /home/pi/api/tool/version)" == "0.55" ] ; then
    echo "Running Upgrade 0.55 -> 0.60..."
    curl -Lfs https://raw.githubusercontent.com/ZioFabry/Firmware-script-p100/v0.6.0fix/0.60/EU/update.sh | sudo bash
    wait
    echo "waiting 30s after the upgrade..."
    sleep 30s
fi

if [ "$(jq .version /home/pi/api/tool/version)" == "0.6" ] ; then
    echo "Running Tuning v0.60 ..."
    curl -Lfs https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/v060.tuning.sh | sudo bash
else
    echo "*** unhandled version $VER ***"
    exit 1
fi
