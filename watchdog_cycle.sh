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
