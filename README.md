# ESXi6.0 Jenkins Slave

Create a Jenkins slave on ESXi6.0 Server.

## Description
This repository contains a template for Ubuntu 14.04 Jenkins Slave on an ESXi-Server.


The Jenkins Slave contains:

* `java`
* `vagrant 1.7.2`
    * `plugin vagrant-vmware-workstation`
    * `plugin vagrant-hostmanager`
* `git`
* `swarm-client`
* `VMWare Workstation 11.0`

## Getting started

**Please note:** You need at least [Packer 0.7.5](https://packer.io/docs/installation.html) to build the VMs.

### Script `createvm.sh`
To build the slave VM you must call the script with following parameters

```
./createvm.sh -v  <name> -p  <password> [-u <username> -i  <hostname>]
    -i  | --ipaddr		ESXi-Server (Default: roevmsrv013)
    -u  | --username    UserName ESXi-Server (Default: root)
    -p  | --password	Passwort ESXi-Server
    -v  | --vmname    	Name of the Jenkins slave VM
    -d  | --disksize    in MB (Default: 200GB)
    -c  | --cpu         Number of CPUs (Default: 8)
    -m  | --memory      in MB (Default: 16GB)
```

.
