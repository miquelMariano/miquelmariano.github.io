---
title: Back-to-basics 6 - Cambiar politica multipath por defecto en hosts ESXi
date: '2017-09-22 00:00:00'
layout: post
image: /assets/images/posts/2018/12/psa.png
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- devops
- backtobasics
- storage
category: blog
author: miquelMariano
description: Back-to-basics 6 - Cambiar politica multipath por defecto en hosts ESXi
hidden: false
permalink: /default/
---

Buenos dias a tod@as!!

Siguiendo con la serie [back-to-basics](https://miquelmariano.github.io/tags/#backtobasics), en el post de hoy veremos como cambiar la politica predeterminada de multipathing de nuestros hosts ESXi.

Por defecto, la politica predeterminada tras instalar un ESXi es "Fixed", por lo tando todos los datastores que tenga montados este ESXi (y los que se montarán a futuro), estarán con esta política.

Cambiarlo, es una terea muy manual, ya que a través del vSphere Client tendremos que hacer el cambio en cada uno de los datastores. Imaginaos la faena en un entorno con varios ESXi y cada uno con varios datastores...

Para solucionar este problema y que de forma predeterminada nos coja otra política de multipathing (Round Robin por ejemplo) seguiremos los siguientes pasos:

Lo primero que verificaremos es los módulos SATP (Storage Array Type Plugin) que tiene cargados el esxi. Normalmente utilizaremos el `VMW_SATP_ALUA`

```ssh
esxcli storage nmp satp list
```

Para cambiar la política de multipacing PSP (Path Selection Plugin), ejecutaremos el siguiente comando:

```ssh
# esxcli storage nmp satp set --default-psp=VMW_PSP_RR --satp=VMW_SATP_ALUA
```

Las políticas PSP disponibles por defecto son: 

```
VMW_PSP_MRU for Most Recently Used mode
VMW_PSP_FIXED for Fixed mode
VMW_PSP_RR for Round Robin mode
```

Y finalmente, será necesario un reinicio para que los cambios surtan efecto.


Por último, si es de vuestro interés, encontrareis también toda la info en la [KB oficial de VMWare](https://kb.vmware.com/s/article/1017760)


Un saludo!

Miquel.


