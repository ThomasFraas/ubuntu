#!/bin/bash

# echo "Patching roecloudsrv001 to be our BTN HTTP proxy for Java downloads"
# echo "10.100.100.101 download.oracle.com # roecloudsrv001 BTN HTTP proxy" | sudo tee -a /etc/hosts

echo "===> inst Oracle JDK 8...:" `date +%H:%M:%S.%N`
# install Oracle JDK 8
sudo apt-get purge openjdk*
sudo apt-get install -y python-software-properties # for add-apt-repository in Ubuntu 12.04
sudo apt-get install -y software-properties-common # for add-apt-repository in Ubuntu 14.04
echo "===> sudo add-apt-repository ppa:webupd8team/java..."
sudo add-apt-repository -y ppa:webupd8team/java
echo "===> sudo apt-get update -y..."
sudo apt-get update -y
echo "debconf 1..."
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
echo "debconf 2..."
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo /usr/bin/debconf-set-selections
echo "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y oracle-java8-installer..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install -q -y oracle-java8-installer
echo "sudo apt-get install -y oracle-java8-set-default..."
sudo apt-get install -q -y oracle-java8-set-default

# Add 'java jdk8 oraclejdk' to labels for this jenkins slave
echo "java jdk8 oraclejdk" >> $HOME/jenkins-labels

echo "===> End java.sh..:" `date +%H:%M:%S.%N`
