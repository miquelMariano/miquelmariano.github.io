---
title: Modificar perfil predeterminado en Windows 10 para entornos VDI VMware Horizon
date: '2022-02-22 00:00:00'
layout: post
image: /assets/images/posts/2018/12/ssh-banner.jpg
tag:
- euc
- horizon
- vdi
- vexpert
- windows 10
---

El post de hoy va a ser muy breve, pero os voy a enseñar una pequeña herramienta muy útil para los que trabajamos en entornos VDI o entornos de escritorio en general.

Se trata de una pequeña utilidad que nos va a servir para modificar el perfil predeterminado en Windows 10 para que todos nuestros usuarios partan de una misma configuración pre establecida al iniciar sesión por primera vez en nuestros escritorios.

Se llama **Docu ForensiT** y se puede descargar fácilmente y sin registros desde [aquí](https://www.forensit.com/support-downloads.html)

Inicialmente, crearemos un usuario en la [plantilla VDI](https://miquelmariano.github.io/jmp-part9/), que nos servirá para hacer toda la configuración que queremos hacer predeterminada y aplicar en todos nuestros usuarios.

![default-profile-00]({{ site.imagesposts2022 }}/02/default-profile-00.png){: .align-center}

En mi caso, a este usuario le he cambiado el fondo de escritorio, le he puesto una serie de iconos y accesos directos tanto en el escritorio como en la barra de tareas

![default-profile-01]({{ site.imagesposts2022 }}/02/default-profile-01.png){: .align-center}

Una vez tengamos al usuario predeterminado completamente configurado a nuestro gusto y necesidad, cerraremos la sesión e iniciaremos con el usuario administrador local.
Ejecutaremos un cmd como administrador y la utilidad defprof.exe con el usuario que queramos hacer predeterminado.

![default-profile-02]({{ site.imagesposts2022 }}/02/default-profile-02.png){: .align-center}

Una vez tengamos ya el perfil predeterminado a partir del usuario que hemos configurado, todos los perfiles que se creen tendrán la configuración pre establecida.

![default-profile-03]({{ site.imagesposts2022 }}/02/default-profile-03.png){: .align-center}

¿Qué os parece?

Espero que os guste ;-)

Saludos!

Miquel.


