#!/bin/bash

echo "Downloading Vagrant 1.7.2 ..."
wget --no-verbose -O /tmp/vagrant.deb https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.2_x86_64.deb

echo "Installing Vagrant 1.7.2 ..."
sudo dpkg -i /tmp/vagrant.deb
rm /tmp/vagrant.deb

echo "Installing vagrant-vmware-workstation plugin ..."
vagrant plugin install vagrant-vmware-workstation

echo "Installing vagrant-hostmanager plugin ..."
vagrant plugin install vagrant-hostmanager

mkdir -p $HOME/.vagrant.d
cat <<VAGRANTFILE | tee /home/vagrant/.vagrant.d/Vagrantfile
Vagrant.configure("2") do |config|

  if Vagrant.has_plugin?("vagrant-vcloud")
    config.vm.provider :vcloud do |vcloud|
      vcloud.hostname = "https://roecloud001.sealsystems.local"
      vcloud.username = "vagrant"
      vcloud.password = "vagrant"
      vcloud.org_name = "COM-BUILD"
      vcloud.vdc_name = "COM-BUILD"
      vcloud.catalog_name = "Vagrant"
      vcloud.ip_subnet = "172.16.32.1/255.255.255.0"
      vcloud.vdc_network_name = "COM-BUILD Internal"
    end
  end
end
VAGRANTFILE


# copy and install vagrant-vmware-workstation licensefile
wget --no-verbose http://roecloudsrv001.sealsystems.local/vmware/workstation10/vagrant-vmware-license.zip
unzip vagrant-vmware-license.zip    
vagrant plugin license vagrant-vmware-workstation license.lic
rm -f vagrant-vmware-license.zip
rm -f license.lic

# set owner of vagrant homedirectory
sudo chown -cR vagrant:vagrant $HOME/.vagrant.d

# Add 'vagrant' to labels for this jenkins slave
echo "vagrant vagrant-vmware-workstation vagrant-hostmanager" >> $HOME/jenkins-labels

# set owner of vmrun directory
#sudo chown -cR vagrant:vagrant /run/user/1000/pulse
