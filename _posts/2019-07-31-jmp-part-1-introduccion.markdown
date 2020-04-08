---
title: Creando un entorno JMP con VMware Horizon - Parte 1 - Introducción
date: '2019-07-31 00:00:00'
layout: post
image: /assets/images/posts/2019/07/horizon-logo.png
tag:
- vmware
- horizon
- vexpert
- euc
- desktop
- mobility
permalink: /jmp-part1/

---

Buenos días a tod@s!!

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
- [Part 12: Configuración inicial App Volumes]({{ site.url }}/jmp-part12/)
- [Part 13: Crear nuestro primer App Stack]({{ site.url }}/jmp-part13/)
- Part 14: Trabajando con Writable Volumes
- Part 15: User Environment Manager Installation
- Part 16: Primeros pasos con UEM
- Part 17: Instalación y configuración JMP Server
- Part 18: Aprovisionamiento con JMP

# Introducción

Han pasado ya muchos años desde que empezaron a aparecer las primeras tecnologías EUC, primero fué Citrix con su producto XenDesktop, después apareció View de VMware que poco a poco ha ido transformandose en Horizon View y ahora solo Horizon. 

Con el paso del tiempo y las nuevas versiones han ido apareciendo nuevas características y funcionalidades que han ido mejorando la vida de los administradores pero siempre ha habido un aspecto que ha sido problemático, los usuarios, o más bien, sus datos y su "experiencia de usuario".

A menudo, los usuarios quieren personalizar su escritorio, iconos, favoritos, y con el uso de Linked Clones + persistent disk + roaming profiles es fácil caer en problemas de ineficiencia en el almacenamiento, cuellos de botella o incluso el riesgo de corrupción de perfiles.

La entrega de aplicaciones al escritorio mediante ThinApp o incluso aplicaciones alojadas en RDS también tiene una fuerte dependencia en la red y que no se produzcan latencias. 

Con todo esto y sin un método "potente" para poder escalar el aprovisionamiento dinámico de aplicaciones, al final, las organizaciones tienen que recurrir a la creación de múltiples plantillas, cada una con sus aplicaciones pre-instaladas para poder atender la demanda de cada "tipo" de usuario.

Con la llegada de Horizon, en su versión 7.5, ha llegado también una nueva característica llamada JMP Integrated Workflow. En términos de marketing, JMP (Just-in-time Management Platform). Realmente, esta característica es la combinación de 3 productos dentro de la suit VMware Horizon Enterprise. Instant Clones, App Volumes y User Environment Manager (UEM)

Lo que nos proporciona JMP, es una nueva metodología para proporcionar a los usuarios la experiencia de un escritorio persistente pero utilizando tecnología de escritorios volátiles (Instant Clones), entrega de aplicaciones en tiempo real (App Volumes) y gestión eficiende de los datos y perfiles de usuario (UEM)


![jmp1]({{ site.imagesposts2019 }}/07/jmp1.png){: .align-center}

Para mas información, VMware ha creado la [siguiente guía](https://techzone.vmware.com/resource/jmp-and-vmware-horizon-7-deployment-considerations) con información detallada sobre JMP y Horizon 7

El propósito de esta serie es crear un step-by-step para crear un entorno JMP completamente funcional y los componentes estarán basados en las siguientes versiones:

 - Horizon 7 Enterprise v7.9
 - App Volumes v2.17
 - UEM v9.8
 - SQL server express 2017
 - ESXi v6.7 U2
 - vCenter v6.7 U2
 - Para los servidores, Windows Server 2019 Standard
 - Para la plantilla, Windows 10 LTSC x64

Os espero en el siguiente post [Part 2: Preparar servidor SQL]({{ site.url }}/jmp-part2/)

Un saludo!

Miquel.


