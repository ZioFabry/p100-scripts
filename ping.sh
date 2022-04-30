#!/bin/bash

APIURL=https://cc.biomine.it/api

if [ -f /opt/panther-x2/data/SN ]; then
    cp /opt/panther-x2/data/SN /var/dashboard/statuses/sn
fi

hostname=$(hostname)
lanmac=$(ip address show eth0 | grep "link/" | egrep -o "ether [^.]+:[^.]+:[^.]+:[^.]+:[^.]+:[^.]+brd" | sed -e "s/ether //"|sed "s/ brd//")
wlanmac=$(ip address show wlan0 | grep "link/" | egrep -o "ether [^.]+:[^.]+:[^.]+:[^.]+:[^.]+:[^.]+brd" | sed -e "s/ether //"|sed "s/ brd//")
lanip=$(ip address show eth0 | grep "inet " | egrep -o "inet [^.]+.[^.]+.[^.]+.[^/]+" | sed -e "s/inet //")
wlanip=$(ip address show wlan0 | grep "inet " | egrep -o "inet [^.]+.[^.]+.[^.]+.[^/]+" | sed -e "s/inet //")

diskusage=$(df -h /|grep -v File|awk '{print $5}'|tr -d '%')
externalip=$(curl -4 icanhazip.com)
uptime=$(uptime)

JSON="{\"lanmacaddr\":\"${lanmac}\""
JSON=$JSON",\"wlanmacaddr\":\"${wlanmac}\""
JSON=$JSON",\"lanip\":\"${lanip}\""
JSON=$JSON",\"wlanip\":\"${wlanip}\""
JSON=$JSON",\"externalip\":\"${externalip}\""
JSON=$JSON",\"diskusage\":\"${diskusage}\""
JSON=$JSON",\"uptime\":\"${uptime}\""
JSON=$JSON",\"hostname\":\"${hostname}\""

FILES="/var/dashboard/statuses/*"
for f in $FILES;
do
    name=$(echo $f | sed 's/\/var\/dashboard\/statuses\///' | sed 's/\_//' | sed 's/\-//')

    case "$name" in
    animalname)
        val=$(cat $f|tr ' ' "-")
        ;;
    lat | lng | infoheight)
        val=$(cat $f|tr '"' "'"|awk '{print $1;}')
        ;;

    recentactivity | peerlist | localip | externalip)
        continue
        ;;

    *)
        val=$(cat $f|tr '"' "'")
        ;;
    esac

    JSON=${JSON}",\"${name}\":\"${val}\""
done

JSON=${JSON}"}"

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
