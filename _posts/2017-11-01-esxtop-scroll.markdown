---
title: Limitando nuestra vista sin necesidad de scroll para nuestra salida ESXTOP
date: '2017-11-01 00:03:00'
layout: post
image: /assets/images/posts/2017/11/esxtop.png
headerImage: true
tag:
- vmware
- vexpert
- vcenter
- vcsa
- vmfs
category: blog
author: miquelMariano
description: Limitando nuestra vista sin necesidad de scroll para nuestra salida ESXTOP
hidden: false
comments: true
---

Muy buenos días a tod@as, en el post de hoy os voy a mostrar una pequeña funcionalidad que tiene el comando esxtop y que me ha sido de mucha ayuda en mas de una ocasión.

Para mi, esxtop es una de mis herramientas favoritas a la hora de hacer troubleshooting ya que permite, en tiempo real, visualizar infinidad de contadores y métricas de performance.

Pero, por poner alguna pega, debido a la gran cantidad de información que da, alguna vez he echado en falta un scroll o un "page down" para poder ver todos los registros. Esto puede ser un problema cuando buscamos objetos específicos que están ocultos en la pantalla ESXTOP debido a que la pantalla es limitada y tampoco se puede desplazar hacia el objeto específico como una VM o una LUN.

![esxtop]({{ site.imagesposts2017 }}/11/esxtop3.png)
*En la imagen superior se ve una lista limitada de volúmenes, pero en realidad todavía hay decenas y decenas que no aparecen

Desafortunadamente, actualmente no existe (o no conozco) una opción de línea de comando para que esxtop especifique las VM / LUN específicas que se deben mostrar, pero si que podemos exportar la lista de "worlds" e importarla nuevamente para limitar la cantidad de VM o LUN mostrados.

Hay una opción disponible con ESXTOP llamada "export-entity" y "import-entity". Mejor lo vemos en detalle :-)

+ Exportamos la salida del comando a un fichero temporal

```ssh
[root@ncoraesxi01:~] esxtop -export-entity /tmp/limited-view
```

+ Editamos este fichero para limitar los "objetos" que queremos mostrar

```ssh
[root@ncoraesxi01:~] vi /tmp/limited-view
```

En este caso concreto, tenia una lista demasiado extensa de datastores, por lo que necesitaba filtrar y mostrar solo los discos que a mi me interesaban en ese momento, así que simplemente comentando (#) las lineas puedo "ocultar" información irrelevante.

```ssh
...
Adapter
vmhba2
vmhba3
vmhba32

Device
#naa.60060e8012ad9c005040ad9c000030f0
#naa.60060e8012ad9c005040ad9c000030f3
naa.60060e8012ad9c005040ad9c00000010
naa.60060e8012ad9c005040ad9c00000011
naa.60060e8012ad9c005040ad9c00000012
naa.60060e8012ad9c005040ad9c00000013
naa.60060e8012ad9c005040ad9c00000014
naa.60060e8012ad9c005040ad9c00000015
naa.60060e8012ad9c005040ad9c00000016
#naa.60060e8012ad9c005040ad9c00002013
#naa.60060e8012ad9c005040ad9c00002014
#naa.60060e8012ad9c005040ad9c00002015
#naa.60060e8012ad9c005040ad9c00002016
#naa.60060e8022155e005041155e00003e00
naa.60060e8012ad9c005040ad9c00000000
#naa.60060e8022155e005041155e00003e01
naa.60060e8012ad9c005040ad9c00000001
naa.60060e8012ad9c005040ad9c00000002
naa.60060e8012ad9c005040ad9c00000003
naa.60060e8012ad9c005040ad9c00000004
naa.60060e8012ad9c005040ad9c00000005
naa.60060e8012ad9c005040ad9c00000006
naa.60060e8012ad9c005040ad9c00000007
naa.60060e8012ad9c005040ad9c00000008
naa.60060e8012ad9c005040ad9c00000009
#naa.60060e8012ad9c005040ad9c00002025
#naa.60060e8012ad9c005040ad9c00002026
#naa.60060e8012ad9c005040ad9c00002027
#naa.60060e8012ad9c005040ad9c00002028
#naa.60060e8012ad9c005040ad9c00002029

NetPort
33554433 Management
33554434 vmnic0
33554435 Shadow of vmnic0
33554436 vmnic1
...
```

+ Lanzamos esxtop importando el fichero editado

```ssh
[root@ncoraesxi01:~] esxtop -import-entity /tmp/limited-view
```

Vista de "disk device" pulsando "u"

![esxtop]({{ site.imagesposts2017 }}/11/esxtop2.png)
*En la imagen superior se ve que ahora si solo se muestran los volúmenes que nos interesan

Espero que os pueda ser de utilidad y si es así, que lo compartáis en vuestras RRSS

Muchas gracias

Un saludo!

Miquel.


