---
title: Creando un entorno JMP con VMware Horizon - Parte 12 - Configuración inicial App Volumes Manager
date: '2020-03-11 00:00:00'
layout: post
image: /assets/images/posts/2019/07/horizon-logo.png
tag:
- vmware
- horizon
- vexpert
- euc
- desktop
- mobility
permalink: /jmp-part12/
---

En el capítulo de hoy, continuaremos con la parte de configuración de nuestro entorno App Volumes manager.

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

# Configuración inicial de App Volumes

Si habéis seguido el proceso de [Instalar App Volumes]({{ site.url }}/jmp-part11/), la primera vez que os conectéis al App Volumes Manager, aparecerá el wizard de configuración inicial:

![appvol_config1]({{ site.imagesposts2020 }}/01/appvol_config1.png){: .align-center}

Por defecto, viene con una licencia pre-instalada, que cómo veis tiene algunas limitaciones:

![appvol_config2]({{ site.imagesposts2020 }}/01/appvol_config2.png){: .align-center}

Configuraremos nuestro dominio de Active Directory. Mi recomendación es que creeis un usuario dedicado para App Volumes [tal como ya hicimos con otros servicios de Horizon.]({{ site.url }}/jmp-part3/)

![appvol_config3]({{ site.imagesposts2020 }}/01/appvol_config3.png){: .align-center}
![appvol_config4]({{ site.imagesposts2020 }}/01/appvol_config4.png){: .align-center}

Añadiremos el grupo que va a ser administrador de App Volumes:

![appvol_config5]({{ site.imagesposts2020 }}/01/appvol_config5.png){: .align-center}
![appvol_config6]({{ site.imagesposts2020 }}/01/appvol_config6.png){: .align-center}

Cómo estamos trabajando con un entorno virtualizado. En la pestaña de Managers registraremos nuestro vCenter.

![appvol_config7]({{ site.imagesposts2020 }}/01/appvol_config7.png){: .align-center}
![appvol_config8]({{ site.imagesposts2020 }}/01/appvol_config8.png){: .align-center}
![appvol_config9]({{ site.imagesposts2020 }}/01/appvol_config9.png){: .align-center}

En este punto, registraremos los datastores en dónde queramos que por defecto se guarden nuestros App Stacks y nuestros Writable Volumes.

![appvol_config10]({{ site.imagesposts2020 }}/01/appvol_config10.png){: .align-center}
![appvol_config11]({{ site.imagesposts2020 }}/01/appvol_config11.png){: .align-center}
![appvol_config12]({{ site.imagesposts2020 }}/01/appvol_config12.png){: .align-center}

Para finalizar, también podremos configurar una serie de parámetros genéricos como el timeout de la sesión, zona horaria, etc, etc...

![appvol_config13]({{ site.imagesposts2020 }}/01/appvol_config13.png){: .align-center}

Y hasta aquí por hoy, en el próximo post veremos [cómo crear nuestro primer App Stack]({{ site.url }}/jmp-part13/)

Un saludo!

Miquel.


