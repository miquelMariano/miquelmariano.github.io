---
title: Creando un entorno JMP con VMware Horizon - Parte 4
date: '2019-09-03 00:00:00'
layout: post
image: /assets/images/posts/2019/07/horizon-logo.png
tag:
- vmware
- horizon
- vexpert
- euc
- desktop
- mobility
permalink: /jmp-part4/

---

Buenos dias a tod@s!!

En la siguiente serie de posts, pretendo explicar durante las próximas semanas el paso a paso para instalar un entorno JMP (Just-in-Time Management Platform) utilizando VMware Horizon 7 Instant Clones + App Volumes + VMware UEM (User Environment Manager) 

- [Part 1: Introducción]({{ site.url }}/jmp-part1/)
- [Part 2: Preparar servidor SQL]({{ site.url }}/jmp-part2/)
- [Part 3: Preparar Active Directory]({{ site.url }}/jmp-part3/)
- [Part 4: Instalación y configuración Connection Server]({{ site.url }}/jmp-part4/)
- Part 5: Instalación y configuración Replica Server
- Part 6: Instalación y configuración de Security Server
- Part 7: Instalación y configuración de UAG
- Part 8: Instalación certificado (opcional)
- Part 9: Preparar plantilla master para Instant Clone
- Part 10: Configurar un pool de Instant Clone
- Part 11: Instalar App Volumes
- Part 12: Configuración inicial App Volumes
- Part 13: Crear nuestro primer App Stack
- Part 14: Trabajando con Writable Volumes
- Part 15: User Environment Manager Installation
- Part 16: Primeros pasos con UEM
- Part 17: Instalación y configuración JMP Server
- Part 18: Aprovisionamiento con JMP

# Instalación y configuración Connection Server

El Connection Server, o servidor de conexión es el core de nuestra infraestructura VDI, es la pieza más importante de todo el entorno.

Lo primero que haremos, será descargarnos el instalador desde el portal de [My.VMware](https://my.vmware.com). Como veis hay muchos instaladores. Empezaremos con el View Connection Server (64-bit) que entre otras cosas es el instalador del servidor de conexión :-)

![con01]({{ site.imagesposts2019 }}/08/con01.png){: .align-center}

Una vez descargado, ejecutaremos el instalador y seguiremos el asistente de instalación:

![con02]({{ site.imagesposts2019 }}/08/con02.png){: .align-center}

![con03]({{ site.imagesposts2019 }}/08/con03.png){: .align-center}

![con04]({{ site.imagesposts2019 }}/08/con04.png){: .align-center}

En este punto es donde seleccionaremos "Servidor estándar de Horizon 7" ya que es la primera instancia de nuestra infraestructura:

![con05]({{ site.imagesposts2019 }}/08/con05.png){: .align-center}

Deberemos especificar una contraseña de recuperación en caso de desastre:

![con06]({{ site.imagesposts2019 }}/08/con06.png){: .align-center}

![con07]({{ site.imagesposts2019 }}/08/con07.png){: .align-center}

Aquí es donde especificaremos el usuario o grupo de usuarios que tendrán permisos de administración sobre nuestra plataforma:

![con08]({{ site.imagesposts2019 }}/08/con08.png){: .align-center}

![con09]({{ site.imagesposts2019 }}/08/con09.png){: .align-center}

![con10]({{ site.imagesposts2019 }}/08/con10.png){: .align-center}

![con11]({{ site.imagesposts2019 }}/08/con11.png){: .align-center}

Una vez finalizado el asistente, en el escritorio veremos un icono para acceder al portal Horizon administrator:

![con12]({{ site.imagesposts2019 }}/08/con12.png){: .align-center}

# Configuración inicial de Horizon

Después del primer login, lo primero que nos pedirá es instalar una licencia válida. Si estamos realizando una demo o PoC, podremos solicitar una licencia de evaluación en el portal de [my.vmware](https://my.vmware.com)

![con13]({{ site.imagesposts2019 }}/08/con13.png){: .align-center}

A continuación, añadiremos la instancia de nuestro vCenter donde se desplegarán los futuros escritorios. Recordar la recomendación de utilizar un usuario de servicio dedicado, tal como vimos en [este post]({{ site.url }}/jmp-part3/)

![con14]({{ site.imagesposts2019 }}/08/con14.png){: .align-center}

![con15]({{ site.imagesposts2019 }}/08/con15.png){: .align-center}

![con16]({{ site.imagesposts2019 }}/08/con16.png){: .align-center}

De momento no tenemos ningún composer server, por lo que nos saltaremos este paso:

![con17]({{ site.imagesposts2019 }}/08/con17.png){: .align-center}

![con18]({{ site.imagesposts2019 }}/08/con18.png){: .align-center}

![con19]({{ site.imagesposts2019 }}/08/con19.png){: .align-center}

![con20]({{ site.imagesposts2019 }}/08/con20.png){: .align-center}

Para acabar, deberemos configurar una BBDD para guardar los eventos de Horizon. Si seguisteis el post de [cómo reparar un servidor SQL]({{ site.url }}/jmp-part2/) ya podremos pasar directamente a la creación de la BBDD:

![events01]({{ site.imagesposts2019 }}/08/events01.png){: .align-center}

![events02]({{ site.imagesposts2019 }}/08/events02.png){: .align-center}

![events03]({{ site.imagesposts2019 }}/08/events03.png){: .align-center}

Con la BBDD creada, la configuraremos desde el apartado de Configuración de View:

![events04]({{ site.imagesposts2019 }}/08/events04.png){: .align-center}

Cómo último paso, también dejaremos configurado el usuario de Instant Clone que vimos cómo crear [en este post]({{ site.url }}/jmp-part3/)

![con21]({{ site.imagesposts2019 }}/08/con21.png){: .align-center}

Espero que os sirva.

Nos vemos en el próximo post: [Part 5: Instalación y configuración Replica Server]({{ site.url }}/jmp-part5/)

Un saludo!

Miquel.


