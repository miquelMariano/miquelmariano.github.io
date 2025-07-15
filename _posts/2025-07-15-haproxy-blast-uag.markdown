---
title: Configuración HAproxy para balancear sesiones Blast a los UAG
date: '2025-07-15 00:00:00'
layout: post
image: /assets/images/posts/2018/12/ssh-banner.jpg
tag:
- euc
- vmware
- vexpert
- haproxy
- pothonos
- keepalived
- loadbalancer
- ha
---

- [Part 1: VMware Horizon/AppVolumes Load Balancer con HAProxy y Keepalived sobre PhotonOS](https://miquelmariano.github.io/2021/09/08/vmware-horizon-haproxy/)
- [Part 2: Monitorización avanzada del estado de Horizon Conection Server para balanceo de carga con HAproxy y keepalived](https://miquelmariano.github.io/2021/12/21/vmware-horizon-load-balancer-haproxy-avanzado/)
- [Part 3: Configuración HAproxy para balancear sesiones Blast a los UAG](https://miquelmariano.github.io/2025/07/15/haproxy-blast-uag/)

Siguiendo con la serie de posts sobre [HAproxy] (https://miquelmariano.github.io/tag/#/haproxy), hoy quiero centrarme en la parte de balanceo externo pasando por los UAG.

En este diseño, la cosa se complica, ya que no solo interviene el puerto 443 para hacer login, sinó también el protocolo de visualización Blast por el 8443

![Horizon8-architecture-design-v2]({{ site.imagesposts2025 }}/07/Horizon8-Architecture-design-v2.png){: .align-center}

Antes de nada, os recomiendo encarecidamente que os paseis por [post oficial](https://techzone.omnissa.com/resource/understand-and-troubleshoot-horizon-connections#internal-connections) en donde se explican los conceptos básicos de cómo funciona horizon.

Lo primero que deberemos entender es que el flujo de conexión a Horizon lo componen:

- Protocolo primario: Básicamente el que nos permite la autenticación a nuestro entorno Horizon y la asignación del escritorio
- Protocolo secundario: Ahí entra en juego el protocolo de visualización. Blast o PCoIP

![Protocolo-primario-secundario]({{ site.imagesposts2025 }}/07/protocolo-primario-secundario1.png){: .align-center}

Entendiendo esto, es básico que nuestro balanceador redirija todas las peticiones de la misma sesión al mismo backend, ya que de lo contrario los UAGs cortarán la conexión.

En el siguiente diagrama se ve todo algo mas visual:

![diagrama-conexion-externa]({{ site.imagesposts2025 }}/07/diagrama-conexion-externa1.png){: .align-center}





