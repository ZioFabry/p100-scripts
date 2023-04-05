#!/bin/bash

/etc/helium_gateway/helium_gateway key info|jq .name|tr -d '"' > /var/dashboard/statuses/animal_name
/etc/helium_gateway/helium_gateway key info|jq .key|tr -d '"' > /var/dashboard/statuses/pubkey
