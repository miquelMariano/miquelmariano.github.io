---
title: Procedimiento instalación nodo VME
subtitle: Parte 2
date: '2025-10-28 00:00:00'
layout: post
thumbnail-img: https://miquelmariano.github.io/assets/images/posts/2025/10/unified_iso.png
cover-img: https://miquelmariano.github.io/assets/images/fondos/08.jpg
share-img: https://miquelmariano.github.io/assets/images/posts/2025/10/unified_iso.png
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

<details markdown="1">
<summary>VER TODA LA SERIE DE POSTS</summary>
- [Parte 1 - Introducción a HPE Morpheus VM Essentials software](https://miquelmariano.github.io/introduccion-hpe-morpheus-vm-essentials-software/)
- [Parte 2 - Instalación VM Essentials software](https://miquelmariano.github.io/instalacion-nodo-vme/)
- [Parte 3 - Instalación VME Manager](https://miquelmariano.github.io/instalacion-manager/)
- [Parte 4 - Configuración inicial](https://miquelmariano.github.io/configuracion-inicial-primeros-pasos-vm-essentials)
- [Parte 5 - Creación cluster Ceph](https://miquelmariano.github.io/cluster-ceph/)
- [Parte 6 - Desplegar nuestra primera VM]
- [Parte 7 - Backups]
- [Parte 8 - Pruebas de HA]
- [Parte 9 - Migración de VMs desde vSphere]
- [Parte 10 - Comandos útiles]
</details>

# Nuevo instalador unificado

El software de HPE VM Essentials corre sobre Ubuntu 24.x. Desde las primeras versiones, era necesario primero instalar el SO, actualizarlo, configuración básica, etc etc antes de poder instalar el software de VME

Es aquí, desde la versión 8.0.8, que HPE ha sacado un instalador unificado que nos ayuda a simplificar el despliegue.

![HPE_Morpheus_VM_Essentials_Unified_ISO]({{ site.imagesposts2025 }}/10/unified_iso.png){: .mx-auto.d-block :}

# Descarga de la ISO

La descarga de la ISO la podremos realizar desde el [Download Center de HPE](https://myenterpriselicense.hpe.com/cwp-ui/product-download-info/HPE_VME_EVAL/-/sw360_eval_customer?&)

El instalador unificado es la HVM_install_xxxxxxxxx.iso

![Descarga]({{ site.imagesposts2025 }}/10/download_iso.png){: .mx-auto.d-block :}

{: .box-warning}
**Warning:** En caso de que no podamos acceder a la descarga, revisar que nuestro perfil de usuario está completo y que los campos no contengan carácteres extraños o acentos. https://auth.hpe.com/profile/UserProfile

# Instalación

Para redactar estos posts he montado un entorno "nested" sobre VMware, por lo que mis nodos VME en realidad son VMs.

Crearemos una nueva VM con los siguientes parámetros y le conectaremos la ISO previamente descargada.

![Proceso_instalacion_01]({{ site.imagesposts2025 }}/10/vme_instalacion_01.png){: .mx-auto.d-block :}

Para que nos funcione la virtualización anidada, deberemos habilitar esta check en la configuración de la VM

![Proceso_instalacion_02]({{ site.imagesposts2025 }}/10/vme_instalacion_02.png){: .mx-auto.d-block :}

A partir de aquí, seguiremos el procedimiento básico de instalación de un Ubuntu.

![Proceso_instalacion_03]({{ site.imagesposts2025 }}/10/vme_instalacion_03.png){: .mx-auto.d-block :}
![Proceso_instalacion_04]({{ site.imagesposts2025 }}/10/vme_instalacion_04.png){: .mx-auto.d-block :}
![Proceso_instalacion_05]({{ site.imagesposts2025 }}/10/vme_instalacion_05.png){: .mx-auto.d-block :}
![Proceso_instalacion_06]({{ site.imagesposts2025 }}/10/vme_instalacion_06.png){: .mx-auto.d-block :}
![Proceso_instalacion_07]({{ site.imagesposts2025 }}/10/vme_instalacion_07.png){: .mx-auto.d-block :}
![Proceso_instalacion_08]({{ site.imagesposts2025 }}/10/vme_instalacion_08.png){: .mx-auto.d-block :}
![Proceso_instalacion_09]({{ site.imagesposts2025 }}/10/vme_instalacion_09.png){: .mx-auto.d-block :}

Antes de reiniciar, desconectaremos el CD si no queremos recibir el siguiente error

![Proceso_instalacion_10]({{ site.imagesposts2025 }}/10/vme_instalacion_10.png){: .mx-auto.d-block :}

Una vez reiniciado, ya tendremos acceso a nuestro primer nodo

![Proceso_instalacion_11]({{ site.imagesposts2025 }}/10/vme_instalacion_11.png){: .mx-auto.d-block :}

Seguiremos el mismo procedimiento tantas veces como nodos queramos desplegar en nuestro entorno de laboratorio

En el próximo post, veremos como desplegar el manager y tener así una interfaz GUI de gestión de la plataforma

Un saludo

Miquel.