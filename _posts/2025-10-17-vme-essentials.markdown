---
title: Part 1 - Introducción Morpheus VM Essentials
date: '2025-07-15 00:00:00'
layout: post
published: true
image: /assets/images/posts/2018/12/ssh-banner.jpg
tag:
- kvm
- hpe
- vme
- cloud
- morpheus
- ha
---

#HPE Morpheus VM Essentials: La Alternativa de Virtualización y Gestión Híbrida de HPE

En el cambiante panorama de las infraestructuras virtuales, las organizaciones buscan constantemente soluciones que ofrezcan flexibilidad, control de costes y agilidad. HPE ha respondido a esta demanda con el lanzamiento de HPE Morpheus VM Essentials Software, una solución de virtualización y gestión unificada que ha surgido como una alternativa estratégica en un mercado dominado en los últimos años por Vmware (ahora Broadcom). Esta oferta es el resultado de una importante adquisición que ha redefinido la propuesta de nube privada de HPE.

Desde hace varias semanas estoy haciendo un poco de I+D sobre Morpheus y VM Essentials. Es por eso que me he decidido a publicar una serie de posts e intentar explorar todas las posibilidades que nos ofrece.


[Parte 1 - Introducción a Morpheus VM Essentials](https://miquelmariano.github.io)
[Parte 2 - Instalación VM Essentials software](https://miquelmariano.github.io)
[Parte 3 - Instalación VME Manager](https://miquelmariano.github.io)
[Parte 4 - Configuración inicial](https://miquelmariano.github.io)
[Parte 5 - Creación cluster Ceph](https://miquelmariano.github.io)
[Parte 6 - Desplegar nuestra primera VM](https://miquelmariano.github.io)
[Parte 7 - Backups](https://miquelmariano.github.io)
[Parte 8 - Pruebas de HA](https://miquelmariano.github.io)
[Parte 9 - Migración de VMs desde vSphere](https://miquelmariano.github.io)
[Parte 10 - Comandos útiles](https://miquelmariano.github.io)


![HPE_Morpheus_VM_Essentials_01]({{ site.imagesposts2025 }}/10/hpe_morpheus_01.jpg){: .align-center}





![HPE_Morpheus_VM_Essentials_02]({{ site.imagesposts2025 }}/10/hpe_morpheus_02.jpg){: .align-center}
![HPE_Morpheus_VM_Essentials_03]({{ site.imagesposts2025 }}/10/hpe_morpheus_03.jpg){: .align-center}


- [Part 1: VMware Horizon/AppVolumes Load Balancer con HAProxy y Keepalived sobre PhotonOS](https://miquelmariano.github.io)
- [Part 2: Monitorización avanzada del estado de Horizon Conection Server para balanceo de carga con HAproxy y keepalived](https://miquelmariano.github.io/2021/12/21/vmware-horizon-load-balancer-haproxy-avanzado/)
- [Part 3: Configuración HAproxy para balancear sesiones Blast a los UAG](https://miquelmariano.github.io/2025/07/15/haproxy-blast-uag/)

Siguiendo con la serie de posts sobre [HAproxy](https://miquelmariano.github.io/tag/#/haproxy), hoy quiero centrarme en la parte de balanceo externo pasando por los UAG.

En este diseño, la cosa se complica, ya que no solo interviene el puerto 443 para hacer login, sinó también el protocolo de visualización Blast por el 8443

![Horizon8-architecture-design-v2]({{ site.imagesposts2025 }}/07/Horizon8-Architecture-design-v2.png){: .align-center}

Antes de nada, os recomiendo encarecidamente que os paseis por [post oficial](https://techzone.omnissa.com/resource/understand-and-troubleshoot-horizon-connections#internal-connections) en donde se explican los conceptos básicos de cómo funciona horizon.

En [este otro post](https://thevirtualhorizon.com/2024/06/17/omnissa-horizon-load-balancing-overview/) también he encontrado teoria muy valiosa para terminar de configurar todo

Lo primero que deberemos entender es que el flujo de conexión a Horizon lo componen:

- Protocolo primario: Básicamente el que nos permite la autenticación a nuestro entorno Horizon y la asignación del escritorio
- Protocolo secundario: Ahí entra en juego el protocolo de visualización. Blast o PCoIP

![Protocolo-primario-secundario]({{ site.imagesposts2025 }}/07/protocolo-primario-secundario1.png){: .align-center}

Entendiendo esto, es básico que nuestro balanceador redirija todas las peticiones de la misma sesión al mismo backend, ya que de lo contrario los UAGs cortarán la conexión.

En el siguiente diagrama se ve todo algo mas visual:

![diagrama-conexion-externa]({{ site.imagesposts2025 }}/07/diagrama-conexion-externa1.png){: .align-center}

Vamos allá con la configuración de HAproxy.

El despliegue de PhotonOS lo expliqué ya en [este post](https://miquelmariano.github.io/2021/09/08/vmware-horizon-haproxy/)

Lo primero que haremos, será editar nuestro fichero iptables para permitir el acceso por Blast. `/etc/systemd/scripts/ip4save`

Añadiremos la siguiente línea a nuestro fichero:

```ssh
-A INPUT -p tcp --dport 8443 -j ACCEPT
```

Quedando un fichero similar a este:

```ssh
# init
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT DROP [0:0]
# Allow local-only connections
-A INPUT -i lo -j ACCEPT
-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
#keep commented till upgrade issues are sorted
#-A INPUT -j LOG --log-prefix "FIREWALL:INPUT "
-A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
-A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
-A INPUT -p tcp --dport 80 -j ACCEPT
-A INPUT -p tcp --dport 443 -j ACCEPT
-A INPUT -p tcp --dport 8404 -j ACCEPT
-A INPUT -p tcp --dport 8443 -j ACCEPT
-A OUTPUT -j ACCEPT
COMMIT
```
Con esta parte lista, nos iremos ya a la configuración de HAproxy > `/etc/haproxy/haproxy-original.cfg`

Recordar que la configuración debe ser idéntica en ambos nodos y que los cambios surtirán efecto tras el reinicio del servicio:

```ssh
systemctl start haproxy
```

> **_NOTA:_** Añadimos la pareja de servidores HAProxy para mantener la tabla de persistencia entre los nodos del cluster

```ssh
#peers to syncronize stick-tables
  peers haproxy_cluster
    peer HAPROXYDMZ01 192.168.195.12:1024
    peer HAPROXYDMZ02 192.168.195.13:1024
```

> **_NOTA:_** En el bloque de frontend definiremos unas ACL para poder redirigir el trafico al puerto correspondiente dependiendo del destino.

```ssh
  #ACLs to identify destination port
  acl is_443 dst_port 443
  acl is_8443 dst_port 8443

  #Use specific backend depending destination port
  use_backend uag-backend-443 if is_443
  use_backend uag-backend-8443 if is_8443
```

> **_NOTA:_** En ambos backend, tanto 443 como 8443 definiremos estas 2 lineas lo que nos permitirá la persistencia de las sesiones y que las tablas se sincronicen entre ambos nodos del cluster HAproxy

```ssh
stick-table type ip size 200k expire 30m peers haproxy_cluster 
stick on src 
```
Finalmente, el fichero completo deberia quedar algo similar a esto:

```ssh
# HAProxy configuration

#Global definitions
global
  chroot /var/lib/haproxy
  stats socket /var/lib/haproxy/stats
  daemon

#peers to syncronize stick-tables
  peers haproxy_cluster
    peer HAPROXYDMZ01 192.168.195.12:1024
    peer HAPROXYDMZ02 192.168.195.13:1024

defaults
  timeout connect 5s
  timeout client 30s
  timeout server 30s

### Statistics & Admin configuration ###
userlist stats-auth
  group admin   users admin
  user admin insecure-password LetMeIn
  group ro users stats
  user stats insecure-password ReadOnly
frontend stats-http8404
  mode http
  bind *:8404
  default_backend statistics
backend statistics
  mode http
  stats enable
  stats show-legends
  stats show-node
  stats refresh 30s
  acl AUTH http_auth(stats-auth)
  acl AUTH_ADMIN http_auth_group(stats-auth) admin
  stats http-request auth unless AUTH
  stats admin if AUTH_ADMIN
  stats uri /stats
  server HAPROXYDMZ01 192.168.195.12:8404 weight 1 check inter 30s fastinter 2s downinter 5s rise 3 fall 3
  server HAPROXYDMZ02 192.168.195.13:8404 weight 1 check inter 30s fastinter 2s downinter 5s rise 3 fall 3

######

### UAG ###

frontend uag-entrada
  mode tcp
  bind 192.168.195.15:443
  bind 192.168.195.15:8443

  #ACLs to identify destination port
  acl is_443 dst_port 443
  acl is_8443 dst_port 8443

  #Use specific backend depending destination port
  use_backend uag-backend-443 if is_443
  use_backend uag-backend-8443 if is_8443

backend uag-backend-443
  mode tcp
  balance source 
  stick-table type ip size 200k expire 30m peers haproxy_cluster 
  stick on src 
  server UAG01_443 192.168.195.10:443 weight 1 check inter 30s fastinter 2s downinter 5s rise 3 fall 3
  server UAG02_443 192.168.195.11:443 weight 1 check inter 30s fastinter 2s downinter 5s rise 3 fall 3

backend uag-backend-8443
  mode tcp
  balance source # Balanceo basado en la IP de origen
  stick-table type ip size 200k expire 30m peers haproxy_cluster 
  stick on src 
  server UAG01_8443 192.168.195.10:8443 weight 1 check inter 30s fastinter 2s downinter 5s rise 3 fall 3
  server UAG02_8443 192.168.195.11:8443 weight 1 check inter 30s fastinter 2s downinter 5s rise 3 fall 3
  ```

Con todo esto, nuestro portal de estadísticas mostrará algo simila a esto:

![haproxy]({{ site.imagesposts2025 }}/07/haproxy.png){: .align-center}

Un saludo!

Miquel.
