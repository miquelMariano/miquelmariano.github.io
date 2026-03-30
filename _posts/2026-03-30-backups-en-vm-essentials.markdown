---
title: Backups nativos en VM Essentials
subtitle: Modulo integrado de protección
date: '2026-03-30 00:00:00'
layout: post
thumbnail-img: https://miquelmariano.github.io/assets/images/posts/2026/03/vme-backups-01.png
cover-img: https://miquelmariano.github.io/assets/images/fondos/05.jpg
share-img: https://miquelmariano.github.io/assets/images/posts/2026/03/vme-backups-01.png
published: true
author: Miquel Mariano
tag:
- kvm
- hpe
- vme
- cloud
- morpheus
- ha
---

Seguimos avanzando con la serie de posts sobre HPE VM Essentials, y es que, una parte importante al desplegar nuestras infraestructuras virtuales es contemplar los mecanismos de protección y copia de seguridad que vamos a implementar para dar continuidad a nuestros servicios.

En este post vamos a ver cómo HPE VM Essentials implementa de forma nativa herramientas de backup tanto para el VME Manager como para las propias VMs alojadas en la infraestructura.

<details markdown="1">
<summary>VER TODA LA SERIE DE POSTS</summary>
- [Parte 1 - Introducción a HPE Morpheus VM Essentials software](https://miquelmariano.github.io/introduccion-hpe-morpheus-vm-essentials-software/)
- [Parte 2 - Instalación VM Essentials software](https://miquelmariano.github.io/instalacion-nodo-vme/)
- [Parte 3 - Instalación VME Manager](https://miquelmariano.github.io/instalacion-manager/)
- [Parte 4 - Configuración inicial](https://miquelmariano.github.io/configuracion-inicial-primeros-pasos-vm-essentials)
- [Parte 5 - Creación cluster Ceph](https://miquelmariano.github.io/cluster-ceph/)
- [Parte 6 - Desplegar nuestra primera VM](https://miquelmariano.github.io/primera-vm-en-vmessentials/)
- [Parte 7 - Backups](https://miquelmariano.github.io/backups-en-vm-essentials/)
- [Parte 8 - Pruebas de HA]
- [Parte 9 - Migración de VMs desde vSphere]
- [Parte 10 - Comandos útiles]
- [Parte 11 - Gestión de actualizaciones en HPE VM Essentials](https://miquelmariano.github.io/actualizaciones-vme-manager-y-nodos-hvm)
</details>

# Backup de VME manager

Antes de nada, os recomiento que le equeis un vistazo a [la documentación oficial tanto para hacer backups como los restores](https://support.hpe.com/hpesc/public/docDisplay?docId=sd00007322en_us&page=GUID-1E710344-0932-4A51-B605-18AEF716E46F.html)

Empezamos por la parte más sencilla: proteger el propio Manager. 

La configuración de Morpheus se almacena en una base de datos MySQL, y el proceso de backup consiste básicamente en un dump de esa BBDD.

Por defecto, si no tenemos ningún repositorio externo configurado, el sistema nos avisará desde el menú principal y los backups se guardarán en el sistema de ficheros local del Manager, en la ruta:

`/var/opt/morpheus/bitcan/backup/backup.1`

![vme-backups-01]({{ site.imagesposts2026 }}/03/vme-backups-01.png){: .mx-auto.d-block :}

De forma nativa, existe un job llamado "Morpheus Appliance" que es el encargado de proteger toda la configuración del Manager. Este job se ejecuta de forma automática y genera el dump de MySQL.

![vme-backups-02]({{ site.imagesposts2026 }}/03/vme-backups-02.png){: .mx-auto.d-block :}

# Restauración de VME manager

El procedimiento de restore es relativamente sencillo. Básicamente consiste en restaurar el dump de la BBDD previamente creado y reiniciar los servicios. Vamos a ello…

## Descomprimir el backup
El backup se descarga como un archivo ZIP. Lo descomprimimos:

`unzip backup.1.20251030121307.zip`

El fichero que nos interesa dentro del ZIP es el que se llama `morpheus`, que contiene el dump de la BBDD.

![vme-backups-03]({{ site.imagesposts2026 }}/03/vme-backups-03.png){: .mx-auto.d-block :}

## Parar el servicio de la UI

`morpheus-ctl stop morpheus-ui`

## Obtener la contraseña de la BBDD
La contraseña del usuario de MySQL se puede obtener del fichero de configuración:

`cat /etc/morpheus/morpheus-secrets.json | grep morpheus_password`

## Restaurar el dump
Con la contraseña en mano, ejecutamos el restore:

`/opt/morpheus/embedded/mysql/bin/mysql -u morpheus -h 127.0.0.1 morpheus -p \
  < /var/opt/morpheus/bitcan/backup/backup.1/morpheus`

## Arrancar de nuevo los servicios

`morpheus-ctl start morpheus-ui`

Y ya tendríamos nuestro Manager completamente operativo y funcional.

![vme-backups-04]({{ site.imagesposts2026 }}/03/vme-backups-04.png){: .mx-auto.d-block :}

# Backups de VMs

Así como el Manager puede guardar sus backups en el sistema de ficheros local, para las VMs es recomendable configurar un repositorio externo debido a su tamaño. En mi caso he creado un repositorio S3 para alojar estos backups.

![vme-backups-05]({{ site.imagesposts2026 }}/03/vme-backups-05.png){: .mx-auto.d-block :}

## Configurar la programación
Lo primero que haremos para configurar un backup es definir una periodicidad. Para ello iremos al menú: Library » Automation » Execute Scheduling » Add

En mi caso, crearé una programación de Lunes a Viernes a las 17:00.

![vme-backups-06]({{ site.imagesposts2026 }}/03/vme-backups-06.png){: .mx-auto.d-block :}

![vme-backups-07]({{ site.imagesposts2026 }}/03/vme-backups-07.png){: .mx-auto.d-block :}

## Crear el Job de Backup
Con la programación creada, el siguiente paso es crear el Job. Para ello vamos a: Backups » Add

Le daremos un nombre, una retención en días y asignaremos la programación que acabamos de crear.

![vme-backups-08]({{ site.imagesposts2026 }}/03/vme-backups-08.png){: .mx-auto.d-block :}

![vme-backups-09]({{ site.imagesposts2026 }}/03/vme-backups-09.png){: .mx-auto.d-block :}

![vme-backups-091]({{ site.imagesposts2026 }}/03/vme-backups-091.png){: .mx-auto.d-block :}

## Crear la definición del Backup
Con el Job creado, deberemos crear la definición del backup propiamente dicho. Para eso vamos de nuevo al menú Backups » Add y seguimos el asistente de tres pasos:

### Paso 1: Select Source
Seleccionaremos como origen una instancia de VME (HVM).
![vme-backups-10]({{ site.imagesposts2026 }}/03/vme-backups-10.png){: .mx-auto.d-block :}

![vme-backups-11]({{ site.imagesposts2026 }}/03/vme-backups-11.png){: .mx-auto.d-block :}

### Paso 2: Name/Type
Seleccionamos la instancia concreta y le damos un nombre descriptivo al backup.
![vme-backups-12]({{ site.imagesposts2026 }}/03/vme-backups-12.png){: .mx-auto.d-block :}


### Paso 3: Asignar al Job
En este último paso definimos el tipo de backup, el repositorio de almacenamiento (S3) y lo añadimos al Job que hemos definido previamente.
![vme-backups-13]({{ site.imagesposts2026 }}/03/vme-backups-13.png){: .mx-auto.d-block :}

![vme-backups-14]({{ site.imagesposts2026 }}/03/vme-backups-14.png){: .mx-auto.d-block :}

Finalmente, para comprobar que lo hemos definido correctamente lo haremos desde la pestaña Backups de la propia instancia
![vme-backups-15]({{ site.imagesposts2026 }}/03/vme-backups-15.png){: .mx-auto.d-block :}

También desde este mismo menú de la instancia podremos ejecutar el backup sin esperar a la programación

![vme-backups-16]({{ site.imagesposts2026 }}/03/vme-backups-16.png){: .mx-auto.d-block :}

![vme-backups-17]({{ site.imagesposts2026 }}/03/vme-backups-17.png){: .mx-auto.d-block :}

Nos vemos en el próximo post ;-)

Un saludo

Miquel.