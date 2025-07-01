#!/bin/bash

VMID=0
STORAGE_DEST=""
HOST_DEST=""

while getopts ":i:s:h" opt
do
  case $opt in
    i ) VMID=$OPTARG ;;
    s ) STORAGE_DEST=$OPTARG ;;
    h ) HOST_DEST=$OPTARG ;;
    \? ) echo "Error"
      exit 1 ;;
    : ) echo "Option -$OPTARG requires an argument"
      exit 1 ;;
  esac
done

VMS="$(qm list | egrep "[0-9]{3}" | awk '{print $1}')"
echo $VMS

if [[ $VMID=="all" ]]
then
  for j in $VMS; do
        DISCOS="$(qm config $j | egrep "^virtio[0-9]|^scsi[0-9]" | awk '{print $1}' | tr -d ":")"
        echo $DISCOS
        for i in $DISCOS; do
                qm move_disk $j $i $STORAGE_DEST --delete --format qcow2
        done
  done
else
  DISCOS="$(qm config $VMID | egrep "^virtio[0-9]|^scsi[0-9]" | awk '{print $1}' | tr -d ":")"
  for i in $DISCOS; do
    qm move_disk $VMID $i $STORAGE_DEST --delete --format qcow2
  done

fi
#qm migrate $VMID $HOST_DEST --online
