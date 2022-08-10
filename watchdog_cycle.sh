#!/bin/bash

if [[ $(ps -efH|egrep '\(.*\)'|wc -l) -gt 5 ]]; then
    echo "[$(date)] Process hang detect, wait 5 sec then recheck..."
    sleep 5s
    if [[ $(ps -efH|egrep '\(.*\)'|wc -l) -gt 5 ]]; then
        echo "[$(date)] Process hang detect, rebooting..."
        reboot -f
        exit
    else
        echo "[$(date)] 2nd check ok."
    fi
fi

if [[ $(ps -efH|egrep '\<defunct\>'|wc -l) -gt 5 ]]; then
    echo "[$(date)] Process defunct detect, wait 5 sec then recheck..."
    sleep 5s
    if [[ $(ps -efH|egrep '\<defunct\>'|wc -l) -gt 5 ]]; then
        echo "[$(date)] Process defunct detect, rebooting..."
        reboot -f
        exit
    else
        echo "[$(date)] 2nd check ok."
    fi
fi

#
CPU=$(ps -C lora_pkt_fwd -o %cpu | tail -1 | tr -d ' ' | tr -d '\n')
if [[ $CPU -gt 80 ]]; then
    echo "[$(date)] Process lora_pkt_fwd high usage, wait 1 min then recheck..."
    sleep 1m
    CPU=$(ps -C lora_pkt_fwd -o %cpu | tail -1 | tr -d ' ' | tr -d '\n')
    if [[ $CPU -gt 80 ]]; then
        echo "[$(date)] Process lora_pkt_fwd still high usage... restarting."
        kill -9 $(pgrep lora_pkt_+)
        sleep 5s
        sudo bash /home/pi/api/tool/onPacket.sh
        echo "[$(date)] Process lora_pkt_fwd restarted."
    else
        echo "[$(date)] Process lora_pkt_fwd normal usage."
    fi
fi
