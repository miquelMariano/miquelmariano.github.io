---
title: Instalación y configuración desatendida de VMWare ESXi
date: '2018-05-30 00:00:00'
layout: post
image: /assets/images/posts/2018/05/esxi_auto.png
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- devops
- esxi
- automation
category: blog
author: miquelMariano
description: Instalación y configuración desatendida de VMWare ESXi
hidden: false
comments: true
---

Buenos dias a tod@as!!

En este post de hoy, vamos a ver como realizar una configuración desatendida de nuestros hosts ESXi en el momento de la instalación con el fichero "kickstart".

Este método de automatizar el despliegue de vuestros ESXi está totalmente soportado por VMWare y en [esta KB](https://kb.vmware.com/s/article/2004582) podréis encontrar más información.

Este fichero de configuración kickstart puede estar disponible en múltiples ubicaciones, entre ellas: 
* FTP 
* HTTP / HTTPS 
* NFS Share 
* Unidad flash USB * Dispositivo CD / DVD
* ...

En este caso, y aprovechando que [ya sabemos cómo montarnos nuestro propio servidor FTP portable](https://miquelmariano.github.io//2017/07/xlight-FTP/) utilizaremos el método por FTP.

En primer lugar, necesitaremos un fichero de configuración. En mi caso, lo he llamado ks.cfg


```ssh
### Custom ESXi kick start installation Script

### Author: Miquel Mariano | miquelMariano.github.io | @miquelMariano
### Date: 28.05.2018
### Tested with: ESXi 6.7
### Usage: ks=https://https://miquelmariano.github.io/assets/KickStartFiles/demo.cfg nameserver=192.168.6.100 ip=192.168.6.78 netmask=255.255.255.0 gateway=192.168.6.1 vlaid=6
### Usage: ks=ftp://ftp.ncora.com/ks.cfg nameserver=192.168.6.100 ip=192.168.6.78 netmask=255.255.255.0 gateway=192.168.6.1 vlaid=6


##### Stage 01 - Pre installation:
 
    ### Accept the VMware End User License Agreement
    vmaccepteula
 
    ### Set the root password for the DCUI and Tech Support Mode
    rootpw Secret123!

    ### Set the keyboard type
    keyboard 'Spanish'
     
    ### The install media (priority: local / remote / USB)
    install --firstdisk=local --overwritevmfs --novmfsondisk
 
    ### Set the network to DHCP on the first network adapter
    network --bootproto=static --device=vmnic0 --ip=192.168.6.35 --netmask=255.255.255.0 --gateway=192.168.6.1 --nameserver=192.168.6.100,192.168.6.101 --hostname=formacionesxi01 --vlanid=6 --addvmportgroup=0
 
    ### Reboot ESXi Host
    reboot --noeject
 
##### Stage 02 - Post installation:
 
    ### Open busybox and launch commands
    %firstboot --interpreter=busybox
 
    ### Set Search Domain
    esxcli network ip dns search add --domain=ncoraformacion.local
 
    ### Add second NIC to vSwitch0
    esxcli network vswitch standard uplink add --uplink-name=vmnic1 --vswitch-name=vSwitch0
 
    ###  Disable IPv6 support (reboot is required)
    esxcli network ip set --ipv6-enabled=false
 
    ### Add NTP Server addresses
    echo "server 192.168.6.100" >> /etc/ntp.conf;
    echo "server 192.168.6.101" >> /etc/ntp.conf;
 
    ### Allow NTP through firewall
    esxcfg-firewall -e ntpClient
     
    ### Enable NTP autostartup
    /sbin/chkconfig ntpd on;
 
    ### Rename local datastore (currently disabled because of --novmfsondisk)
    vim-cmd hostsvc/datastore/rename datastore1 "$(hostname -s)"
 
    ### Disable CEIP
    esxcli system settings advanced set -o /UserVars/HostClientCEIPOptIn -i 2
     
    ### Enable maintaince mode
    esxcli system maintenanceMode set -e true
     
    ### Reboot
    esxcli system shutdown reboot -d 15 -r "rebooting after ESXi host configuration"
```

Una vez tengamos el fichero preparado y accesible por FTP (mediante el usuario anónimo), será el momento de arrancar el instalador del ESXi y hacer la llamada a este fichero.

* Paso 1: Arrancar nuestro servidor con la ISO de instalación del ESXi.
* Paso 2: Pulsamos `shift + o` en el momento del arranque del instalador
* Paso 3: añadiremos la siguiente línea para hacer la llamada al fichero kickstart (con nuestra propia configuración IP, claro está. Esta configuración es temporal, para poder descargarse el fichero de configuración. NO es la IP que se quedará en el ESXi)

```ssh
ks=ftp://ftp.ncora.com/ks.cfg nameserver=192.168.6.100 ip=192.168.6.78 netmask=255.255.255.0 gateway=192.168.6.1 vlaid=6
```
* Paso 4: Una vez finalizada la instalación, automáticamente el ESXi se reiniciará y ya estará configurado con los parámetros pasados en el fichero de configuración

![ks01]({{ site.imagesposts2018 }}/05/ks01.png)

![ks02]({{ site.imagesposts2018 }}/05/ks02.png)

Y hasta aquí por hoy, espero que sea de vuestro interés

Un saludo!

Miquel.


