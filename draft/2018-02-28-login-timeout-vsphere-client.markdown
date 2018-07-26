---
title: Back-to-basics 4 - vSphere HA
date: '2018-02-28 00:00:00'
layout: post
image: /assets/images/posts/2018/06/ha0.png
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- devops
- backtobasics
category: blog
author: miquelMariano
description: Back-to-basics 4 - vSphere HA
hidden: false
permalink: /timeout/
---

Buenos dias a tod@s!

Los que trabajais continuamente con el vSphere Client, os abreis dado cuenta que durante vuestra jornada laboral estais continuamente haciendo login en el cliente. Eso es debido a que el timeout de la sesión, por defecto está en 2 minutos.

A continuación vamos a ver como cambiar este tiempo modificando el fichero `webclient.properties` 

Para vCenter Server Appliance, el fichero se encuentra en:

* Flash-based Web Client - /etc/vmware/vsphere-client/

* vSphere Client in vSphere 6.5 - /etc/vmware/vsphere-ui/

Simplemente tendremos que modificar la siguiente linea

```ssh
# Web client session timeout in minutes, default is 120, i.e. 2 hours
session.timeout = 120

```

Y por último, reiniciar los servicios


Reiniciar el servicio Flash-based Web Client 

```ssh
service-control --stop vsphere-client
service-control --start vsphere-client
```

Reinicial HTML5 vSphere Client 

```ssh
service-control --stop vsphere-ui
service-control --start vsphere-ui
```



https://kb.vmware.com/s/article/2040626