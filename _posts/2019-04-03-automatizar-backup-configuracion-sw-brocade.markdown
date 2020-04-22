---
title: Automatizar backup de la configuración en Brocade FC Switches
date: '2019-04-03 00:00:00'
layout: post
image: /assets/images/posts/2017/10/brocade-logo.png
headerImage: true
tag:
- backup
- brocade
- fabric
- san
- fc
---


Buenos días a tod@s!!!

Hace ya tiempo, os enseñé [cómo exportar vuestra configuración en switches FC Brocade](https://miquelmariano.github.io/2017/10/04/backup-configuracion-sw-brocade/)

En esta ocasión, quiero dar un paso más en esta tarea y automatizarla.

Para realizar un bakcup de un sw Brocade, ya lo vimos en su dia:

![brocade1]({{ site.imagesposts2019 }}/04/brocade1.png)

El problema que tiene este sistema de backup, es que es interactivo, es decir, un administrador debe ir completando los parámetros que el propio switch va preguntando.

Para saltarnos este handicap, tenemos el comando expect:

Expect es un programa que habla a otros programas a través de un script. Siguiendo este script, Expect sabe qué salida esperar del programa que ejecuta y responder en consecuencia y, si procede, es posible devolver el control al usuario o revocarlo.
Resulta muy útil para automatizar tareas repetitivas en sistemas, tanto de forma local como remota, que requieren introducir información manualmente, más aún cuando trabajamos con instrucciones y protocolos como SSH, SCP, SFTP, TELNET o RLOGIN.  
De igual modo, los despliegues de aplicaciones o componentes en máquinas remotas pueden ser gestionados con scripts de usuarios (init.d), que controlan los permisos y el acceso externo. Con Expect, la secuencia de comandos a introducir es fácilmente automatizable y los scripts simples también son fáciles de integrar en nuestro workflow.
Para equipos que deban administrar sistemas, instalando siempre los mismos programas o modificando configuraciones a través de la terminal, también resulta una opción a tener en cuenta, ya que se puede desarrollar un script que lance todos esos procesos de una sola vez.
{: .notice}

![expect]({{ site.imagesposts2019 }}/04/expect.png)

A continuacion teneis el script, que interpreta los parámetros que pregunta el SW para poder pasárselos correctamente:

```ssh
#!/usr/bin/expect

set swuser [lindex $argv 0]
set swpasswd [lindex $argv 1]
set swhost [lindex $argv 2]

set dstuser [lindex $argv 3]
set dstpasswd [lindex $argv 4]
set dsthost [lindex $argv 5]

set dstfile [lindex $argv 6]

#set file "$(date --date='-1 days' +%Y%m%d_$swhost.txt)"
set DATE [exec date "+%Y%m%d"]
set file $dstfile$swhost-$DATE.txt

spawn ssh -l $swuser $swhost
expect "password:"
send "$swpasswd\r"
expect "to proceed."
send "\003" #To send a "Ctrl-C" in Expect using its octal value, use the command "send \003" in your script.
expect ">"
send "configupload\r"
expect ": "
send "scp\r"
expect ": "
send "N\r"
expect ": "
send "$dsthost\r"
expect ": "
send "$dstuser\r"
expect ": "
send "$file\r"
expect ": "
send "all\r"
expect "password:"
send "$dstpasswd\r"
expect ">"
send "exit\r"
expect eof
```

Ya para finalizar, sólo nos quedará configurar un cron para ejecutar periodicamente el script y pasándole por parámetro todos los argumentos necesarios:

```ssh
35 10 * * * /home/backups_san_brocade/backup_san_brocade.sh admin password 10.245.58.19 root xorux4you 10.245.56.195 /home/backups_san_brocade/SWFC01.txt
40 10 * * * /home/backups_san_brocade/backup_san_brocade.sh admin password 10.245.58.20 root xorux4you 10.245.56.195 /home/backups_san_brocade/SWFC02.txt
```

Espero que os sea de utilidad.
Gracias por compartir

Un saludo

Miquel.





