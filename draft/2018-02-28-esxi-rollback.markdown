---
title: Rollback en VMWare ESXi 6.x
date: '2018-02-28 00:00:00'
layout: post
image: /assets/images/posts/2018/11/esxi-rollback.png
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- esxi
category: blog
author: miquelMariano
description: Rollback en VMWare ESXi 6.x
hidden: false
permalink: /rollback/
---

http://www.virtubytes.com/2017/11/16/downgrade-esxi-6-5/

Buenos dias a tod@s.

En el post de hoy, os traigo una de esas cosas algo desconocidas y que podemos hacer con un ESXi. 

Por suerte, no es muy frecuente, pero un problema/error/bug podría requerir a un administrador vSphere volver atrás una versión instalada de ESXi. 

Hacer un rollback en un ESXi no es una acción que debamos tomarnos a la ligera, pero en un momento dado nos puede sacar de apuros.

Antes de hacer rollaback en un ESXi deberemos tener en cuenta los siguientes aspectos:

* **VMFS 6:**VMFS 6 se introdujo con vSphere 6.5. Sin embargo, vSphere 6.0 utilizó VMFS 5. Si creó una versión VMFS 6 con ESXi 6.5, no podrá acceder al almacén de datos después de la reversión.
* **Versión de hardware de VM:** vSphere 6.5 también introdujo el hardware de la máquina virtual de la versión 13. El hardware de la versión 13 no es compatible con ESXi 6.0. La versión 11 o inferior es compatible . Sin embargo, hay algunas opciones compatibles para degradar las versiones de hardware de máquinas virtuales.

tail -2 /*bootbank/boot.cfg`

![rollback0]({{ site.imagesposts2018 }}/11/rollback0.png)

![rollback1]({{ site.imagesposts2018 }}/11/rollback1.png)
![rollback2]({{ site.imagesposts2018 }}/11/rollback2.png)
![rollback3]({{ site.imagesposts2018 }}/11/rollback3.png)
![rollback4]({{ site.imagesposts2018 }}/11/rollback4.png)
![rollback5]({{ site.imagesposts2018 }}/11/rollback5.png)
![rollback6]({{ site.imagesposts2018 }}/11/rollback6.png)