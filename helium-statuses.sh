#!/bin/bash
pubkey=$(</var/dashboard/statuses/pubkey)
root_uri='https://api.helium.io/v1/hotspots/'
activity_uri="/activity"
uri="$root_uri$pubkey"

data=$(wget -qO- $uri)

online_status=$(echo $data | grep -Po '"online":".*?[^\\]"' | sed -e 's/^"online"://' | tr -d '"')
lat=$(echo $data | grep -Po '"lat":[^\,]+' | sed -e 's/^"lat"://')
lng=$(echo $data | grep -Po '"lng":[^\,]+' | sed -e 's/^"lng"://')

if [[ $pubkey ]]; then
  echo $online_status > /var/dashboard/statuses/online_status
else
  echo 'unknown' > /var/dashboard/statuses/online_status
fi

echo $lat > /var/dashboard/statuses/lat
echo $lng > /var/dashboard/statuses/lng

