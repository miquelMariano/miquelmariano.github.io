---
title: Back-to-basics 3 - ESXi logs
date: '2018-04-18 00:00:00'
layout: post
image: /assets/images/posts/2018/03/logs.png
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- devops
- backtobasics
---

Buenos dias a tod@as!!

En el post de hoy, y siguiendo con la serie [back-to-basics](https://miquelmariano.github.io/tags/#backtobasics), vamos a ver [donde se encuentran los principales logs de un entorno VMWare](https://kb.vmware.com/s/article/1021806)

Para mí, los mas interesantes son los de un host ESXi, ya que es desde donde podremos extraer la mayor información de lo que está pasando en en entorno. Ahí van los principales logs y donde los encontraremos.

![esxilogs]({{ site.imagesposts2018 }}/04/esxilogs.png)

Para leerlos, desde una sesión SSH, simplemente tendremos que ejecutar el comando `tail -f nombre\del\log` y en tiempo real veremos como se va actualizando con todo lo que está pasando.

También nos pueden resultar de utilidad los propios [logs de las VMs](https://www.ncora.com/blog/configuracion-de-logs-en-maquinas-virtuales/), que estos, se almacenan en la misma carpeta donde está la VM en el datastore.

Espero que os pueda ser de utilidad.


Un saludo!

Miquel.


