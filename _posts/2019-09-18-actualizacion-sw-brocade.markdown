---
title: Actualización de firmware en switches Brocade FC
date: '2017-09-18 00:00:00'
layout: post
image: /assets/images/posts/2017/10/brocade-logo.png
tag:
- firmware
- brocade
- fabric
- san
- fc
---

Buenos días a tod@s!!!

En el post de hoy veremos cómo realizar una actualización de firmware en nuestros switches Brocade de nuestra SAN.

**IMPORTANTE** Hay que tener en cuenta que cualquier actualización de firmware en cualquier dispositivo en general es una operación que debe realizarse por personal cualificado. En el caso de nuestra SAN, una mala planificación en el proceso de actualización (no seguir el orden correcto, no comprobar la compatibilidad de nuestros dispositivos...) podría generar problemas graves en el acceso al almacenamiento, incluso provocar disrupción de servicio.
{: .notice}

Como comentaba anteriormente, la actualización de firmware debe realizarse por personal cualificado, y en cualquier caso, [hacer un backup de la configuración antes de comenzar](https://miquelmariano.github.io/2017/10/backup-configuracion-sw-brocade)

# Preparar repositorio FTP con el firmware

La mejor opción para cargar el firmware en los switches es hacerlo por FTP, de esta manera nos evitamos el desplazamiento para tener que poner un USB (que es otra forma de cargar el firmware)

Hace tiempo, [publiqué un post para montar un pequeño FTP portable](https://miquelmariano.github.io/2017/07/xlight-FTP). Es el momento de ponerlo en práctica :-)

![ftp1]({{ site.imagesposts2019 }}/09/ftp1.png){: .align-center}

![ftp2]({{ site.imagesposts2019 }}/09/ftp2.png){: .align-center}

# Actualización de firmware

**IMPORTANTE** Antes de empezar con la actualización, hay que leerse las RELEASE NOTES de cada versión para ver la correcta compatibilidad con nuestro dispositivo y sobretodo el "update path" a seguir. El muy probable que tengamos que dar varios saltos antes de llegar a la versión definitiva que queremos dejar. Como norma básica, deberemos ir a la versión última de cada sub­familia para pasar a la primera de la familia siguiente.
{: .notice}

El comando que utilizaremos para hacer la actualización es `firmwaredownload`. Con este comando, se nos abrirá un wizard que deberemos de ir completando con los datos de nuestro FTP que hemos preparado anteriormente:

![firmware1]({{ site.imagesposts2019 }}/09/firmware1.png){: .align-center}

Cuando el firmware esté descargado y comprobado, deberemos confirmar la instalación:

![firmware2]({{ site.imagesposts2019 }}/09/firmware2.png){: .align-center}

El proceso tardará unos minutos y al finalizar, nos reiniciará la sesión:

![firmware3]({{ site.imagesposts2019 }}/09/firmware3.png){: .align-center}

El reboot hace referencia a la parte de administración, SSH, telnet, GUI java... El acceso a dato y el IO de los servidores no se pierde
{: .notice}

Con el comando `firmwareshow` podremos ver la versión de cada "partición" del Switch. Como se ve en la imagen, la partición primaria ya está actualizada y está en proceso la secundaria.

![firmware4]({{ site.imagesposts2019 }}/09/firmware4.png){: .align-center}

También disponemos del comando `firmwaredownloadstatus` que nos dará información de todo el proceso de actualización:

![firmware5]({{ site.imagesposts2019 }}/09/firmware5.png){: .align-center}

Al finalizar todo el proceso, ambas particiones deberían estar a la misma versión.

![firmware6]({{ site.imagesposts2019 }}/09/firmware6.png){: .align-center}


Espero que os sea de utilidad.
Gracias por compartir

Un saludo

Miquel.



