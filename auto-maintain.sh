#!/bin/bash
service=$(cat /var/dashboard/services/auto-maintain | tr -d '\n')
ua='user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.88 Safari/537.36'
xrw='x-requested-with: XMLHttpRequest'

if [[ $service == 'enabled' ]]; then
  bash /etc/monitor-scripts/update-check.sh &> /dev/null
  bash /etc/monitor-scripts/miner-version-check.sh &> /dev/null
  bash /etc/monitor-scripts/helium-statuses.sh &> /dev/null
  current_docker_status=$(sudo docker ps -a -f name=miner --format "{{ .Status }}")
  current_info_height=$(cat /var/dashboard/statuses/infoheight)
  live_height=$(cat /var/dashboard/statuses/current_blockheight)
  snap_height=$(wget -q -H $ua -H $xrw https://helium-snapshots.nebra.com/latest.json -O - | grep -Po '\"height\": [0-9]*' | sed 's/\"height\": //')
  pubkey=$(cat /var/dashboard/statuses/animal_name)

  echo "[$(date)] Starting auto-automaintain..." >> /var/dashboard/logs/auto-maintain.log
  echo "[$(date)] - current_docker_status: $current_docker_status" >> /var/dashboard/logs/auto-maintain.log
  echo "[$(date)] - current_info_height  : $current_info_height" >> /var/dashboard/logs/auto-maintain.log
  echo "[$(date)] - live_height          : $live_height" >> /var/dashboard/logs/auto-maintain.log
  echo "[$(date)] - snap_height          : $snap_height" >> /var/dashboard/logs/auto-maintain.log
  echo "[$(date)] - pubkey               : $pubkey" >> /var/dashboard/logs/auto-maintain.log

  if [[ ! $current_docker_status =~ 'Up' ]]; then
    echo "[$(date)] Problems with docker, trying to start..." >> /var/dashboard/logs/auto-maintain.log
    docker start miner
    sleep 1m
    current_docker_status=$(sudo docker ps -a -f name=miner --format "{{ .Status }}")
    uptime=$(sudo docker ps -a -f name=miner --format "{{ .Status }}" | grep -Po "Up [0-9]* seconds" | sed 's/ seconds//' | sed 's/Up //')

    if [[ ! $current_docker_status =~ 'Up' ]] || [[ $uptime != '' && $uptime -le 55 ]]; then
      echo "[$(date)] Still problems with docker, trying a miner update..." >> /var/dashboard/logs/auto-maintain.log
      echo 'start' > /var/dashboard/services/miner-update
      bash /etc/monitor-scripts/miner-update.sh
      sleep 1m
      current_info_height=$(cat /var/dashboard/statuses/infoheight)
      current_docker_status=$(sudo docker ps -a -f name=miner --format "{{ .Status }}")
      uptime=$(sudo docker ps -a -f name=miner --format "{{ .Status }}" | grep -Po "Up [0-9]* seconds" | sed 's/ seconds//' | sed 's/Up //')

      if [[ ! $current_docker_status =~ 'Up' || $uptime != '' && $uptime -le 55 ]]; then
        echo "[$(date)] STILL problems with docker, trying a blockchain clear..." >> /var/dashboard/logs/auto-maintain.log
        echo 'start' > /var/dashboard/services/clear-blockchain
        bash /etc/monitor-scripts/clear-blockchain.sh
        sleep 1m
        current_info_height=$(cat /var/dashboard/statuses/infoheight)
      fi
    fi
  fi
  if [[ $live_height ]] && [[ $snap_height ]]; then
    let "snapheight_difference = $live_height - $snap_height"
  fi

  if [[ $live_height ]] && [[ $current_info_height ]]; then
    let "blockheight_difference = $live_height - $current_info_height"
  fi

  if [[ $blockheight_difference -ge 500 ]]; then
    if [ ! -f /var/dashboard/statuses/maybeResyncNextMaintain ]; then
        echo "[$(date)] difference of $blockheight_difference found, maybe a fast sync to next cycle..." >> /var/dashboard/logs/auto-maintain.log
        touch /var/dashboard/statuses/maybeResyncNextMaintain
        bash /etc/biomine-scripts/killStucked.sh
    else
        rm /var/dashboard/statuses/maybeResyncNextMaintain
        echo "[$(date)] Big difference in blockheight, doing a fast sync..." >> /var/dashboard/logs/auto-maintain.log
        wget https://helium-snapshots.nebra.com/snap-$snap_height -O /home/pi/hnt/miner/snap/snap-latest
        docker exec miner miner repair sync_pause
        docker exec miner miner repair sync_cancel
        docker exec miner miner snapshot load /var/data/snap/snap-latest
        sleep 2m
        sync_state=$(docker exec miner miner repair sync_state)

        if [[ $sync_state != 'sync active' ]]; then
          docker exec miner miner repair sync_resume
        else
          sleep 2m
          docker exec miner miner repair sync_resume
        fi
    fi
  fi

  if [[ ! $pubkey ]]; then
    echo "[$(date)] Your public key is missing, trying a refresh..." >> /var/dashboard/logs/auto-maintain.log
    bash /etc/monitor-scripts/pubkeys.sh
  fi

  echo "Clearing out old snapshots..." >> /var/dashboard/logs/auto-maintain.log
  for f in /home/pi/hnt/miner/saved-snaps/*;
  do
    rm -rfv "$f" >> /var/dashboard/logs/$name.log;
  done

  echo "Purging old docker content..." >> /var/dashboard/logs/auto-maintain.log
  docker system prune -a --force >> /var/dashboard/logs/auto-maintain.log

fi
