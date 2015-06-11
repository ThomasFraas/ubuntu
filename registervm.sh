#!/bin/sh

vmname=$1
action=$2
datastore="/vmfs/volumes/datastore1"

echo "VM: $vmname"
echo "Aktion: $action"

if [ "$action" == "deleteVM" ]; then
  if [ -d $datastore/$vmname ]; then
    oldID=$(vim-cmd vmsvc/getallvms | grep $vmname | awk '{print $1}')
    echo "Power off VM $vmname ID: $oldID"
    vim-cmd vmsvc/power.off $oldID
    sleep 5
    echo "Unregister VM $vmname ID: $oldID"
    vim-cmd vmsvc/unregister $oldID
    echo "Remove Directory $datastore/$vmname"
    rm -rf $datastore/$vmname
  fi
elif [ "$action" == "registerVM" ]; then
  echo "Rename output-vmware-iso to $vmname"
  mv $datastore/output-vmware-iso $datastore/$vmname

  # Append the line vhv.enable = "TRUE" to the VM's vmx file by running
  #echo "vhv.enable = \"TRUE\"">> $datastore/$vmname/$vmname.vmx
  
  # Register and start VM
  vmID=$(vim-cmd solo/registervm $datastore/$vmname/$vmname.vmx)
  vim-cmd vmsvc/power.on $vmID
  vim-cmd vmsvc/getallvms
fi

exit 0