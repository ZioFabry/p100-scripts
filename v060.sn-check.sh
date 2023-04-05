#!/bin/bash
curl -s 'http://localhost:8001/api/test/minerSn/read' | jq .minerSn|tr -d '"' > /var/dashboard/statuses/sn
