#!/bin/bash

echo "Updating BioCC..."

# Update BioCC
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/ping.sh -O /etc/biomine-scripts/ping.sh
chmod 755 /etc/biomine-scripts/ping.sh

wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/killStucked.sh -O /etc/biomine-scripts/killStucked.sh
chmod 755 /etc/biomine-scripts/killStucked.sh

wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/helium-statuses.sh -O /etc/biomine-scripts/helium-statuses.sh
chmod 755 /etc/biomine-scripts/helium-statuses.sh

wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/biomine-ping.service -O /etc/systemd/system/biomine-ping.service
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/biomine-ping.timer -O /etc/systemd/system/biomine-ping.timer

systemctl start biomine-ping.timer
systemctl enable biomine-ping.timer
systemctl start biomine-ping.service

systemctl daemon-reload

echo "running killStucked script..."
/etc/biomine-scripts/killStucked.sh

echo "waiting 30s..."
sleep 30s

AGE=$(($(date +%s) - $(date +%s -r /etc/monitor-scripts/dashboard-update.sh)))

if [[ $AGE -gt 86400 ]]; then
    echo "Updating dashboard..."
    # force update of the Briffy's dashboard
    echo 'start' > /var/dashboard/services/dashboard-update
    /etc/monitor-scripts/dashboard-update.sh
fi

echo "Tuning..."

curl -s https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/tuning.sh | sudo bash
