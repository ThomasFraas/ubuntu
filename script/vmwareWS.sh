#!/bin/bash

SSH_USER=${SSH_USERNAME:-vagrant}

echo "Downloading VMware Workstation 11 ..."
#wget --no-verbose  -O VMware-Workstation.bundle --no-check-certificate http://www.vmware.com/go/tryworkstation-linux-64
wget --no-verbose  -O VMware-Workstation.bundle --no-check-certificate http://roecloudsrv001.sealsystems.local/vmware/workstation11/VMware-Workstation-Full-11.1.0-2496824.x86_64.bundle
sudo sh ./VMware-Workstation.bundle --console --required --eulas-agreed
rm ./VMware-Workstation.bundle


# copy and install vmware-workstation licensefile
#wget --no-verbose http://roecloudsrv001.sealsystems.local/vmware/workstation11/vmware-license.zip
#unzip vmware-license.zip    
#license=`cat vmware-license.txt`
#/usr/lib/vmware/bin/vmware-vmx --new-sn $license
#rm -f vmware-license.zip
#rm -f license.lic

#sudo vmware-networks --stop
#sudo sed -i "s/172.16./192.168./g" /etc/vmware/networking
#sudo sed -i "s/172.16./192.168./g" /etc/vmware/vmnet1/dhcpd/dhcpd.conf
#sudo sed -i "s/172.16./192.168./g" /etc/vmware/vmnet8/dhcpd/dhcpd.conf
#sudo vmware-networks --start
