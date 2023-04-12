#!/bin/bash

#sys init
ulimit -n 65535

#GPS init
echo 12 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio12/direction
echo 1 > /sys/class/gpio/gpio12/value
sleep 1

echo 20 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio20/direction
echo 1 >/sys/class/gpio/gpio20/value

sleep 1
echo 16 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio16/direction
echo 1 > /sys/class/gpio/gpio16/value

#packet-forward init
sudo bash /home/pi/api/tool/onPacket.sh

#init api
cd /home/pi/api/
sudo python /home/pi/api/api.py > /home/pi/log/py.log &

#init kafka
cd /home/pi/kafka/
sudo node /home/pi/kafka/kafka.js > /home/pi/log/kafka.log &
sudo node /home/pi/kafka/http.js > /home/pi/log/kafka-http.log &
sudo node /home/pi/kafka/autoLoop.js > /home/pi/log/kafka-loop.log &

#init advertise
cd /home/pi/api/tool/
sudo bash /home/pi/api/tool/startAdvertise.sh > /home/pi/log/gateway_config_advertise.log &

#init service
set GW_ONBOARDING=ecc://i2c-0:96?slot=15
set GW_KEYPAIR=ecc://i2c-0:96?slot=0
systemctl start helium

#init biomine watchdog
sudo bash /etc/biomine-scripts/watchdog.sh 1>> /var/dashboard/logs/watchdog.log 2>&1 &
