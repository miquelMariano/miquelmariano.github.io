---
title: Cambiar cadena conexión de Veeam Backup
date: '2019-04-24 00:00:00'
layout: post
image: /assets/images/posts/2019/04/veeam-logo.png
tag:
- vmware
- vsphere
- vexpert
- veeam
- backup
---

Buenos días a tod@as!!

Posiblemente os hayáis encontrado alguna vez la necesidad de cambiar la cadena de conexión de nuestro Veeam Backup a nuestro vCenter.

La solución es muy sencilla y se podrá realizar siempre y cuando la BBDD del vCenter no se haya cambiado.

Este procedimiento nos servirá, por ejemplo, durante una migración de dominio, en el que el nombre de nuestro vCenter pasa a ser vCenter.dominio-A.local a vCenter.dominio-B.local

Lo primero que os quiero enseñar, es que desde la consola de Veeam B&R la conexión no se puede modificar (tampoco eliminar si hay jobs vinculados a esa conexión):

![veeam1]({{ site.imagesposts2019 }}/04/veeam1.png)

Para modificar la conexión sin corromper los jobs y evitar tener que recrearlos de nuevo, abriremos un Power Shell desde el propio Veeam:

![veeam2]({{ site.imagesposts2019 }}/04/veeam2.png)

Con el siguiente comando, crearemos una variable con el nombre actual de nuestro vCenter:

```powershell
$Servers = Get-VBRServer -name "Current-VCName/IP"
```

Y una vez tengamos la variable, le modificaremos el nombre de la conexión:

```powershell
$Servers.SetName("New-VCName/IP")
```

![veeam3]({{ site.imagesposts2019 }}/04/veeam3.png)

Tras estos pasos, será necesario cerrar y abrir de nuevo la consola GUI de Veeam Backup para ver que efectivamente los cambios han surgido efecto:

![veeam4]({{ site.imagesposts2019 }}/04/veeam4.png)

Espero que os sea de utilidad.

Encontrareis la KB oficial de Veeam, [aquí](https://www.veeam.com/kb1905)

Un saludo!

Miquel.


