---
title: Error de certificado al actualizar a vCenter 6.5
date: '2018-12-20 00:00:00'
layout: post
tag:
- automation
- ansible
- devops
category: blog
author: miquelMariano
description: Error de certificado al actualizar a vCenter 6.5
hidden: false
---

Buenos dias a tod@as!!

Llevo un par de semanas actualizando varios VCSA 5.5 a VCSA 6.5 y en la mayoria de los casos me he encontrado con un error de certificado durante el proceso de actualización:

```
Error

The vCenter Server Appliance FQDN vCenterApp.hf.local does not match the configuration of the vCenter Server certificate. vCenter Server DNS names: "localhost.localdom, localhost" vCenter Server IP addresses: ""

Resolution

Verify that the vCenter Server certificate is valid and that it points to the vCenter Server Appliance FQDN.
```

![error]({{ site.imagesposts2018 }}/12/migracion-error.png)

La solución que he encontrado es sencilla, y pasa por regenerar los certificados del propio vCenter y reiniciarlo.

Encontrareis toda la info en la [esta KB](https://kb.vmware.com/s/article/2110772?lang=en_US)

Un saludo!

Miquel.


