#!/bin/bash

export R3_BULK_REGISTRATION_CODE=D6323F42-E3A7-1720-906A-27BD07C9342C

DOWORK=0
OLDHOST=$(hostname)

case "${OLDHOST}" in
        raspberrypi)
                NEWHOST="p100-$(cat /sys/class/net/eth0/address|tr -d ':')"
                DOWORK=1
                ;;

        Panther-X2)
                NEWHOST="px2-$(cat /sys/class/net/eth0/address|tr -d ':')"
                DOWORK=1
                ;;

        p100*)
                NEWHOST="raspberrypi"
                DOWORK=2
                ;;

        px2*)
                NEWHOST="Panther-X2"
                DOWORK=2
                ;;

        *)
                echo "unknown model: ${OLDHOST}"
                ;;
esac

if [[ $DOWORK -gt 0 ]]; then
        echo "Working..."

        if [ "$(hostname)" = "${OLDHOST}" ]; then
                echo "change hostname to from '${OLDHOST}' to '${NEWHOST}'"
                echo $NEWHOST | tee /etc/hostname

                hostnamectl set-hostname $NEWHOST

                sed -i "s/${OLDHOST}/${NEWHOST}/g" /etc/hosts

                systemctl restart avahi-daemon

                export HOSTNAME=$NEWHOST
        fi

        case $DOWORK in
        1)
                sh -c "$(curl -L https://downloads.remote.it/remoteit/install_agent.sh)"
                ;;
        2)
                apt -y remove remoteit
                rm -rf /etc/remoteit
        esac
fi

