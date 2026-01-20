---
title: Creación de nuestra primera VM en HPE VM Essentials
subtitle: Parte 6
date: '2026-01-20 00:00:00'
layout: post
thumbnail-img: https://miquelmariano.github.io/assets/images/posts/2026/01/primera-vm-01.png
cover-img: https://miquelmariano.github.io/assets/images/fondos/02.jpg
share-img: https://miquelmariano.github.io/assets/images/posts/2026/01/primera-vm-01.png
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

Arrancamos el año en el blog con una nueva entrada en la serie sobre VM Essentials. En esta ocasión vamos a ver cómo crear nuestra primera VM e instalar Windows Server 2025 para que sea completamente funcional.

Aprovecho para recordar el índice de toda la serie.

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
</details>

# Nuestra primera VM

Arrancaremos el asistente de despliegue de una nueva instancia desde el menú de "Provisioning" >> "Add"

![HPE_Morpheus_VM_Essentials_primera-vm-01]({{ site.imagesposts2026 }}/01/primera-vm-01.png){: .mx-auto.d-block :}

Seleccionaremos qué tipo de instancia vamos a desplegar; en nuestro caso desplegaremos sobre un cluster HVM

![HPE_Morpheus_VM_Essentials_primera-vm-02]({{ site.imagesposts2026 }}/01/primera-vm-02.png){: .mx-auto.d-block :}

Completamos información básica de la instancia, como nombre, grupo, en qué cloud desplegaremos, etc etc...

![HPE_Morpheus_VM_Essentials_primera-vm-03]({{ site.imagesposts2026 }}/01/primera-vm-03.png){: .mx-auto.d-block :}

Aquí es donde definiremos el "sabor" de la instancia, el tamaño y número de discos, su ubicación en los datastores, la red, la iso, etc etc

![HPE_Morpheus_VM_Essentials_primera-vm-04]({{ site.imagesposts2026 }}/01/primera-vm-04.png){: .mx-auto.d-block :}

En las opciones avanzadas es importante conectar las VirtIO para poder instalar el driver durante la instalación, de lo contrario, Windows será incapaz de detectar el disco para realizar la instalación.

![HPE_Morpheus_VM_Essentials_primera-vm-05]({{ site.imagesposts2026 }}/01/primera-vm-05.png){: .mx-auto.d-block :}

Seguiremos hasta llegar al final del asistente.

![HPE_Morpheus_VM_Essentials_primera-vm-06]({{ site.imagesposts2026 }}/01/primera-vm-06.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primera-vm-07]({{ site.imagesposts2026 }}/01/primera-vm-07.png){: .mx-auto.d-block :}

Una vez arrancado el despliegue, en la pestaña de histórico podremos ver el paso a paso del proceso que se está llevando a cabo.

![HPE_Morpheus_VM_Essentials_primera-vm-08]({{ site.imagesposts2026 }}/01/primera-vm-08.png){: .mx-auto.d-block :}

A partir de aquí, abriremos la consola de la instancia y realizaremos la instalación de Windows Server.

![HPE_Morpheus_VM_Essentials_primera-vm-09]({{ site.imagesposts2026 }}/01/primera-vm-09.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primera-vm-10]({{ site.imagesposts2026 }}/01/primera-vm-10.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primera-vm-11]({{ site.imagesposts2026 }}/01/primera-vm-11.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primera-vm-12]({{ site.imagesposts2026 }}/01/primera-vm-12.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primera-vm-13]({{ site.imagesposts2026 }}/01/primera-vm-13.png){: .mx-auto.d-block :}

Veréis que no aparece ningún disco, eso es debido a que los drivers SCSI todavía no están instalados y deberemos cargarlos a través del CD de las VirtIO que previamente hemos conectado a la instancia.

![HPE_Morpheus_VM_Essentials_primera-vm-14]({{ site.imagesposts2026 }}/01/primera-vm-14.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primera-vm-15]({{ site.imagesposts2026 }}/01/primera-vm-15.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primera-vm-16]({{ site.imagesposts2026 }}/01/primera-vm-16.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primera-vm-17]({{ site.imagesposts2026 }}/01/primera-vm-17.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primera-vm-18]({{ site.imagesposts2026 }}/01/primera-vm-18.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primera-vm-19]({{ site.imagesposts2026 }}/01/primera-vm-19.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primera-vm-20]({{ site.imagesposts2026 }}/01/primera-vm-20.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primera-vm-21]({{ site.imagesposts2026 }}/01/primera-vm-21.png){: .mx-auto.d-block :}

Y ya tendríamos nuestro Windows Server instalado y arrancado.

![HPE_Morpheus_VM_Essentials_primera-vm-22]({{ site.imagesposts2026 }}/01/primera-vm-22.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primera-vm-23]({{ site.imagesposts2026 }}/01/primera-vm-23.png){: .mx-auto.d-block :}

Finalmente, para que todo sea 100% funcional y dejar la instalación finalizada, tocará instalar las VirtIO. Aquí se incluyen todos los drivers y binarios necesarios para que se reconozca todo el hardware virtual que le está provisionando VM Essentials.

![HPE_Morpheus_VM_Essentials_primera-vm-24]({{ site.imagesposts2026 }}/01/primera-vm-24.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primera-vm-25]({{ site.imagesposts2026 }}/01/primera-vm-25.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primera-vm-26]({{ site.imagesposts2026 }}/01/primera-vm-26.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primera-vm-27]({{ site.imagesposts2026 }}/01/primera-vm-27.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primera-vm-28]({{ site.imagesposts2026 }}/01/primera-vm-28.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primera-vm-29]({{ site.imagesposts2026 }}/01/primera-vm-29.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primera-vm-20]({{ site.imagesposts2026 }}/01/primera-vm-30.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primera-vm-31]({{ site.imagesposts2026 }}/01/primera-vm-31.png){: .mx-auto.d-block :}

Y hasta aquí por hoy, en entorno ya va cogiendo forma poco a poco y ya tenemos nuestra primera VM desplegada.

Nos vemos en el próximo post ;-)

Un saludo

Miquel.