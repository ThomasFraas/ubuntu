#!/usr/bin/bash

function usage
{
    echo -e "\nusage: $0 -v name -p password | [-h]"
    echo ""
    echo "    -i  | --ipaddr      ESXi-Server (Default: roevmsrv013)"
    echo "    -u  | --username    UserName ESXi-Server (Default: root)"
    echo "    -p  | --password    Passwort ESXi-Server"
    echo "    -v  | --vmname      Name of the Jenkins slave VM"
    echo "    -d  | --disksize    in MB (Default: 200GB)"
    echo "    -c  | --cpu         Number of CPUs (Default: 8)"
    echo "    -m  | --memory      in MB (Default: 16GB)"
	echo "    -h  | --help        this usage"
}

##### Main
# set Variables
start=`date +"%s"`
vmname="E_NOPARAM"
password="E_NOPARAM"
username="root"
ipaddr="roevmsrv013"
disksize="204800"
cpu="8"
memory="16384"

while [ "$1" != "" ]; do
    case $1 in
        -v | --vmname )         shift
                                vmname=$1
                                ;;
        -i | --ipaddr )         shift
                                ipaddr=$1
                                ;;
        -u | --username )       shift
                                username=$1
                                ;;
        -p | --password )       shift
		                        password=$1
                                ;;
        -d | --disksize )       shift
		                        disksize=$1
                                ;;
        -c | --cpu )       shift
		                        cpu=$1
                                ;;
        -m | --memory )       shift
		                        memory=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

if [ "$vmname" == "E_NOPARAM" ]; then
  echo -e "\nError: Parameter -vm fehlt!"
  usage
  exit 1
elif [ "$password" == "E_NOPARAM" ]; then
  echo -e "\nError: Parameter -pw fehlt!"
  usage
  exit 1
fi

echo "Host:     $ipaddr"
echo "Username: $username"
echo "Password: $password"
echo "VM:       $vmname"   
echo "Disk:     $disksize"   
echo "CPU:      $cpu"   
echo "Memory:   $memory"   

# delete existing VM
scp registervm.sh $username@$ipaddr:
ssh $username@$ipaddr "./registervm.sh $vmname deleteVM"

#packer
packer build \
  -var "rhost=$ipaddr" \
  -var "rusername=$username" \
  -var "vmname=$vmname" \
  -var "rpassword=$password" \
  -var "hostname=$vmname" \
  -var "disksize=$disksize" \
  -var "cpu=$cpu" \
  -var "memory=$memory" \
  ubuntu1404-seal.json
rc=$?

# register new VM
if [ $rc -eq 0 ]; then
ssh $username@$ipaddr "./registervm.sh $vmname registerVM"
fi



end=`date +"%s"`
echo "GesamtDauer: $(date -u -d "0 $end sec - $start sec" +"%H:%M:%S")"

exit 0

