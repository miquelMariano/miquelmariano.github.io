---
title: End of General Support para vSphere 5.5
date: '2018-09-20 00:00:00'
layout: post
image: /assets/images/posts/2018/09/support.png
headerImage: true
tag:
- vmware
- vsphere
category: blog
author: miquelMariano
description: End of General Support para vSphere 5.5
hidden: false
comments: true
---

Buenos días a todos, como muchos ya sabréis, ayer 19 de septiembre de 2019 vSphere 5.5 se quedó fuera de la fase de "General Support"

Muchos de nosotros, ya nos hemos preocupado de actualizar nuestros entornos a una versión 6.x, por miedo/preocupación en que nos afecten temas de compatibilidad o simplemente por seguir evolucionando nuestra infraestructura.

Pero, que es realmente "End of General Support" y la nueva fase en la que hemos entrado de "Technical Guidance"

![eol]({{ site.imagesposts2018 }}/09/eol.png)

Primero de todo, cabe aclarar que salir de la fase "General Support" no significa que de repente el producto se vuelva inestable y nuestra infraestructura se vaya a caer.

"Technical Guidance" significa que aunque soporte nos seguirá "orientando" cuando tengamos una incidencia. La severidad 1 deja de existir y el contacto telefónico también. Podremos seguir abriendo casos de soporte, pero muy probablemente, quien nos atienda no hará mas que guiarnos hacia el portal de autoayuda y a las KB oficiales de VMware.

Tampoco se evolucionará más el producto, por lo tanto dejaremos de recibir actualizaciones.

La documentación del ciclo de vida del producto, así lo indica:

>“Technical Guidance is available primarily through the self-help portal and telephone support is 
>not provided. Customers can also open a support request online to receive support and workarounds 
>for low-severity issues on supported configurations only. During the Technical Guidance phase, 
>VMware does not offer new hardware support, server/client/guest OS updates, new security patches 
>or bug fixes unless otherwise noted. This phase is intended for usage by customers operating in 
>stable environments with systems that are operating under reasonably stable loads.”

A parte de todo esto, hay que tener en cuenta que vSphere 5.5 vió la luz en 2013 y desde entonces ya han aparecido tres versiones más recientes del producto. La mayoria de las incidencias que recibirá hoy en dia VMWare tendrán que ver con las versiones mas recientes, por lo que es probable que  muchos ingenieros de soporte tengan mas agilidad en vSphere 6.x que en resolver problemas complejos en vSphere 5.5

Así que ya lo sabeis, ha llegado la hora de actualizar vuestro entorno a vSphere 6.x

![upgradepath]({{ site.imagesposts2018 }}/09/upgradepath.png)

En el siguiente [enlace](https://www.vmware.com/content/dam/digitalmarketing/vmware/en/pdf/support/product-lifecycle-matrix.pdf) podreis ver la matriz del ciclo de vida de los diferentes productos que VMWare tiene en el mercado.

Un saludo!!

Miquel.



