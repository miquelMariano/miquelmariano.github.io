---
title: Creando un entorno JMP con VMware Horizon - Parte 13 - Crear nuestro primer App Stack
date: '2020-04-08 00:00:00'
layout: post
image: /assets/images/posts/2019/07/horizon-logo.png
tag:
- vmware
- horizon
- vexpert
- euc
- desktop
- mobility
permalink: /jmp-part13/

---

Si habéis seguido la serie con atención, en este punto ya tendréis [instalado]({{ site.url }}/jmp-part11/) y [configurado]({{ site.url }}/jmp-part12/) vuestro entorno con App Volumes.

- [Part 1: Introducción]({{ site.url }}/jmp-part1/)
- [Part 2: Preparar servidor SQL]({{ site.url }}/jmp-part2/)
- [Part 3: Preparar Active Directory]({{ site.url }}/jmp-part3/)
- [Part 4: Instalación y configuración Connection Server]({{ site.url }}/jmp-part4/)
- [Part 5: Instalación y configuración Replica Server (opcional)]({{ site.url }}/jmp-part5/)
- [Part 6: Instalación y configuración de UAG (opcional)]({{ site.url }}/jmp-part6/)
- [Part 7: Configuración de UAG en HA]({{ site.url }}/jmp-part7/)
- [Part 8: Instalación certificado (opcional)]({{ site.url }}/jmp-part8/)
- [Part 9: Preparar plantilla master para Instant Clone]({{ site.url }}/jmp-part9/)
- [Part 10: Configurar un pool de Instant Clone]({{ site.url }}/jmp-part10/)
- [Part 11: Instalar App Volumes]({{ site.url }}/jmp-part11/)
- [Part 12: Configuración inicial App Volumes]({{ site.url }}/jmp-part12/)
- [Part 13: Crear nuestro primer App Stack]({{ site.url }}/jmp-part13/)
- [Part 14: Trabajando con Writable Volumes]({{ site.url }}/jmp-part14/)
- [Part 15: Instalación Dynamic Environment Manager]({{ site.url }}/jmp-part15/)
- [Part 16: Primeros pasos con DEM]({{ site.url }}/jmp-part16/)

Es el momento ahora de ver cómo se crea nuestro primer AppStack.

Un AppStack es un disco, generalmente un .vmdk, de sólo lectura que contiene una o múltiples aplicaciones ya instaladas. Estos AppStack los podremos asignar a usuarios, unidades organizativas (OU), cuantas de equipo, etc, etc.. con el fin de permitir la entrega y uso de estas aplicaciones a nuestros usuarios finales.

Es posible combinar diferentes aplicaciones en un mismo AppStack, lo que nos permitirá agrupar, por ejemplo, las aplicaciones "core" de nuestra empresa y distribuirlas conjuntamente.

![appstack00]({{ site.imagesposts2020 }}/04/appstack00.png){: .align-center}

Una vez tengamos creados los AppStack, se montarán en modo sólo lectura y serán compartidos entre los escritorios de nuestros usuarios dentro del datacenter.

Vamos al lio!

#	Creación de nuestro primer App Stack

Al entrar en nuestro App Volumes Manager, nos dirigiremos en la pestaña "Volumes" > "AppStacks" y pulsaremos sobre el botón "Create"

![appstack1]({{ site.imagesposts2020 }}/04/appstack1.png){: .align-center}

Se nos abrirá el menú de creación, en dónde especificaremos los siguientes parámetros:

Name: Nombre descriptivo del AppStack
Storage: Se refiere al datastore en dónde se guardará el disco .vmdk con las aplicaciones instaladas
Path: Hace referencia a la ruta dentro del datastore previamente seleccionado
Template: La plantilla en la que se basará el nuevo .vmdk que crearemos. La plantilla por defecto es de 20Gb y será suficiente para la gran mayoria de aplicaciones.
Description: Por si queremos poner una descripción

![appstack2]({{ site.imagesposts2020 }}/04/appstack2.png){: .align-center}

![appstack3]({{ site.imagesposts2020 }}/04/appstack3.png){: .align-center}

Cuando tengamos nuestro AppStack creado, podremos empezar con el aprovisionamiento de aplicaciones:

![appstack4]({{ site.imagesposts2020 }}/04/appstack4.png){: .align-center}

Deberemos de seleccionar un equipo, que tenga App Volumes Agent instalado. En este caso, tengo disponibles varios escritorios Instant Clone que me irán de lujo para poder provisionar, ya que al ser volátiles, una vez finalizado el proceso se podrán destruir sin mayor problema.

![appstack5]({{ site.imagesposts2020 }}/04/appstack5.png){: .align-center}

![appstack6]({{ site.imagesposts2020 }}/04/appstack6.png){: .align-center}

Si entramos en nuestra VM que hemos seleccionado para provisionar, nos aparecerá un pop-up indicando que estamos en modo aprovisionamiento.

Ojo, no pulsar en "Aceptar", ahora es el momento de instalar todas nuestras aplicaciones que queramos "capturar"

![appstack7]({{ site.imagesposts2020 }}/04/appstack7.png){: .align-center}

Tras instalar todas las aplicaciones, en mi caso Notepad++, será el momento de pulsar en el botón de "Aceptar"

Empezará el proceso de analizar todos los cambios que ha habido en el sistema y finalmente nos pedirá un reinicio.

![appstack8]({{ site.imagesposts2020 }}/04/appstack8.png){: .align-center}
![appstack9]({{ site.imagesposts2020 }}/04/appstack9.png){: .align-center}
![appstack10]({{ site.imagesposts2020 }}/04/appstack10.png){: .align-center}

Tras el reinicio, nos aparecerá otro pop-up indicando que el aprovisionamiento se ha completado satisfactoriamente. Pulsaremos en "Aceptar" y desde el App Volumes Manager, completaremos el proceso

![appstack11]({{ site.imagesposts2020 }}/04/appstack11.png){: .align-center}
![appstack12]({{ site.imagesposts2020 }}/04/appstack12.png){: .align-center}
![appstack13]({{ site.imagesposts2020 }}/04/appstack13.png){: .align-center}

Y listo, ya tenemos nuestro primer App Stack listo para assignarlo a nuestros usuarios.

![appstack14]({{ site.imagesposts2020 }}/04/appstack14.png){: .align-center}

#	Asignación de usuarios

Es una buena práctica, que la gestión de asignaciones se haga a través de nuestro directorio activo. En mi caso, he creado unos grupos en mi dominio con nombre ***g_appstack_xxx***. De esta manera con sólo asignar usuarios a estos grupos, automáticamente ya podrán acceder a las aplicaciones.

![appstack15]({{ site.imagesposts2020 }}/04/appstack15.png){: .align-center}

Y por fin, así verán nuestros usuarios las aplicaciones en su VDI

![appstack16]({{ site.imagesposts2020 }}/04/appstack16.png){: .align-center}

Podemos ver cómo aparece el icono de Notepad++ en el escritorio, incluso en programas y características aparece cómo un programa mas.
En el administrador de discos podemos ver un nuevo disco, que corresponde al AppStack, pero sin embargo no se monta cómo una una unidad más y es totalmente transparente para el usuario

Espero que os guste.

Un saludo!

Miquel.


