---
title: VMware Horizon/AppVolumes Load Balancer con HAProxy y Keepalived sobre PhotonOS
date: '2021-09-08 00:00:00'
layout: post
image: /assets/images/posts/2018/12/ssh-banner.jpg
tag:
- euc
- vmware
- vexpert
- haproxy
- pothonos
- keepalived
- haproxy
- loadbalancer
- ha
---

En el post de hoy veremos cómo podemos balancear y dotar de alta disponibilidad a nuestros servidores de conexión de VMware Horizon y a nuestros AppVolumes Managers.

Para que mentalmente os podais hacer una idea de lo que vamos a hacer, os dejo con el siguiente esquema:

![Horizon8-architecture-design]({{ site.imagesposts2021 }}/09/Horizon8-Architecture-design.png){: .align-center}

En él, podeis ver cómo añadiremos 2 nuevos servidores a nuestra infraestructura e instalaremos HAProxy + Keepalive en ellos.

Utilizaremos PhotonOS 3.0 revision3 para montar los servidores. PhotonOS es una versión optimizada para entornos vSphere con unos recursos mínimos.
Podremos descargar la OVA with virtual hardware v13 (UEFI Secure Boot) desde [aquí](https://github.com/vmware/photon/wiki/Downloading-Photon-OS)

# Despiegue Photon OS

El despliegue de la OVA es muy sencillo y solo tendremos que seguir el asistente del propio vCenter

![haproxy-00]({{ site.imagesposts2021 }}/09/haproxy-00.png){: .align-center}
![haproxy-01]({{ site.imagesposts2021 }}/09/haproxy-01.png){: .align-center}
![haproxy-02]({{ site.imagesposts2021 }}/09/haproxy-02.png){: .align-center}
![haproxy-03]({{ site.imagesposts2021 }}/09/haproxy-03.png){: .align-center}
![haproxy-04]({{ site.imagesposts2021 }}/09/haproxy-04.png){: .align-center}
![haproxy-05]({{ site.imagesposts2021 }}/09/haproxy-05.png){: .align-center}
![haproxy-06]({{ site.imagesposts2021 }}/09/haproxy-06.png){: .align-center}
![haproxy-07]({{ site.imagesposts2021 }}/09/haproxy-07.png){: .align-center}
![haproxy-08]({{ site.imagesposts2021 }}/09/haproxy-08.png){: .align-center}
![haproxy-09]({{ site.imagesposts2021 }}/09/haproxy-09.png){: .align-center}
![haproxy-10]({{ site.imagesposts2021 }}/09/haproxy-10.png){: .align-center}
![haproxy-11]({{ site.imagesposts2021 }}/09/haproxy-11.png){: .align-center}
![haproxy-12]({{ site.imagesposts2021 }}/09/haproxy-12.png){: .align-center}
![haproxy-13]({{ site.imagesposts2021 }}/09/haproxy-13.png){: .align-center}
![haproxy-14]({{ site.imagesposts2021 }}/09/haproxy-14.png){: .align-center}
![haproxy-15]({{ site.imagesposts2021 }}/09/haproxy-15.png){: .align-center}

# Configuración inicial

Por defecto, la ova de PhotonOS está configurada para coger IP por DHCP y SSH está habilitado en el arranque.

Nos conectaremos por SSH a la IP que nos ha proporcionado y accederemos con las credenciales por defecto (admin/changeme). La primera vez que hagamos login nos pedirá cambiar la contraseña.

![changeme]({{ site.imagesposts2021 }}/09/changeme.png){: .align-center}

Una vez tengamos desplegadas las 2 VMs haremos una pequeña configuración inicial para empezar.

- Actualizamos el SO

```ssh
tdnf upgrade -y
```

- Configurar IP estática
Por defecto, el fichero de configuración de IP se encuentra en `/etc/systemd/network/99-dhcp-en.network`

Con nuestro editor de textos preferido (vim, por ejemplo), deshabilitaremos DHCP
```ssh
[Match]
Name=e*
[Network]
DHCP=no
```

Crearemos un nuevo fichero de configuración con la siguiente configuración y lo llamaremos `/etc/systemd/network/10-static-en.network`
```ssh
[Match]

Name=eth0
[Network]
Address=192.168.6.120/24
Gateway=192.168.6.1
DNS=192.168.6.100
[DHCP]
UseDNS=false
```

> **_NOTA:_** Pondremos la IP correspondiente a cada uno de los servidores

- Cambiaremos el propietario del fichero con el siguiente comando: 

```ssh
chown systemd-network:systemd-network /etc/systemd/network/10-static-en.network
```

Para poder usar las VIP en ambos nodos de Keepalive y HAProxy, será necesario realizar ciertos cambios para permitir el reenvio a nivel IP y permitir que ambos servicios usen una IP que no está definida en la interfaz física de la VM.

Por defecto, PhotonOS tiene este comportamiento deshabilitado y lo podremos habilitar de la siguiente manera:

- Creamos y editamos el fichero de configuración `/etc/sysctl.d/55-keepalived.conf`

```ssh
#Enable IPv4 Forwarding
net.ipv4.ip_forward = 1
#Enable non-local IP bind
net.ipv4.ip_nonlocal_bind = 1
```

> **_NOTA:_** Fijaros que en la misma carpeta, está un fichero llamado `50-security-hardening.conf`. Al usar nosotros un numero superior en el fichero creado, es posible que se sobreescriban algunas configuraciones definidas por defecto.

Finalmente, necesitaremos configurar iptables para permitir el acceso http/https. `/etc/systemd/scripts/ip4save`

> **_NOTA:_** Añadiremos también el puerto 8404 para configurar el acceso al portal de estadísticas de HAProxy. Lo veremos mas adelante.

Añadiremos estas 4 lineas:

```ssh
-A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
-A INPUT -p tcp --dport 80 -j ACCEPT
-A INPUT -p tcp --dport 443 -j ACCEPT
-A INPUT -p tcp --dport 8404 -j ACCEPT
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
-A OUTPUT -j ACCEPT
COMMIT
```

Reiniciamos el servidor con el comando `reboot`

# Instalación alta disponibilidad con Keepalived

Para dotar de alta disponibilidad a nuestro balanceador, usaremos Keepalived.
Keepalived utiliza VRRP (Virtual Router Redundancy Protocol) para asignar una virtual IP (VIP) al nodo master de HAProxy y que así esté siempre disponible.

Instalaremos keepalived en ambos nodos con el siguiente comando:

```ssh
tdnf install keepalived -y
```

Una vez instalado haremos un backup de la configuración antes de modificarla.

```ssh
mv /etc/keepalived/keepalived.conf /etc/keepalived/keepalived-original.conf
```

Y crearemos un nuevo fichero de configuración similar a este:

**Nodo MASTER: PhotonLB-01**

```ssh
! Configuration File for keepalived PhotonLB-01

global_defs {
   router_id PhotonLB-01
   vrrp_skip_check_adv_addr
   vrrp_garp_interval 0
   vrrp_gna_interval 0
}
vrrp_script chk_haproxy {
  script "/usr/bin/kill -0 haproxy"
  interval 2
  weight 2
}
vrrp_instance LB_VIP {
  interface eth0
  state MASTER                  # BACKUP on PhotonLB-02
  priority 101                  # 100 on PhotonLB-02
  virtual_router_id 11          # same on all peers
  authentication {              # same on all peers
    auth_type AH
    auth_pass Pass1234
  }
  unicast_src_ip 192.168.6.120    # real IP of MASTER peer
  unicast_peer {
    192.168.1.121                 # real IP of BACKUP peer
  }
  virtual_ipaddress {
    192.168.6.122                 # Virtual IP for HAProxy loadbalancer
    192.168.6.123                 # Virtual IP for Horizon
    192.168.6.124                 # Virtual IP for AppVolumes Manager
  }
  track_script {
    chk_haproxy                 # if HAProxy is not running on this peer, start failover
  }
}

```

**Nodo SLAVE: PhotonLB-02**

```ssh
! Configuration File for keepalived PhotonLB-02

global_defs {
   router_id PhotonLB-02
   vrrp_skip_check_adv_addr
   vrrp_garp_interval 0
   vrrp_gna_interval 0
}
vrrp_script chk_haproxy {
  script "/usr/bin/kill -0 haproxy"
  interval 2
  weight 2
}
vrrp_instance LB_VIP {
  interface eth0
  state BACKUP                  # MASTER on PhotonLB-01
  priority 100                  # 101 on PhotonLB-01
  virtual_router_id 11          # same on all peers
  authentication {              # same on all peers
    auth_type AH
    auth_pass Pass1234
  }
  unicast_src_ip 192.168.6.121    # real IP of BACKUP peer
  unicast_peer {
    192.168.1.120                 # real IP of MASTER peer
  }
  virtual_ipaddress {
    192.168.6.122                 # Virtual IP for HAProxy loadbalancer
    192.168.6.123                 # Virtual IP for Horizon
    192.168.6.124                 # Virtual IP for AppVolumes Manager
  }
  track_script {
    chk_haproxy                 # if HAProxy is not running on this peer, start failover
  }
}

```

Resumiendo:

* El nodo MASTER tiene una prioridad 101 y el BACKUP 100
* Cada 2 segundos Keepalived chequea que HAProxy esté corriendo. Si está UP incrementa en 2 la prioridad y si está DOWN la baja 2
* Mientras HAProxy esté UP en ambos servidores, el que tenga prioridad mas alta será MASTER
* Si HAProxy se para en el nodo MASTER, la prioridad bajará y el BACKUP se convertirá en MASTER

En este punto, ya tenemos la configuración básica de keepalive. Se puede arrancar pero dará algunos fallos ya que todavia no tenemos instalado HAProxy y el script de chequeo fallará.

```ssh
systemctl start keepalived
```

> **_NOTA:_** Con el comando `journalctl -r` podemos ver el registro de logs

En el log veremos una salida similar a esta, el servicio se ha arrancado correctamente pero el script de HAProxy falla porque aún no está instalado.

```ssh
Keepalived_vrrp[777]: Script `chk_haproxy` now returning 1
Keepalived_vrrp[777]: VRRP_Script(chk_haproxy) failed (exited with status 1)
Keepalived_vrrp[777]: (LB_VIP) Receive advertisement timeout
Keepalived_vrrp[777]: (LB_VIP) Entering MASTER STATE

Keepalived_vrrp[777]: (LB_VIP) setting VIPs.
```

Para acabar, habilitaremos el servicio keepalived para que arranque durante el boot del servidor.

```ssh
systemctl enable keepalived
```

# Instalación de HAProxy

Instalamos HAProxy con el siguiente comando:

```ssh
tdnf install haproxy -y
```

Antes de empezar con la config, crearemos un directorio extra donde guardaremos información de estadísticas.

```ssh
mkdir /var/lib/haproxy
chmod 755 /var/lib/haproxy
```

Al igual que con el fichero de configuración de keepalived, haremos un backup previo de la configuración original.

```ssh
mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy-original.cfg
```

> **_NOTA:_** A diferencia que keepalived, HAProxy tiene que tener idéntica configuración en ambos servidores. Así que asegurate de que los cambios que se realicen, se hagan de forma idéntica en ambos nodos.

El nuevo fichero de configuración tendrá la siguiente información:

```ssh
# HAProxy configuration

#Global definitions
global
  chroot /var/lib/haproxy
  stats socket /var/lib/haproxy/stats
  daemon

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
  server PhotonLB01 192.168.6.120:8404 weight 1 check inter 30s fastinter 2s downinter 5s rise 3 fall 3
  server PhotonLB02 192.168.6.121:8404 weight 1 check inter 30s fastinter 2s downinter 5s rise 3 fall 3

######

### Horizon Connection servers ###
frontend horizon-http
  mode http
  bind 192.168.6.123:80
  # Redirect http to https
  redirect scheme https if !{ ssl_fc }

frontend horizon-https
  mode tcp
  bind 192.168.6.123:443
  default_backend horizon
backend horizon
  mode tcp
  option ssl-hello-chk
  balance source
  server Horizon_Connection_Server_01 192.168.6.113:443 weight 1 check inter 30s fastinter 2s downinter 5s rise 3 fall 3
  server Horizon_Connection_Server_02 192.168.6.114:443 weight 1 check inter 30s fastinter 2s downinter 5s rise 3 fall 3
######

### AppVolume Managers ###
frontend appvol-http
  mode http
  bind 192.168.6.124:80
  redirect scheme https if !{ ssl_fc }
frontend appvol-https
  mode tcp
  bind 192.168.6.124:443
  default_backend appvol

backend appvol
  mode tcp
  option ssl-hello-chk
  balance source
  server AppVolumes_Manager_01 192.168.6.118:443 weight 1 check inter 30s fastinter 2s downinter 5s rise 3 fall 3
  server AppVolumes_Manager_02 192.168.6.119:443 weight 1 check inter 30s fastinter 2s downinter 5s rise 3 fall 3
######

```

- **Statistics & Admin configuration:** En esta parte creamos 2 grupos y 2 usuarios (Uno admin y otro read-only). Este grupo se usará para ver las estadísticas de HAProxy y para poner los servidores de backend en modo mantenimiento. Definimos el frontend para que acepte conexiones a cualquier ip `bind: *:8404` Este es el puerto que definimos en iptables, os acordais? Para acceder al frontend y poder ver las estadísticas y habilitar/deshabilitar backend nos conectaremos a la URL http://192.168.6.122:8404/stats

- **Horizon Connection Servers:** La primera parte sólo hacemos una redirección de HTTP a HTTPS. A continuación, la interfaz se configura utilizando la VIP para Horizon. En el backend se especifican los servidores de conexión y el algoritmo de equilibrio de carga.
La opción ssl-hello-chk es necesaria para asegurarse de que HAProxy no solo verifique si el puerto 443 está abierto en el backend para configurar el backend como activo, sino también para verificar que realmente haya una conexión SSL válida al backend. Si no especificamos esto, el backend se activará para HAProxy, mientras que es posible que los servicios de Horizon aún se estén iniciando y aún no estén disponibles para su uso.
En condiciones normales, cada 30 segundos se comprueban los backends. Cuando un backend está inactivo, la verificación se realiza cada 5 s (downinter 5s), y cuando una verificación falla o tiene éxito después de una falla anterior, los backends se verifican cada 2s (fastinter 2s).

- **AppVolumes Managers:** Esta sección es similar a la de los Connection Server

Una vez tengamos la configuración hecha en ambos servidores, es momento de arrancar el servicio

```ssh
systemctl start haproxy
```

La salida del comando `journalctl -r` deberia ser similar a esta:

```ssh
systemd[1]: Starting HAProxy Load Balancer...
haproxy[3143]: [NOTICE] 040/100726 (3143) : New worker #1 (3145) forked
systemd[1]: Started HAProxy Load Balancer.
Keepalived_vrrp[3127]: Script `chk_haproxy` now returning 0
Keepalived_vrrp[3127]: VRRP_Script(chk_haproxy) succeeded
Keepalived_vrrp[3127]: (LB_VIP) Changing effective priority from 101 to 103
```

Para acabar, habilitaremos el servicio haproxy para que arranque durante el boot del servidor.

```ssh
systemctl enable haproxy
```

Si todo ha ido bien y los servicios han arrancado sin errores, nos podremos conectar al portal de estadísticas en la url http://192.168.6.122:8404/stats (nos pedirá el usuario/contraseña que hemos definido en la configuración de haproxy)

![stats]({{ site.imagesposts2021 }}/09/stats.png){: .align-center}

# Comprobar estado keepalive

No quiero despedirme sin antes enseñaros un pequeño método para verificar el estado del Keepalive y quien es MASTER y quien es BACKUP

Con el siguiente comando, podremos verificar el "role" que tiene cada servidor:

```ssh
root@PhotonLB-01 [ ~ ]# journalctl -u keepalived |grep Entering
Aug 25 12:27:01 PhotonLB-01 Keepalived_vrrp[539]: (LB_VIP) Entering MASTER STATE
```

Y con este la prioridad que tiene cada uno de ellos

```ssh
root@PhotonLB-01 [ ~ ]# journalctl -u keepalived |grep effective
Aug 25 12:26:58 PhotonLB-01 Keepalived_vrrp[539]: (LB_VIP) Changing effective priority from 101 to 103
```

También otro comando interesante es el que vacia el log, por si tenemos muchos registros y nos cuesta indentificar cada acción

```ssh
journalctl --rotate
journalctl --vacuum-time=1s
```

```ssh
clear
journalctl --rotate
journalctl --vacuum-time=1s
systemctl restart keepalived
sleep 5
journalctl -r |grep Keepalived_vrrp
ip --brief add
```

Y hasta aquí el post de hoy.

Espero sea de utilidad.

Un saludo!

Miquel.
