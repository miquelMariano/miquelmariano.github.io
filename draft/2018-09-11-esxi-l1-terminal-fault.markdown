---
title: ESXi | L1 Terminal Fault or esx.problem.hyperthreading.unmitigated
date: '2017-09-22 00:00:00'
layout: post
image: /assets/images/posts/2018/09/bug.jpg
headerImage: true
tag:
- vmware
- bug
- vexpert
- esxi
- vsphere
category: blog
author: miquelMariano
description: ESXi | L1 Terminal Fault or esx.problem.hyperthreading.unmitigated
hidden: false
permalink: /l1/
---

Buenos dias a tod@as!!

Muchos de vosotros, os abreis dado cuenta que al actualizar vuestros hosts ESXi a la última versión os han aparecido unos misteriosos mensajes:

![warning1]({{ site.imagesposts2018 }}/09/esxi-warning1.png)

![warning2]({{ site.imagesposts2018 }}/09/esxi-warning2.png)

Esto es debido al bug *[L1 Terminal Fault - VMM](https://kb.vmware.com/s/article/55806?src=af_5acfd7716582e&cid=70134000001YR6X)*

> The L1 Terminal Fault (aka Foreshadow) bug is another speculative execution side channel attack  
> that affects Intel Core processors and Intel Xeon processors only.

VMWare sacó el 14 de agosto una [serie de parches:](https://www.vmware.com/security/advisories/VMSA-2018-0020.html?src=af_5acfd7716582e&cid=70134000001YR6X) 

![tabla]({{ site.imagesposts2018 }}/09/tabla.png)

Estos parches, por defecto, NO mitigan el riesgo de ejecución de código. Para ello, tendremos que seguir la [KB55806](https://kb.vmware.com/s/article/55806)

![3pasos]({{ site.imagesposts2018 }}/09/3pasos.png)

1. Fase de actualización: aplicar actualizaciones y parches de vSphere
2. Fase de planificación: evaluar el entorno
3. Fase de habilitar sheduler: habilitar el scheduler de  ESXi Side-Channel-Aware

Es importante aplicar los parches en el orden correcto. Primero el vCenter y luego los hosts ESXI. Si lo hacemos a la inversa, nos aparecerá un error del tipo
`xxx esx.problem.hyperthreading.unmitigated.formatOnHost not found xxx` 
o
`esx.problem.hyperthreading.unmitigated`

Para habilitar el scheduler ESXi side-channel-aware tendremos que seguir los siguientes pasos en nuestro vSphere Client:

- Conéctese al vCenter Server utilizando vSphere Web o vSphere Client.
- Seleccione un host ESXi en el inventario.
- Pestaña Configurar.
- En Sistema, haga clic en  Configuración avanzada del sistema .
- Haga clic en el cuadro Filtro y buscamos VMkernel.Boot.hyperthreadingMitigation
- Seleccionamos la configuración por nombre y haga clic en el   icono Editar
- Cambie la opción de configuración a true (predeterminado: false).
- Haga clic en  Aceptar .
- Reinicie el host ESXi para que el cambio de configuración entre en vigencia.

![habilitar]({{ site.imagesposts2018 }}/09/habilitar.png)

Una vez llegados a este punto y hemos conseguido eliminar este molesto mensaje, a mi personalmente me salta una pregunta

¿Por qué esta remediación no está activa por defecto? 

El motivo principal parece ser el posible impacto en el rendimiento/capacidad. Parece ser que así como Spectre y Meltdown, el aplicar este parche podria tener alrededor de un 30% de penalización en cuanto a rendimiento. Para mas información sobre este punto, podeis consultar la [KB55767](https://kb.vmware.com/s/article/55767?src=af_5acfd7716582e&cid=70134000001YR6X)

Espero que os pueda ser de utilidad

Un saludo!

Miquel.


