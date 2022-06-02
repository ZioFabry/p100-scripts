#!/bin/bash

while true;
do
    if [[ $(ps -efH|egrep '\(.*\)'|wc -l) -gt 5 ]]; then
        echo "[$(date)] Process hang detect, wait 5 sec then recheck..." >> /var/dashboard/logs/watchdog.log
        sleep 5s
        if [[ $(ps -efH|egrep '\(.*\)'|wc -l) -gt 5 ]]; then
            echo "[$(date)] Process hang detect, rebooting..." >> /var/dashboard/logs/watchdog.log
            reboot -f
            exit
        else
            echo "[$(date)] 2nd check ok." >> /var/dashboard/logs/watchdog.log
        fi
    fi
    
    if [[ $(ps -efH|egrep '\<defunct\>'|wc -l) -gt 5 ]]; then
        echo "[$(date)] Process defunct detect, wait 5 sec then recheck..." >> /var/dashboard/logs/watchdog.log
        sleep 5s
        if [[ $(ps -efH|egrep '\<defunct\>'|wc -l) -gt 5 ]]; then
            echo "[$(date)] Process defunct detect, rebooting..." >> /var/dashboard/logs/watchdog.log
            reboot -f
            exit
        else
            echo "[$(date)] 2nd check ok." >> /var/dashboard/logs/watchdog.log
        fi
    fi
       
    sleep 1m
done
