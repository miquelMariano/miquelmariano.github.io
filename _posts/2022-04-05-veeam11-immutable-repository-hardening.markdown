---
title: Repositorio immutable en Veeam 11
date: '2022-04-05 00:00:00'
layout: post
tag:
- vmware
- vsphere
- vexpert
- veeam
- ramsonware
- inmutable
---

Con la nueva versión de [Veeam Backup & Replication 11](https://www.veeam.com/veeam_backup_11_0_release_notes_rn.pdf) viene incluida una nueva funcionalidad que nos permite hacer inmutables los backups de nuestro entorno utilizando un 'Hardened Repository' montado sobre un sistema linux.

En este post, veremos su instalación y configuración paso a paso.

![veeam-immutable-repository-00]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-00.png){: .align-center}

# Requisitos

- Veeam Backup & Replication v11
- Una distribución de linux 64bits. En este post utilizaremos una Ubuntu server
- La distribución debe soportar el sistema de ficheros XFS

# Instalación Ubuntu Server 20.04 LTS

En este laboratorio, utilizaremos un Ubuntu Server 20.04 LTS, el cual podremos descargar desde [aquí](https://ubuntu.com/download/server)

Crearemos una VM con los siguientes parámetros:

- 1 vVPU
- 1 Gb Ram
- 20Gb HDD 1 (Para instalar SO)
- 500Gb HDD2 (Para el repositorio XFS)

![veeam-immutable-repository-01]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-01.png){: .align-center}

Arrancamos la VM con el live CD y seguimos el asistente:

![veeam-immutable-repository-02]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-02.png){: .align-center}
![veeam-immutable-repository-03]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-03.png){: .align-center}
![veeam-immutable-repository-04]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-04.png){: .align-center}
![veeam-immutable-repository-05]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-05.png){: .align-center}
![veeam-immutable-repository-06]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-06.png){: .align-center}
![veeam-immutable-repository-07]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-07.png){: .align-center}

Seleccionaremos la opción para configurar manualmente la parte de storage

![veeam-immutable-repository-08]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-08.png){: .align-center}

Crearemos la partición GPT en el disco de SO en formato ext4 y el punto de montaje raiz / 

![veeam-immutable-repository-09]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-09.png){: .align-center}
![veeam-immutable-repository-10]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-10.png){: .align-center}

Con el disco de datos, haremos lo mismo, pero esta vez, el formato será xfs y el punto de montaje /mnt/veeamrepo01

![veeam-immutable-repository-11]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-11.png){: .align-center}
![veeam-immutable-repository-12]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-12.png){: .align-center}

Verificaremos que hemos definido los parámetros correctos y se crearán las particiones

![veeam-immutable-repository-13]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-13.png){: .align-center}
![veeam-immutable-repository-14]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-14.png){: .align-center}

Configuraremos parámetros básicos de usuario, nombre del servidor y credenciales. También instalaremos OpenSSH

![veeam-immutable-repository-15]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-15.png){: .align-center}
![veeam-immutable-repository-16]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-16.png){: .align-center}
![veeam-immutable-repository-17]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-17.png){: .align-center}
![veeam-immutable-repository-18]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-18.png){: .align-center}
![veeam-immutable-repository-19]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-19.png){: .align-center}

Veremos el proceso de instalación y al finalizar reiniciaremos el sistema

![veeam-immutable-repository-20]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-20.png){: .align-center}

# Configuración del repositorio inmutable

Con el SO instalado, ya nos podremos conectar con el usuario administrador previamente creado

![veeam-immutable-repository-21]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-21.png){: .align-center}

Lanzamos actualización del SO y verificamos que tenemos el disco montado en xfs

```ssh
# sudo apt-get upgrade
# df -Th
```
![veeam-immutable-repository-22]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-22.png){: .align-center}
![veeam-immutable-repository-23]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-23.png){: .align-center}

## Creación usuario local

Este usuario se usará para el *Veeam Transport Service* poder montar el repositorio.
Creamos una nueva cuenta de la siguiente manera:

```ssh
# sudo useradd locveeam --create-home -s /bin/bash
# sudo passwd locveeam
```

![veeam-immutable-repository-24]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-24.png){: .align-center}

De manera temporal, este usuario necesitará privilegios de root para instalar los servicios de Veeam

```ssh
# sudo usermod -a -G sudo localveeam
```
![veeam-immutable-repository-25]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-25.png){: .align-center}

# Configuración punto de montaje

Para poder usar la tecnología de Fast-Clone, deberemos habilitar primero Reflink en ubuntu, que por defecto viene deshabilitado.
Esta configuración nos ayudará a optimizar el espacio y rendimiento durante las operaciones de synthetic full.

Veeam requiere que el filesystem esté formateado con reflink para habilitar la funcionalidad de Fast-Clone.

Localizamos el disco utilizado como repositorio con el siguiente comando

```ssh
sudo fdisk -l
```

![veeam-immutable-repository-26]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-26.png){: .align-center}

Como la partición se montó durante el proceso de instalación del SO, deberemos desmontarla primero

```ssh
# sudo umount /mnt/veeamrepo01
```
![veeam-immutable-repository-27]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-27.png){: .align-center}

Con la partición desmontada, podremos formatearla con los parámetros requeridos por Veeam

```ssh
 sudo mkfs.xfs -b size=4096 -m reflink=1,crc=1 /dev/sdb -f
```
![veeam-immutable-repository-28]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-28.png){: .align-center}

Como el UUID de la partición habrá cambiado, necesitamos modificar el fstab para que se monte la partición automaticamente tras un reinicio

```ssh
sudo blkid /dev/sdb
sudo vi /etc/fstab
sudo mount -a
```

![veeam-immutable-repository-29]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-29.png){: .align-center}
![veeam-immutable-repository-30]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-30.png){: .align-center}
![veeam-immutable-repository-31]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-31.png){: .align-center}

# Asignar permisos al punto de montaje
Asignaremos permisos al usuario local creado previamente con los siguientes comandos

```ssh
# sudo chown -R localveeam:localveeam /mnt/veeamrepo01/
# sudo chmod 700 /mnt/veeamrepo
```

![veeam-immutable-repository-32]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-32.png){: .align-center}

Verificamos los permisos asignados
```ssh
# ll /mnt
```
![veeam-immutable-repository-33]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-33.png){: .align-center}

# Configuración repositorio Veeam

Añadiremos el nuevo servidor linux siguiendo el wizard

![veeam-immutable-repository-34]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-34.png){: .align-center}
![veeam-immutable-repository-35]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-35.png){: .align-center}
![veeam-immutable-repository-36]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-36.png){: .align-center}
![veeam-immutable-repository-37]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-37.png){: .align-center}
![veeam-immutable-repository-38]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-38.png){: .align-center}
![veeam-immutable-repository-39]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-39.png){: .align-center}
![veeam-immutable-repository-40]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-40.png){: .align-center}
![veeam-immutable-repository-41]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-41.png){: .align-center}
![veeam-immutable-repository-42]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-42.png){: .align-center}
![veeam-immutable-repository-43]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-43.png){: .align-center}

Una vez los servicios de veeam están instalados con el usuario *localveeam*, podremos sacar los privilegios de sudo. En cualquier caso, es importante recalcar que las credenciales de este usuario no se han almacenado en Veeam al utilizar la opción de "Single-use credentials for hardened repository"

```ssh
# sudo deluser localveeam sudo
```
![veeam-immutable-repository-44]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-44.png){: .align-center}

Añadiremos un nuevo repositorio desde *Backup Infrastructure*

![veeam-immutable-repository-45]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-45.png){: .align-center}
![veeam-immutable-repository-46]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-46.png){: .align-center}
![veeam-immutable-repository-47]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-47.png){: .align-center}
![veeam-immutable-repository-48]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-48.png){: .align-center}
![veeam-immutable-repository-49]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-49.png){: .align-center}

Aquí es donde definimos la inmutabilidad de los datos del repositorio en días

![veeam-immutable-repository-50]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-50.png){: .align-center}
![veeam-immutable-repository-51]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-51.png){: .align-center}
![veeam-immutable-repository-52]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-52.png){: .align-center}
![veeam-immutable-repository-53]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-53.png){: .align-center}
![veeam-immutable-repository-54]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-54.png){: .align-center}
![veeam-immutable-repository-55]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-55.png){: .align-center}

Configuramos un nuevo job con el nuevo repositorio inmutable

![veeam-immutable-repository-56]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-56.png){: .align-center}
![veeam-immutable-repository-57]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-57.png){: .align-center}
![veeam-immutable-repository-58]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-58.png){: .align-center}

Los repositorios inmutables de Veeam requieren de forward incremental. No está soportado reverse incremental

![veeam-immutable-repository-59]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-59.png){: .align-center}
![veeam-immutable-repository-60]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-60.png){: .align-center}

# Pruebas de inmutabilidad

Si intentamos eliminar un objeto del repositorio, nos indicará que es inmutable y no se puede eliminar

![veeam-immutable-repository-61]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-61.png){: .align-center}
![veeam-immutable-repository-62]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-62.png){: .align-center}

Desde la linea de comandos, también podremos comprobar la inmutabilidad de los backups.

```ssh
# lsattr
# lsattr -l
```
![veeam-immutable-repository-63]({{ site.imagesposts2022 }}/04/veeam-immutable-repository-63.png){: .align-center}

Podemos ver que los ficheros de backup aparecen como inmutables. Sólo el fichero .vbm no tiene este atributo y es debido a que veeam lo necesita actualizar continuamente durante las sesiones de backup.

Un saludo!

Miquel.


