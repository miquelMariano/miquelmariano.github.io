---
title: Actualizar ESXi mediante el bundle offline
date: '2018-05-02 00:00:00'
layout: post
image: /assets/images/posts/2018/05/offline.jpg
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- esxi
- update
category: blog
author: miquelMariano
description: Actualizar ESXi mediante el bundle offline
hidden: false
---

Hola a tod@as!!

En el post de hoy voy a tratar de explicar cómo de forma fácil, podemos actualizar nuestros servidores ESXi con el bundle offline.
Ya que VMWare acaba de publicar la nueva versión 6.7, vamos a utlizar como ejemplo esta nueva versión ;-)

## 1| Descargar ESXi 6.7 Offline Bundle

El primer paso va a ser descargar el paquete offline desde el portal de [my.vmware](https://my.vmware.com/group/vmware/details?downloadGroup=ESXI670&productId=742&download=true&fileId=4e1ca8c0b74408eb322f86b61025ae2a&secureParam=4d84a9981043dc6dd57ffe0e1f91041a&uuId=3419576b-30f0-4f34-9748-5de64a246088&downloadType=)

![esxidownload]({{ site.imagesposts2018 }}/05/downloadesxi67.png)

## 2| Copiar el paquete descargado en un datastore del ESXi que queremos actualizar 

A través del ESXi embebed host client, podremos subir el paquete .zip a un datastore.

![offline1]({{ site.imagesposts2018 }}/05/offline1.png)

## 3| Nos conectamos al servidor ESXi a través de un cliente SSH

Nos conectamos a través de un cliente SSH y verificamos la versión actual.

![offline2]({{ site.imagesposts2018 }}/05/offline2.png)

## 4| Con el comando esxcli lanzamos la actualización en el servidor 

```ssh
 esxcli software vib update -d /vmfs/volumes/formacionesxi01/VMware-ESXi-6.7.0-8169922-depot.zip
```

Tras unos segundos, veremos el resultado de la acrtualización, con los paquetes instalados y los que se han eliminado. Y si todo ha ido bien, será necesario un reinicio del servidor.

![offline3]({{ site.imagesposts2018 }}/05/offline3.png)

> #### Actualización 24/08/2018
> Es probable que os encontreis con algún paquete incompatible.
> ![actualizacion_offline1]({{ site.imagesposts2018 }}/05/actualizacion_offline1.png)
> En este caso, el comando a utilizar es el siguiente:

> `esxcli software profile update -d <full_path_to_offline_bundle> -p <Image Profile>`

> Para saber cual es el "Image Profile" podreis ejecutar el comando:

> `esxcli software sources profile list -d <full_path_to_offline_bundle>`

## 5| Verificar que el host se ha actualizado correctamente.

Tras el correspondiente reinicio, comprobaremos que la versión del ESXi ya es la nueva 6.7

![offline4]({{ site.imagesposts2018 }}/05/offline4.png)

![offline5]({{ site.imagesposts2018 }}/05/offline5.png)


Espero que os sea de utilidad.

Un saludo!

Miquel.


