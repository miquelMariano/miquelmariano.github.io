---
title: Monitorización avanzada del estado de Horizon Conection Server para balanceo de carga con HAproxy y keepalived
date: '2021-12-21 00:00:00'
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

- [Part 1: VMware Horizon/AppVolumes Load Balancer con HAProxy y Keepalived sobre PhotonOS](https://miquelmariano.github.io/vmware-horizon-haproxy/)
- [Part 2: Monitorización avanzada del estado de Horizon Conection Server para balanceo de carga con HAproxy y keepalived](https://miquelmariano.github.io/vmware-horizon-load-balancer-haproxy-avanzado/)
- [Part 3: Configuración HAproxy para balancear sesiones Blast a los UAG](https://miquelmariano.github.io/haproxy-blast-uag/)

Tiempo atrás [escribí una entrada](https://miquelmariano.github.io/2021/09/08/vmware-horizon-haproxy/) en la que hablaba sobre balancear nuestros servicios de Horizon Connection Server y App Volumes con HAProxy y Keepalived sobre una VM Photon OS.

En el post de hoy, quiero dar una vuelta de tuerca más a esta arquitectura para monitorizar de forma más exhaustiva si los servicios por detrás del balanceador (HAproxy) están o no realmente disponibles. En el [post original](https://miquelmariano.github.io/2021/09/08/vmware-horizon-haproxy/) hacíamos una comprobación muy básica del estado de los connection servers o app volumes manager y solo comprobábamos si el servidor web contestaba o no.

Esto nos puede llevar a una situación no deseada, ya que desde el Horizon Administrator es posible deshabilitar un Connection Server de manera administrativa. El servidor web sigue levantado y, por lo tanto, HAProxy le sigue enviando peticiones, con el consiguiente "deny" del connection server.

Para evitar este escenario he averiguado que podemos monitorizar "connnection-server-url/favicon.ico". Si el servidor está OK y aceptando sesiones devolverá un código 200, en cambio, si está deshabilitado administrativamente, devolverá un código 503

![cs-disabled-01]({{ site.imagesposts2021 }}/12/cs-disabled-01.png){: .align-center}
![cs-disabled-02]({{ site.imagesposts2021 }}/12/cs-disabled-02.png){: .align-center}
![cs-disabled-03]({{ site.imagesposts2021 }}/12/cs-disabled-03.png){: .align-center}

Con HAProxy podemos verificar esto y declarar un servidor de backend en "down" si el código devuelto es diferente a 200. Para eso, necesitaremos modificar el fichero de configuración `/etc/haproxy/haproxy.cfg` y ajustar la configuración:

```ssh
...
backend horizon
  mode tcp
  option ssl-hello-chk
  balance source
  option httpchk HEAD /favicon.ico
  server Horizon_Connection_Server_01 192.168.6.113:443 weight 1 check check-ssl verify none inter 30s fastinter 2s downinter 5s rise 3 fall 3
  server Horizon_Connection_Server_02 192.168.6.114:443 weight 1 check check-ssl verify none inter 30s fastinter 2s downinter 5s rise 3 fall 3
...
```

> Añadiremos la línea **_option httpchk HEAD /favicon.ico_** y también añadiremos el **_check-ssl verify none_** en las 2 líneas de los server.

Tendremos que reiniciar el servicio de ambos servidores con el comando `systemctl restart haproxy`

Una vez arrancado con la nueva config, en el portal de estadísticas veremos cómo declara el servidor en DOWN porque ha recibido un 503

![cs-disabled-04]({{ site.imagesposts2021 }}/12/cs-disabled-04.png){: .align-center}

Al habilitar el conection server de nuevo, el servidor se recuperará y volverá a aceptar peticiones:

![cs-disabled-05]({{ site.imagesposts2021 }}/12/cs-disabled-05.png){: .align-center}
![cs-disabled-06]({{ site.imagesposts2021 }}/12/cs-disabled-06.png){: .align-center}

Aparte de esto, VMware también recomienda una frecuencia de chequeo que no sobrecargue en exceso los servidores. VMware recomienda una frecuencia de 30 segundos entre chequeos y 91 segundos de timeout (3 check + 1 segundo). Así pues, la configuración quedaria de la siguiente manera:

```ssh
...
frontend horizon-https
  mode tcp
  bind 192.168.6.123:443
  timeout server 91s
  default_backend horizon
backend horizon
  mode tcp
  option ssl-hello-chk
  balance source
  option httpchk HEAD /favicon.ico
  timeout server 91s
  server Horizon_Connection_Server_01 192.168.6.113:443 weight 1 check check-ssl verify none inter 30s fastinter 2s downinter 5s rise 3 fall 3
  server Horizon_Connection_Server_02 192.168.6.114:443 weight 1 check check-ssl verify none inter 30s fastinter 2s downinter 5s rise 3 fall 3

...
```

> Añadiremos las líneas **_timeout client 91s_** tanto en el bloque de frontend como en backend.

Para acabar, una última optimización que me parece interesante es cambiar el modo de balanceo de "source" a "leastconn", de esta manera, nos aseguraremos que HAProxy enviará la petición al connection server menos sobrecargado.

Con esta configuración, hay que asegurarnos que la persistencia del source esté habilitado para que un usuario no vaya cambiando de connection server tras una desconexión, ya que eso le obligaría a iniciar sesión de nuevo. En HAProxy, podemos crear una tabla IP y decirle que mantenga las conexiones como "fijas" según la dirección IP. 

Al configurar esta tabla, se debe especificar un timeout que se recomienda sea 1/3 de la configuración que tengamos en el Horizon Administrator. En mi caso, lo tengo configurado a 600 minutos, por lo tanto, 200 en la config de HAProxy.

![cs-disabled-07]({{ site.imagesposts2021 }}/12/cs-disabled-07.png){: .align-center}

```ssh
...
frontend horizon-https
  mode tcp
  bind 192.168.6.123:443
  timeout server 91s
  default_backend horizon
backend horizon
  mode tcp
  option ssl-hello-chk
  balance leastconn
  stick-table type ip size 1m expire 200m
  stick on src
  option httpchk HEAD /favicon.ico
  timeout server 91s
  server Horizon_Connection_Server_01 192.168.6.113:443 weight 1 check check-ssl verify none inter 30s fastinter 2s downinter 5s rise 3 fall 3
  server Horizon_Connection_Server_02 192.168.6.114:443 weight 1 check check-ssl verify none inter 30s fastinter 2s downinter 5s rise 3 fall 3
...
```

> Añadiremos las líneas **_tbalance leastconn_**, **_stick-table type ip size 1m expire 200m_** y **_stick on src_** 

Cómo resumen final, el bloque de nuestros connection servers en la configuración del HAProxy debería quedar similar a esto:

```ssh
#### Horizon Connection servers ###
frontend horizon-http
  mode http
  bind 192.168.6.123:80
  # Redirect http to https
  redirect scheme https if !{ ssl_fc }

frontend horizon-https
  mode tcp
  bind 192.168.6.123:443
  timeout server 91s
  default_backend horizon
backend horizon
  mode tcp
  option ssl-hello-chk
  balance leastconn
  stick-table type ip size 1m expire 200m
  stick on src
  option httpchk HEAD /favicon.ico
  timeout server 91s
  server Horizon_Connection_Server_01 192.168.6.113:443 weight 1 check check-ssl verify none inter 30s fastinter 2s downinter 5s rise 3 fall 3
  server Horizon_Connection_Server_02 192.168.6.114:443 weight 1 check check-ssl verify none inter 30s fastinter 2s downinter 5s rise 3 fall 3
  ```

Y hasta aquí el post de hoy.

Espero sea de utilidad.

Un saludo!

Miquel.
