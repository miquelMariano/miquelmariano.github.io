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

Buenos dias a tod@s.

En el post de hoy, os traigo una de esas cosas algo desconocidas y que podemos hacer con un ESXi. 

Por suerte, no es muy frecuente, pero un problema/error/bug podría requerir a un administrador vSphere volver atrás una versión instalada de ESXi. 

Hacer un rollback en un ESXi no es una acción que debamos tomarnos a la ligera, pero en un momento dado nos puede sacar de apuros.

Antes de hacer rollaback en un ESXi deberemos tener en cuenta los siguientes aspectos:

* **Sistema de ficheros VMFS**VMFS6 se introdujo con vSphere 6.5. Las versiones anteriores de ESXi solo son compatibles con VMFS5. Si hacemos rollback de un servidor ESXi 6.5 o 6.7 a versiones anteriores y tenemos datastores en VMFS5, estos, no serán accesibles después del rollback.
* **Versión de hardware de VM:** vSphere 6.5 también introdujo el virtual hardware versión 13 (versión 14 en vSphere 6.7). Por ejemplo, el virtual hardware versión 13 no es compatible con ESXi 6.0. Hacer rollback y quedarnos con VMs con virtual hardware superior a la versión del ESXi supondrá que esas VMs no podrán ser encendidas.

También es recomendable, antes de hacer cualquier actuación sobre un ESXi, tener un [backup](https://miquelmariano.github.io/2018/03/backup-restore-esxi-configuration/) consistente del mismo.

Vamos al lio, antes de empezar, y para comprobar si nuestro ESXi puede hacer rollback a una versión anterior, deberemos ejecutar el siguiente comando:

```ssh
tail -2 /*bootbank/boot.cfg
```

![rollback0]({{ site.imagesposts2018 }}/11/rollback0.png)

Como podemos ver aquí, el arranque principal contiene el código ESXi 6.5 y el arranque alternativo contiene el código ESXi 6.0.

1| Poner nuestro esxi en "maintenance mode"

![rollback1]({{ site.imagesposts2018 }}/11/rollback1.png)

2| Procederemos con el reinicio del host

![rollback2]({{ site.imagesposts2018 }}/11/rollback2.png)
![rollback3]({{ site.imagesposts2018 }}/11/rollback3.png)

3| Durante el boot tendremos que pulsar `shift+R` para entrar en el modo recovery

![rollback4]({{ site.imagesposts2018 }}/11/rollback4.png)

4| Nos aparecerá la información de las posibilidades que tenemos y deberemos pulsar "Y"

Esta acción va a ser permanente, es decir, una vez tirado el rollback ya no tendremos opción de recuperar la versión mas reciente.

![rollback5]({{ site.imagesposts2018 }}/11/rollback5.png)

5| Tras el reinicio, comprobaremos que la versión del ESXi es la previa a la que teniamos.

![rollback6]({{ site.imagesposts2018 }}/11/rollback6.png)

6| Deberemos conectar de nuevo nuestro ESXi al vCenter

![rollback7]({{ site.imagesposts2018 }}/11/rollback7.png)

7| Y por último salir del "maintenance mode"

![rollback8]({{ site.imagesposts2018 }}/11/rollback8.png)

Espero que este pequeño procedimiento os sirva ;-)

Un saludo!

Miquel.