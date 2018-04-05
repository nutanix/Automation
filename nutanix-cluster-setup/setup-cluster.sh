#!/bin/sh

ncli=/home/nutanix/prism/cli/ncli
acli=/usr/local/nutanix/bin/acli
cvm_ips=10.120.100.30,10.120.100.31,10.120.100.32,10.120.100.33
cluster_name=NTNX-Demo
cluster_ip=10.120.100.35
cluster_ds_ip=10.120.100.45
dns_ip=8.8.8.8
ntp_server=0.au.pool.ntp.org
timezone=Australia/Melbourne
sp_name=sp1
container_name=NTNX-Container
images_container_name=Images
centos_image=CentOS7-Install
centos_annotation="CentOS7-Installation-ISO"
centos_source=http://centos.mirror.digitalpacific.com.au/7/isos/x86_64/CentOS-7-x86_64-Minimal-1611.iso
vlan_name=vlan.0
vlan_id=0
vlan_ip_config=10.120.100.253/24
dhcp_pool_start=10.120.100.140
dhcp_pool_end=10.120.100.179
domain_name=ntnxdemo.local
centos7_vm_name=CentOS7-VM
centos7_vm_disk_size=20G

# discover available nodes
echo Discovering nodes ...
/usr/local/nutanix/cluster/bin/discover_nodes

# create cluster
echo Creating cluster ...
/usr/local/nutanix/cluster/bin/cluster -s $cvm_ips create --redundancy_factor=2

# pause while Prism services restart
echo Pausing for 30s while Prism services start ...
sleep 30s

# rename cluster
echo Setting cluster name, adding cluster external IP address and adding cluster external data services IP address ...
$ncli cluster edit-params new-name="$cluster_name" external-ip-address="$cluster_ip" external-data-services-ip-address="$cluster_ds_ip"

# specify DNS and NTP servers
echo Adding DNS and NTP servers ...
$ncli cluster add-to-name-servers servers="$dns_ip"
$ncli cluster add-to-ntp-servers servers="$ntp_server"

# set cluster timezone
echo Setting cluster time zone ...
$ncli cluster set-timezone timezone=$timezone

# rename default storage pool
echo Renaming default storage pool ...
$ncli sp edit name=`$ncli sp ls | sed -n 4p | awk -F": " '{print $NF}'` new-name="$sp_name"

# rename default container
echo Renaming default container ...
$ncli ctr edit name=`$ncli ctr ls | sed -n 5p | awk -F": " '{print $NF}'` new-name="$container_name"

# creating container for storing images
$ncli container create sp-name="$sp_name" name="$images_container_name" rf="2" enable-compression="true" fingerprint-on-write="off" on-disk-dedup="off"

# create CentOS 7 VM image
echo Creating CentOS 7 image - this can take a while, depending on your internet connection ...
$acli image.create "$centos_image" image_type=kIsoImage container="$images_container_name" annotation="$centos_annotation" source_url="$centos_source"

# create network
echo Creating $vlan_name network ...
$acli net.create $vlan_name vlan=$vlan_id ip_config=$vlan_ip_config
echo Adding DHCP pool ...
$acli net.add_dhcp_pool $vlan_name start=$dhcp_pool_start end=$dhcp_pool_end
echo Configuring $vlan_name DNS settings ...
$acli net.update_dhcp_dns $vlan_name domains=$domain_name servers=$dns_ip

# create VMs - CentOS 7
echo Creating CentOS 7 VM ...
$acli vm.create $centos7_vm_name num_vcpus=1 num_cores_per_vcpu=1 memory=1G
echo Attaching CDROM device ...
$acli vm.disk_create $centos7_vm_name cdrom=true clone_from_image="$centos_image"
echo Creating system disk ...
$acli vm.disk_create $centos7_vm_name create_size=$centos7_vm_disk_size container="$container_name"
echo Creating network adapter ...
$acli vm.nic_create $centos7_vm_name network=$vlan_name
echo Powering on CentOS 7 VM ...
$acli vm.on $centos7_vm_name

echo Done!