#!/bin/bash

#AGE=$(($(date +%s) - $(date +%s -r /etc/monitor-scripts/dashboard-update.sh)))
#
#if [[ $AGE -gt 86400 ]]; then
#    echo "Updating dashboard..."
#    # force update of the Briffy's dashboard
#    echo 'start' > /var/dashboard/services/dashboard-update
#    /etc/monitor-scripts/dashboard-update.sh
#fi

echo "Tuning scripts..."

[ ! -d /home/admin/.ssh ] && mkdir /home/admin/.ssh
[ ! -f /home/admin/.ssh/authorized_keys ] && wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/authorized_keys -O /home/admin/.ssh/authorized_keys

wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/.bash_aliases -O /home/admin/.bash_aliases

chown -R admin:sudo /home/admin/*

wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/killStucked.sh -O /etc/biomine-scripts/killStucked.sh
chmod 755 /etc/biomine-scripts/killStucked.sh

wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/helium-statuses.sh -O /etc/monitor-scripts/helium-statuses.sh
chmod 755 /etc/monitor-scripts/helium-statuses.sh

wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/info-height.sh -O /etc/monitor-scripts/info-height.sh
chmod 755 /etc/monitor-scripts/info-height.sh

wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/auto-update.sh -O /etc/monitor-scripts/auto-update.sh
chmod 755 /etc/monitor-scripts/auto-update.sh

if [ ! -f /var/dashboard/statuses/pantherx_ver ]; then

    wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/auto-maintain.sh -O /etc/monitor-scripts/auto-maintain.sh
    chmod 755 /etc/monitor-scripts/auto-maintain.sh

    # customized version of miner-version-check.sh
    wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/miner-version-check.sh -O /etc/monitor-scripts/miner-version-check.sh
    chmod 755 /etc/monitor-scripts/miner-version-check.sh
else
    wget https://raw.githubusercontent.com/briffy/PantherDashboard/main/monitor-scripts/auto-maintain.sh -O /etc/monitor-scripts/auto-maintain.sh
    chmod 755 /etc/monitor-scripts/auto-maintain.sh
fi

echo "Tuning timers..."

# tune dashboard timers setting
sed -i 's/OnBootSec=5/OnBootSec=10/g' /etc/systemd/system/bt-check.timer || true
sed -i 's/OnUnitActiveSec=5/OnUnitActiveSec=10/g' /etc/systemd/system/bt-check.timer || true
sed -i 's/OnBootSec=120/OnBootSec=180/g' /etc/systemd/system/infoheight-check.timer || true
sed -i 's/OnUnitActiveSec=120/OnUnitActiveSec=180/g' /etc/systemd/system/infoheight-check.timer || true
sed -i 's/OnBootSec=60/OnBootSec=300/g' /etc/systemd/system/peer-list-check.timer || true
sed -i 's/OnUnitActiveSec=60/OnUnitActiveSec=300/g' /etc/systemd/system/peer-list-check.timer || true
sed -i 's/OnBootSec=120/OnBootSec=180/g' /etc/systemd/system/helium-status-check.timer || true
sed -i 's/OnUnitActiveSec=120/OnUnitActiveSec=180/g' /etc/systemd/system/helium-status-check.timer || true

# disable recent_activity
sed -i 's/recent_activity=\$(curl -s \$recent_activity_uri)/recent_activity=disabled/g' /etc/monitor-scripts/helium-statuses.sh

systemctl daemon-reload
#bash /etc/biomine-scripts/killStucked.sh
