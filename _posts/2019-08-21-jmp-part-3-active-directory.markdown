---
title: Creando un entorno JMP con VMware Horizon - Parte 3 - Preparar Active Directory
date: '2019-08-21 00:00:00'
layout: post
image: /assets/images/posts/2019/07/horizon-logo.png
tag:
- vmware
- horizon
- vexpert
- euc
- desktop
- mobility
permalink: /jmp-part3/

---

Buenos dias a tod@s!!

En la siguiente serie de posts, pretendo explicar durante las próximas semanas el paso a paso para instalar un entorno JMP (Just-in-Time Management Platform) utilizando VMware Horizon 7 Instant Clones + App Volumes + VMware UEM (User Environment Manager) 

- [Part 1: Introducción]({{ site.url }}/jmp-part1/)
- [Part 2: Preparar servidor SQL]({{ site.url }}/jmp-part2/)
- [Part 3: Preparar Active Directory]({{ site.url }}/jmp-part3/)
- [Part 4: Instalación y configuración Connection Server]({{ site.url }}/jmp-part4/)
- [Part 5: Instalación y configuración Replica Server (opcional)]({{ site.url }}/jmp-part5/)
- [Part 6: Instalación y configuración de UAG (opcional)]({{ site.url }}/jmp-part6/)
- [Part 7: Configuración de UAG en HA]({{ site.url }}/jmp-part7/)
- Part 8: Instalación certificado (opcional)
- [Part 9: Preparar plantilla master para Instant Clone]({{ site.url }}/jmp-part9/)
- [Part 10: Configurar un pool de Instant Clone]({{ site.url }}/jmp-part10/)
- [Part 11: Instalar App Volumes]({{ site.url }}/jmp-part11/)
- [Part 12: Configuración inicial App Volumes]({{ site.url }}/jmp-part12/)
- [Part 13: Crear nuestro primer App Stack]({{ site.url }}/jmp-part13/)
- [Part 14: Trabajando con Writable Volumes]({{ site.url }}/jmp-part14/)
- [Part 15: Instalación Dynamic Environment Manager]({{ site.url }}/jmp-part15/)
- [Part 16: Primeros pasos con DEM]({{ site.url }}/jmp-part16/)

# Preparar Active Directory

Para que nuestro entorno funcione correctamente, necesitaremos de almenos 2 usuarios que tendrán funciones diferentes:

- **Horizon_VC**: Es el usuario que usaremos para conectar el Connection Server con nuestro vCenter y será el encargado de desplegar las máquinas virtuales

- **Horizon_IC**: Este usuario es el que utilizaremos para vincular nuestros VDI a nuestra infraestructura AD. Será el encargado de asignar al dominio nuestros escritorios Instant Clone

**NOTA:** A mi personalmente me gusta segmentar los usuarios por tareas, pero tampoco habria ningún tipo de problema en utilizar el mismo usuario para ambas cosas.
{: .notice}

Antes de empezar a crear las cuentas, crearemos una OU llamada **VDI** que va a ser donde estarán los escritorios que se vayan desplegando.

![ad1]({{ site.imagesposts2019 }}/08/ad1.png){: .align-center}

Creamos el usuario **Horizon_VC**:

![ad2]({{ site.imagesposts2019 }}/08/ad2.png){: .align-center}

![ad3]({{ site.imagesposts2019 }}/08/ad3.png){: .align-center}

![ad4]({{ site.imagesposts2019 }}/08/ad4.png){: .align-center}

Ahora, es el momento de dar permisos al usuario que acabamos de crear a nuestro vCenter para que pueda crear máquinas virtuales.

Accederemos a nuestro vCenter con un usuario con permisos de administración global y nos vamos en el apartado de roles:

![ad5]({{ site.imagesposts2019 }}/08/ad5.png){: .align-center}

| Item                   | Permision                                                                                                                                                                                                    |
|------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Folder                 | Create folder                                                                                                                                                                                                |
|                        | Delete folder                                                                                                                                                                                                |
| Datastore              | Allocate space                                                                                                                                                                                               |
|                        | Browse datastore                                                                                                                                                                                             |
|                        | Low level file operations                                                                                                                                                                                    |
| Host                   | In Inventory                                                                                                                                                                                                 |
|                        | - Modify Cluster                                                                                                                                                                                             |
| Virtual machine        | In Configuration (all)                                                                                                                                                                                       |
|                        | In Interaction:                                                                                                                                                                                              |
|                        | - Power Off                                                                                                                                                                                                  |
|                        | - Power On                                                                                                                                                                                                   |
|                        | - Reset                                                                                                                                                                                                      |
|                        | - Suspend                                                                                                                                                                                                    |
|                        | - Perform wipe or shrink operations                                                                                                                                                                          |
|                        | - Device connection                                                                                                                                                                                          |
|                        | In Inventory (all)                                                                                                                                                                                           |
|                        | In Snapshot management (all)                                                                                                                                                                                 |
|                        | In Provisioning:                                                                                                                                                                                             |
|                        | - Customize                                                                                                                                                                                                  |
|                        | - Deploy template                                                                                                                                                                                            |
|                        | - Read customization specifications                                                                                                                                                                          |
|                        | - Clone template                                                                                                                                                                                             |
|                        | - Clone Virtual Machine                                                                                                                                                                                      |
|                        | - Allow disk access                                                                                                                                                                                          |
| Resource               | Assign virtual machine to resource pool                                                                                                                                                                      |
|                        | The following privilege is required to perform View Composer rebalance operations.                                                                                                                           |
|                        | Migrate powered off virtual machine                                                                                                                                                                          |
| Global                 | Enable methods                                                                                                                                                                                               |
|                        | Disable methods                                                                                                                                                                                              |
|                        | System tag                                                                                                                                                                                                   |
|                        | Manage custom attributes                                                                                                                                                                                     |
|                        | Set custom attribute                                                                                                                                                                                         |
|                        | The following privilege is required to implement View Storage Accelerator, which enables ESXi host caching. The vCenter Server user requires this privilege even if you do not use View Storage Accelerator. |
|                        | Act as vCenter Server                                                                                                                                                                                        |
| Network                | (all)                                                                                                                                                                                                        |
| Profile Driven Storage | (all–If you are using Virtual SAN datastores or Virtual Volumes)                                                                                                                                             |
| Storage views          | View                                                                                                                                                                                                         |

Ahora que tenemos el role creado, le asignaremos estos permisos al usuario previamente creado **Horizon_VC** a nivel de vCenter.

![ad6]({{ site.imagesposts2019 }}/08/ad6.png){: .align-center}

Llegados a este punto, es el momento de crear el usuario que utilizará horizon para crear cuentas de equipo en nuestro Active directory. Crearemos el usuario **Horizon_IC** de igual forma que hemos creado el otro usuario.

![ad7]({{ site.imagesposts2019 }}/08/ad7.png){: .align-center}

A este usuario, deberemos asignarle ciertos permisos especiales sobre la OU dedicada para VDI:

![ad8]({{ site.imagesposts2019 }}/08/ad8.png){: .align-center}

![ad9]({{ site.imagesposts2019 }}/08/ad9.png){: .align-center}

![ad10]({{ site.imagesposts2019 }}/08/ad10.png){: .align-center}

Los permisos a asignar son:

- List Contents
- Read All Properties
- Write All Properties
- Read Permissions
- Create Computer Objects
- Delete Computer Objects

Y comprobamos que se han asignado los permisos especiales:

![ad11]({{ site.imagesposts2019 }}/08/ad11.png){: .align-center}

Para finaliar el procedimiento, le tendremos que delegar el control sobre esta OU al usuario que hemos creado, de la siguiente forma:

![ad12]({{ site.imagesposts2019 }}/08/ad12.png){: .align-center}

![ad13]({{ site.imagesposts2019 }}/08/ad13.png){: .align-center}

![ad14]({{ site.imagesposts2019 }}/08/ad14.png){: .align-center}

![ad15]({{ site.imagesposts2019 }}/08/ad15.png){: .align-center}

![ad16]({{ site.imagesposts2019 }}/08/ad16.png){: .align-center}

![ad17]({{ site.imagesposts2019 }}/08/ad17.png){: .align-center}

![ad18]({{ site.imagesposts2019 }}/08/ad18.png){: .align-center}

Para finalizar con esta parte de AD, también crearemos un grupo de seguridad, que nos servirá para agrupar los usuarios que podrán administrar la plataforma Horizon.

![ad19]({{ site.imagesposts2019 }}/08/ad19.png){: .align-center}

![ad20]({{ site.imagesposts2019 }}/08/ad20.png){: .align-center}

Espero que os sirva.

Nos vemos en el próximo post: [Part 4: Instalación y configuración Connection Server]({{ site.url }}/jmp-part4/)

Un saludo!

Miquel.


