#!/bin/bash

echo "Updating components..."

wget https://raw.githubusercontent.com/inigoflores/helium-miner-log-analyzer/main/processlogs.php -O ~/processlogs.php 
chmod a+x ~/processlogs.php

wget https://raw.githubusercontent.com/moophlo/pisces-miner-scripts/main/clear_resync.sh -O /usr/bin/clear_resync.sh
chmod +x /usr/bin/clear_resync.sh

wget https://raw.githubusercontent.com/moophlo/pisces-miner-scripts/main/crontab_job.sh -O - | sudo bash

echo "Installing remoteit..."

wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/remoteit.sh -O - | sudo bash

echo "Updating dashboard..."
if [ -f /var/dashboard/statuses/pantherx_ver ]; then
    wget https://raw.githubusercontent.com/briffy/PantherDashboard/main/update.sh -O - | sudo bash
else
    wget https://raw.githubusercontent.com/briffy/PiscesQoLDashboard/main/update.sh -O - | sudo bash
fi

echo "Installing BioCC..."

apt-get update
apt-get -f --assume-yes install jq dnsutils

[[ ! -d /etc/biomine-scripts ]] && mkdir /etc/biomine-scripts

# Update BioCC
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/ping.sh -O /etc/biomine-scripts/ping.sh
chmod 755 /etc/biomine-scripts/ping.sh

wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/biomine-ping.service -O /etc/systemd/system/biomine-ping.service
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/biomine-ping.timer -O /etc/systemd/system/biomine-ping.timer

systemctl start biomine-ping.timer
systemctl enable biomine-ping.timer
systemctl start biomine-ping.service

systemctl daemon-reload

echo "Running Tuning..."

curl -s https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/tuning.sh | sudo bash

bash /etc/monitor-scripts/miner-version-check.sh

echo start | sudo tee /var/dashboard/services/miner-update
echo enabled | sudo tee /var/dashboard/services/auto-maintain
echo enabled | sudo tee /var/dashboard/services/auto-update
