---
title: Extender particiones xfs y repositorio immutable Veeam
date: '2022-06-09 00:00:00'
layout: post
tag:
- vmware
- vsphere
- vexpert
- veeam
- ramsonware
- inmutable
---

Semanas atrás, publiqué un post en donde se explicaba [como montar repositorios immutables con Veeam 11](https://miquelmariano.github.io/2022/04/05/veeam11-immutable-repository-hardening/).
En el post de hoy, vamos a ver de forma sencilla como extender una partición cuando el sistema de ficheros es xfs y, por lo tanto, extender un repositorio immutable. Vamos a ello ;-)

- Como paso previo, lo primero que tendremos que hacer es ampliar nuestro disco. Ya bien desde nuestro vCenter en caso de ser un disco virtual o desde nuestro sistema de almacenamiento en caso de utilizar discos RDM.

- Localizaremos el identificador del disco con el siguiente comando

```ssh
ls /sys/class/scsi_disk/
```

- Realizaremos un escaneo del disco usando el identificador previo para refrescar la capacidad del disco. En mi caso el identificador es 2:0:1:0

```ssh
echo 1 > /sys/class/scsi_device/2:0:1:0/device/rescan
```

![xfs1]({{ site.imagesposts2022 }}/06/xfs1.png){: .align-center}

- Comprobaremos el estado de los discos y podremos ver como el tamaño del disco es mayor que el de la partición de sistema:

```ssh
fdisk -l
```

![xfs2]({{ site.imagesposts2022 }}/06/xfs2.png){: .align-center}

- Redimensionaremos la partición con el siguiente comando:

```ssh
parted /dev/sdX
```

Con el comando `print` podremos mostrar el listado de particiones. En mi caso, la partición a ampliar es la 1 (aceptamos la advertencia con `fix`)

![xfs3]({{ site.imagesposts2022 }}/06/xfs3.png){: .align-center}

- Ampliamos la partición 1:

```ssh
resizepart 1
```

![xfs4]({{ site.imagesposts2022 }}/06/xfs4.png){: .align-center}

- Certificamos que el disco y la partición tienen el mismo tamaño:

```ssh
fdisk -l /dev/sdX
```

![xfs5]({{ site.imagesposts2022 }}/06/xfs5.png){: .align-center}

- Ahora es el momento de ampliar nuestro sistema de ficheros, que aún indica que es de 10Gb

![xfs6]({{ site.imagesposts2022 }}/06/xfs6.png){: .align-center}

- Mostraremos información del sistema de ficheros antes de ampliarlo

```ssh
xfs_growfs -n /media/datos
```

![xfs7]({{ site.imagesposts2022 }}/06/xfs7.png){: .align-center}

- Ampliamos el sistema de ficheros y verificamos la ampliación a nivel de bloque:

```ssh
xfs_growfs /media/datos
xfs_info /media/datos
```

![xfs8]({{ site.imagesposts2022 }}/06/xfs8.png){: .align-center}

- Finalmente, verificaremos la ampliación del sistema de ficheros XFS:

```ssh
df -h
```

![xfs9]({{ site.imagesposts2022 }}/06/xfs9.png){: .align-center}

- En última instancia, nos tendremos que conectar a nuestro veeam y hacer un rescan del repositorio para refrescar el tamaño final.

Espero que os sirva.

Un saludo!

Miquel.


