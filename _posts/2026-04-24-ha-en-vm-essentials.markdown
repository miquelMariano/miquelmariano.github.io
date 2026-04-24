---
title: Pruebas de HA en VM Essentials
subtitle: Alta disponibilidad nativa
date: '2026-04-24 00:00:00'
layout: post
thumbnail-img: https://miquelmariano.github.io/assets/images/posts/2026/04/ha-01.png
cover-img: https://miquelmariano.github.io/assets/images/fondos/06.jpg
share-img: https://miquelmariano.github.io/assets/images/posts/2026/04/ha-01.png
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
 
Vamos a ver en el post de hoy como HPE VM Essentials dispone nativamente de un mecanismo de alta disponibilidad o HA para poder dar alta resilencia a nuestros servicios en caso de una falla hardware en alguno de los nodos.

<details markdown="1">
<summary>VER TODA LA SERIE DE POSTS</summary>
- [Parte 1 - Introducción a HPE Morpheus VM Essentials software](https://miquelmariano.github.io/introduccion-hpe-morpheus-vm-essentials-software/)
- [Parte 2 - Instalación VM Essentials software](https://miquelmariano.github.io/instalacion-nodo-vme/)
- [Parte 3 - Instalación VME Manager](https://miquelmariano.github.io/instalacion-manager/)
- [Parte 4 - Configuración inicial](https://miquelmariano.github.io/configuracion-inicial-primeros-pasos-vm-essentials)
- [Parte 5 - Creación cluster Ceph](https://miquelmariano.github.io/cluster-ceph/)
- [Parte 6 - Desplegar nuestra primera VM](https://miquelmariano.github.io/primera-vm-en-vmessentials/)
- [Parte 7 - Backups](https://miquelmariano.github.io/backups-en-vm-essentials/)
- [Parte 8 - Pruebas de HA](https://miquelmariano.github.io/ha-en-vm-essentials/)
- [Parte 9 - Migración de VMs desde vSphere]
- [Parte 10 - Comandos útiles]
- [Parte 11 - Gestión de actualizaciones en HPE VM Essentials](https://miquelmariano.github.io/actualizaciones-vme-manager-y-nodos-hvm)
</details>

Antes de nada, para que el mecanismo de HA funcione, es necesario habilitar heartbeat en nuestros datastores a nivel de clúster. De esta manera, todos los miembros del cluster se "comunican" a través de este datastore para determinar si estan o no OK

![vme-backups-07]({{ site.imagesposts2026 }}/04/ha-07.png){: .mx-auto.d-block :}

Arrancamos las pruebas validando inicialmente en que nodo tenemos nuestra VM. Recordar que para mover VMs entre los diferentes nodos usaremos la acción de "Manage Placement"

En mi caso, tenemos la VM corriendo sobre el nodo-2

![vme-backups-01]({{ site.imagesposts2026 }}/04/ha-01.png){: .mx-auto.d-block :}

También es necesario que la VM esté alojada en un repositorio compartido. En nuestro caso, está sobre un Datastore CEPH

![vme-backups-02]({{ site.imagesposts2026 }}/04/ha-02.png){: .mx-auto.d-block :}

Validamos que la VM está encendida, está accesible y contesta a ping.

![vme-backups-03]({{ site.imagesposts2026 }}/04/ha-03.png){: .mx-auto.d-block :}

Como el nodo-2 en realidad es una VM vSphere, nos conectamos al vCenter y apagamos directamente la VM

![vme-backups-04]({{ site.imagesposts2026 }}/04/ha-04.png){: .mx-auto.d-block :}

La VM se cae y deja de responder

![vme-backups-05]({{ site.imagesposts2026 }}/04/ha-05.png){: .mx-auto.d-block :}

El cluster detecta la caída

![vme-backups-06]({{ site.imagesposts2026 }}/04/ha-06.png){: .mx-auto.d-block :}

Finalmente, vemos como automáticamente la VM arranca en otro nodo del cluster y nos vuelve a contestar a ping

![vme-backups-08]({{ site.imagesposts2026 }}/04/ha-08.png){: .mx-auto.d-block :}

Nos vemos en el próximo post ;-)

Un saludo

Miquel.