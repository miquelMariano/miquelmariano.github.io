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

Siguiendo con la serie [back-to-basics](https://miquelmariano.github.io/tags/#backtobasics), en el post de hoy veremos como cambiar la politica de multipathing de nuestros hosts ESXi.

```ssh
esxcli storage nmp satp list
```



```ssh
# esxcli storage nmp satp set --default-psp=VMW_PSP_RR --satp=VMW_SATP_ALUA
```
 
>VMW_PSP_MRU for Most Recently Used mode
>VMW_PSP_FIXED for Fixed mode
>VMW_PSP_RR for Round Robin mode

Por último, será necesario un reinicio para que los cambios surtan efecto.

Encontrareis también toda la info en la [KB oficial de VMWare](https://kb.vmware.com/s/article/1017760)




Un saludo!

Miquel.


