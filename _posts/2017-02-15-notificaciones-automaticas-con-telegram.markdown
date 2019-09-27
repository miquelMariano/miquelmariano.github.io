---
title: Notificaciones automáticas con Telegram
layout: post
date: 2017-02-15 00:00
image: /assets/images/posts/2017/02/logo_telegram.png
headerImage: true
tag:
- telegram
- automation
- devops
---

Buenos días a tod@s!

Hoy os vengo a contar una de las funcionalidades  que mas me ha llamado la atención de Telegram.
Como sabeis, Telegram es un sistema de mensajería instantánea, muy similar a WatsApp, pero con algunas funcionalidades extra, por ejemplo los bots.
[Transcribiendo de la Wikipedia](https://es.wikipedia.org/wiki/Bot), un bot es un programa informático, imitando el comportamiento de un humano. Pues bien, vamos a crear uno de esos bots para que nos envíe notificaciones de nuestra infraestructura. Cualquier "cosa" que sea capaz de invocar una URL será capaz de enviarnos notificaciones via Telegram.

Vamos al lío!
Lo primero que necesitaremos es "hacernos amigo" del gran BotFather, es el bot que pone Telegram a disposición de los usuarios para crear otros bot.

![bf01]({{ site.imagesposts2017 }}/02/bf01.png)

![bf02]({{ site.imagesposts2017 }}/02/bf02.png)


Con el comando `/newbot` arrancaremos el asistente de creación que nos guiará paso a paso

![bf03]({{ site.imagesposts2017 }}/02/bf03.png)

![bf04]({{ site.imagesposts2017 }}/02/bf04.png)

![bf05]({{ site.imagesposts2017 }}/02/bf05.png)


Una vez finalizado, BotFather nos dará un token único con el que podremos acceder vía HTTP a la API de nuestro nuevo bot. Recordemos los datos...

```
Bot name: Notificaciones Infraestructura
Username: @notificacionesinfraestructurabot
Token: 304017237:AAHpKXZBaw_wOF3H-ryhWl3F3wqIVP_Zqf8
URL API: https://api.telegram.org/bot{token}
```

Con la siguiente URL `/getUpdates` podremos ver si nuestro bot está up & ready
 
`https://api.telegram.org/bot304017237:AAHpKXZBaw_wOF3H-ryhWl3F3wqIVP_Zqf8/getUpdates`

El resultado deberia ser algo similar a este:

```
{"ok":true,"result":[]}
```

De la misma forma que inicialmente hemos buscado el BotFather, ahora podremos encontrar nuestro bot en la búsqueda global e iniciar un chat con él

![bf06]({{ site.imagesposts2017 }}/02/bf06.png)

![bf06]({{ site.imagesposts2017 }}/02/bf07.png)

![bf08]({{ site.imagesposts2017 }}/02/bf08.png)

En cuanto tengamos un chat abierto con nuestro bot, la información del `/getUpdates` cambiará
Recordad:  

`https://api.telegram.org/bot304017237:AAHpKXZBaw_wOF3H-ryhWl3F3wqIVP_Zqf8/getUpdates`
 
La información será similar a esta, y lo mas importante es el ID del chat, en mi caso **6343788**
 
```
{"message_id":2,"from":{"id":6343788,"first_name":"Miquel","last_name":"Mariano","username":"miquelMariano"},"chat":{"id":6343788,"first_name":"Miquel","last_name":"Mariano","username":"miquelMariano","type":"private"},"date":1485939966,"text":"/start","entities":[{"type":"bot_command","offset":0,"length":6}]}}]}
```

Con la información del token y la del chat_id, ya estaremos en disposición de invocar a nuestro bot vía http, por ejemplo:

`https://api.telegram.org/bot304017237:AAHpKXZBaw_wOF3H-ryhWl3F3wqIVP_Zqf8/sendMessage?chat_id=6343788&text=Hello+World`

El resultado de la API será algo similar a esto:

```
{"ok":true,"result":{"message_id":4,"from":{"id":304017237,"first_name":"Notificaciones infraestructura","username":"notificacionesinfraestructurabot"},"chat":{"id":6343788,"first_name":"Miquel","last_name":"Mariano","username":"miquelMariano","type":"private"},"date":1485940456,"text":"Hello World"}}
```

Y en nuestro chat, tendremos el mensaje de nuestro bot :)

![bf09]({{ site.imagesposts2017 }}/02/bf09.png)

Por cierto, que casi se me olvida, a parte de crear nuevos bots, el BotFather nos puede ayudar a customizar nuestros bots, como por ejemplo, asignándoles una imagen de perfil
 
![bf10]({{ site.imagesposts2017 }}/02/bf10.png)
 
Y ya tendríamos foto de perfil para nuestro bot :)
 
![bf11]({{ site.imagesposts2017 }}/02/bf11.png) 
 
Con todo esto, ya queda a la imaginación de cada uno ver que uso le podemos dar a nuestro bot. 
Por ejemplo, los usos mas comunes que yo le estoy dando son:

- Alertas del sistema de monitorización (PRTG, Zabbix, Nagios)
- Alertas del propio vCenter
- Scripts que se ejecutan periodicamente en nuestro crontab y/o tareas programadas de windows
- ...

¿Y a vosotros, que utilidad se os ocurre?
 
Un saludo

Miquel.