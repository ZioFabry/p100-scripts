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

[ ! -f /usr/bin/dig ] && apt-get -f --assume-yes install dnsutils

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

wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/helium-statuses.sh -O /etc/monitor-scripts/helium-statuses.sh
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/peer-list.sh -O /etc/monitor-scripts/peer-list.sh
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/info-height.sh -O /etc/monitor-scripts/info-height.sh
wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/auto-update.sh -O /etc/monitor-scripts/auto-update.sh

if [ ! -f /var/dashboard/statuses/pantherx_ver ]; then
    #
    #   Pisces
    #
    wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/auto-maintain.sh -O /etc/monitor-scripts/auto-maintain.sh
    wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/miner-version-check.sh -O /etc/monitor-scripts/miner-version-check.sh
    wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/dashboard-update.sh -O /etc/monitor-scripts/dashboard-update.sh
    wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/miner-update-piesces.sh -O /etc/monitor-scripts/miner-update.sh
    wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/service-pf.sh -O /etc/monitor-scripts/service-pf.sh

    wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/cleanlog.sh -O /home/pi/hnt/script/cleanlog.sh
    wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/init.sh -O /home/pi/hnt/script/init.sh
    chmod 777 /home/pi/hnt/script/*.sh

    curl -Lf http://pisces-firmware.sidcloud.cn/0.55/sys.config -o /home/pi/hnt/miner/configs/sys.config
    curl -Lf http://pisces-firmware.sidcloud.cn/0.55/version -o /home/pi/api/tool/version
    
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
else
    #
    #   Panther
    #
    wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/auto-maintain-px2.sh -O /etc/monitor-scripts/auto-maintain.sh
    wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/miner-version-check.sh -O /etc/monitor-scripts/miner-version-check.sh
    wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/dashboard-update-px2.sh -O /etc/monitor-scripts/dashboard-update.sh
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

echo "Tuning timers..."

# tune dashboard timers setting

/etc/biomine-scripts/adjust-timer.sh auto-maintain               30m  1h
/etc/biomine-scripts/adjust-timer.sh auto-update                  1h  1h
/etc/biomine-scripts/adjust-timer.sh biomine-ping                30s  1m
/etc/biomine-scripts/adjust-timer.sh bt-check                     3m 30s
/etc/biomine-scripts/adjust-timer.sh bt-service-check           240s 15s
/etc/biomine-scripts/adjust-timer.sh clear-blockchain-check     248s 15s
/etc/biomine-scripts/adjust-timer.sh cpu-check                   32s 15s
/etc/biomine-scripts/adjust-timer.sh external-ip-check            5m  1h
/etc/biomine-scripts/adjust-timer.sh fastsync-check               6m 15s
/etc/biomine-scripts/adjust-timer.sh gps-check                    4m 30s
/etc/biomine-scripts/adjust-timer.sh helium-status-check          5m  5m 
/etc/biomine-scripts/adjust-timer.sh infoheight-check             3m  3m
/etc/biomine-scripts/adjust-timer.sh local-ip-check               3m  1h
/etc/biomine-scripts/adjust-timer.sh miner-check                 95s 15s
/etc/biomine-scripts/adjust-timer.sh miner-service-check        242s 15s
/etc/biomine-scripts/adjust-timer.sh miner-version-check         45m  1h
/etc/biomine-scripts/adjust-timer.sh password-check             250s 15s
/etc/biomine-scripts/adjust-timer.sh peer-list-check              7m  5m
/etc/biomine-scripts/adjust-timer.sh pf-check                    65s 15s
/etc/biomine-scripts/adjust-timer.sh pf-service-check           244s 15s
/etc/biomine-scripts/adjust-timer.sh pubkeys-check               10m  1h
/etc/biomine-scripts/adjust-timer.sh reboot-check                 1m  5s
/etc/biomine-scripts/adjust-timer.sh sn-check                    12m  1h
/etc/biomine-scripts/adjust-timer.sh temp-check                  30s 30s
/etc/biomine-scripts/adjust-timer.sh update-check                25m  6h
/etc/biomine-scripts/adjust-timer.sh update-dashboard-check       4m 15s
/etc/biomine-scripts/adjust-timer.sh update-miner-check           4m 16s
/etc/biomine-scripts/adjust-timer.sh vpn-check                    4m 17s
/etc/biomine-scripts/adjust-timer.sh wifi-check                   3m 15s
/etc/biomine-scripts/adjust-timer.sh wifi-config-check            2m 14s
/etc/biomine-scripts/adjust-timer.sh wifi-service-check         246s 15s

# disable recent_activity
sed -i 's/recent_activity=\$(curl -s \$recent_activity_uri)/recent_activity=disabled/g' /etc/monitor-scripts/helium-statuses.sh

sed -i 's/init.sh \&/init.sh \> \/dev\/null \&/g' /etc/rc.local
sed -i 's/\#\$nrconf{kernelhints} \= -1\;/\$nrconf{kernelhints} \= 0\;/g'  /etc/needrestart/needrestart.conf
 
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
