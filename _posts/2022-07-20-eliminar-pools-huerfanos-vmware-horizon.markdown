---
title: Eliminar pools huérfanos en VMware Horizon
date: '2022-07-20 00:00:00'
layout: post
tag:
- vmware
- horizon
- vexpert
- euc
---

Los que trabajamos habitualmente con entornos Horizon, nos ha pasado mas de una vez que al intentar eliminar un Desktop Pool se nos queda en estado "eliminando" o directamente aparece en gris y sin poder interactuar con él.

En el post de hoy veremos como podemos eliminar definitivamente estos pool y cómo limpiar cualquier rastro.

![horizon-adam-01]({{ site.imagesposts2022 }}/07/horizon-adam-01.png){: .align-center}

Para salir de esta situación, no nos quedará otra opción que utilizar la herramienta de ADSI Edit para poder modificar la ADAM database que utiliza horizon.

# Eliminar pools huérfanos en VMware Horizon

Desde el propio servidor de conexión, abriremos la herramienta ADSI Edit y realizaremos la conexión:

![horizon-adam-02]({{ site.imagesposts2022 }}/07/horizon-adam-02.png){: .align-center}

Añadiremos los siguientes datos de conexión:

- Name: Nombre descriptivo de la conexión
- Select or type a Distinguished Name or Naming Context: **dc=vdi,dc=vmware,dc=int**
- Select or tpe a domain or server: **localhost:389**

![horizon-adam-03]({{ site.imagesposts2022 }}/07/horizon-adam-03.png){: .align-center}

KB oficial [aquí](https://kb.vmware.com/s/article/2012377)

Expandimos **dc=vdi,dc=vmware,dc=int** y accedemos a **OU=Server Groups**
Buscaremos el **CN** que contiene el desktop pool que queramos eliminar y con el botón secundario *Delete*

![horizon-adam-04]({{ site.imagesposts2022 }}/07/horizon-adam-04.png){: .align-center}

Confirmamos con el botón *Yes*

![horizon-adam-05]({{ site.imagesposts2022 }}/07/horizon-adam-05.png){: .align-center}

El pool será eliminado

![horizon-adam-06]({{ site.imagesposts2022 }}/07/horizon-adam-06.png){: .align-center}

Ahora accederemos a **OU=Applications** y también eliminaremos el **CN** de esta sección

![horizon-adam-07]({{ site.imagesposts2022 }}/07/horizon-adam-07.png){: .align-center}

Confirmamos con el botón **Yes**

![horizon-adam-05]({{ site.imagesposts2022 }}/07/horizon-adam-05.png){: .align-center}

Y verificamos que ya no aparece el registro

![horizon-adam-08]({{ site.imagesposts2022 }}/07/horizon-adam-08.png){: .align-center}

Una vez terminado, podremos acceder de nuevo desde el horizon administrator en el apartado de *Inventario > Escritorios* y verificar que realmente se han eliminado los escritorios que estaban en ese estado bloqueado.

![horizon-adam-09]({{ site.imagesposts2022 }}/07/horizon-adam-09.png){: .align-center}

Un saludo!!!