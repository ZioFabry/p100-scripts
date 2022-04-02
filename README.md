# p100-scripts

Based on Briffy's Dashboard https://github.com/briffy/PiscesQoLDashboard

## Biomine CC Install

    sudo wget https://raw.githubusercontent.com/ZioFabry/p100-scripts/main/install.sh -O - | sudo bash

## Helium Miner Logs Analyzer

    wget -O processlogs.php https://raw.githubusercontent.com/inigoflores/helium-miner-log-analyzer/main/processlogs.php; chmod a+x processlogs.php

## Fix for the Pisces P100 LAN Port 1Gbps Issue

    sudo wget https://raw.githubusercontent.com/inigoflores/pisces-p100-tools/main/1Gbps_LAN_Port_Fix/pisces_fix_lan.sh -O - | sudo bash

## Apply peerbook fix

    sudo wget https://raw.githubusercontent.com/inigoflores/pisces-p100-tools/main/Not_Found_Fix/apply.sh -O - | sudo bash

## Restore original version of sys.config

    sudo wget https://raw.githubusercontent.com/inigoflores/pisces-p100-tools/main/Not_Found_Fix/restore.sh -O - | sudo bash

## Clear & Resync utility

    sudo wget https://raw.githubusercontent.com/moophlo/pisces-miner-scripts/main/clear_resync.sh -O /usr/bin/clear_resync.sh; sudo chmod +x /usr/bin/clear_resync.sh

## Daily Check of root filesystem

    wget https://raw.githubusercontent.com/moophlo/pisces-miner-scripts/main/crontab_job.sh -O - | sudo bash
