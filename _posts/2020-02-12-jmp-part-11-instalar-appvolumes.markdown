---
title: Creando un entorno JMP con VMware Horizon - Parte 11 - Instalar App Volumes
date: '2020-02-12 00:00:00'
layout: post
image: /assets/images/posts/2019/07/horizon-logo.png
tag:
- vmware
- horizon
- vexpert
- euc
- desktop
- mobility
permalink: /jmp-part11/

---

Buenos dias a tod@s!!

En la siguiente serie de posts, pretendo explicar durante las próximas semanas el paso a paso para instalar un entorno JMP (Just-in-Time Management Platform) utilizando VMware Horizon 7 Instant Clones + App Volumes + VMware UEM (User Environment Manager) 

- [Part 1: Introducción]({{ site.url }}/jmp-part1/)
- [Part 2: Preparar servidor SQL]({{ site.url }}/jmp-part2/)
- [Part 3: Preparar Active Directory]({{ site.url }}/jmp-part3/)
- [Part 4: Instalación y configuración Connection Server]({{ site.url }}/jmp-part4/)
- [Part 5: Instalación y configuración Replica Server (opcional)]({{ site.url }}/jmp-part5/)
- Part 6: Instalación y configuración de Security Server (opcional)
- [Part 7: Instalación y configuración de UAG (opcional)]({{ site.url }}/jmp-part7/)
- Part 8: Instalación certificado (opcional)
- [Part 9: Preparar plantilla master para Instant Clone]({{ site.url }}/jmp-part9/)
- [Part 10: Configurar un pool de Instant Clone]({{ site.url }}/jmp-part10/)
- [Part 11: Instalar App Volumes]({{ site.url }}/jmp-part11/)
- Part 12: Configuración inicial App Volumes
- Part 13: Crear nuestro primer App Stack
- Part 14: Trabajando con Writable Volumes
- Part 15: User Environment Manager Installation
- Part 16: Primeros pasos con UEM
- Part 17: Instalación y configuración JMP Server
- Part 18: Aprovisionamiento con JMP

En el post de hoy, hablaremos de VMware App Volumes

# ¿Que es App Volumes?

VMWare App Volumes es una tecnología que nos permite entregar aplicaciones en tiempo real a nuestros usuarios.

Al ser un producto cliente-servidor, podremos entregar aplicaciones a cualquier windows que tenga el App Volumes Agent instalado. Gracias a eso, no se limita sólo a entornos VMware Horizon, sinó que también se puede utilizar en Citrix Xen Desktop, Microsoft RDS, o simplemente a cualquier puesto de trabajo que podamos instalar el agente.

App Volumes te permite capturar aplicaciones y empaquetarlas en un disco virtual. El resultado de esta captura, es lo que se denomina App Stack.

Un App Stack puede estar formado por 1 o varias aplicaciones y se pueden asignar tanto a usuarios, grupos, incluso a unidades organizativas de nuestro Active Directory.

Además de los AppStack, también disponemos de los Writable Volumes. Estos volúmenes, al igual que los App Stack se empaquetan en un disco virtual y nos sirven para que las modificaciones que hace un usuario en su VDI se guarden en este Writable Volume. De esta manera, conseguimos que las configuraciones que hace un usuario "le sigan" indistintamente del equipo que inicie sesión.

![appvolumesdiagram]({{ site.imagesposts2020 }}/01/app-volumes-diagram.png){: .align-center}

# Requisitos del servidor

Para la instalación del servidor de App Volumes (App Volumes Manager), necesitaremos una máquina con las siguientes especificaciones mínimas:

### Hardware:

- 4 vCPU
- 2Gb RAM
- 20Gb Disco

### Software

- Windows Server 2008 R2, 2012 R2, 2016 o 2019 (Standard o Datacenter)
- Un servidor de BBDD MS SQL Server 2012 SP1 o 2017 (puede ser express)

# Crear usuario de servicio en nuestro directorio activo

Cómo ya vimos en la [parte 3 de esta serie](https://miquelmariano.github.io/jmp-part3/), necesitaremos crear un usuario en nuestro directorio activo para gestionar la parte de App Volumes

![appvol01]({{ site.imagesposts2020 }}/01/appvol01.png){: .align-center}
![appvol02]({{ site.imagesposts2020 }}/01/appvol02.png){: .align-center}
![appvol03]({{ site.imagesposts2020 }}/01/appvol03.png){: .align-center}

También deberemos dar permisos de lectura a este usuario para poder explorar todos los objetos que tiene nuestro Active Directory.

![appvol04]({{ site.imagesposts2020 }}/01/appvol04.png){: .align-center}
![appvol05]({{ site.imagesposts2020 }}/01/appvol05.png){: .align-center}
![appvol06]({{ site.imagesposts2020 }}/01/appvol06.png){: .align-center}
![appvol07]({{ site.imagesposts2020 }}/01/appvol07.png){: .align-center}
![appvol08]({{ site.imagesposts2020 }}/01/appvol08.png){: .align-center}
![appvol09]({{ site.imagesposts2020 }}/01/appvol09.png){: .align-center}
![appvol10]({{ site.imagesposts2020 }}/01/appvol10.png){: .align-center}

Para finalizar, a mi me gusta crear un grupo, el cual tendrá los usuarios que van a administrar App Volumes.

![appvol12]({{ site.imagesposts2020 }}/01/appvol12.png){: .align-center}
![appvol13]({{ site.imagesposts2020 }}/01/appvol13.png){: .align-center}

# Agregar permisos al usuario en nuestro vCenter

En mi caso, utilizaré el usuario creado anteriormente para asignarle permisos a nuestro vCenter

![appvol11]({{ site.imagesposts2020 }}/01/appvol11.png){: .align-center}

Al ser un laboratorio, le asignaremos permisos de Administrator, pero si queremos afinar más, en la [guía de administración de App Volumes](https://docs.vmware.com/en/VMware-App-Volumes/2.16/App-Volumes-Admin-Guide-216.pdf) se detallan exactamente los permisos que necesita este usuario:

![appvol11_permisions]({{ site.imagesposts2020 }}/01/appvol11_permisions.png){: .align-center}

# Crear usuario para la BBDD

Cómo se especificaba en la parte de requisitos, necesitaremos de una BBDD para que App Volumes guarde su configuración. [Si habéis seguido esta serie desde el principio, deberíais de tener ya un servidor SQL Express](https://miquelmariano.github.io/jmp-part2/) en el que podremos crear la BBDD para App Volumes

![appvol_db01]({{ site.imagesposts2020 }}/01/appvol_db01.png){: .align-center}
![appvol_db02]({{ site.imagesposts2020 }}/01/appvol_db02.png){: .align-center}
![appvol_db03]({{ site.imagesposts2020 }}/01/appvol_db03.png){: .align-center}

# Instalación de App Volumes

La instalación es bastante sencilla, bastará con seguir el wizard de instalación tal como os enseño a continuación:

![appvol_install01]({{ site.imagesposts2020 }}/01/appvol_install01.png){: .align-center}
![appvol_install02]({{ site.imagesposts2020 }}/01/appvol_install02.png){: .align-center}
![appvol_install03]({{ site.imagesposts2020 }}/01/appvol_install03.png){: .align-center}
![appvol_install04]({{ site.imagesposts2020 }}/01/appvol_install04.png){: .align-center}
![appvol_install05]({{ site.imagesposts2020 }}/01/appvol_install05.png){: .align-center}
![appvol_install06]({{ site.imagesposts2020 }}/01/appvol_install06.png){: .align-center}
![appvol_install07]({{ site.imagesposts2020 }}/01/appvol_install07.png){: .align-center}
![appvol_install08]({{ site.imagesposts2020 }}/01/appvol_install08.png){: .align-center}
![appvol_install09]({{ site.imagesposts2020 }}/01/appvol_install09.png){: .align-center}
![appvol_install10]({{ site.imagesposts2020 }}/01/appvol_install10.png){: .align-center}
![appvol_install11]({{ site.imagesposts2020 }}/01/appvol_install11.png){: .align-center}

Al acabar todo el asistente, en el escritorio nos habrá aparecido un nuevo icono para acceder a App Volumes Manager.

![appvol_install12]({{ site.imagesposts2020 }}/01/appvol_install12.png){: .align-center}

Y hasta aquí por hoy, hasta el próximo capítulo >> [Part 12: Configuración inicial App Volumes]({{ site.url }}/jmp-part12/)

Un saludo!

Miquel.


