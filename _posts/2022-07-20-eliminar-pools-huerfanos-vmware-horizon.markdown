---
title: Eliminar pools huerfanos en VMware Horizon
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

# Conexión con la ADAM database

Desde el propio servidor de conexión, abriremos la herramienta ADSI Edit y realizaremos la conexión:

![horizon-adam-02]({{ site.imagesposts2022 }}/07/horizon-adam-02.png){: .align-center}

Añadiremos los siguientes datos de conexión:

- Name: Nombre descriptivo de la conexión
- Select or type a Distinguished Name or Naming Context: *dc=vdi,dc=vmware,dc=int*
- Select or tpe a domain or server: *localhost:389*

![horizon-adam-03]({{ site.imagesposts2022 }}/07/horizon-adam-03.png){: .align-center}

KB oficial [aquí](https://kb.vmware.com/s/article/2012377)

Expandimos *dc=vdi,dc=vmware,dc=int* y accedemos a *OU=Server Groups*
Buscaremos el *CN* que contiene el desktop pool que queramos eliminar y con el botón secundario *Delete*

![horizon-adam-04]({{ site.imagesposts2022 }}/07/horizon-adam-04.png){: .align-center}

Confirmamos con el botón *Yes*

![horizon-adam-05]({{ site.imagesposts2022 }}/07/horizon-adam-05.png){: .align-center}

El pool será eliminado

![horizon-adam-06]({{ site.imagesposts2022 }}/07/horizon-adam-06.png){: .align-center}

Ahora accederemos a *OU=Applications* y también eliminaremos el *CN* de esta sección

![horizon-adam-07]({{ site.imagesposts2022 }}/07/horizon-adam-07.png){: .align-center}

Confirmamos con el botón *Yes*

![horizon-adam-05]({{ site.imagesposts2022 }}/07/horizon-adam-05.png){: .align-center}

Y verificamos que ya no aparece el registro

![horizon-adam-08]({{ site.imagesposts2022 }}/07/horizon-adam-08.png){: .align-center}

Una vez terminado, podremos acceder de nuevo desde el horizon administrator en el apartado de *Inventario > Escritorios* y verificar que realmente se han eliminado los escritorios que estaban en ese estado bloqueado.

![horizon-adam-09]({{ site.imagesposts2022 }}/07/horizon-adam-09.png){: .align-center}

Un saludo!!!































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


