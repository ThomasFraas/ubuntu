#!/bin/sh

echo "==> set hostname"
hostname=$VMNAME
echo $hostname | sudo tee /etc/hostname
sudo sed -i "s/^send host-name.*/send host-name=\"$hostname\";/" /etc/dhcp/dhclient.conf
 
