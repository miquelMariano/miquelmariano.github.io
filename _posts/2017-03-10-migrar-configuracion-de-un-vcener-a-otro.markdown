---
title: Migrar configuración de un vCenter a otro
layout: post
date: 2017-03-10 00:00:00
image: /assets/images/posts/2017/03/vcenter-migrate-logo.png
headerImage: true
tag:
- vmware
- vsphere
- dvswitch
- drs
- vexpert
- powercli
category: blog
author: miquelMariano
description: Migrar configuración de un vCenter a otro
hidden: false
comments: true
---

En el post de hoy voy a mostraros como migrar las configuraciones de un vCenter a otro.

El problema se plantea cuando por un motivo u otro es necesario hacer una reinstalación "start from the scratch" y claro, necesitamos mantener ciertas configuraciones:

+ dvSwitches
+ Roles
+ Permisos
+ Estructura de carpetas
+ Configuración/reglas de DRS

La migración de un vdSwitch es relativamente sencilla, simplemente con el [procedimiento de export/import](https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2034602) tendremos la configuración en el nuevo vCenter.

El reto se plantea al querer migrar el resto de configuraciones, que por su volúmen, se hace imposible hacerlo de forma manual.

Gracias a la comunidad, encontré este [post](https://virtuallyjason.blogspot.com.es/2016/02/migrating-from-one-vcenter-to-another.html) que me resultó tremendamente interesente para hacer la migración de una manera menos "dolorosa"

Antes de empezar, deberemos descargarnos [estos modulos DRS](https://github.com/PowerCLIGoodies/DRSRule) e importarlos a PowerCLI, en mi caso, con el comando:

```powershell
Import-Module .\DRSRule-master\DRSRule.psm1
```

![powercli]({{ site.imagesposts2017 }}/03/powercli-set-executionpolicy.png)

El proceso es sencillo, para exportar:

```powershell
.\Get-SourceSettings.ps1 -directory c:/tmp -datacenter VDC
```

Y para el import:

```powershell
.\Set-SourceSettings.ps1 -directory c:/tmp -datacenter VDC -vms
```

Con los siguienes "modificadores" podremos indicar que queremos importar

+ -VMs
+ -Folders
+ -Permissions
+ -DRS 
+ -Roles

Ahi van los scripts:

+ [Get-SourceSettings.ps1](https://miquelmariano.github.io/Set-SourceSettings)
+ [Set-SourceSettings.ps1](https://miquelmariano.github.io/Set-SourceSettings)

Espero que os sea de utilidad tanto como a mi y os pueda sacar de algún que otro apuro ;-)
 
Un saludo

Miquel.