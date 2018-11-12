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
permalink: /removevib/
---

Últimamente me estoy encontrando con algunas incompatibilidades al intentar actualizar los ESXi de nuestros clientes a la versión 6.5.

Dichas incompatibilidades se deben a algunos paquetes que vienen heredados de instalaciones y versiones anteriores de ESXi y que no son compatibles con ESXi 6.5.

![removevib1]({{ site.imagesposts2018 }}/11/removevib1.png)

La solución es bien sencilla y pasa por desinstalar estos paquetes.

Para ello, utilizaremos el comando Esxcli de la siguiente manera.

1. Buscaremos el nombre del paquete incompatible:

```ssh
esxcli software vib list | grep scsi-mpt3
```

2. Lo desinstalaremos con el siguiente comando:

```ssh
esxcli software vib remove -n scsi-mpt3sas
```

![removevib2]({{ site.imagesposts2018 }}/11/removevib2.png)

Una vez desinstalado, ya podremos proceder a la actualización de nuestro servidor ESXi 6.5 mediante Update Manager.

Espero que sea de vuestro interés y no dudéis en dejar un comentario con vuestras dudas o sugerencias.

¡Un abrazo!

Miquel.