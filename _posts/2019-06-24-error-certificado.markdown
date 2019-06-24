---
title: Error de certificado al actualizar vCenter Server Appliance a 6.5
date: '2019-06-24 00:00:00'
layout: post
image: /assets/images/posts/2019/06/update-vcenter-server-appliance-6-5.png
headerImage: true
tag:
- vmware
- vexpert
- vcsa
---

Buenos dias a tod@as!!

Como sabéis, [la versión 5.5 de vSphere está fuera de soporte desde el pasado septiembre](https://miquelmariano.github.io/2018/09/end-general-support), así que es tiempo de migrar nuestros entornos a una versión superior y soportada.

Llevo ya un par de actualizaciones en varios clientes de VCSA 5.5 a VCSA 6.5 y en la mayoria de los casos me he encontrado con un error de certificado durante el proceso de actualización:

```
Error

The vCenter Server Appliance FQDN vCenterApp.hf.local does not match the configuration of the vCenter Server certificate. vCenter Server DNS names: "localhost.localdom, localhost" vCenter Server IP addresses: ""

Resolution

Verify that the vCenter Server certificate is valid and that it points to the vCenter Server Appliance FQDN.
```

![error]({{ site.imagesposts2018 }}/12/migracion-error.png)

La solución que he encontrado es sencilla, y pasa por regenerar los certificados del propio vCenter y reiniciarlo.

Encontrareis toda la info y el paso a paso en [esta KB](https://kb.vmware.com/s/article/2110772?lang=en_US)

Espero que os sirva.

Un saludo!

Miquel.


