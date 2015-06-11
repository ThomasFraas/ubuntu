#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}

if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
    echo "==> Installing VMware Tools"
    # Assuming the following packages are installed
    # apt-get install -y linux-headers-$(uname -r) build-essential perl
    apt-get install -y git

    echo "==> - Mount CDRom"
    cd /tmp
    mkdir -p /mnt/cdrom
    mount /dev/cdrom /mnt/cdrom

    git clone https://github.com/rasa/vmware-tools-patches.git
    vmware-tools-patches/untar-and-patch.sh /mnt/cdrom/VMwareTools-*.tar.gz
    echo "==> - Call install script"
    vmware-tools-distrib/vmware-install.pl -d -f

    umount /mnt/cdrom
    rmdir /mnt/cdrom
    rm -rf /tmp/VMwareTools-* /tmp/vmware-tool-patches /tmp/vmware-tools-distrib
fi

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
    echo "==> Installing VirtualBox guest additions"
    # Assuming the following packages are installed
    # apt-get install -y linux-headers-$(uname -r) build-essential perl
    # apt-get install -y dkms

    VBOX_VERSION=$(cat /home/${SSH_USER}/.vbox_version)
    mount -o loop /home/${SSH_USER}/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
    sh /mnt/VBoxLinuxAdditions.run
    umount /mnt
    rm /home/${SSH_USER}/VBoxGuestAdditions_$VBOX_VERSION.iso
    rm /home/${SSH_USER}/.vbox_version

    if [[ $VBOX_VERSION = "4.3.10" ]]; then
        ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
    fi
fi

if [[ $PACKER_BUILDER_TYPE =~ parallels ]]; then
    echo "==> Installing Parallels tools"

    mount -o loop /home/${SSH_USER}/prl-tools-lin.iso /mnt
    /mnt/install --install-unattended-with-deps
    umount /mnt
    rm -rf /home/${SSH_USER}/prl-tools-lin.iso
    rm -f /home/${SSH_USER}/.prlctl_version
fi
