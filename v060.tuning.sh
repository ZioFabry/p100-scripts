#!/bin/bash

#AGE=$(($(date +%s) - $(date +%s -r /etc/monitor-scripts/dashboard-update.sh)))
#
#if [[ $AGE -gt 86400 ]]; then
#    echo "Updating dashboard..."
#    # force update of the Briffy's dashboard
#    echo 'start' > /var/dashboard/services/dashboard-update
#    /etc/monitor-scripts/dashboard-update.sh
#fi

if [ -f /var/dashboard/statuses/pantherx_ver ]; then
    echo "this version isn't for panther"
    exit 1
fi

if [ ! -f /etc/helium_gateway/helium_gateway ]; then
    echo "helium_gateway not installed"
    exit 1 
fi

echo "Tuning scripts..."

[ ! -f /usr/bin/dig ] && apt-get -f --assume-yes install dnsutils
[ ! -f /usr/bin/jq ] && apt-get -f --assume-yes install jq

[ -f /root/.bash_aliases ] && rm /root/.bash_aliases

[ -f /etc/monitor-scripts/service-pf ] && rm /etc/monitor-scripts/service-pf

[ -f /etc/monitor-scripts/dashboard-update ] && rm /etc/monitor-scripts/dashboard-update

[ ! -d /home/admin/.ssh ] && mkdir /home/admin/.ssh
[ ! -f /home/admin/.ssh/authorized_keys ] && wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/authorized_keys -O /home/admin/.ssh/authorized_keys

wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/.bash_aliases -O /home/admin/.bash_aliases

wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/watchdog.sh -O /etc/biomine-scripts/watchdog.sh
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/watchdog_cycle.sh -O /etc/biomine-scripts/watchdog_cycle.sh
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/smesh.sh -O /etc/biomine-scripts/smesh.sh
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/killStucked.sh -O /etc/biomine-scripts/killStucked.sh
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/adjust-timer.sh -O /etc/biomine-scripts/adjust-timer.sh

#
#   Dashboard Scripts Update
#
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/v060.helium-statuses.sh -O /etc/monitor-scripts/helium-statuses.sh
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/v060.miner.sh -O /etc/monitor-scripts/miner.sh
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/v060.pubkeys.sh -O /etc/monitor-scripts/pubkeys.sh
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/v060.sn-check.sh -O /etc/monitor-scripts/sn-check.sh
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/service-pf.sh -O /etc/monitor-scripts/service-pf.sh

#
#   Remove not more required timers/services/scripts
#
[ -f /etc/monitor-script/install-dashboard.sh ] && rm -rf /etc/monitor-script/install-dashboard.sh

systemctl disable auto-maintain.timer || true
[ -f /etc/systemd/system/auto-maintain.service ] && rm -rf /etc/systemd/system/auto-maintain.service
[ -f /etc/systemd/system/auto-maintain.timer ] && rm -rf /etc/systemd/system/auto-maintain.timer
[ -f /etc/monitor-script/auto-maintain.sh ] && rm -rf /etc/monitor-script/auto-maintain.sh

systemctl disable auto-update.timer || true
[ -f /etc/systemd/system/auto-update.service ] && rm -rf /etc/systemd/system/auto-update.service
[ -f /etc/systemd/system/auto-update.timer ] && rm -rf /etc/systemd/system/auto-update.timer
[ -f /etc/monitor-script/auto-update.sh ] && rm -rf /etc/monitor-script/auto-update.sh

systemctl disable clear-blockchain-check.timer || true
[ -f /etc/systemd/system/clear-blockchain-check.timer ] && rm -rf /etc/systemd/system/clear-blockchain-check.timer
[ -f /etc/systemd/system/clear-blockchain-check.service ] && rm -rf /etc/systemd/system/clear-blockchain-check.service
[ -f /etc/monitor-scripts/clear-blockchain.sh ] && rm -rf /etc/monitor-scripts/clear-blockchain.sh

systemctl disable fastsync-check.timer || true
[ -f /etc/systemd/system/fastsync-check.service ] && rm -rf /etc/systemd/system/fastsync-check.service
[ -f /etc/systemd/system/fastsync-check.timer ] && rm -rf /etc/systemd/system/fastsync-check.timer
[ -f /etc/monitor-scripts/fastsync.sh ] && rm -rf /etc/monitor-scripts/fastsync.sh

systemctl disable infoheight-check.timer || true
[ -f /etc/systemd/system/infoheight-check.service ] && rm -rf /etc/systemd/system/infoheight-check.service
[ -f /etc/systemd/system/infoheight-check.timer ] && rm -rf /etc/systemd/system/infoheight-check.timer
[ -f /etc/monitor-scripts/info-height.sh ] && rm -rf /etc/monitor-scripts/info-height.sh

systemctl disable miner-version-check.timer || true
[ -f /etc/systemd/system/miner-version-check.timer ] && rm -rf /etc/systemd/system/miner-version-check.timer
[ -f /etc/systemd/system/miner-version-check.service ] && rm -rf /etc/systemd/system/miner-version-check.service
[ -f /etc/monitor-scripts/miner-version-check.sh ] && rm -rf /etc/monitor-scripts/miner-version-check.sh

systemctl disable update-miner-check.timer || true
[ -f /etc/systemd/system/update-miner-check.timer ] && rm -rf /etc/systemd/system/update-miner-check.timer
[ -f /etc/systemd/system/update-miner-check.service ] && rm -rf /etc/systemd/system/update-miner-check.service
[ -f /etc/monitor-scripts/miner-update.sh ] && rm -rf /etc/monitor-scripts/miner-update.sh

systemctl disable peer-list-check.timer || true
[ -f /etc/systemd/system/peer-list-check.service ] && rm -rf /etc/systemd/system/peer-list-check.service
[ -f /etc/systemd/system/peer-list-check.timer ] && rm -rf /etc/systemd/system/peer-list-check.timer
[ -f /etc/monitor-scripts/peer-list.sh ] && rm -rf /etc/monitor-scripts/peer-list.sh

systemctl disable update-dashboard-check.timer || true
[ -f /etc/systemd/system/update-dashboard-check.timer ] && rm -rf /etc/systemd/system/update-dashboard-check.timer
[ -f /etc/systemd/system/update-dashboard-check.service ] && rm -rf /etc/systemd/system/update-dashboard-check.service
[ -f /etc/monitor-scripts/dashboard-update.sh ] && rm -rf /etc/monitor-scripts/dashboard-update.sh

systemctl disable update-check.timer || true
[ -f /etc/systemd/system/update-check.service ] && rm -rf /etc/systemd/system/update-check.service
[ -f /etc/systemd/system/update-check.timer ] && rm -rf /etc/systemd/system/update-check.timer
[ -f /etc/monitor-scripts/update-check.sh ] && rm -rf /etc/monitor-scripts/update-check.sh

wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/cleanlog.sh -O /home/pi/hnt/script/cleanlog.sh
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/init.sh -O /home/pi/hnt/script/init.sh
chmod 777 /home/pi/hnt/script/*.sh

if [[ $(cat /home/pi/hnt/paket/paket/packet_forwarder/global_conf.json|grep gps_tty_path|wc -l) -gt 0 ]]; then
    echo "Fixing global_conf.json..."
    cat /home/pi/hnt/paket/paket/packet_forwarder/global_conf.json|grep -v gps_tty_path >/home/pi/hnt/paket/paket/packet_forwarder/global_conf_fixed.json
    cp /home/pi/hnt/paket/paket/packet_forwarder/global_conf_fixed.json /home/pi/hnt/paket/paket/packet_forwarder/global_conf.json
    echo "Restarting Packet Forwarder..."
    kill -9 $(pgrep lora_pkt_+)
    sleep 5s
    bash /home/pi/api/tool/onPacket.sh 1>/dev/null 2>&1 &
    echo "Packet Forwarder Restarted..."
fi

chown -R admin:sudo /home/admin/*
chmod 755 /etc/biomine-scripts/*.sh
chmod 755 /etc/monitor-scripts/*.sh

echo "Watchdog..."

CPID=$(ps -efH|grep '/etc/biomine-scripts/watchdog.sh'|grep -v grep|wc -l)

if [[ $CPID -gt 0 ]]; then
    kill -9 $(pgrep -f /etc/biomine-scripts/watchdog.sh)
fi

bash /etc/biomine-scripts/watchdog.sh 1>> /var/dashboard/logs/watchdog.log 2>&1 &

# tune dashboard timers setting

echo "Tuning timers..."

/etc/biomine-scripts/adjust-timer.sh biomine-ping                30s  1m

/etc/biomine-scripts/adjust-timer.sh miner-check                 60s 30s
/etc/biomine-scripts/adjust-timer.sh temp-check                  80s 30s
/etc/biomine-scripts/adjust-timer.sh reboot-check               100s 30s
/etc/biomine-scripts/adjust-timer.sh bt-check                   120s 30s 
/etc/biomine-scripts/adjust-timer.sh gps-check                  140s 30s
/etc/biomine-scripts/adjust-timer.sh cpu-check                  160s 30s
/etc/biomine-scripts/adjust-timer.sh pf-check                   190s 30s
/etc/biomine-scripts/adjust-timer.sh vpn-check                  210s 30s
/etc/biomine-scripts/adjust-timer.sh wifi-check                 230s 30s
/etc/biomine-scripts/adjust-timer.sh password-check             250s 30s

/etc/biomine-scripts/adjust-timer.sh bt-service-check           270s  1m
/etc/biomine-scripts/adjust-timer.sh miner-service-check        300s  1m
/etc/biomine-scripts/adjust-timer.sh pf-service-check           320s  1m
/etc/biomine-scripts/adjust-timer.sh wifi-service-check         340s  1m
/etc/biomine-scripts/adjust-timer.sh wifi-config-check          360s  1m

/etc/biomine-scripts/adjust-timer.sh helium-status-check         10m 30m 

/etc/biomine-scripts/adjust-timer.sh local-ip-check               3m  1h
/etc/biomine-scripts/adjust-timer.sh sn-check                     4m  1h
/etc/biomine-scripts/adjust-timer.sh external-ip-check            5m  1h
/etc/biomine-scripts/adjust-timer.sh pubkeys-check                6m  1h


echo "varius fix..."
# disable recent_activity
sed -i 's/recent_activity=\$(curl -s \$recent_activity_uri)/recent_activity=disabled/g' /etc/monitor-scripts/helium-statuses.sh

sed -i 's/init.sh \&/init.sh \> \/dev\/null \&/g' /etc/rc.local
sed -i 's/\#\$nrconf{kernelhints} \= -1\;/\$nrconf{kernelhints} \= 0\;/g'  /etc/needrestart/needrestart.conf
 
sed -i 's/type=/Type=/g' /lib/systemd/system/helium.service

chmod -x /etc/systemd/system/*.timer
chmod -x /etc/systemd/system/*.service

if [ -f /etc/init.d/zerotier-one ]; then
    echo "disinstall zerotier-one..."
    /etc/init.d/zerotier-one stop
    apt remove -y zerotier-one
    rm -f /etc/init.d/zerotier-one
    rm -f /etc/init/zerotier-one.conf

    echo "disinstall zerotier-one... done"
fi

systemctl daemon-reload

#echo "Forcing new scripts execution..."
#bash /etc/monitor-scripts/pubkeys.sh
#bash /etc/monitor-scripts/sn-check.sh
#bash /etc/monitor-scripts/helium-statuses.sh
#bash /etc/monitor-scripts/miner.sh

echo "done"