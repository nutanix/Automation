#!/bin/bash

# Basic shell script to take an existing Nutanix cluster running the Acropolis Hypervisor (AHV) and configure the Image Service, untagged VLAN and 3x virtual machines.
# All done using the Acropolis CLI (acli)

clear

# set some variables
# change these to match your environment
# note that not all options are set here - just the settings most likely to change in a demo environment (in my opinion)

NFS_SERVER=10.10.10.243
NFS_EXPORT=Shared/Software

CENTOS_ISO=$NFS_EXPORT/CentOS/CentOS-7-x86_64-Minimal-1503-01.iso
WINDOWS_ISO=$NFS_EXPORT/Microsoft/Windows_Server_2012_R2_Datacenter_Customer_VLK_2015.05.18/SW_DVD9_Windows_Svr_Std_and_DataCtr_2012_R2_64Bit_English_-4_MLF_X19-82891.ISO
PRISM_CENTRAL_BOOT_ISO=$NFS_EXPORT/Nutanix/Prism_Central/4.5.0.2/AHV/4.5.0.2-prism_central-boot.qcow2;
PRISM_CENTRAL_DATA_ISO=$NFS_EXPORT/Nutanix/Prism_Central/4.5.0.2/AHV/4.5.0.2-prism_central-data.qcow2;
VIRTIO_ISO=$NFS_EXPORT/Other/VirtIO/0.1.102_ISO/virtio-win-0.1.102.iso;

VLAN_NAME=vlan.0
VLAN=0
VLAN_IP_CONFIG=10.10.10.253/24
DHCP_START=10.10.10.100
DHCP_END=10.10.10.200
DOMAIN_NAME=ntnxdemo.local
DNS_SERVER=10.10.10.239
WINDOWS_DISK_SIZE=40G
CENTOS_DISK_SIZE=10G
PRISM_CENTRAL_CPUS=4
PRISM_CENTRAL_RAM=8G
PRISM_CENTRAL_IP=10.10.10.92

echo

# create images
# sleep for 3 seconds between each image creation process
# this is because the dev platform is based on OS X - NFS seems to disconnect clients if one session finishes then another immediately starts

echo "Creating CentOS7 image ..."
acli image.create "CentOS 7" image_type=kIsoImage source_url=nfs://$NFS_SERVER/$CENTOS_ISO;
sleep 3
echo "Creating Prism Central Boot image ..."
acli image.create "PC_4502_Boot" image_type=kIsoImage source_url=nfs://$NFS_SERVER/$PRISM_CENTRAL_BOOT_ISO;
sleep 3
echo "Creating Prism Central Data image (this may take a while) ..."
acli image.create "PC_4502_Data" image_type=kIsoImage source_url=nfs://$NFS_SERVER/$PRISM_CENTRAL_DATA_ISO;
sleep 3
echo "Creating Windows 2012 R2 image (this may take a while) ..."
acli image.create "Windows 2012 R2" image_type=kIsoImage source_url=nfs://$NFS_SERVER/$WINDOWS_ISO;
sleep 3
echo "Creating VirtIO Driver image ..."
acli image.create "VirtIO" image_type=kIsoImage source_url=nfs://$NFS_SERVER/$VIRTIO_ISO;

echo

# create network
echo "Creating vlan.0 network ..."
acli net.create $VLAN_NAME vlan=$VLAN ip_config=$VLAN_IP_CONFIG;
echo "Adding DHCP pool ..."
acli net.add_dhcp_pool $VLAN_NAME start=$DHCP_START end=$DHCP_END;
echo "Configuring $VLAN_NAME DNS settings ..."
acli net.update_dhcp_dns $VLAN_NAME domains=$DOMAIN_NAME servers=$DNS_SERVER;

echo

# create VMs - Windows 2012
echo "Creating Windows 2012 R2 VM ..."
acli vm.create "Windows2012R2" num_vcpus=1 num_cores_per_vcpu=1 memory=8G;
echo "Attaching CDROM devices ..."
acli vm.disk_create "Windows2012R2" cdrom=true clone_from_image="Windows 2012 R2";
acli vm.disk_create "Windows2012R2" cdrom=true clone_from_image="VirtIO";
echo "Creating system disk ..."
acli vm.disk_create "Windows2012R2" create_size=$WINDOWS_DISK_SIZE;
echo "Creating network adapter ..."
acli vm.nic_create "Windows2012R2" network=$VLAN_NAME;
echo "Powering on Windows 2012 R2 VM ..."
acli vm.on "Windows2012R2";

echo

# create VMs - CentOS 7
echo "Creating CentOS 7 VM ..."
acli vm.create "CentOS7" num_vcpus=1 num_cores_per_vcpu=1 memory=1G;
echo "Attaching CDROM device ..."
acli vm.disk_create "CentOS7" cdrom=true clone_from_image="CentOS 7";
echo "Creating system disk ..."
acli vm.disk_create "CentOS7" create_size=$CENTOS_DISK_SIZE;
echo "Creating network adapter ..."
acli vm.nic_create "CentOS7" network=$VLAN_NAME;
echo "Powering on CentOS 7 VM ..."
acli vm.on "CentOS7";

echo

# create VMs - Prism Central
echo "Creating Prism Central VM ..."
acli vm.create "Prism Central" num_vcpus=$PRISM_CENTRAL_CPUS num_cores_per_vcpu=1 memory=$PRISM_CENTRAL_RAM;
echo "Attaching Boot & Data disks ..."
acli vm.disk_create "Prism Central" clone_from_image="PC_4502_Boot";
acli vm.disk_create "Prism Central" clone_from_image="PC_4502_Data";
echo "Creating network adapter ..."
acli vm.nic_create "Prism Central" network=$VLAN_NAME ip=$PRISM_CENTRAL_IP;
echo "Powering on Prism Central VM ..."
acli vm.on "Prism Central";

echo
echo "Finished!"
echo