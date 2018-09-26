---
title: Back-to-basics 5 - Memory balloon
date: '2018-02-28 00:00:00'
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
description: Back-to-basics 4 - vSphere HA
hidden: false
permalink: /balloon/
---

Hace un par de dias, uno de mis alumnos en el curso [Administracion vSphere 6.7](https://www.ncora.com/formacion-tic/administracion-de-vsphere/administracion-vsphere-67-training-pack/) me preguntaba sobre el proceso "ballooning". 

Para todos aquellos que tengan alguna duda sobre que es y como funiona, aquí os dejo este post de la serie [back-to-basics](https://miquelmariano.github.io/tags/#backtobasics)

Memoru balloon, es un fenómeno que ocurre cuando un host se está quedando sin memoria física disponible. Implica el uso de un controlador, denominado controlador de globo, instalado en el sistema operativo invitado (SO).

Entonces, ¿cómo sucede esto?

    La máquina virtual A necesita memoria, y el hipervisor no tiene más memoria física disponible.
    La máquina virtual B tiene algo de memoria infrautilizada.
    El controlador de globo en VM B 'se infla' y esta memoria ahora está disponible para el hipervisor.
    El hipervisor hace que este globo de memoria esté disponible para VM A.
    Una vez que haya más memoria física disponible, el globo en VM B 'se desinfla'.

Aquí hay una gran ventaja: la utilización de la memoria física es más eficiente, a expensas de posibles problemas de rendimiento. Hasta aquí todo bien.

Todo este proceso es invisible para el sistema operativo invitado, sin embargo, puede afectar el rendimiento en la máquina virtual. Un exceso de globos en el hipervisor (inflar y desinflar) puede afectar el rendimiento de cualquier aplicación en ejecución. Un administrador que soluciona problemas y supervisa solo la máquina virtual y el sistema operativo invitado no podrá identificar la causa raíz del problema, y ​​mucho menos solucionarlo. El globo puede manifestarse como una alta I / O de disco o latencia. Sin embargo, como puede ver, la causa raíz está en el nivel del hipervisor.

Para evitar inflar, puede crear una "reserva de memoria" para la máquina virtual, garantizando una cantidad de memoria física. El globo puede conducir al intercambio, otra técnica de gestión de la memoria


![balloon1]({{ site.imagesposts2018 }}/10/balloon1.png)

VMware actualizó vSphere HA en 2017


Un saludo!

Miquel.


