---
title: Creando un entorno JMP con VMware Horizon - Parte 15 - Instalación Dynamic Environment Manager
date: '2020-07-14 00:00:00'
layout: post
image: /assets/images/posts/2019/07/horizon-logo.png
tag:
- vmware
- horizon
- vexpert
- euc
- desktop
- mobility
permalink: /jmp-part15/

---

Seguimos con la serie de posts sobre Horizon7. En el capítulo de hoy, hablaremos sobre Dynamic Environment Manager.

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

- [Bonus 1: Gestión de perfiles con Microsoft FSLogix](https://miquelmariano.github.io/gestion-de-perfiles-con-fslogix/)

Dynamic Environment Manager, es una solución que nos provee una forma robusta i ágil de gestión del perfil de nuestros usuarios y gestión de su espacio de trabajo en general. Con esta herramienta podremos centralizar las configuraciones en un share y dar persistencia a nuestros usuarios.

DEM, no es una aplicación cliente-servidor cómo pueda ser App Volumes. DEM está basado en carpetas compartidas en dónde se almacenará la configuración y que los DEM Agent consultarán a través de una GPO de usuario.

Todo esto, lo gestionaremos desde una GUI que podremos instalar en cualquier windows.

![dem_esquema]({{ site.imagesposts2020 }}/07/dem_esquema.png){: .align-center}

Vamos al lío.

# Descargar última versión e instalación plantillas ADMX

Lo primero que haremos, será descargarnos del portal de my.vmware la última versión de DEM.

A fecha de edición de este post, la última versión disponible es la  9.11, así que nos descargaremos esa versión
![dem_download]({{ site.imagesposts2020 }}/07/dem_download01.png){: .align-center}

En el fichero que nos descargemos, encontraremos una carpeta con unas plantillas .admx y sus correspondientes ficheros de idioma. Tendremos que copiarlos en nuestro DC para poder crear posteriormente las GPO

![uem_config1]({{ site.imagesposts2020 }}/07/dem_config1.png){: .align-center}

# Crear carpetas compartidas y configuración permisos
Cómo hemos comentado al principio, DEM no es una aplicación cliente-servidor, sinó que el agente tiene que conectarse a un recurso compartido de red para buscar la configuración.

De entrada, necesitaremos 3 carpetas compartidas

* **DEM_CONFIG** > Se almacenará la configuración general de DEM
* **DEM_PROFILES** > Dónde cada usuario almacenará la información relacionada con su perfil
* **DEM_FOLDERREDIRECTION** > Dónde configuraremos la redirección de carpetas cómo el Escritorio, Mis Docuentos, Favoritos, etc etc.
* **DEM_LOGS** > Guardaremos todos los logs referentes a DEM

A nivel de share, daremos control total a todos los usuarios, ya que controlaremos los accesos a nivel de NTFS

![dem_permisos01]({{ site.imagesposts2020 }}/07/dem_permisos01.png){: .align-center}

## DEM_CONFIG

**Administradores:** Control total

**Usuarios:** Lectura

![dem_permisos02]({{ site.imagesposts2020 }}/07/dem_permisos02.png){: .align-center}

## DEM_PROFILE

**Administradores:** Control total

**Usuarios:** Lectura/ejecución, Crear carpetas (sólo en esta carpeta)

**Propietario:** Control total

![dem_permisos03]({{ site.imagesposts2020 }}/07/dem_permisos03.png){: .align-center}

## DEM_FOLDERREDIRECTION

**Administradores:** Control total

**Usuarios:** Lectura/ejecución, Crear carpetas (sólo en esta carpeta)

**Propietario:** Control total

![dem_permisos04]({{ site.imagesposts2020 }}/07/dem_permisos04.png){: .align-center}

## DEM_LOGS

**Administradores:** Control total

**Usuarios:** Lectura/ejecución, Crear Carpetas (sólo en esta carpeta)

**Propietario:** Control total

![dem_permisos05]({{ site.imagesposts2020 }}/07/dem_permisos05.png){: .align-center}

# Instalación DEM Management Console
La instalación de la Management Consola es muy senzilla y puede instalarse en cualquier máquina windows desde la que queramos administrar nuestro entorno. Simplemente ejecutaremos el instalador correspondiente a nuestro SO y siguiente, siguiente, fin...

![dem_instalation01]({{ site.imagesposts2020 }}/07/dem_instalacion01.png){: .align-center}
![dem_instalation02]({{ site.imagesposts2020 }}/07/dem_instalacion02.png){: .align-center}
![dem_instalation03]({{ site.imagesposts2020 }}/07/dem_instalacion03.png){: .align-center}
![dem_instalation04]({{ site.imagesposts2020 }}/07/dem_instalacion04.png){: .align-center}
Aquí deberemos seleccionar la opción de Management Console
![dem_instalation05]({{ site.imagesposts2020 }}/07/dem_instalacion05.png){: .align-center}
![dem_instalation06]({{ site.imagesposts2020 }}/07/dem_instalacion06.png){: .align-center}
![dem_instalation07]({{ site.imagesposts2020 }}/07/dem_instalacion07.png){: .align-center}
Tras finalizar, conectaremos la Management Console a la carpeta compartida dónde guardaremos toda la configuración.
![dem_instalation08]({{ site.imagesposts2020 }}/07/dem_instalacion08.png){: .align-center}

# Configuración GPO
El entorno DEM está basado en 2 GPOs:

## GPO de Equipo, aplicable a los VDI

![dem_gpo01]({{ site.imagesposts2020 }}/07/dem_gpo01.png){: .align-center}
![dem_gpo02]({{ site.imagesposts2020 }}/07/dem_gpo02.png){: .align-center}

## GPO de Usuario, aplicable a los usuarios que utilizarán DEM

![dem_gpo03]({{ site.imagesposts2020 }}/07/dem_gpo03.png){: .align-center}
![dem_gpo04]({{ site.imagesposts2020 }}/07/dem_gpo04.png){: .align-center}
![dem_gpo05]({{ site.imagesposts2020 }}/07/dem_gpo05.png){: .align-center}
![dem_gpo06]({{ site.imagesposts2020 }}/07/dem_gpo06.png){: .align-center}
![dem_gpo07]({{ site.imagesposts2020 }}/07/dem_gpo07.png){: .align-center}
![dem_gpo08]({{ site.imagesposts2020 }}/07/dem_gpo08.png){: .align-center}
![dem_gpo09]({{ site.imagesposts2020 }}/07/dem_gpo09.png){: .align-center}
![dem_gpo10]({{ site.imagesposts2020 }}/07/dem_gpo10.png){: .align-center}
![dem_gpo11]({{ site.imagesposts2020 }}/07/dem_gpo11.png){: .align-center}

# Instalación DEM agent
Al igual que la Management Console. El DEM Agent se instala con el mismo instalador. Simplemente en uno de los pasos, indicaremos que queremos instalar el agente y no la Management Console

![dem_instalation_a01]({{ site.imagesposts2020 }}/07/dem_instalacion_a01.png){: .align-center}
![dem_instalation_a02]({{ site.imagesposts2020 }}/07/dem_instalacion_a02.png){: .align-center}
![dem_instalation_a03]({{ site.imagesposts2020 }}/07/dem_instalacion_a03.png){: .align-center}
![dem_instalation_a04]({{ site.imagesposts2020 }}/07/dem_instalacion_a04.png){: .align-center}
Aquí es dónde indicamos que esta instalación va a ser en modo Agente.
![dem_instalation_a05]({{ site.imagesposts2020 }}/07/dem_instalacion_a05.png){: .align-center}
![dem_instalation_a06]({{ site.imagesposts2020 }}/07/dem_instalacion_a06.png){: .align-center}
![dem_instalation_a07]({{ site.imagesposts2020 }}/07/dem_instalacion_a07.png){: .align-center}
![dem_instalation_a08]({{ site.imagesposts2020 }}/07/dem_instalacion_a08.png){: .align-center}

Y hasta aquí la introducción e instalación de DEM, en el próximo post, veremos los [Primeros pasos con UEM]({{ site.url }}/jmp-part16/)

Un saludo!

Miquel.


