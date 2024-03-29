#!/bin/bash
status=$(</var/dashboard/services/PF)

if [[ $status == 'stop' ]]; then
  pid=$(sudo pgrep lora_pkt_+)
  sudo kill -9 $pid
  echo 'disabled' > /var/dashboard/services/PF
fi

if [[ $status == 'start' ]]; then
  echo 'starting' > /var/dashboard/services/PF
  bash /home/pi/api/tool/onPacket.sh 1>/dev/null 2>&1 &
fi

if [[ $status == 'starting' ]]; then
  pid=$(sudo pgrep lora_pkt_+)
  if [[ $pid ]]; then
    echo 'running' > /var/dashboard/services/PF
  fi
fi
