---
title: Aumentar tiempo de cierre de sesión en vSphere Client
date: '2018-07-26 00:00:00'
layout: post
image: /assets/images/posts/2018/07/timeout.png
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- vcenter
---

Buenos dias a tod@s!

Los que trabajáis continuamente con el vSphere Client, os abréis dado cuenta que durante vuestra jornada laboral estais continuamente haciendo login en el cliente. Eso es debido a que el timeout de la sesión, por defecto está en 2 minutos.

A continuación vamos a ver como cambiar este tiempo modificando el fichero `webclient.properties` 

Para vCenter Server Appliance, el fichero se encuentra en:

* Flash-based Web Client - `/etc/vmware/vsphere-client/`

* vSphere Client in vSphere 6.5 - `/etc/vmware/vsphere-ui/`

Simplemente tendremos que modificar la siguiente linea

```ssh
# Web client session timeout in minutes, default is 120, i.e. 2 hours
session.timeout = 120
```

Y por último, reiniciar los servicios.

Reiniciar el servicio Flash-based Web Client 

```ssh
service-control --stop vsphere-client
service-control --start vsphere-client
```

Reiniciar HTML5 vSphere Client 

```ssh
service-control --stop vsphere-ui
service-control --start vsphere-ui
```

Para los que todavía sigáis manteniendo el vCenter sobre windows, en la [KB oficial](https://kb.vmware.com/s/article/2040626) también explica como cambiarlo.

Espero que sea de vuestro interés.

Un saludo!!

Miquel.