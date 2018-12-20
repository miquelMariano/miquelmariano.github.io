---
title: Reclamar bloques eliminados en datastores VMFS
date: '2017-09-20 00:00:00'
layout: post
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
comments: true
---

**Actualización 11/12/2018!** Para los que ya tengáis VMFS6, pasaros por [este post](https://www.jorgedelacruz.es/2018/12/10/vmware-vistazo-rapido-a-unmap-y-novedades-en-vsphere-6-7-reclamando-espacio-vacio-en-disco/) del gran Jorge de la Cruz.
{: .notice}

Buenos días, en el post de hoy vamos a ver como reclamar bloques eliminados en nuestros datastores VMFS3 o VMFS5.

El proceso, consiste en reclamar el espacio que ya no se está utilizando en un datastore VMFS y devolverlo a la cabina para su posterior reutilización.

![unmap]({{ site.imagesposts2017 }}/09/unmap.png)

Es un proceso sencillo y se ejecuta en backgroud sin afectar al funcionamiento normal de la cabina. Para que se pueda recuperar este espacio no utilizado, es necesario que el ESXi marque estos bloques a 0, indicando de esta forma a la cabina, que no los está utilizando. En la nueva versión ESXi 6.5 el [proceso de unmap aparece como una de las mejoras](https://www.vmware.com/content/dam/digitalmarketing/vmware/en/pdf/whitepaper/vsphere/vmw-white-paper-vsphr-whats-new-6-5.pdf), pero si disponemos una versión anterior, deberemos ejecutar el siguiente procedimiento:

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

Para obtener esta vista en esxtop (`u` para ver los datastores) es necesario entrar en el menú de selección de columnas pusando `f` y seleccionar  solo las columnas `a` `o` `p`
Los valores mostrados en la columna Delete es el nº de bloques que se van a eliminar. El valor de cada bloque en VMFS5 es de 1MB
{: .notice}

También el `/var/log/hostd.log` podremos ver como va haciendo el unmap:

![hostd-log]({{ site.imagesposts2017 }}/07/hostd-log.png)

Como habréis podido deducir, el reclamado de espacio se tiene que ejecutar sobre cada uno de los datastores VMFS que tengamos en nuestra infraestructura y eso, no siempre es una tarea sencilla. Para ello, podemos utilizar el siguiente script:

```ssh
#!/bin/sh
for datastore in `esxcli storage filesystem list | grep "NUESTRO_DATASTORE_VMFS" | awk -F " " '{print $2}'`; do
  echo "Performing UNMAP on $datastore ..."
  esxcli storage vmfs unmap -l $datastore
done
```

El comando `esxcli storage filesystem list` genera la lista de datastores. No quiero que el script se ejecute en datastores locales o NFS, así que con el `grep` filtramos los que nos interesen. La tercera parte, con el `awk` es lo que nos ayudará a seleccionar el nombre del datastore para luego ejecutar el `esxcli storage vmfs unmap -l $datastore. 

Una vez ejecutado... 

```ssh
[root@formacionesxi03:/tmp] ./unmap.sh
Performing UNMAP on NCORA_FORM_NLSAS_LUN000 ...
[root@formacionesxi03:/tmp]
```

Espero que os sea de utilidad.

Hasta el próximo post!!

 
Un saludo

Miquel.