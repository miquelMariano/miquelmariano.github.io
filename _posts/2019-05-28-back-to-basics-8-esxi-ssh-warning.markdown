---
title: Back-to-basics 8 - Eliminar warning ESXi al habilitar SSH
date: '2019-05-28 00:00:00'
layout: post
image: /assets/images/posts/2019/05/ssh-logo.png
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- devops
- backtobasics
category: blog
author: miquelMariano
description: En el post de hoy veremos como eliminar ese molesto warning cuando habilitamos el servicio SSH en un host ESXi...º
hidden: false
comments: true
---

Buenos días a tod@as!!

Siguiendo con la serie [back-to-basics](https://miquelmariano.github.io/tags/#backtobasics), en el post de hoy veremos como eliminar ese molesto warning que se activa al habilitar SSH a nuestros ESXi.

Os habréis dado cuenta, que hal habilitar SSH en un host ESXi, os aparece esta alarma:

![ssh-warning-1]({{ site.imagesposts2019 }}/05/ssh-warning-1.png)

Para poder solucionar este warning sin tener que deshabilitar de nuevo ESXi, ya que lo queremos mantener arrancado para tareas de management, tendremos que editar las opciones avanzadas del host:

![ssh-warning-2]({{ site.imagesposts2019 }}/05/ssh-warning-2.png)

Tenemos que editar la variable `UserVars.SuppressShellWarning` que por defecto está a 0 y cambiarlo a 1:

![ssh-warning-3]({{ site.imagesposts2019 }}/05/ssh-warning-3.png)

Una vez guardemos los cambios, automáticamente el warning desaparecerá:

![ssh-warning-4]({{ site.imagesposts2019 }}/05/ssh-warning-4.png)

Aprovecho también la ocación, para recordaros que hace ya tiempo, publiqué un post de [cómo manejar ESXi mediante Ansible](https://miquelmariano.github.io/2017/07/esxi-configuration-with-ansible) y que en él explicaba como configurar SSH en los ESXi mediante [este role de galaxy](https://galaxy.ansible.com/miquelMariano/ESXi_ssh)

Espero que os sirva.

Un saludo!

Miquel.


