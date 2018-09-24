---
title: Reclamar bloques eliminados en datastores VMFS
date: '2017-09-20 00:00:00'
layout: post
image: /assets/images/posts/2017/09/vmfs.png
headerImage: true
tag:
- vmware
- vexpert
- vsphere
- storage
- vmfs
- esxcli
category: blog
author: miquelMariano
description: Reclamar bloques eliminados en datastores VMFS
hidden: false
---

Buenos días, en el post de hoy vamos a ver como reclamar bloques eliminados en nuestros datastores VMFS3 o VMFS5.

El proceso, consiste en reclamar el espacio que ya no se está utilizando en un datastore VMFS y devolverlo a la cabina para su posterior reutilización.

![unmap]({{ site.imagesposts2017 }}/09/unmap.png)

Es un proceso sencillo y se ejecuta en backgroud sin afectar al funcionamiento normal de la cabina. Para que se pueda recuperar este espacio no utilizado, es necesario que el ESXi marque estos bloques a 0, indicando de esta forma a la cabina, que no los está utilizando. En la nueva versión ESXi 6.5 el [proceso de unmap aparece como una de las mejoras](https://www.vmware.com/content/dam/digitalmarketing/vmware/en/pdf/whitepaper/vsphere/vmw-white-paper-vsphr-whats-new-6-5.pdf), pero si disponemos una versión anterior, debejemos ejecutar el siguiente procedimiento:

1) Accedemos a cualquier ESXi del clúster por SSH

2) Verificamos que todos los volúmenes tienen Thin Provisioning habilitado:

```
esxcli storage core device list
```

![esxcli_storage_core_device_list]({{ site.imagesposts2017 }}/07/esxcli_storage_core_device_list.png)

3) Verificamos que todos los volúmenes utilizan el driver de ~~Hitachi VMW_VAAIP_HDS~~ nuestro fabricante de storage y que soporta en Zero Status y el Delete Status

```
esxcli storage core device vaai status get
```

![esxcli_storage_core_device_vaai_status_get]({{ site.imagesposts2017 }}/07/esxcli_storage_core_device_vaai_status_get.png)

4) Lanzamos el commando para que marque con un 0 los bloques no utilizado de cada datastore

```
esxcli storage vmfs unmap -l DATASTORE01
```

5) Con el comando esxtop podremos ver como empieza a marcar bloques como eliminables


![esxtop1]({{ site.imagesposts2017 }}/07/esxtop1.png)

También el `/var/log/hostd.log` podremos ver como va haciendo el unmap:

![hostd-log]({{ site.imagesposts2017 }}/07/hostd-log.png)


Para obtener esta vista en esxtop es necesario entrar en el menú de selección de columnas pusando `f` y seleccionar  solo las columnas `a` `o` `p`
Los valores mostrados en la columna Delete es el nº de bloques que se van a eliminar. El valor de cada bloque en VMFS5 es de 1MB


Como habréis podido deducir, el reclamado de espacio se tiene que ejecutar sobre cada uno de los datastores VMFS que tengamos en nuestra infraestructura y eso, no siempre es una tarea sencilla. Para ello, podemos utilizar [este script](https://miquelmariano.github.io/reclaimZeroPages/)


Una vez ejecutado... 

```
python /tmp/reclaimZeroPages.py
```
...tendremos una salida similar a esta:


```
* Analizando datatores...
Thin Provisioning Status: Key naa.60060e801332e000502032e000003106 not found
VAAI Plugin: Key naa.60060e801332e000502032e000003106 not found
Zero Status: Key naa.60060e801332e000502032e000003106 not found
Delete Status: Key naa.60060e801332e000502032e000003106 not found
 
* Comandos a lanzar:
 Executing: esxcli storage vmfs unmap -n 200 -l HUS110_Datastore000
 Executing: esxcli storage vmfs unmap -n 200 -l VSPG800_Datastore000
 Executing: esxcli storage vmfs unmap -n 200 -l VSPG800_Datastore002
 Executing: esxcli storage vmfs unmap -n 200 -l VSPG800_Datastore003
 Executing: esxcli storage vmfs unmap -n 200 -l HUSVM_Datastore000
 
* Datastore erroneos:
 
* Fin.
```

Espero que os sea de utilidad.

Hasta el próximo post!!

 
Un saludo

Miquel.