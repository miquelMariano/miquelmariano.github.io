---
title: Procedimiento instalación VME Manager
subtitle: Parte 3
date: '2025-11-07 00:00:00'
layout: post
thumbnail-img: https://miquelmariano.github.io/assets/images/posts/2025/11/manager2.png
cover-img: https://miquelmariano.github.io/assets/images/fondos/09.jpg
share-img: https://miquelmariano.github.io/assets/images/posts/2025/11/manager2.png
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

# HPE VM Essentials Manager

El HPE VM Essentials Manager es el "cerebro" detrás de de la solución basada en KVM de HPE. Su misión es hacer la vida de los administradores más fácil.

El Manager, nos implementar y gestionar clústeres de manera sencilla, ofreciendo funcionalidades clave como la migración en vivo (vMotion) de máquinas virtuales entre hosts sin parada, la distribución dinámica de cargas de trabajo (DRS) y la recuperación automática de fallos si un host cae (HA). Además, facilita el aprovisionamiento de nuevas cargas de trabajo mediante plantillas y una profunda integración con entornos VMware vCenter. Es la herramienta central para mantener tu entorno virtualizado funcionando sin problemas.

![HPE_Morpheus_VM_Essentials_Manager_overview]({{ site.imagesposts2025 }}/11/manager-overview.png){: .mx-auto.d-block :}

Para la instalación del VME Manager disponemos de 2 opciones:
- La que veremos hoy, que consiste en desplegar la instancia sobre un nodo de HVM
- [Instalar manualmente el software del Manager sobre una máquina Ubuntu 24 ya sea en otro entorno de virtualización o incluso en físico](https://miquelmariano.github.io/pdte)

Os recuerdo que este post está incluido en la serie sobre HPE VM Essentials

<details markdown="1">
<summary>VER TODA LA SERIE DE POSTS</summary>
- [Parte 1 - Introducción a HPE Morpheus VM Essentials software](https://miquelmariano.github.io/2025/10/17/introduccion-hpe-morpheus-vm-essentials-software/)
- [Parte 2 - Instalación VM Essentials software](https://miquelmariano.github.io/2025/10/28/instalacion-nodo-vme/)
- [Parte 3 - Instalación VME Manager](https://miquelmariano.github.io/2025/11/08/instalacion-manager/)
- [Parte 4 - Configuración inicial]
- [Parte 5 - Creación cluster Ceph]
- [Parte 6 - Desplegar nuestra primera VM]
- [Parte 7 - Backups]
- [Parte 8 - Pruebas de HA]
- [Parte 9 - Migración de VMs desde vSphere]
- [Parte 10 - Comandos útiles]
</details>

La opción de instalar el Manager sobre un entorno VME es la preferida y recomendada y para ello necesitaremos descargar la ISO con el software del portal de HPE

![HPE_Morpheus_VM_Essentials_Manager_install_0]({{ site.imagesposts2025 }}/11/manager0.png){: .mx-auto.d-block :}

Esta ISO la deberemos montar a través de la iDRAC, iLO, XCC de turno a nuestro nodo VME o en mi caso (que es una VM, vincular la iso a través de vSphere)

Una vez montada la ISO, la montaremos a nuestro nodo y ejecutaremos el comando `sudo hpe-vm`

![HPE_Morpheus_VM_Essentials_Manager_install_1]({{ site.imagesposts2025 }}/11/manager1.png){: .mx-auto.d-block :}

{: .box-note}
**Nota:** `hpe-vm` es la TUI (Text User Interface) que de momento tenemos disponible para operar con un nodo independiente de VME. Se espera que en futuras releases HPE implemente una GUI al estilo vSphere Host Client que tenemos en VMware

Para instalar el Manager iremos a la opción **"Install VME Manager"**

![HPE_Morpheus_VM_Essentials_Manager_install_2]({{ site.imagesposts2025 }}/11/manager2.png){: .mx-auto.d-block :}

Completaremos las opciones básicas de configuración IP y credenciales y en **"Image URI"** podremos explorar la ISO que anteriormente hemos montado para seleccionar el fichero .qcow de imagen

![HPE_Morpheus_VM_Essentials_Manager_install_3]({{ site.imagesposts2025 }}/11/manager3.png){: .mx-auto.d-block :}

![HPE_Morpheus_VM_Essentials_Manager_install_4]({{ site.imagesposts2025 }}/11/manager4.png){: .mx-auto.d-block :}

En este momento, arrancará el poceso de despliegue de la imagen QCOW sobre nuestro nodo VME. Tardará unos pocos minutos...

![HPE_Morpheus_VM_Essentials_Manager_install_5]({{ site.imagesposts2025 }}/11/manager5.png){: .mx-auto.d-block :}

![HPE_Morpheus_VM_Essentials_Manager_install_6]({{ site.imagesposts2025 }}/11/manager6.png){: .mx-auto.d-block :}

![HPE_Morpheus_VM_Essentials_Manager_install_7]({{ site.imagesposts2025 }}/11/manager7.png){: .mx-auto.d-block :}

Una vez finalizado, nos aparecerá el siguiente mensaje

![HPE_Morpheus_VM_Essentials_Manager_install_8]({{ site.imagesposts2025 }}/11/manager8.png){: .mx-auto.d-block :}

Podremos ver si la nueva VM está bien implementada y ejecutandose desde el menu de **"Virtual Machines"**

![HPE_Morpheus_VM_Essentials_Manager_install_9]({{ site.imagesposts2025 }}/11/manager9.png){: .mx-auto.d-block :}

Si todo ha ido bien, podremos abrir un explorador web y acceder por HTTPS al nuevo manager que acabamos de desplegar

![HPE_Morpheus_VM_Essentials_Manager_install_10]({{ site.imagesposts2025 }}/11/manager10.png){: .mx-auto.d-block :}

{: .box-note}
**Nota:** Los servicios tardan unos minutos en arrancar, no te impacientes, al terminar podremos hacer login por primera vez en nuestro VME Manager ;-)

En el próximo post, veremos el primer inicio de sesión y los primeros pasos para configurar el Manager

Un saludo

Miquel.