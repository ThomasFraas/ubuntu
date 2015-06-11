#!/bin/bash

echo "===> Change domain-name in /etc/avahi/avahi-daemon.conf"

# http://superuser.com/questions/704785/ping-cant-resolve-hostname-but-nslookup-can
sudo sed -i "s/^#domain-name=.*/domain-name=.alocal/" /etc/avahi/avahi-daemon.conf
sudo service avahi-daemon restart

