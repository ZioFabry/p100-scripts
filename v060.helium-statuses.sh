#!/bin/bash
pubkey=$(</var/dashboard/statuses/pubkey)

root_uri='https://api.helium.io/v1/hotspots/'
uri="$root_uri$pubkey"

ua='user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.88 Safari/537.36'
xrw='x-requested-with: XMLHttpRequest'

recent_activity=disabled

if [[ $pubkey ]]; then
    data=$(wget -qO- -H $ua -H $xrw $uri)
    online_status=$(echo $data | grep -Po '"online":".*?[^\\]"' | sed -e 's/^"online"://' | tr -d '"')
    lat=$(echo $data | grep -Po '"lat":[^\,]+' | sed -e 's/^"lat"://')
    lng=$(echo $data | grep -Po '"lng":[^\,]+' | sed -e 's/^"lng"://')
else
    online_status="GWNotReady"
    lat="-1"
    lng="-1"
fi

height=$(wget -qO- -H $ua -H $xrw 'https://api.helium.io/v1/blocks/height' | grep -Po '"height":[^}]+' | sed -e 's/^"height"://')

echo $online_status > /var/dashboard/statuses/online_status
echo $lat > /var/dashboard/statuses/lat
echo $lng > /var/dashboard/statuses/lng
echo $height > /var/dashboard/statuses/current_blockheight
echo $recent_activity > /var/dashboard/statuses/recent_activity