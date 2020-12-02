---
title: Creando un entorno JMP con VMware Horizon - Parte 16 - Primeros pasos con DEM
date: '2020-12-02 00:00:00'
layout: post
image: /assets/images/posts/2019/07/horizon-logo.png
tag:
- vmware
- horizon
- vexpert
- euc
- desktop
- mobility
permalink: /jmp-part16/
---

Tras mas de 1 año desde la [primera entrada]({{ site.url }}/jmp-part1/) de esta serie, hoy vamos a ver la última entrega de cómo configurar cuales son los primeros pasos en nuestro entorno DEM. Os dejo aquí el índice de toda la serie:

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
- [Part 16: Primeros pasos con DEM]({{ site.url }}/jmp-part16/)

# Instalación Dynamic Environment Manager console

Para poder administrar nuestro entorno DEM, lo primero que haremos será instalar la "Management Console".
El instalador para la management console es el mismo que utilizamos para instalar el agente en el [post anterior]({{ site.url }}/jmp-part15/).

![dem-primeros-pasos-00]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-00.png){: .align-center}
![dem-primeros-pasos-01]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-01.png){: .align-center}
![dem-primeros-pasos-02]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-02.png){: .align-center}
![dem-primeros-pasos-03]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-03.png){: .align-center}
![dem-primeros-pasos-04]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-04.png){: .align-center}
![dem-primeros-pasos-05]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-05.png){: .align-center}
![dem-primeros-pasos-06]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-06.png){: .align-center}
![dem-primeros-pasos-06-1]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-06-1.png){: .align-center}

# Configuración inicial

Tras instalar la management console y ejecutarla por primera vez, lo primero que nos preguntará es una ruta UNC para guardar la configuración. Esta ruta, ya vimos cómo crearla y que permisos asignarle, también en el [post anterior]({{ site.url }}/jmp-part15/).

![dem-primeros-pasos-07]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-07.png){: .align-center}

Cómo en la ruta, inicialmente no hay ningún tipo de información, nos aparecerá la opción de "Easy Start", este botón, lo que hará es crear toda la estructura y ficheros necesarios para que DEM funcione.

![dem-primeros-pasos-08]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-08.png){: .align-center}
![dem-primeros-pasos-09]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-09.png){: .align-center}
![dem-primeros-pasos-10]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-10.png){: .align-center}

# Pestaña "Personalization"

En esta pestaña, aunque se llame Personalization, no podremos hacer ninguna customización. Este nombre, hace referencia a las posibles personalizaciones que el usuario pueda hacer en su entorno de trabajo y que debamos conservar.

Lo que vamos a poder configurar son los datos de personalización que queremos que sean persistentes de cara al usuario.
Esas configuraciónes que el usuario hará en sus aplicaciones y que queremos conservar una vez se volatilice el escritorio.

Veréis que hay muchas opciones y sub pestañas disponibles, no voy a explicar cada una de ellas, eso me lo reservo para otro post pas avanzado xD

La pestaña Import / Export es la que nos permitirá indicar que queremos que se exporte/importe cuando el usuario haga logoff/login.
Aquí, básicamente podremos configurar rutas del sistema de ficheros o ramas del registro que queramos conservar.

En la siguiente captura, os muestro por ejemplo la configuración para Adobe Reader. Podemos ver que con DEM se "capturan" 4 ramas del registro y el AppData de esta aplicación

![dem-primeros-pasos-11]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-11.png){: .align-center}

La parte buena de esto es que en la mayoria de casos no tendremos que customizar "a mano" nuestra aplicación.
VMware tiene una biblioteca pública, de la cual nos podremos descargar estas configuraciones sin tener que hacerlas manualmente.

Con el botón "Download Config Template" podremos conectarnos a este repositorio público y buscar la aplicación que necesitemos e importarla.

![dem-primeros-pasos-12]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-12.png){: .align-center}
![dem-primeros-pasos-13]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-13.png){: .align-center}
![dem-primeros-pasos-14]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-14.png){: .align-center}

# Pestaña User Environment

En esta pestaña, es dónde podremos empezar a hacer personalizaciones a nuestros usuarios.

* Mapeo de unidades de red
* Mapeo de impresoras
* Crear ficheros o carpetas
* Crear accesos directos
* Configurar scripts en el login o logof del usuario
* Etc. etc...

En el siguiente ejemplo, vemos cómo podemos crear un fichero txt en el escritorio de nuestros usuarios. Y como en el VDI aparece este fichero

![dem-primeros-pasos-15]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-15.png){: .align-center}
![dem-primeros-pasos-16]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-16.png){: .align-center}

También vemos cómo he podido crear un acceso directo en el escritorio para que los usaurios fácilmente puedan cerrar sesión en sus VDIs

![dem-primeros-pasos-17]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-17.png){: .align-center}
![dem-primeros-pasos-18]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-18.png){: .align-center}

# Pestaña Computer Environment

Esta pestaña es relativamente nueva, y lo que nos permite es hacer configuraciones no solo en los usuarios, sinó también en sus equipos.
Está basado en políticas y sus correspondientes plantillas, por lo que inicialmente nos tendremos que descargar estas .admx

Con el botón "Manage Templates", podremos indicarle a DEM en que carpeta están las plantillas .admx que posteriormente usaremos

![dem-primeros-pasos-19]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-19.png){: .align-center}

Y ya podremos crear una nueva política con DEM

![dem-primeros-pasos-20]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-20.png){: .align-center}

Una vez seleccionadas las categorias, ya podremos editar la política con un editor muy similar al que estamos acostumbrados a utilizar, solo que en esta ocasión, solo nos mostrará las opciones disponibles en las categorias seleccionadas.

![dem-primeros-pasos-21]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-21.png){: .align-center}

# Pestaña Condition Sets

Es una parte muy importante de DEM, ya que nos permitirá configurar condiciones a cada una de las configuraciones disponibles.

Es obvio que no todos los usuarios van a ser iguales y que por lo tanto, cada uno tendrá su propio entorno de trabajo y sus configuraciones. 

Con los "condition sets" podremos conseguir este comportamiento diferente dependiendo de una condición.

Existes muchas condiciones que podemos utilizar, las mas comunes:

* Filtrar por atributo en nuestro AD
* Filtrar por grupo de AD
* Filtrar por nombre de usuario
* Filtrar por OU
* Filtrar por IP
* etc, etc...

![dem-primeros-pasos-22]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-22.png){: .align-center}

Os abréis dado cuenta de que no existe ninguna condición que nos permita filtrar por usuario. Para ello, utilizaremos la condición "Environment Variable" y la variable "username", de esta forma podremos filtrar por nombre de usuario.

![dem-primeros-pasos-23]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-23.png){: .align-center}

Como comentaba, estas condiciones se pueden aplicar en casi todos los objetos, así que nos facilita mucho el trabajo a la hora de tener diferentes configuraciones en funcion al usuario o departamento de nuestra empresa.

![dem-primeros-pasos-24]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-24.png){: .align-center}
![dem-primeros-pasos-25]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-25.png){: .align-center}

# Pestaña Application Migration

Con "Aplication Migration" lo que vamos a poder hacer es migrar la configuración de una aplicación a otra. No es muy común utilizar esta opción, pero si tenemos aplicaciones muy complejas y que tengan mucha configuración, con esta opción podriamos migrar de una a otra.

La siguiente captura sólo es para enseñaros como es este proceso, evidentemente no tienen ningún sentido que el origen sea Google Chrome y el destino Notepad++

![dem-primeros-pasos-26]({{ site.imagesposts2020 }}/12/dem-primeros-pasos-26.png){: .align-center}

Y hasta aquí por hoy.

Hasta el próximo post.

Un saludo!

Miquel.


