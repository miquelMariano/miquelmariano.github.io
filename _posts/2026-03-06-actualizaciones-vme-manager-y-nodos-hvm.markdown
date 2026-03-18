---
title: Gestión de actualizaciones en HPE VM Essentials
subtitle: Procedimiento actualización del manager y nodos HVM
date: '2026-03-06 00:00:00'
layout: post
thumbnail-img: https://miquelmariano.github.io/assets/images/posts/2026/02/updates-01.png
cover-img: https://miquelmariano.github.io/assets/images/fondos/04.jpg
share-img: https://miquelmariano.github.io/assets/images/posts/2026/01/updates-01.png
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

Vamos a seguir con la serie de posts sobre HPE VM Essentials. En esta ocasión vamos a ver el procedimiento para llevar a cabo la actualización de nuestro entorno VME

<details markdown="1">
<summary>VER TODA LA SERIE DE POSTS</summary>
- [Parte 1 - Introducción a HPE Morpheus VM Essentials software](https://miquelmariano.github.io/introduccion-hpe-morpheus-vm-essentials-software/)
- [Parte 2 - Instalación VM Essentials software](https://miquelmariano.github.io/instalacion-nodo-vme/)
- [Parte 3 - Instalación VME Manager](https://miquelmariano.github.io/instalacion-manager/)
- [Parte 4 - Configuración inicial](https://miquelmariano.github.io/configuracion-inicial-primeros-pasos-vm-essentials)
- [Parte 5 - Creación cluster Ceph](https://miquelmariano.github.io/cluster-ceph/)
- [Parte 6 - Desplegar nuestra primera VM](https://miquelmariano.github.io/primera-vm-en-vmessentials/)
- [Parte 7 - Backups]
- [Parte 8 - Pruebas de HA]
- [Parte 9 - Migración de VMs desde vSphere]
- [Parte 10 - Comandos útiles]
- [Parte 11 - Gestión de actualizaciones en HPE VM Essentials](https://miquelmariano.github.io/actualizaciones-vme-manager-y-nodos-hvm)
</details>

Antes de empezar, es altamente recomendable revisar el upgrade path entre versiones. Esto lo podremos encontrar en la documentación oficial del producto, [aquí](https://support.hpe.com/hpesc/public/docDisplay?docId=sd00007027en_us&page=GUID-B7279DC1-CAB8-4172-8874-29A0FE86C772.html)

En mi caso, pretendo subir de la versión 8.0.10 a la 8.0.11

![updates-01]({{ site.imagesposts2026 }}/02/updates-01.png){: .mx-auto.d-block :}

Como comento, en mi laboratorio partiremos de la versión 8.0.10 que podremos validar en la parte inferior derecha.

![updates-02]({{ site.imagesposts2026 }}/02/updates-02.png){: .mx-auto.d-block :}

# Procedimiento actualización VME Manager

Iniciaremos el procedimiento subiendo el binario que previamente hemos descargado del portal de licencias de HPE a nuestro manager. Por ejemplo con WinSCP

![updates-03]({{ site.imagesposts2026 }}/02/updates-03.png){: .mx-auto.d-block :}

![updates-04]({{ site.imagesposts2026 }}/02/updates-04.png){: .mx-auto.d-block :}

Detendremos el servicio UI con el comando `sudo morpheus-ctl stop morpheus-ui`

![updates-05]({{ site.imagesposts2026 }}/02/updates-05.png){: .mx-auto.d-block :}

Lanzaremos la actualización con el comando `sudo dpkg -i HPE_VM_Essentials_vXXXXXXX....`

![updates-06]({{ site.imagesposts2026 }}/02/updates-06.png){: .mx-auto.d-block :}

Durante el procedimiento de actualización veremos de la versión que venimos y hacia a la que vamos y finalmente el proceso de actualización finalizará.

![updates-07]({{ site.imagesposts2026 }}/02/updates-07.png){: .mx-auto.d-block :}

Ya con el nuevo binario instalado, ejecutaremos la reconfiguración con el comando `sudo morpheus-ctl reconfigure`

![updates-08]({{ site.imagesposts2026 }}/02/updates-08.png){: .mx-auto.d-block :}

![updates-09]({{ site.imagesposts2026 }}/02/updates-09.png){: .mx-auto.d-block :}

Podremos validar que todos los servicios han arrancado de nuevo con el comando `sudo morpheus-ctl status`

![updates-10]({{ site.imagesposts2026 }}/02/updates-10.png){: .mx-auto.d-block :}

Y podremos volver a validar la versión final en la parte inferior derecha

![updates-11]({{ site.imagesposts2026 }}/02/updates-11.png){: .mx-auto.d-block :}

# Actualización agentes HVM

Tras la actualización del Manager, nos quedará actualizar los nodos HVM.

Desde el menú de Infrastructure > Compute > node veremos que aparece una notificación que nos recomienda actualizar.

Es tan fácil como iniciar la actualización de los agentes desde el botón de Actions > Upgrade Agent

![updates-12]({{ site.imagesposts2026 }}/02/updates-12.png){: .mx-auto.d-block :}

![updates-13]({{ site.imagesposts2026 }}/02/updates-13.png){: .mx-auto.d-block :}

Como podeis ver, el proceso es relativamente sencillo y tardaremos pocos minutos en actualizar nuestro entorno de HPE VM Essentials

Nos vemos en el próximo post ;-)

Un saludo

Miquel.