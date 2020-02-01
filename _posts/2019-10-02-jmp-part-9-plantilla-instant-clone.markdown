---
title: Creando un entorno JMP con VMware Horizon - Parte 9 - Preparar plantilla master para Instant Clone
date: '2019-10-02 00:00:00'
layout: post
image: /assets/images/posts/2019/07/horizon-logo.png
tag:
- vmware
- horizon
- vexpert
- euc
- desktop
- mobility
permalink: /jmp-part9/

---

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
- Part 11: Instalar App Volumes
- Part 12: Configuración inicial App Volumes
- Part 13: Crear nuestro primer App Stack
- Part 14: Trabajando con Writable Volumes
- Part 15: User Environment Manager Installation
- Part 16: Primeros pasos con UEM
- Part 17: Instalación y configuración JMP Server
- Part 18: Aprovisionamiento con JMP

# Preparar plantilla master para Instant Clone

Partiremos de la base de que ya hemos elegido nuestro SO base (generalmente un SO cliente) y que ya lo tenemos instalado en nuestra VM que nos servirá como plantilla master.

Os recomiendo, que repaseis i sigais [este documento de best practices](https://techzone.vmware.com/creating-optimized-windows-image-vmware-horizon-virtual-desktop#1150978) para crear vuestra plantilla base.

Como en esta serie de posts estamos tratando de explicar el paso a paso para crear un entorno JMP, necesitaremos instalar varios agentes en nuestra plantilla:

- VMware Tools
- VMware Horizon Agent
- VMware User Environment Manager (UEM) agent
- VMware App Volumes Agent

En este post, solo vamos a ver cómo instalar nuestro Horizon Agent, pero hay que tener en cuenta que el orden de instalación de los agentes es importante a la hora de configurar bien nuestra plantilla. Podeis consultar la nota técnica en la [siguiente KB](https://kb.vmware.com/s/article/2118048)

Como decía, en este post vamos a ver como configurar una plantilla para Instant Clone, que básicamente se consigue instalando el Horizon Agent con unos parámetros determinados. Vamos a ello...

Arrancamos el instalador y seguimos el wizard:

![agent1]({{ site.imagesposts2019 }}/09/agent1.png){: .align-center}

Aceptamos la licencia y continuamos:

![agent2]({{ site.imagesposts2019 }}/09/agent2.png){: .align-center}

Seleccionamos IPv4 como protocolo predefinido y continuamos:

![agent3]({{ site.imagesposts2019 }}/09/agent3.png){: .align-center}

Aquí es dónde está la parte importante de la instalación. Por defecto, la opción de VMware Horizon View composer está habilitada, pero esta opción solo nos sirve para la tecnología Linked Clone, no para Instant Clone. Así pues, deberemos desmarcar esta opción y marcar VMware Horizon Instant Clone Agent:

![agent4]({{ site.imagesposts2019 }}/09/agent4.png){: .align-center}

Cómo en todo este proceso vamos a utilizar UEM para la personalización de los escritorios, desmarcaremos también la opción de VMware Horizon 7 Persona Management:

![agent5]({{ site.imagesposts2019 }}/09/agent5.png){: .align-center}

Install...

![agent6]({{ site.imagesposts2019 }}/09/agent6.png){: .align-center}

Cuando termine la instalación, finalizamos el asistente y reiniciamos la VM:

![agent7]({{ site.imagesposts2019 }}/09/agent7.png){: .align-center}

Con el agente ya instalado, procederemos a apagar nuestra VM y crear un snapshot del cual partirán nuestros escritorios:

![agent8]({{ site.imagesposts2019 }}/09/agent8.png){: .align-center}

Y hasta aquí por hoy, en el próximo post veremos cómo crear nuestro primer Pool de Instant Clones

Espero que os sirva.

Nos vemos en el próximo post: [Part 10: Configurar un pool de Instant Clone]({{ site.url }}/jmp-part10/)

Un saludo!

Miquel.


