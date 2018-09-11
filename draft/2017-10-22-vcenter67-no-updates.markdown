---
title: vCenter 6.7 no muestra actualizaciones disponibles
date: '2017-09-22 00:00:00'
layout: post
image: /assets/images/posts/2018/08/awx-logo.png
headerImage: true
tag:
- vcenter
- vami
- vexpert
- vsphere
- vmware
category: blog
author: miquelMariano
description: vCenter 6.7 no muestra actualizaciones disponibles
hidden: false
permalink: /update/
---

Buenos dias a tod@as!!

Es probable que os hayais dado cuenta que al intentar actualizar vuestro vCenter 6.7 a la última build, desde el portal VAMI, no se encuentra ninguna actualización disponible

![vcsa1]({{ site.imagesposts2018 }}/10/vcsa1.png)
![vcsa2]({{ site.imagesposts2018 }}/10/vcsa2.png)

Comprobamos el el [portal de VMWare](https://kb.vmware.com/s/article/2143838?CoveoV2.CoveoLightningApex.getInitializationData=1&r=3&other.KM_Utility.getArticleDetails=1&other.KM_Utility.getArticleMetadata=1&other.KM_Utility.getUrl=1&other.KM_Utility.getUser=1&other.KM_Utility.getAllTranslatedLanguages=1&ui-comm-runtime-components-aura-components-siteforce-qb.Quarterback.validateRoute=1) y realmente si que deberia haber parches disponibles

![buildnumbers]({{ site.imagesposts2018 }}/10/buildnumbers.png)

El problema, es un error conocido documentado en la [KB55683](https://kb.vmware.com/s/article/55683) y que por el momento no tiene solucion.

El workarround que propone VMWare es cambiar el repositorio de descarga, por este:

`https://vapp-updates.vmware.com/vai-catalog/valm/vmw/8d167796-34d5-4899-be0a-6daade4005a3/6.7.0.10000.latest/.`

![vcsa3]({{ site.imagesposts2018 }}/10/vcsa3.png)
![vcsa4]({{ site.imagesposts2018 }}/10/vcsa4.png)

Espero que os sea de utilidad

Un saludo!

Miquel.


