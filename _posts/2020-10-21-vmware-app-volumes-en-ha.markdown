---
title: Configurar VMware App Volumes en HA (Alta disponibilidad)
date: '2020-10-21 00:00:00'
layout: post
image: /assets/images/posts/2019/07/horizon-logo.png
tag:
- vmware
- horizon
- vexpert
- euc
- desktop
- mobility
---

Hace ya varios meses, en la serie [Creando un entorno JMP con VMware Horizon]({{ site.url }}/jmp-part1/) vimos cómo hacer la configuración e instalación de [App Volumes]({{ site.url }}/jmp-part11/). En este post, veremos la configuración para dotar al sistema de HA y eliminar ese temido [SPOF](https://es.wikipedia.org/wiki/Single_point_of_failure)

Es lógico, que para montar nuestro App Volumes Manager en alta disponibilidad primeramente tengamos nuestra BBDD en un servidor independiente, fuera del propio App Volumes Manager. En [este post](https://miquelmariano.github.io/jmp-part11/) explicábamos la parte de nuestro servidor SQL.

El objetivo es tener una arquitectura similar a la representada en el siguiente esquema:

![appvolumes-diagram]({{ site.imagesposts2020 }}/10/appvolumes-diagram.png){: .align-center} 

# Instalación segundo App Volumes Manager

Iniciaremos la instalación de nuestro segundo manager de la misma manera que [instalamos el primero]({{ site.url }}/jmp-part11/)

![appvolumes-install-01]({{ site.imagesposts2020 }}/10/appvolumes-install-01.png){: .align-center} 
![appvolumes-install-02]({{ site.imagesposts2020 }}/10/appvolumes-install-02.png){: .align-center}

Utilizaremos la misma BBDD que ya tenemos instalanda. Es importante que la opción de "overwrite" esté desmarcada y si estamos utilizando certificados autofirmados, también desmarcar el segundo check. 
![appvolumes-install-03]({{ site.imagesposts2020 }}/10/appvolumes-install-03.png){: .align-center} 
![appvolumes-install-04]({{ site.imagesposts2020 }}/10/appvolumes-install-04.png){: .align-center} 
![appvolumes-install-05]({{ site.imagesposts2020 }}/10/appvolumes-install-05.png){: .align-center} 
![appvolumes-install-06]({{ site.imagesposts2020 }}/10/appvolumes-install-06.png){: .align-center} 
![appvolumes-install-07]({{ site.imagesposts2020 }}/10/appvolumes-install-07.png){: .align-center} 
![appvolumes-install-08]({{ site.imagesposts2020 }}/10/appvolumes-install-08.png){: .align-center}

Tras finalizar la instalación, si nos conectamos al portal de administración, en el apartado de Configuration > Managers, veremos que el segundo servidor aparece en estado "Unregistered" 
![appvolumes-install-09]({{ site.imagesposts2020 }}/10/appvolumes-install-09.png){: .align-center} 

Para registrarlo, iniciaremos sesión en el portal de administración desde el servidor que acabamos de instalar y nos aparecerá el wizard de registro que tendremos que seguir
![appvolumes-install-10]({{ site.imagesposts2020 }}/10/appvolumes-install-10.png){: .align-center} 
![appvolumes-install-11]({{ site.imagesposts2020 }}/10/appvolumes-install-11.png){: .align-center} 

Una vez finalizado el registro, ya nos aparecerá correctamente registrado en el apartado de "Managers"
![appvolumes-install-12]({{ site.imagesposts2020 }}/10/appvolumes-install-12.png){: .align-center} 

# Configurar NLB

Si en nuestro entorno no tenemos ningún balanceador enterprise, tipo F5 o similar, os recomiendo utilizar el propio servicio de Windows NLB (Net Load Balancer)

En [este post](https://miquelmariano.github.io/jmp-part5/) explicaba como instalar la cararterística de windows y su configuración inicial.

Tras finalizar con la configuración, deberiamos tener un escenario similar a este:

![appvolumes-install-13]({{ site.imagesposts2020 }}/10/appvolumes-install-13.png){: .align-center} 

# Reconfigurar App Volumes Agent

Para finalizar, y para utilizar el balanceo de carga y el HA que hemos configurado en los App Volumes Managers, será necesario reconfigurar el agente.

Para ello, deberemos editar nuestra plantilla maestra y editar la siguiente clave de registro:

`HKLM\System\CurrentControlSet\services\svservice\parameters`

Por defecto nos aparecerá la clave Manager1, la cual configuraremos la virtual IP del balanceador.

No seria necesario configurar mas managers, pero a mi me gusta dejar también configurados las IPs de cada uno de los servidores por si en algún momento el balanceador deja de funcionar

![appvolumes-install-14]({{ site.imagesposts2020 }}/10/appvolumes-install-14.png){: .align-center} 

Y hasta aquí por hoy. Espero que os sirva ;-)

Un saludo!

Miquel.


