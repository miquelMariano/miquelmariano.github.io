---
title: Instalación Veeam Backup & Replication v13
subtitle: Depliegue nuevo virtual appliance
date: '2026-02-05 00:00:00'
layout: post
thumbnail-img: https://miquelmariano.github.io/assets/images/posts/2026/02/veeam-install-15.png
cover-img: https://miquelmariano.github.io/assets/images/fondos/03.jpg
share-img: https://miquelmariano.github.io/assets/images/posts/2026/01/02/veeam-install-15.png
published: true
author: Miquel Mariano
tag:
- veeam
- backup
- ramsonware
---

Cómo muchos ya sabréis, el pasado mes de septiembre Veeam lanzó la versión 13 de su producto estrella Veeam Backup & Replication.

Este lanzamiento marca uno de los mayores cambios en el producto con la introducción de una versión appliance basada en Linux como forma principal de despliegue, además de la opción tradicional Windows.

# Puntos clave de Veeam v13

1. Nuevo enfoque: appliance Linux (Veeam Software Appliance)
- Veeam deja gradualmente la necesidad de Windows Server para el backup core, ofreciendo una appliance Linux preconfigurada y endurecida (JeOS) para mayor seguridad y simplicidad. 
- Se distribuye en ISO y OVA para entornos físicos y virtuales. 

2. Seguridad reforzada
- Hardened by default: SELinux, servicios mínimos, actualizaciones automatizadas y menor superficie de ataque. 
- Integración con SSO (SAML), RBAC avanzado y detección mejorada de amenazas. 

3. Interfaz moderna
-  Nueva consola web HTTPS para gestión moderna y accesible desde navegador, junto con compatibilidad con roles y SSO. 

4. Operaciones y resiliencia
- Alta disponibilidad nativa planeada en appliance. 
- Automatización de despliegue y menor mantenimiento OS. 

5. Mejoras ampliadas de plataforma
- Seguridad y protección avanzada: detección de malware, inmutabilidad por defecto y análisis inteligente. 
- Cloud y recuperación: recuperación instantánea a Microsoft Azure y mejoras de integración cloud. 
- Performance y escalabilidad: arquitectura 64-bit, mejoras en engine y más paralelismo. 

# Despliegue virtual appliance en vSphere

En apartado no hay mucho misterio. Deberemos descargarnos la OVA desde el portal de soporte de Veeam y haremos la implementación a través del vCenter como cualquier otro tipo de OVA

![Despliegue-veeam-virtual-appliance-01]({{ site.imagesposts2026 }}/02/veeam-ova-01.png){: .mx-auto.d-block :}

![Despliegue-veeam-virtual-appliance-02]({{ site.imagesposts2026 }}/02/veeam-ova-02.png){: .mx-auto.d-block :}

![Despliegue-veeam-virtual-appliance-03]({{ site.imagesposts2026 }}/02/veeam-ova-03.png){: .mx-auto.d-block :}

![Despliegue-veeam-virtual-appliance-04]({{ site.imagesposts2026 }}/02/veeam-ova-04.png){: .mx-auto.d-block :}

![Despliegue-veeam-virtual-appliance-05]({{ site.imagesposts2026 }}/02/veeam-ova-05.png){: .mx-auto.d-block :}

![Despliegue-veeam-virtual-appliance-06]({{ site.imagesposts2026 }}/02/veeam-ova-06.png){: .mx-auto.d-block :}

![Despliegue-veeam-virtual-appliance-07]({{ site.imagesposts2026 }}/02/veeam-ova-07.png){: .mx-auto.d-block :}

# Configuración inicial

Con la OVA ya desplegada y la máquina virtual arrancada, nos conectaremos a la consola y arrancaremos el proceso de instalación y configuración inicial.

![Configuracion-veeam-virtual-appliance-01]({{ site.imagesposts2026 }}/02/veeam-install-01.png){: .mx-auto.d-block :}

![Configuracion-veeam-virtual-appliance-02]({{ site.imagesposts2026 }}/02/veeam-install-02.png){: .mx-auto.d-block :}

Aceptamos la licencia y continuamos.

![Configuracion-veeam-virtual-appliance-03]({{ site.imagesposts2026 }}/02/veeam-install-03.png){: .mx-auto.d-block :}

Configuraremos un nombre para el appliance y especificaremos la configuración IP.

![Configuracion-veeam-virtual-appliance-04]({{ site.imagesposts2026 }}/02/veeam-install-04.png){: .mx-auto.d-block :}

![Configuracion-veeam-virtual-appliance-05]({{ site.imagesposts2026 }}/02/veeam-install-05.png){: .mx-auto.d-block :}

![Configuracion-veeam-virtual-appliance-06]({{ site.imagesposts2026 }}/02/veeam-install-06.png){: .mx-auto.d-block :}

Configuración NTP.

![Configuracion-veeam-virtual-appliance-07]({{ site.imagesposts2026 }}/02/veeam-install-07.png){: .mx-auto.d-block :}

Especificaremos una contraseña para el usuario `veeamadmin`quien será de momento el único administrador de la plataforma.
También será obligatorio configurar un MFA, por ejemplo, con Microsoft Authenticator u otro generador de tokens OTP

![Configuracion-veeam-virtual-appliance-08]({{ site.imagesposts2026 }}/02/veeam-install-08.png){: .mx-auto.d-block :}

![Configuracion-veeam-virtual-appliance-09]({{ site.imagesposts2026 }}/02/veeam-install-09.png){: .mx-auto.d-block :}

El usuario `veamso`es un usuario privilegiado, que si bien no es administrador de la plataforma, es quien debe auditar y aprobar ciertas tareas que se hagan en la plataforma.
Le configuraremos también una contraseña

![Configuracion-veeam-virtual-appliance-10]({{ site.imagesposts2026 }}/02/veeam-install-10.png){: .mx-auto.d-block :}

Aquí tenemos el resumen final y procederemos con la instalación

![Configuracion-veeam-virtual-appliance-11]({{ site.imagesposts2026 }}/02/veeam-install-11.png){: .mx-auto.d-block :}

Podremos ver todo el proceso de instalación

![Configuracion-veeam-virtual-appliance-12]({{ site.imagesposts2026 }}/02/veeam-install-12.png){: .mx-auto.d-block :}

Finalmente nos aparecerá la pantalla principal del appliance y con la información relevante a los accesos

**Host Management Console:** Es la interfaz de gestión del appliance, reiniciar servicios, revisar logs, gestionar actualizaciones... se realizan desde aquí

**Veeam Backup & Replication web UI:** Es la nueva interfaz web de Veeam. Por el momento es algo limitada pero para operaciones básicas es más que suficiente

![Configuracion-veeam-virtual-appliance-13]({{ site.imagesposts2026 }}/02/veeam-install-13.png){: .mx-auto.d-block :}

Al acceder a la UI web nos dará la posibilidad de descargar el cliente pesado para windows para poder tener la experiencia completa y la que estamos acostumbrados con versiones anteriores.

![Configuracion-veeam-virtual-appliance-14]({{ site.imagesposts2026 }}/02/veeam-install-14.png){: .mx-auto.d-block :}

Y finalmente este seria el dashboard principal de la UI web.

![Configuracion-veeam-virtual-appliance-15]({{ site.imagesposts2026 }}/02/veeam-install-15.png){: .mx-auto.d-block :}

Nos vemos en el próximo post ;-)

Un saludo

Miquel.