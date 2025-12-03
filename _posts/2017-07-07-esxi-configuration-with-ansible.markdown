---
title: Automatizar configuración de ESXi con Ansible
date: '2017-07-07 00:00:00'
layout: post
image: /assets/images/posts/2017/07/ansible-esxi.jpg
headerImage: true
tag:
- ansible
- devops
- automation
- vexpert
- esxi
---


Muy buenos días amigos.

En el post de hoy voy a enseñaros como podemos empezar a automatizar las configuraciones de nuestros ESXi.

**¿Por que automatizar?**

Una de las primeras respuestas que le viene uno a la cabeza es el ahorro de tiempo. Y es cierto, automatizando ciertas tareas de configuración podemos llegar a ganar mucho tiempo en granjas formadas por muchos ESXi. Otro aspecto muy importante, y que yo me tomo muy en serio, es el tema de que TODOS mis ESXi compartan los mismos parámetros de configuración. El servidor NTP, el dominio de búsqueda predeterminado, el directorio de logs, etc, etc son configuraciones básicas que se configuran al instalar un nuevo ESXi y que es muy fácil que se nos pase por alto algún valor.

Así pues, con Ansible, nos aseguramos de que, aunque en nuestra plataforma solo añadamos nuevos hosts cada 3 años, la configuración será siempre idéntica.

**Manejar ESXi con Ansible**

En uno de mis [antiguos posts](https://miquelmariano.github.io/ansible-for-dummies/) ya explicaba como generar una clave SSH y copiarla a los servidores que queramos controlar, pero al tratarse de ESXi, el procedimiento cambia un poco. Simplemente, desde el servidor donde tenemos instalado Ansible, copiaremos la clave SSH a nuestros ESXi con el siguiente comando:

```
$ cat /root/.ssh/id_rsa.pub | ssh root@esxi05.ncora.local \ 'cat >> /etc/ssh/keys-root/authorized_keys'
```

Una vez copiada la clave, ya podremos generar un inventario y ejecutar roles contra nuestra granja.

**Roles**

En el repositorio [Galaxy](https://galaxy.ansible.com/miquelMariano/) he creado algunos roles para las configuraciones básicas que se realizan nada mas instalar un ESXi

[ESXi_ssh](https://galaxy.ansible.com/miquelMariano/ESXi_ssh)→ Evidentemente, como Ansible funciona a través de SSH, deberemos tenerlo activado en nuestros ESXi. Con este role deshabitaremos los warnings que aparecen a nivel de vCenter a parte de configurar el daemon para que arranque automáticamente al arrancar el servidor.

[ESXi_dns](https://galaxy.ansible.com/miquelMariano/ESXi_dns)→ Configura los servidores DNS, y el dominio de búsqueda por defecto

[ESXi_ipv6](https://galaxy.ansible.com/miquelMariano/ESXi_ipv6)→ Deshabilita ipv6.

[ESXi_ntp](https://galaxy.ansible.com/miquelMariano/ESXi_ntp_config)→ Configura los servidores NTP y configura el daemon para que arranque automáticamente al arrancar el servidor.

[ESXi_syslog](https://galaxy.ansible.com/miquelMariano/ESXi_syslog)→ Configura en envío de logs a un servidor syslog remoto a parte de guardar los logs en un datastore local.

Un abrazo saludo!

Miquel.

