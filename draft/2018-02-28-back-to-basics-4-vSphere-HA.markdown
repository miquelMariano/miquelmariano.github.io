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

https://www.dtechinspiration.com/high-availability-harequirementsfundamental-componentsconfiguring/

Buenos dias a todos

Continuando con la serie [back-to-basics](https://miquelmariano.github.io/tags/#backtobasics), en esta ocasión vamos a hablar sobre vSphere HA.

VMware introdujo por primera vez vSphere HA, creo recordar, en Virtual Infrastructure 3, allá por el 2006 y lo ha seguido desarrollando y mejorando con el paso del tiempo.

vSphere HA es una funcionalidad que nos da VMWare y que permite a un administrador agrupar servidores físicos en un mismo grupo lógico llamado clúster. Esto nos permite, que en caso de fallo de un servidor físico, vSphere HA detecta qué máquinas virtuales se han visto afectadas y las reinicia en otro servidor estable dentro del clúster. Este proceso de reinicio de cargas de trabajo fallidas en sistemas secundarios se denomina conmutación por error.

### Funciones de vSphere HA

VMware vSphere HA nos permite mejorar la disponibilidad de nuestros servidores, detectando automáticamente máquinas virtuales con errores y reiniciándolas en diferentes servidores físicos sin intervención humana manual. La posibilidad de reiniciar estas máquinas virtuales en hardware físico diferente es posible porque los archivos del disco de la máquina virtual (VMDK) se guardan en almacenamiento compartido, accesible para todos los servidores físicos conectados a través del clúster HA.

![ha1]({{ site.imagesposts2018 }}/06/ha1.png)

### Componentes de vSphere HA

#### vCenter Server

Es el responsable de varias tareas respecto a vSphere HA, por ejemplo:

* Desplegar y configurar los agentes HA sobre los ESXi
* Configurar la protección de las VMs
* Comunicar la configuración del clúster y todos los cambios al nodo master

#### Hostd y VPXA

El "daemon" hostd es quizás el componente más importante de un host ESXi, que juntamente con el VPXA son los encargados de comunicarse con el vCenter. Ambos se encuentran instalados en cada ESXi. El agente FDM depende del hostd del host para obtener la información sobre la lista de todas las máquinas virtuales inventariadas en ese host y en caso de que el hostd no esté operativo, el agente FDM detiene / pausa todas las funciones y espera hasta que esté de nuevo en funcionamiento

#### FDM Agent o HA Agent

FDM (Fault Domain Manager) usa el concepto de agente ejecutándose en un host ESXi y se encuentra completamente separado y desacoplado del agente de vCenter (VPXA). Desde su aparición en la versión 5.1 (Viene a substituir AAM Automatic Availability Manager), han introducido algunas mejoras: 

* FDM es compatible con la arquitectura master & slave.
* Es compatible con IPV6.
* FDM controla los problemas de particionamiento y aislamiento de red.
* FDM utiliza tanto la red de management como los datastores para la comunicación heartbeat.

![ha2]({{ site.imagesposts2018 }}/06/ha2.jpg)

### Cómo funciona vSphere HA

#### hola

vSphere HA utiliza un agente llamado Fault Domain Manager para monitorear la  disponibilidad del host de ESXi y reiniciar las máquinas virtuales fallidas. Al configurar vSphere HA, un administrador define los servidores miembros del clúster de alta disponibilidad. Fault Domain Manager se ejecuta en cada host ESXi dentro del clúster. Uno de los host dentro clúster sirve como "master"  (todos los demás se denominan "slave") para supervisar las señales de heartbeat de otros hosts y comunicarse con vCenter Server.

![ha-arch]({{ site.imagesposts2018 }}/06/ha-arch.jpg)

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


