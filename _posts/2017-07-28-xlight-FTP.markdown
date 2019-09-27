---
title: Xlight, un servidor FTP portable
date: '2017-07-28 00:00:00'
layout: post
image: /assets/images/posts/2017/08/ftplogo.png
headerImage: true
tag:
- windows
- devops
- ftp
category: blog
author: miquelMariano
description: Xlight, un servidor FTP portable
hidden: false
comments: true
---

Buenos días queridos lectores!!

En el post de hoy voy a enseñaros una pequeña utilidad que me ha venido como anillo al dedo en alguna que otra ocasión.

¿Cuántas veces no habéis necesitado de un servidor FTP para realizar alguna tarea sobre vuestra infraestructura? 

Actualizar algún firmware en nuestros servidores, extraer algún tipo de report de alguna aplicación o realizar un backup de la configuración son escenarios habituales en los que necesitamos un servidor FTP

Pues bien, con [Xlight](https://www.xlightftpd.com/) podremos tener ese ansiado FTP server sin tener que instalar nada en ningún servidor y de manera "portable"

Desde su propia web, podremos descargar el binario, ya sea en formato [32 bits](http://www.xftpserver.com/download/xlight.zip) o en [64 bits](http://www.xftpserver.com/download/xlight-x64.zip)

Y la configuración es de lo mas sencillo:

1) Ejecutamos el binario y creamos un nuevo virtual server

![ftp1]({{ site.imagesposts2017 }}/08/ftp1.png)

2) Arrancamos en nuevo virtual server

![ftp2]({{ site.imagesposts2017 }}/08/ftp2.png)
![ftp3]({{ site.imagesposts2017 }}/08/ftp3.png)

3) Crearemos un usuario para ese virtual server y listo.

![ftp4]({{ site.imagesposts2017 }}/08/ftp4.png)

Por supuesto que la aplicación tiene muchas mas opciones y configuraciones avanzadas, pero para levantar un FTP server de manera temporal en un momento dado, estas pequeñas configuraciones serán mas que suficientes.

Espero que os sea de utilidad :)

Un saludo!



Miquel.