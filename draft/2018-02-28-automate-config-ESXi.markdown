---
title: Automatizando configuración de VMWare ESXi tras instalación
date: '2018-02-28 00:00:00'
layout: post
image: /assets/images/posts/2018/05/esxi_auto.png
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- devops
- backtobasics
category: blog
author: miquelMariano
description: Automatizando configuración de VMWare ESXi tras instalación
hidden: false
permalink: /configesxi/
---

https://be-virtual.net/automated-installation-with-vmware-esxi-5-56-06-5/

Buenos dias a tod@as!!

```ssh
### ESXi Installation Script
### Hostname: LAB-ESXi01A
### Author: M. Buijs
### Date: 2017-08-11
### Tested with: ESXi 6.0 and ESXi 6.5
 
##### Stage 01 - Pre installation:
 
    ### Accept the VMware End User License Agreement
    vmaccepteula
 
    ### Set the root password for the DCUI and Tech Support Mode
    rootpw VMware1!
     
    ### The install media (priority: local / remote / USB)
    install --firstdisk=local --overwritevmfs --novmfsondisk
 
    ### Set the network to DHCP on the first network adapter
    network --bootproto=static --device=vmnic0 --ip=192.168.151.101 --netmask=255.255.255.0 --gateway=192.168.151.254 --nameserver=192.168.126.21,192.168.151.254 --hostname=LAB-ESXi01A.lab.local --addvmportgroup=0
 
    ### Reboot ESXi Host
    reboot --noeject
 
##### Stage 02 - Post installation:
 
    ### Open busybox and launch commands
    %firstboot --interpreter=busybox
 
    ### Set Search Domain
    esxcli network ip dns search add --domain=lab.local
 
    ### Add second NIC to vSwitch0
    esxcli network vswitch standard uplink add --uplink-name=vmnic1 --vswitch-name=vSwitch0
 
    ###  Disable IPv6 support (reboot is required)
    esxcli network ip set --ipv6-enabled=false
 
    ### Add NTP Server addresses
    echo "server 192.168.126.21" >> /etc/ntp.conf;
    echo "server 192.168.151.254" >> /etc/ntp.conf;
 
    ### Allow NTP through firewall
    esxcfg-firewall -e ntpClient
     
    ### Enable NTP autostartup
    /sbin/chkconfig ntpd on;
 
    ### Rename local datastore (currently disabled because of --novmfsondisk)
    #vim-cmd hostsvc/datastore/rename datastore1 "DAS - $(hostname -s)"
 
    ### Disable CEIP
    esxcli system settings advanced set -o /UserVars/HostClientCEIPOptIn -i 2
     
    ### Enable maintaince mode
    esxcli system maintenanceMode set -e true
     
    ### Reboot
    esxcli system shutdown reboot -d 15 -r "rebooting after ESXi host configuration"
```




Un saludo!

Miquel.


