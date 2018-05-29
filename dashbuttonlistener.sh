#!/bin/bash

# Simplest way to hack your Amazon Dash buttons:
# 
# 1. Connect you dashbutton with the amazon app to your home network
# 2. Lookup it's MAC address in you routes DHCP client list
# 3. Deny all traffic from that MAC address in your routers firewall
# 4. Change the MAC address and the function below
# 5. Check if your sever is connected to the network on 'eth0' or change accordingly
# 6. Move this file to a local server (like a raspberry pi)
# 7. Add the following cronjob (crontab -e) to ensure it's always running:
#    @reboot /home/user/dashbuttonlistener.sh > /dev/null 2>&1
#

sudo tcpdump ether "dst host FF:FF:FF:FF:FF:FF and (port 67 or port 68)" -e -i eth0 -n -p -t -l | while read line; do

    if [[ "$line" =~ ^ab:cd:ef:gh:ij:kl ]]; then

        echo "Button Pressed, change this to a usefull command";

    fi

done
