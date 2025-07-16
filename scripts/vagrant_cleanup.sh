#!/bin/bash

echo "==== Stopping all running Vagrant VMs ===="
vagrant global-status --prune | awk '/running/ { print $1 }' | while read id; do
    echo "Stopping VM ID: $id"
    vagrant halt $id
done

echo "==== Destroying all Vagrant VMs ===="
vagrant global-status --prune | awk '/virtualbox/ { print $1 }' | while read id; do
    echo "Destroying VM ID: $id"
    vagrant destroy -f $id
done

echo "==== Removing all Vagrant Boxes ===="
vagrant box list | awk '{ print $1 }' | while read box; do
    echo "Removing box: $box"
    vagrant box remove -f $box
done

echo "==== Unregistering and deleting all VirtualBox VMs ===="
VBoxManage list vms | awk -F\" '{ print $2 }' | while read vm; do
    echo "Unregistering and deleting VM: $vm"
    VBoxManage unregistervm "$vm" --delete
done

echo "==== Deleting unattached VirtualBox disks ===="
VBoxManage list hdds | grep -B4 "State:           Not Attached" | grep "^UUID:" | awk '{ print $2 }' | while read uuid; do
    echo "Deleting unattached disk UUID: $uuid"
    VBoxManage closemedium disk $uuid --delete
done

echo "==== Removing .vagrant folders in home and subdirs ===="
find ~ -name ".vagrant" -type d -exec rm -rf {} +

echo "==== Clearing Vagrant cache ===="
rm -rf ~/.vagrant.d/boxes
rm -rf ~/.vagrant.d/tmp

echo "==== Cleaning system packages ===="
sudo apt clean
sudo apt autoremove -y

echo "==== Disk Usage After Cleanup ===="
df -h

echo "==== Vagrant + VirtualBox cleanup completed successfully! ===="
