---
title: Back-to-basics 5 - Memory balloon
date: '2018-10-03 00:00:00'
layout: post
image: /assets/images/posts/2018/10/balloon.jpeg
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- devops
- backtobasics
category: blog
author: miquelMariano
description: Back-to-basics 5 - Memory balloon
hidden: false
permalink: /balloon/
---

Hace un par de días, uno de mis alumnos en el curso [Administración vSphere 6.7](https://www.ncora.com/formacion-tic/administracion-de-vsphere/administracion-vsphere-67-training-pack/) me preguntaba sobre el proceso "ballooning". 

Para todos aquellos que tengan alguna duda sobre que es y como funciona, aquí os dejo este post de la serie [back-to-basics](https://miquelmariano.github.io/tags/#backtobasics)

Memory balloon, es un proceso que ocurre cuando un host se está quedando sin memoria física disponible. Para que esto ocurra, es necesario tener el driver balloon instalado en el SO dentro de cada VM. Este driver, forma parte de las VMWare tools, por lo que sólo tenemos que asegurarnos de que estén instaladas en todas nuestras VMs.

### Vale, pero ¿cómo funciona?

* La máquina virtual A necesita memoria, pero, el hipervisor no tiene más memoria física disponible para asignarle.
* La máquina virtual B tiene algo de memoria infrautilizada, pero tampoco es plan de quitarle memoria a nuestra VM a las bravas.
* El driver de balloon instalado (con las VMWare Tools)en VM B "se infla" y esta memoria ahora está disponible para el hipervisor.
* El hipervisor hace que este "globo" de memoria esté disponible para VM A, y todos contentos ;-)
* Una vez que haya más memoria física disponible, el globo en VM B 'se desinfla' y cada VM vuelve a disfrutar de la memoria que tenga asignada.

![balloon1]({{ site.imagesposts2018 }}/10/balloon1.png)

Este proceso de ballooning es una gran ventaja, ya que hace posible una utilización de la memoria física mucho mas eficiente.

Todo este proceso es completamente invisible para el sistema operativo que reside en la VM, sin embargo, puede afectar en el rendimiento. Un exceso de "globos" en el hipervisor (inflar y desinflar) puede afectar el rendimiento de nuestras máquinas y será tarea del administrador
el detectar que esto no ocurra.

### ¿Cómo controlar el uso del proceso ballooning?

Como administradores, disponemos de algunas herramientas que nos da VMWare para controlar estos valores. Por ejemplo a través del propio performance monitor que tenemos en el vCenter

El contador `vmmemctl` es el que nos indica la cantidad de memoria que recupera el driver balloon. Lo normal, si no hay competencia en vuestra infraestructura virtual, es que la métrica siempre esté a 0

![balloon3]({{ site.imagesposts2018 }}/10/balloon3.png)

También con la herramienta `esxcli` tendremos mucha información de como se está comportando nuestro entorno

![balloon2]({{ site.imagesposts2018 }}/10/balloon2.png)

**“MCTL?”**: indicates if the balloon driver is active “Y” or not “N”. If VMware tools is not installed or not running this value will show as “N”

**“MCTLSZ”**: the amount (in MB) of guest physical memory that is actually reclaimed by the balloon driver

**“MCTLTGT”**: the amount (in MB) of guest physical memory that is going to be reclaimed (targeted memory). If this counter is greater than “MCTLSZ”, the balloon driver inflates causing more memory to be reclaimed. If “MCTLTGT” is less than “MCTLSZ”, then the balloon will deflate. This deflating process runs slowly unless the guest requests memory.

**“MCTLMAX”**: the maximum amount of guest physical memory that the balloon driver can reclaim. Default is 65% of assigned memory.

Ya para finalizar, comentar también que si bien no es lo ideal, en caso de tengáis fuerte competencia en vuestro entorno por los recursos de memoria, podéis hacer servir las "reservas"

Para evitar inflar/desinflar el driver balloon, puede crear una "reserva de memoria" para la máquina virtual, garantizando una cantidad de memoria física. 

Espero que os sea de utilidad.

Un saludo!

Miquel.


