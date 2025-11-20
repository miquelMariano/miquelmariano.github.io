---
title: Back-to-basics 12 - Actualización HW virtual y VMWare Tools con LifeCycle Manager
date: '2023-01-19 00:00:00'
layout: post
image: /assets/images/posts/2017/10/updatemanager.png
headerImage: true
tag:
- vmware
- vexpert
- vcenter
- vcsa
- updatemanager 
- vum
- vsphere
- backtobasics
---

Buenos dias a tod@as!!

Hoy traigo una pequeña actualización al post [Actualización HW virtual y VMWare Tools con vSphere Update Manager](https://miquelmariano.github.io/2017/12/13/update-manager/) que tanto se ha usado en los últimos años. Lo hemos adaptándolo a las nuevas versiones de vSphere, cliente HTML5, cambio de nomenclatura a LifeCycle Manager, etc etc y de paso, incluirlo en la serie [back to basics](https://miquelmariano.github.io/tags/#/backtobasics), que hacia tiempo que no actualizaba ;-)

También aprovecho para mencionar a mi compi [Ibón](https://www.linkedin.com/in/ibon-lizana-cob-086793153/) que me ha ayudado en la actualización

El presente documento pretende servir de guía para la configuración y posterior uso de vSphere Update Manager como herramienta para la actualización de HW Virtual y VMWare Tools en nuestras máquinas virtuales de un entorno vSphere

# *Actualización HW virtual*

##### Iniciar sesión en vCenter a través del vSphere Cient

![lc1]({{ site.imagesposts2023 }}/01/lifecycle01.png)

##### Seleccionamos cualquier objeto de nuestro árbol de inventario y la pestaña Actualizaciones

![lc2]({{ site.imagesposts2023 }}/01/lifecycle02.png)

##### Lo primero que se tiene que actualizar es el VM Hardware, seleccionando el "actualizar para coincidir con el host" veremos las opciones disponibles

![lc3]({{ site.imagesposts2023 }}/01/lifecycle03.png)

#### En el caso de querer actualizar el componente de inmediato, seleccionaremos actualizar para coincidir con el host

![lc4]({{ site.imagesposts2023 }}/01/lifecycle04.png)

#### Para programarlo, desplegaremos el listado de opciones que nos proporciona

![lc5]({{ site.imagesposts2023 }}/01/lifecycle05.png)

![lc5]({{ site.imagesposts2023 }}/01/lifecycle05.png)

> NOTA: Es recomendable tomar un snapshot antes de realizar la acción y marcar que se elimine
> automáticamente pasadas 24 horas

![lc07]({{ site.imagesposts2023 }}/01/lifecycle07.png)

![lc08]({{ site.imagesposts2023 }}/01/lifecycle08.png)

> NOTA: La actualización de VM Hardware requiere de reinicio, por lo que tomar en cuenta cuando se
> aplicará este procedimiento

#### Finalizado el proceso, aparecerá el componente como “Conforme”

# *VMWare Tools*

#### El proceso de actualización de las VMWare Tools es prácticamente idéntico al del VM Hardware

![lc09]({{ site.imagesposts2023 }}/01/lifecycle09.png)

#### Comprobamos el estado del HW Virtual y Tools

![lc10]({{ site.imagesposts2023 }}/01/lifecycle10.png)

#### Seleccionando actualizar para coincidir con el host veremos las opciones disponibles

![lc11]({{ site.imagesposts2023 }}/01/lifecycle11.png)

#### En el caso de querer actualizar el componente de inmediato, seleccionaremos actualizar para coincidir con el host

![lc12]({{ site.imagesposts2023 }}/01/lifecycle12.png)

#### Para programarlo, desplegaremos el listado de opciones que nos proporciona

![lc13]({{ site.imagesposts2023 }}/01/lifecycle13.png)

![lc14]({{ site.imagesposts2023 }}/01/lifecycle14.png)

#### Es recomendable tomar un snapshot antes de realizar la acción y marcar que se elimine automáticamente pasadas 24 horas

![lc15]({{ site.imagesposts2023 }}/01/lifecycle15.png)

![lc16]({{ site.imagesposts2023 }}/01/lifecycle16.png)

> NOTA: La actualización de VMWare Tools requiere de reinicio, por lo que tomar en cuenta cuando se 
> aplicará este procedimiento

#### Una vez finalizado el proceso, ambos componentes estarán en estado “Conforme”

#### En caso necesario, ara visualizar las tareas programadas en las VMs del cluster, se podrá hacer con el siguiente comando

```powershell
 (Get-View ScheduledTaskManager).ScheduledTask | %{(Get-View $_).Info} | Select Name,NextRunTime
```

![lc17]({{ site.imagesposts2023 }}/01/lifecycle17.png)

Os dejo por aquí el [proceso de instalción de PowerCLI sobre windows](https://miquelmariano.github.io/2019/01/09/instalar-powerCLI-10-windows/)

Espero que os sea de utilidad.

Un saludo!

Miquel.


