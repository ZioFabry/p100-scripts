#!/bin/bash

# force update of the Briffy's dashboard
echo 'running' > /var/dashboard/services/dashboard-update
wget https://raw.githubusercontent.com/briffy/PiscesQoLDashboard/main/update.sh -O - | sudo bash

# customized version of miner-version-check.sh
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/miner-version-check.sh -O /etc/monitor-scripts/miner-version-check.sh
chmod 755 /etc/monitor-scripts/miner-version-check.sh

# tune dashboard timers setting
sed -i 's/OnBootSec=5/OnBootSec=10/g' bt-check.timer
sed -i 's/OnUnitActiveSec=5/OnUnitActiveSec=10/g' bt-check.timer
sed -i 's/OnBootSec=120/OnBootSec=180/g' infoheight-check.timer
sed -i 's/OnUnitActiveSec=120/OnUnitActiveSec=180/g' infoheight-check.timer
sed -i 's/OnBootSec=60/OnBootSec=300/g' peer-list-check.timer
sed -i 's/OnUnitActiveSec=60/OnUnitActiveSec=300/g' peer-list-check.timer
sed -i 's/OnBootSec=120/OnBootSec=180/g' helium-status-check.timer
sed -i 's/OnUnitActiveSec=120/OnUnitActiveSec=180/g' helium-status-check.timer

# disable recent_activity
sed -i 's/recent_activity=\$(curl -s \$recent_activity_uri)/recent_activity=disabled/g' /etc/monitor-scripts/helium-statuses.sh

# Update BioCC
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/ping.sh -O /etc/biomine-scripts/ping.sh
chmod 755 /etc/biomine-scripts/ping.sh

wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/helium-statuses.sh -O /etc/biomine-scripts/helium-statuses.sh
chmod 755 /etc/biomine-scripts/helium-statuses.sh

wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/biomine-ping.service -O /etc/systemd/system/biomine-ping.service
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/biomine-ping.timer -O /etc/systemd/system/biomine-ping.timer

systemctl start biomine-ping.timer
systemctl enable biomine-ping.timer
systemctl start biomine-ping.service

systemctl daemon-reload
