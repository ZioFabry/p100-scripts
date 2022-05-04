#!/bin/bash

wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/helium-statuses.sh -O /etc/biomine-scripts/helium-statuses.sh
chmod 755 /etc/biomine-scripts/helium-statuses.sh

wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/info-height.sh -O /etc/monitor-scripts/info-height.sh
chmod 755 /etc/biomine-scripts/helium-statuses.sh

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

