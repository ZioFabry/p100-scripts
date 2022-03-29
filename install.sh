#!/bin/bash

mkdir /etc/biomine-scripts

wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/ping.sh -O /etc/biomine-scripts/ping.sh
chmod 755 /etc/biomine-scripts/ping.sh

wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/biomine-ping.service -O /etc/systemd/system/biomine-ping.service
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/biomine-ping.timer -O /etc/systemd/system/biomine-ping.timer

systemctl start biomine-ping.timer
systemctl enable biomine-ping.timer
systemctl start biomine-ping.service
