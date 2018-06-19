---
title: Back-to-basics 4 - vSphere HA
date: '2018-02-28 00:00:00'
layout: post
image: /assets/images/posts/2018/06/ha0.png
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
permalink: /basics4/
---

https://searchvmware.techtarget.com/definition/VMware-HA

Buenos dias a todos

Continuando con la serie [back-to-basics](https://miquelmariano.github.io/tags/#backtobasics), en esta ocasión vamos a hablar sobre vSphere HA.

VMware introdujo por primera vez vSphere HA, creo recordar, en Virtual Infrastructure 3, allá por el 2006 y lo ha seguido desarrollando y mejorando con el paso del tiempo.

vSphere HA es una funcionalidad que nos da VMWare y que permite a un administrador agrupar servidores físicos en un mismo grupo lógico llamado clúster. Esto nos permite, que en caso de fallo de un servidor físico, vSphere HA detecta qué máquinas virtuales se han visto afectadas y las reinicia en otro servidor estable dentro del clúster. Este proceso de reinicio de cargas de trabajo fallidas en sistemas secundarios se denomina conmutación por error.

![ha1]({{ site.imagesposts2018 }}/06/ha1.png)

### Funciones de VMware vSphere HA
VMware vSphere HA permite a las organizaciones mejorar la disponibilidad detectando automáticamente máquinas virtuales con errores y reiniciándolas en diferentes servidores físicos sin la participación humana manual. La posibilidad de reiniciar estas máquinas virtuales en hardware físico diferente es posible porque los archivos del disco de la máquina virtual (VMDK) se guardan en el almacenamiento compartido, accesible para todos los servidores físicos conectados a través del clúster de HA.

 El planificador de recursos distribuidos (DRS) de VMware  se usa a menudo junto con vSphere HA para reequilibrar las cargas de trabajo que deben reiniciarse en hosts alternativos. Una organización que usa vSphere HA y DRS en conjunto puede garantizar que las VM reiniciadas no afecten el rendimiento de otras VM en el host de conmutación por error.

La característica de tolerancia a fallas de VMware también puede garantizar niveles muy altos de disponibilidad. Mientras que vSphere HA reinicia máquinas virtuales fallidas después de una detección breve y un tiempo de arranque, Fault Tolerance mantiene una copia redundante de la máquina virtual protegida que puede hacerse cargo de las operaciones de la copia fallida.

### Cómo funciona vSphere HA
VMware vSphere HA utiliza una utilidad llamada Fault Domain Manager Agent para monitorear la  disponibilidad del host de ESXi y reiniciar las máquinas virtuales fallidas. Al configurar vSphere HA, un administrador define un grupo de servidores para que sirvan como un clúster de alta disponibilidad. Fault Domain Manager se ejecuta en cada host dentro del clúster. Un host en el clúster sirve como  host principal  (todos los demás hosts se denominan  esclavos  ) para supervisar las señales de otros hosts en el clúster y comunicarse con vCenter Server.

 
VMware actualizó vSphere HA en 2017.
Los servidores host dentro de un clúster HA se comunican a través de un latido, que es un mensaje periódico que indica que un host se está ejecutando como se esperaba. Si el host principal no puede detectar una señal de latido de otro host o VM dentro del clúster, instruye a vSphere HA para que tome medidas correctivas. El tipo de acción depende del tipo de falla detectada, así como de las preferencias del usuario. En el caso de una falla de máquina virtual en la que el servidor host continúa ejecutándose, vSphere HA reinicia la máquina virtual en el host original. Si falla un host completo, la utilidad reinicia todas las VM afectadas en otros hosts en el clúster.

La utilidad HA también puede reiniciar máquinas virtuales si un host continúa ejecutándose, pero pierde una conexión de red con el resto del clúster. El host principal puede monitorear si ese host aún se está comunicando con los almacenes de datos conectados a la red para detectar si un host segregado por la red aún se está ejecutando. El almacenamiento compartido, como una  red de área de almacenamiento , permite que los hosts del clúster accedan a los archivos de disco de VM y reinicien la máquina virtual, incluso si se estaba ejecutando en otro servidor del clúster.

### Cómo configurar y usar vSphere HA
El primer paso para configurar vSphere HA es crear un clúster desde  vSphere Web Client  en Crear un clúster y luego seleccionar hosts ESXi y almacenamiento compartido para participar en el clúster. Los clústeres de HA deben contener al menos dos hosts, pero muchas organizaciones mantienen clústeres más grandes que agrupan más recursos y pueden acomodar múltiples fallas.

Un administrador puede activar la característica de vSphere HA desde el cliente web en Administrar> Configuración> vSphere HA. Finalmente, un usuario puede ajustar las configuraciones y preferencias de configuración de vSphere HA desde vSphere Web Client.

### Requisitos y mejores prácticas de VMware vSphere HA
Los administradores pueden ajustar muchas configuraciones de HA, incluido el tiempo que una VM o host no está disponible antes de que vSphere HA intente reiniciarlo; el valor predeterminado es 120 segundos. Un administrador puede configurar las preferencias de reinicio de VM, seleccionando el orden en que las VM se reinician en el clúster. Esta configuración es útil si, por ejemplo, no hay suficiente espacio en el clúster para reiniciar todas las VM fallidas. En muchos casos, un administrador asigna una mayor prioridad de reinicio a máquinas virtuales que ejecutan  aplicaciones de misión crítica .



Un saludo!

Miquel.


