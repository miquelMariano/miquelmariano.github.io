---
title: Back-to-basics 4 - vSphere HA
date: '2018-07-11 00:00:00'
layout: post
image: /assets/images/posts/2018/06/ha0.png
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- devops
- backtobasics
---

Buenos dias a todos

Continuando con la serie [back-to-basics](https://miquelmariano.github.io/tag/#backtobasics), en esta ocasión vamos a hablar sobre vSphere HA.

VMware introdujo por primera vez vSphere HA, creo recordar, en Virtual Infrastructure 3, allá por el 2006 y lo ha seguido desarrollando y mejorando con el paso del tiempo.

vSphere HA es una funcionalidad que nos da VMWare y que permite a un administrador agrupar servidores físicos en un mismo grupo lógico llamado clúster. Esto nos permite, que en caso de fallo de un servidor físico, vSphere HA detecta qué máquinas virtuales se han visto afectadas y las reinicia en otro servidor estable dentro del clúster. Este proceso de reinicio de cargas de trabajo fallidas en sistemas secundarios se denomina conmutación por error.

### Funciones de vSphere HA

VMware vSphere HA nos permite mejorar la disponibilidad de nuestros servidores, detectando automáticamente máquinas virtuales con errores y reiniciándolas en diferentes servidores físicos sin intervención humana manual. La posibilidad de reiniciar estas máquinas virtuales en hardware físico diferente es posible porque los archivos del disco de la máquina virtual (VMDK) se guardan en almacenamiento compartido, accesible para todos los servidores físicos conectados a través del clúster HA.

![ha1]({{ site.imagesposts2018 }}/06/ha1.png)

### Componentes de vSphere HA

#### __vCenter Server__

Es el responsable de varias tareas respecto a vSphere HA, por ejemplo:

* Desplegar y configurar los agentes HA sobre los ESXi
* Configurar la protección de las VMs
* Comunicar la configuración del clúster y todos los cambios al nodo master

#### __Hostd y VPXA__

El "daemon" hostd es quizás el componente más importante de un host ESXi, que juntamente con el VPXA son los encargados de comunicarse con el vCenter. Ambos se encuentran instalados en cada ESXi. El agente FDM depende del hostd del host para obtener la información sobre la lista de todas las máquinas virtuales inventariadas en ese host y en caso de que el hostd no esté operativo, el agente FDM detiene / pausa todas las funciones y espera hasta que esté de nuevo en funcionamiento

#### __FDM Agent o HA Agent__

El agente FDM (Fault Domain Manager) es el encargado de monitorear la  disponibilidad del host ESXi y reiniciar las máquinas virtuales en caso de error físico. Fault Domain Manager se ejecuta en cada host ESXi dentro del clúster. Uno de estos host dentro clúster toma el role de "master" mientras todos los demás se denominan "slave". Para supervisar el estado de los ESXi, estos utilizan unas señales en foma de heartbeat de otros hosts y comunicarse con vCenter Server.

Desde su aparición en la versión 5.1 (viene a substituir AAM Automatic Availability Manager), han introducido algunas mejoras: 

* FDM es compatible con la arquitectura master & slave.
* Es compatible con IPV6.
* FDM controla los problemas de particionamiento y aislamiento de red.
* FDM utiliza tanto la red de management como los datastores para la comunicación heartbeat.

![ha2]({{ site.imagesposts2018 }}/06/ha2.jpg)

### Cómo funciona vSphere HA

vSphere HA utiliza el FDM Agent para monitorizar la  disponibilidad de los host ESXi y reiniciar las máquinas virtuales en caso de caída. Uno de los host dentro clúster sirve como "master"  (todos los demás se denominan "slave") para supervisar las señales de heartbeat de otros hosts y comunicarse con vCenter Server.

![ha-arch]({{ site.imagesposts2018 }}/06/ha-arch.jpg)

Los servidores ESXi dentro de un clúster HA se comunican a través de un heartbeat, que es un mensaje periódico que indica que un host se está ejecutando como se espera. Si el host "master" no puede detectar los heartbeat de los otros hosts del clúster, instruye a vSphere HA para que tome medidas correctivas. El tipo de acción depende del tipo de falla detectada, así como de las preferencias del usuario. 

La utilidad HA también puede reiniciar máquinas virtuales aunque un host continue en ejecución, pero que ha perdido la conexión de red con el resto del clúster. El host "master" puede monitorizar si ese host aún se está comunicando con los datastores para detectar si realmente se ha caido o es que se ha quedado aislado a nivel de red. El almacenamiento compartido, permite que los otros hosts del clúster accedan a los archivos de disco de VM y reinicien la máquina virtual.


Un saludo!

Miquel.


