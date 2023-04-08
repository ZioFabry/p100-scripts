#!/bin/bash

echo "Updating components..."

apt-get update
apt-get -f --assume-yes install jq dnsutils

# curl -Lfs https://raw.githubusercontent.com/inigoflores/helium-miner-log-analyzer/main/processlogs.php -o /home/admin/processlogs.php 
# chmod a+x ~/processlogs.php

# curl -Lfs https://raw.githubusercontent.com/moophlo/pisces-miner-scripts/main/clear_resync.sh -o /usr/bin/clear_resync.sh
# chmod +x /usr/bin/clear_resync.sh

# curl -Lfs https://raw.githubusercontent.com/moophlo/pisces-miner-scripts/main/crontab_job.sh | sudo bash

echo "Installing remoteit..."

curl -Lfs https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/remoteit.sh | sudo bash

echo "Updating dashboard..."
if [ -f /var/dashboard/statuses/pantherx_ver ]; then
    curl -Lfs https://raw.githubusercontent.com/briffy/PantherDashboard/main/update.sh | sudo bash
else
    curl -Lfs https://raw.githubusercontent.com/briffy/PiscesQoLDashboard/main/update.sh | sudo bash
fi

echo "Installing BioCC..."

[[ ! -d /etc/biomine-scripts ]] && mkdir /etc/biomine-scripts

echo "Running Update..."

curl -Lfs https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/update.sh | sudo bash
