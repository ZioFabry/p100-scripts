#!/bin/bash

echo "[$(date)] Smashing the seed nodes..."
seeds=$(dig +short seed.helium.io)
for s in $seeds; do
  echo "[$(date)] - $(docker exec miner miner peer connect /ip4/$s/tcp/2154)"
done
