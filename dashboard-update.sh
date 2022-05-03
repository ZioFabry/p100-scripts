#!/bin/bash
service=$(cat /var/dashboard/services/dashboard-update | tr -d '\n')

if [[ $service == 'start' ]]; then
  echo 'running' > /var/dashboard/services/dashboard-update
  wget https://raw.githubusercontent.com/briffy/PiscesQoLDashboard/main/update.sh -O - | sudo bash
  cp /var/dashboard/update /var/dashboard/version
  curl -s https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/tuning.sh | sudo bash
fi
