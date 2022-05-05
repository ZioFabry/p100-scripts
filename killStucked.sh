#!/bin/bash

ps -ef|grep 'docker exec'|egrep -v '(sudo|grep|sync|snapshot|sh -c)'|awk '{print $2;}'|while read P; do
    AGE=$(ps -o etimes= -p $P|tr -d ' ')
    if [[ $AGE -gt 300 ]]; then
        echo "Kill PID=${P}, AGE=${AGE}";
        kill $P
    fi
done
