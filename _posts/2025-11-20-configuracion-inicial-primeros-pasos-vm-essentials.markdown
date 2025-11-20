---
title: Configuración inicial y primeros pasos en HPE VM Essentials
subtitle: Parte 4
date: '2025-11-20 00:00:00'
layout: post
thumbnail-img: https://miquelmariano.github.io/assets/images/posts/2025/11/primeros-pasos01.png
cover-img: https://miquelmariano.github.io/assets/images/fondos/10.jpg
share-img: https://miquelmariano.github.io/assets/images/posts/2025/11/primeros-pasos01.png
published: true
author: Miquel Mariano
tag:
- kvm
- hpe
- vme
- cloud
- morpheus
- ha
---

La serie sobre VM Essentials ya va cogiendo forma poco a poco y en este nuevo post, vamos a ver la configuración y primeros pasos dentro de VM Essentials manager.

Recordemos que venimos de [hacer una instalación desde 0](https://miquelmariano.github.io/2025/11/08/instalacion-manager/)

<details markdown="1">
<summary>VER TODA LA SERIE DE POSTS</summary>
- [Parte 1 - Introducción a HPE Morpheus VM Essentials software](https://miquelmariano.github.io/2025/10/17/introduccion-hpe-morpheus-vm-essentials-software/)
- [Parte 2 - Instalación VM Essentials software](https://miquelmariano.github.io/2025/10/17/instalacion-nodo-vme/)
- [Parte 3 - Instalación VME Manager](https://miquelmariano.github.io/2025/11/07/instalacion-manager/)
- [Parte 4 - Configuración inicial](https://miquelmariano.github.io/2025/11/20/configuracion-inicial-primeros-pasos-vm-essentials)
- [Parte 5 - Creación cluster Ceph]
- [Parte 6 - Desplegar nuestra primera VM]
- [Parte 7 - Backups]
- [Parte 8 - Pruebas de HA]
- [Parte 9 - Migración de VMs desde vSphere]
- [Parte 10 - Comandos útiles]
</details>

# Crear nuevo tenant

Con el primer inicio de sesión, deberemos seguir un simple asistente que nos guiará para configurar los datos básicos de nuestro tenant

![HPE_Morpheus_VM_Essentials_primeros_pasos1]({{ site.imagesposts2025 }}/11/primeros-pasos01.png){: .mx-auto.d-block :}

Crearemos el primer usuario de la plataforma y por tanto el que será superadmin de la misma.

![HPE_Morpheus_VM_Essentials_primeros_pasos2]({{ site.imagesposts2025 }}/11/primeros-pasos02.png){: .mx-auto.d-block :}

El check de "Enable Backups" por defecto viene deshabilitado y por tanto se recomienda habilitarlo para que automáticamente se realice backup del propio manager (en futuros posts hablaremos más en detalle del capítulo backups)

![HPE_Morpheus_VM_Essentials_primeros_pasos3]({{ site.imagesposts2025 }}/11/primeros-pasos03.png){: .mx-auto.d-block :}

En caso de disponer de una licencia, la podremos instalar en este paso. De lo contrario, entraremos en un período de evaluación de 60 días

![HPE_Morpheus_VM_Essentials_primeros_pasos4]({{ site.imagesposts2025 }}/11/primeros-pasos04.png){: .mx-auto.d-block :}

Y ya finalmente entraríamos en el panel principal de administración.

![HPE_Morpheus_VM_Essentials_primeros_pasos5]({{ site.imagesposts2025 }}/11/primeros-pasos05.png){: .mx-auto.d-block :}

# Configuración User Settings

Antes de nada, en el panel de "User Settings", podremos personalizar nuestro perfil, añadirle una foto, etc etc.

Os recomiendo que seleccionéis el idioma en inglés, ya que algunos menús no están del todo bien traducidos y puede inducir a confusión.

![HPE_Morpheus_VM_Essentials_primeros_pasos6]({{ site.imagesposts2025 }}/11/primeros-pasos06.png){: .mx-auto.d-block :}

# Concepto de "Group" y "Cloud"

No podremos agregar nuestro primer clúster HVM sin tener previamente definido un Grupo o Nube.

Los grupos definen agrupaciones lógicas de recursos y los usuarios acceden a ellos según las asociaciones que tengas a sus respectivos roles. Sería el concepto de "Resource Group" en un ecosistema Azure por ejemplo.

Las nubes o clouds representan la agrupación de clústers HVM o una conexión a un entorno VMware vCenter

Para definir un grupo, sólo necesitamos un nombre como mínimo y obviamente cuanto más descriptivo sea mejor. Por ejemplo, podríamos crear un grupo por ubicación geográfica

![HPE_Morpheus_VM_Essentials_primeros_pasos7]({{ site.imagesposts2025 }}/11/primeros-pasos07.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primeros_pasos8]({{ site.imagesposts2025 }}/11/primeros-pasos08.png){: .mx-auto.d-block :}

A continuación, crearemos una nube o cloud.
En el menú Infraestructura > Nubes > +AGREGAR
Como decíamos, una nube no sólo es una agregación lógica de clusters HVM sino que también puede servir para conectar a un entorno específico vSphere

![HPE_Morpheus_VM_Essentials_primeros_pasos9]({{ site.imagesposts2025 }}/11/primeros-pasos09.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primeros_pasos10]({{ site.imagesposts2025 }}/11/primeros-pasos10.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primeros_pasos11]({{ site.imagesposts2025 }}/11/primeros-pasos11.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primeros_pasos12]({{ site.imagesposts2025 }}/11/primeros-pasos12.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primeros_pasos13]({{ site.imagesposts2025 }}/11/primeros-pasos13.png){: .mx-auto.d-block :}

Y aquí ya podríamos crear nuestro primer clúster HVM

{: .box-warning}
**Nota:** Es importante que tanto manager como los nodos HVM sean capaces de resolverse mutuamente los DNS

![HPE_Morpheus_VM_Essentials_primeros_pasos14]({{ site.imagesposts2025 }}/11/primeros-pasos14.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primeros_pasos15]({{ site.imagesposts2025 }}/11/primeros-pasos15.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primeros_pasos16]({{ site.imagesposts2025 }}/11/primeros-pasos16.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primeros_pasos17]({{ site.imagesposts2025 }}/11/primeros-pasos17.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primeros_pasos18]({{ site.imagesposts2025 }}/11/primeros-pasos18.png){: .mx-auto.d-block :}

Aquí es donde indicaremos la conexión con los hosts, credenciales, interface de management, etc etc

![HPE_Morpheus_VM_Essentials_primeros_pasos19]({{ site.imagesposts2025 }}/11/primeros-pasos19.png){: .mx-auto.d-block :}
![HPE_Morpheus_VM_Essentials_primeros_pasos20]({{ site.imagesposts2025 }}/11/primeros-pasos20.png){: .mx-auto.d-block :}

Y hasta aquí por hoy.

En el próximo post, veremos como desplegar un cluster HCI con Ceph

Un saludo

Miquel.