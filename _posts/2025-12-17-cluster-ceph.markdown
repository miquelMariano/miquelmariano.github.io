---
title: Cluster Ceph en HPE VM Essentials
subtitle: Parte 5
date: '2025-12-17 00:00:00'
layout: post
thumbnail-img: https://miquelmariano.github.io/assets/images/posts/2025/12/ceph-00.png
cover-img: https://miquelmariano.github.io/assets/images/fondos/01.jpg
share-img: https://miquelmariano.github.io/assets/images/posts/2025/12/ceph-00.png
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

Hoy seguimos con la serie sobre VM Essentials y hablaremos sobre sobe almacenamiento Ceph y como utilizar la hiperconvergencia en un entorno VME

<details markdown="1">
<summary>VER TODA LA SERIE DE POSTS</summary>
- [Parte 1 - Introducción a HPE Morpheus VM Essentials software](https://miquelmariano.github.io/2025/10/17/introduccion-hpe-morpheus-vm-essentials-software/)
- [Parte 2 - Instalación VM Essentials software](https://miquelmariano.github.io/2025/10/17/instalacion-nodo-vme/)
- [Parte 3 - Instalación VME Manager](https://miquelmariano.github.io/2025/11/07/instalacion-manager/)
- [Parte 4 - Configuración inicial](https://miquelmariano.github.io/2025/11/20/configuracion-inicial-primeros-pasos-vm-essentials)
- [Parte 5 - Creación cluster Ceph](https://miquelmariano.github.io/cluster-ceph/)
- [Parte 6 - Desplegar nuestra primera VM]
- [Parte 7 - Backups]
- [Parte 8 - Pruebas de HA]
- [Parte 9 - Migración de VMs desde vSphere]
- [Parte 10 - Comandos útiles]
</details>

 # Qué es un Cluster Ceph

Un cluster Ceph es una avanzada plataforma de almacenamiento distribuido y de código abierto (Software-Defined Storage o SDS) que transforma servidores commodity en una única y masiva fuente de datos. Su diseño se enfoca en la escalabilidad horizontal (maneja fácilmente petabytes de datos) y en la tolerancia a fallos, eliminando cualquier punto único de fallo.

Ceph está basado en un sistema de almacenamiento de objetos (RADOS), donde los datos se dividen y se replican inteligentemente a través de la red en componentes llamados OSDs (Object Storage Devices). El algoritmo CRUSH determina la ubicación óptima de los datos, asegurando que estén distribuidos para prevenir pérdidas si algún disco o nodo falla.

**Servicios Unificados**
La gran ventaja de Ceph es su capacidad para ofrecer tres interfaces de almacenamiento principales de forma simultánea y unificada:

- Almacenamiento de Objetos: Compatible con APIs REST como Amazon S3 y OpenStack Swift (a través de RGW).
- Almacenamiento por Bloques: Discos virtuales para máquinas virtuales o contenedores (a través de RBD).
- Sistema de Archivos: Un sistema de archivos POSIX compatible (a través de CephFS).

Esto lo convierte en la elección predilecta para infraestructuras de virtualización (como Proxmox o OpenStack) y entornos de cloud computing que requieren flexibilidad, rendimiento y una solidez a prueba de fallos. Es, básicamente, un sistema de almacenamiento que sabe hacer de todo y no se rompe fácilmente.

![HPE_Morpheus_VM_Essentials_ceph-cluster-00]({{ site.imagesposts2025 }}/12/ceph-00.png){: .mx-auto.d-block :}

# Documentación

La documentación oficial la podrememos encontrar [aquí](https://support.hpe.com/hpesc/public/docDisplay?docId=sd00006775en_us&docLocale=en_US&page=GUID-9886AD4A-5C64-4E09-A106-B14419362757.html#ariaid-title1)

Por el momento HPE VM Essentials sólo se permite crear el cluster HCI con un único disco por nodo. El resto de discos los deberemos de ayadir al cluster ceph a través de cli y los comandos nativos ceph

En un futuro se espera poder seleccionar mas discos.

# Laboratorio

En este laboratorio tenemos como base 3 nodos VME [aquí teneis el post para su instalación](https://miquelmariano.github.io/2025/10/17/instalacion-nodo-vme/).
Y cada uno de ellos con un disco adicional de 150Gb que será el que nos aportará la capacidad al cluster Ceph

![HPE_Morpheus_VM_Essentials_ceph-cluster-01]({{ site.imagesposts2025 }}/12/ceph-01.png){: .mx-auto.d-block :}

Arrancamos el asistente para agregar nuevo cluster de HVM

![HPE_Morpheus_VM_Essentials_ceph-cluster-02]({{ site.imagesposts2025 }}/12/ceph-02.png){: .mx-auto.d-block :}

![HPE_Morpheus_VM_Essentials_ceph-cluster-03]({{ site.imagesposts2025 }}/12/ceph-03.png){: .mx-auto.d-block :}

![HPE_Morpheus_VM_Essentials_ceph-cluster-04]({{ site.imagesposts2025 }}/12/ceph-04.png){: .mx-auto.d-block :}

![HPE_Morpheus_VM_Essentials_ceph-cluster-05]({{ site.imagesposts2025 }}/12/ceph-05.png){: .mx-auto.d-block :}

En este punto, en el desplegable seleccionaremos la opción de cluster HCI Ceph y añadiremos los 3 hosts mínimos necesarios para su creación.

![HPE_Morpheus_VM_Essentials_ceph-cluster-06]({{ site.imagesposts2025 }}/12/ceph-06.png){: .mx-auto.d-block :}

![HPE_Morpheus_VM_Essentials_ceph-cluster-07]({{ site.imagesposts2025 }}/12/ceph-07.png){: .mx-auto.d-block :}

Veremos como arranca el proceso de aprovisionamiento y en el submenú de history iremos viendo todo el proceso

![HPE_Morpheus_VM_Essentials_ceph-cluster-08]({{ site.imagesposts2025 }}/12/ceph-08.png){: .mx-auto.d-block :}

![HPE_Morpheus_VM_Essentials_ceph-cluster-09]({{ site.imagesposts2025 }}/12/ceph-09.png){: .mx-auto.d-block :}

Desplegando cada uno de los nodos, podremos ir viendo las operaciones que se están realizando y en caso de algún error, nos será muy cómodo analizar la posible causa

![HPE_Morpheus_VM_Essentials_ceph-cluster-10]({{ site.imagesposts2025 }}/12/ceph-10.png){: .mx-auto.d-block :}

![HPE_Morpheus_VM_Essentials_ceph-cluster-11]({{ site.imagesposts2025 }}/12/ceph-11.png){: .mx-auto.d-block :}

![HPE_Morpheus_VM_Essentials_ceph-cluster-12]({{ site.imagesposts2025 }}/12/ceph-12.png){: .mx-auto.d-block :}

![HPE_Morpheus_VM_Essentials_ceph-cluster-13]({{ site.imagesposts2025 }}/12/ceph-13.png){: .mx-auto.d-block :}

![HPE_Morpheus_VM_Essentials_ceph-cluster-14]({{ site.imagesposts2025 }}/12/ceph-14.png){: .mx-auto.d-block :}

![HPE_Morpheus_VM_Essentials_ceph-cluster-15]({{ site.imagesposts2025 }}/12/ceph-15.png){: .mx-auto.d-block :}

Una vez finalizado el despliegue, nos aparecerá como disponible un nuevo clúster de computo del tipo HCI Ceph

![HPE_Morpheus_VM_Essentials_ceph-cluster-16]({{ site.imagesposts2025 }}/12/ceph-16.png){: .mx-auto.d-block :}

Y ya veremos nuestro RBD Pool con la suma de los 3 nodos (150Gb por nodo)

![HPE_Morpheus_VM_Essentials_ceph-cluster-17]({{ site.imagesposts2025 }}/12/ceph-17.png){: .mx-auto.d-block :}

# Comandos útiles ceph

En [este post](https://www.redhat.com/en/blog/10-commands-every-ceph-administrator-should-know) de la misma comunidad redhat he encontrado algunos comandos interesantes para validar el buen estado de salud del cluster

Ver estado de salud global del cluster
`ceph status || ceph -w`
![HPE_Morpheus_VM_Essentials_ceph-cluster-18]({{ site.imagesposts2025 }}/12/ceph-18.png){: .mx-auto.d-block :}

Ver el espacio libre en los diferentes Pools
`ceph df`
![HPE_Morpheus_VM_Essentials_ceph-cluster-19]({{ site.imagesposts2025 }}/12/ceph-19.png){: .mx-auto.d-block :}

Ver el estado de los discos y el host que los aporta
`ceph osd tree`
![HPE_Morpheus_VM_Essentials_ceph-cluster-20]({{ site.imagesposts2025 }}/12/ceph-20.png){: .mx-auto.d-block :}

Y hasta aquí por hoy.

Un saludo

Miquel.