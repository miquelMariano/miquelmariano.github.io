---
title: Actualización HW virtual y VMWare Tools con vSphere Update Manager
date: '2017-12-13 00:00:00'
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
---

Buenos dias a tod@as!!!

El presente post pretende servir de guía para la configuración y posterior uso de vSphere Update Manager como herramienta para la actualización de HW Virtual y VMWare Tools en nuestras máquinas virtuales de un entorno vSphere

# *Actualización HW virtual*

##### Iniciar sesión en vCenter a través del vSphere Cient

![vum1]({{ site.imagesposts2017 }}/12/vum1.png)

> *NOTA:* Utilizaremos la etiqueta locale=en_US en caso de querer la interfaz en inglés
> https://172.24.0.47/vsphere-client/?locale=en_US

##### Seleccionamos cualquier objeto de nuestro árbol de inventario y la pestaña Update Manager

![vum2]({{ site.imagesposts2017 }}/12/vum2.png)

#### Añadimos los correspondientes Baseline a los objetos seleccionados

![vum3]({{ site.imagesposts2017 }}/12/vum3.png)

#### Escaneamos estado de todos los componentes

![vum4]({{ site.imagesposts2017 }}/12/vum4.png)

#### Una vez terminado el proceso de scan, nos mostrará el estado

![vum5]({{ site.imagesposts2017 }}/12/vum5.png)

#### Lo primero que se tiene que actualizar es el VM Hardware, seleccionando el componente nos dará información de estado actual y versión actualizable

![vum6]({{ site.imagesposts2017 }}/12/vum6.png)

#### Marcamos el componente de VM Hardware y “Remediate” para actualizar el Hardware Virtual

![vum7]({{ site.imagesposts2017 }}/12/vum7.png)

![vum8]({{ site.imagesposts2017 }}/12/vum8.png)

![vum9]({{ site.imagesposts2017 }}/12/vum9.png)

> NOTA: Tenemos la posibilidad de programar la tarea o ejecutarlo en el momento

![vum10]({{ site.imagesposts2017 }}/12/vum10.png)

> NOTA: Es recomendable tomar un snapshot antes de realizar la acción y marcar que se elimine
> automáticamente pasadas 24 horas

![vum11]({{ site.imagesposts2017 }}/12/vum11.png)

![vum12]({{ site.imagesposts2017 }}/12/vum12.png)

> NOTA: La actualización de VM Hardware requiere de reinicio, por lo que tomar en cuenta cuando se
> aplicará este procedimiento

#### Finalizado el proceso, aparecerá el componente como “Compliant”

![vum13]({{ site.imagesposts2017 }}/12/vum13.png)

# *VMWare Tools*

#### El proceso de actualización de las VMWare Tools es prácticamente idéntico al del VM Hardware

![vum14]({{ site.imagesposts2017 }}/12/vum14.png)

#### Marcamos el componente de VMware Tools y “Remediate”

![vum15]({{ site.imagesposts2017 }}/12/vum15.png)

![vum16]({{ site.imagesposts2017 }}/12/vum16.png)

![vum17]({{ site.imagesposts2017 }}/12/vum17.png)

![vum18]({{ site.imagesposts2017 }}/12/vum18.png)

![vum19]({{ site.imagesposts2017 }}/12/vum19.png)

![vum20]({{ site.imagesposts2017 }}/12/vum20.png)

> NOTA: La actualización de VMWare Tools requiere de reinicio, por lo que tomar en cuenta cuando se 
> aplicará este procedimiento

#### Una vez finalizado el proceso, ambos componentes estarán en estado “Compliant”

![vum21]({{ site.imagesposts2017 }}/12/vum21.png)

![vum22]({{ site.imagesposts2017 }}/12/vum22.png)

Espero que os sea de utilidad.

Un saludo!

Miquel.


