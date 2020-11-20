---
title: Creando un entorno JMP con VMware Horizon - Parte 10 - Configurar un pool de Instant Clone
date: '2019-10-23 00:00:00'
layout: post
image: /assets/images/posts/2019/07/horizon-logo.png
tag:
- vmware
- horizon
- vexpert
- euc
- desktop
- mobility
permalink: /jmp-part10/

---

Buenos días a tod@s!!

En la siguiente serie de posts, pretendo explicar durante las próximas semanas el paso a paso para instalar un entorno JMP (Just-in-Time Management Platform) utilizando VMware Horizon 7 Instant Clones + App Volumes + VMware UEM (User Environment Manager) 

- [Part 1: Introducción]({{ site.url }}/jmp-part1/)
- [Part 2: Preparar servidor SQL]({{ site.url }}/jmp-part2/)
- [Part 3: Preparar Active Directory]({{ site.url }}/jmp-part3/)
- [Part 4: Instalación y configuración Connection Server]({{ site.url }}/jmp-part4/)
- [Part 5: Instalación y configuración Replica Server (opcional)]({{ site.url }}/jmp-part5/)
- [Part 6: Instalación y configuración de UAG (opcional)]({{ site.url }}/jmp-part6/)
- [Part 7: Configuración de UAG en HA]({{ site.url }}/jmp-part7/)
- Part 8: Instalación certificado (opcional)
- [Part 9: Preparar plantilla master para Instant Clone]({{ site.url }}/jmp-part9/)
- [Part 10: Configurar un pool de Instant Clone]({{ site.url }}/jmp-part10/)
- [Part 11: Instalar App Volumes]({{ site.url }}/jmp-part11/)
- [Part 12: Configuración inicial App Volumes]({{ site.url }}/jmp-part12/)
- [Part 13: Crear nuestro primer App Stack]({{ site.url }}/jmp-part13/)
- [Part 14: Trabajando con Writable Volumes]({{ site.url }}/jmp-part14/)
- [Part 15: Instalación Dynamic Environment Manager]({{ site.url }}/jmp-part15/)
- Part 16: Primeros pasos con DEM

# Tecnología Instant clone

Antes de empezar a ver cómo crear un pool de Instant Clone, me gustaria hacer un pequeño inciso en qué es y cómo funciona esta tecnología de Instant Clone.

Mi amigo [Ricard Ibañez](https://www.cenabit.com/) escribió un fantástico capítulo en le libro [#VmwarePorvExperts](https://miquelmariano.github.io/vmwareporvexperts/) dónde explica con detalle esta tecnología. Os animo a que le echeis un vistazo.

**Instant Clone.** La tecnología Instant Clone es muy parecida en concepto a Linked Clone, pero con una operativa totalmente distinta. Así como Linked Clone opera a nivel de disco y mantiene un disco en cada escritorio virtual con los datos diferenciales respecto a la VM Réplica, Instant Clone genera en cada escritorio virtual, un disco diferencial y una memoria RAM diferencial respecto a una VM Parent, que se aprovisiona para cada uno de los nodos ESXi y se mantiene encendida.

![ic01]({{ site.imagesposts2019 }}/10/ic01.png){: .align-center}

Esta tecnología no permite mantener ningún dato del escritorio virtual de manera persistente, de este modo, cuando el usuario cierra la sesión o reinicia el escritorio, este, se destruye y se genera de nuevo en el mismo estado que la VM Parent.
Instant Clone genera varias VM en el proceso de aprovisionamiento del Pool, por lo que necesitamos una VM Base con un Snapshot del estado que vamos a aprovisionar. Luego se generará una plantilla, para todo el Pool, del estado de nuestra VM Base con el Snapshot y seguidamente una VM Réplica en cada uno de los Datastores asignados al Pool. Estas VM Réplica serán la que generará las VM Parent en cada uno de los nodos ESXi y en cada Datastore asignado al Pool. Las VM Parent están siempre encendidas y son las encargadas de compartir tanto el disco como la memoria para generar los escritorios virtuales y aprovisionarlos en muy pocos minutos.

![ic02]({{ site.imagesposts2019 }}/10/ic02.png){: .align-center}

# Configurar un pool de Instant Clone

Para arrancar con el proceso de creación de nuestro pool de Instant clone, lo primero que haremos es conectarnos a nuestro [connection server]({{ site.url }}/jmp-part4/)

Nos dirigiremos en el menú izquierdo "Grupos de escritorio" > "Agregar"

![pool-ic01]({{ site.imagesposts2019 }}/10/pool-ic01.png){: .align-center}

Seleccionaremos "Grupo de escritorio automatizado"

![pool-ic02]({{ site.imagesposts2019 }}/10/pool-ic02.png){: .align-center}

Seleccionaremos el tipo de asignación de usuarios "Flotante" para no generar ninguna relación estática entre usuario y escritorio. Los escritorios se irán asignando así como los usuarios los vayan solicitando y de manera aleatoria.

![pool-ic03]({{ site.imagesposts2019 }}/10/pool-ic03.png){: .align-center}

Como estamos creando un pool de Instant Clone, seleccionaremos esta tecnología en la siguiente ventana del wizard.

![pool-ic04]({{ site.imagesposts2019 }}/10/pool-ic04.png){: .align-center}

Deberemos poner un identificador al pool y un nombre que será el que los usuarios vean al conectarse. Hay que tener el cuenta que el identificador debe ser único, y no podrá cambiarse una vez creado el pool. El nombre para mostrar, si que se podrá cambiar a posteriori.

![pool-ic05]({{ site.imagesposts2019 }}/10/pool-ic05.png){: .align-center}

De las opciones de configuración que se muestran a continuación, dependerá de cada entorno, el poner una opción u otra. Para este laboratorio me he decantado por las siguientes:

![pool-ic06]({{ site.imagesposts2019 }}/10/pool-ic06.png){: .align-center}
![pool-ic07]({{ site.imagesposts2019 }}/10/pool-ic07.png){: .align-center}

En nuestro caso, al no tener vSAN no marcaremos esta opción.

![pool-ic08]({{ site.imagesposts2019 }}/10/pool-ic08.png){: .align-center}

Configuración de nuestro vCenter. En este punto, le indicaremos al pool, las opciones básicas a nivel de vCenter cómo nombre de la [plantilla master]({{ site.url }}/jmp-part9/), snapshot, carpeta dónde ubicar los escritorios, cluster vSphere, datastores, etc etc...

![pool-ic09]({{ site.imagesposts2019 }}/10/pool-ic09.png){: .align-center}

En este punto, seleccionaremos el dominio y la OU al cual van a pertenecer los escritorios que se desplieguen en este pool.

![pool-ic10]({{ site.imagesposts2019 }}/10/pool-ic10.png){: .align-center}

A continuación se nos muestra un pequeño resumen de todas las opciones que hemos ido configurando a lo largo del wizard y también podremos marcar el check para asignar los permisos a los diferentes usuarios que van a tener que conectarse a este pool.

![pool-ic11]({{ site.imagesposts2019 }}/10/pool-ic11.png){: .align-center}

En caso de no marcar el check anteriormente indicado, desde las propias opciones del pool, podremos entrar en "Autorizaciones" para así autorizar a nuestros usuarios de Active Directory conectarse a nuestro pool.

![pool-ic12]({{ site.imagesposts2019 }}/10/pool-ic12.png){: .align-center}

Tras finalizar todo el proceso, veremos que empiezan a desplegarse escritorios y aparecen en la carpeta correspondiente en nuestro vCenter

![pool-ic13]({{ site.imagesposts2019 }}/10/pool-ic13.png){: .align-center}

![pool-ic14]({{ site.imagesposts2019 }}/10/pool-ic14.png){: .align-center}


# Acceso a nuestra infraestructura VDI

Para que nuestros usuarios puedan acceder a nuestra plataforma VDI, necesitaremos de un cliente. Este cliente puede ser mediante un navegador web o instalando un cliente pesado en nuestro equipo.

## Mediante cliente HTML

Para poder utilizar este acceso, el pool debe estár configurado esplicitamente, os acordais de esta vendana?

Será necesario habilitar el acceso HTML en la configuración del pool.

![pool-ic15]({{ site.imagesposts2019 }}/10/pool-ic15.png){: .align-center}

Accederemos con un navegador web a nuestro [connection server]({{ site.url }}/jmp-part4/) y accedemos al portal HTML:

![pool-ic16]({{ site.imagesposts2019 }}/10/pool-ic16.png){: .align-center}

Accederemos con las credenciales de dominio de algún usuario autorizado a utilizar el Pool

![pool-ic17]({{ site.imagesposts2019 }}/10/pool-ic17.png){: .align-center}

En el workspace, nos aparecerán los pools a los cuales tenemos acceso. En este caso, solo al que acabamos de crear:

![pool-ic18]({{ site.imagesposts2019 }}/10/pool-ic18.png){: .align-center}

Una vez accedamos al pool, tendremos nuestro windows completamente funcional:

![pool-ic19]({{ site.imagesposts2019 }}/10/pool-ic19.png){: .align-center}


## Mediante Horizon Client

El Horizon Client, es un cliente pesado que se puede instalar tanto en Windows, Linux o Mac y nos sirve para conectarnos a nuestros escritorios VDI.

El procedimiento es igual que el acceso mediante cliente HTML:

![pool-ic20]({{ site.imagesposts2019 }}/10/pool-ic20.png){: .align-center}

![pool-ic21]({{ site.imagesposts2019 }}/10/pool-ic21.png){: .align-center}

![pool-ic22]({{ site.imagesposts2019 }}/10/pool-ic22.png){: .align-center}

Espero que os sirva.

Nos vemos en el próximo post: [Part 11: Instalar App Volumes]({{ site.url }}/jmp-part11/)

Un saludo!

Miquel.


