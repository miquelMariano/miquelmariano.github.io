---
title: Ampliar disco en servidor Windows
subtitle: Parte 6.1 - Ampliar disco en servidor Windows
date: '2026-09-04 00:00:00'
layout: post
thumbnail-img: https://miquelmariano.github.io/assets/images/posts/2026/09/ampliar-disco-windows-01.png
cover-img: https://miquelmariano.github.io/assets/images/fondos/09.jpg
share-img: https://miquelmariano.github.io/assets/images/posts/2026/09/ampliar-disco-windows-01.png
published: true
author: Miquel Mariano
tag:
- kvm
- hpe
- vme
- cloud
- morpheus
- ha
- veeam
---

En este procedimiento vamos a ver el paso a paso para poder ampliar el disco y la unidad C: en una máquina virtual Windows en caliente y sin ningún tipo de parada de servicio.

<details>
<summary>VER TODA LA SERIE DE POSTS SOBRE VME</summary>

<ul>
  <li><a href="https://miquelmariano.github.io/introduccion-hpe-morpheus-vm-essentials-software/">Parte 1 - Introducción a HPE Morpheus VM Essentials software</a></li>
  <li><a href="https://miquelmariano.github.io/instalacion-nodo-vme/">Parte 2 - Instalación VM Essentials software</a></li>
  <li><a href="https://miquelmariano.github.io/instalacion-manager/">Parte 3 - Instalación VME Manager</a></li>
  <li><a href="https://miquelmariano.github.io/configuracion-inicial-primeros-pasos-vm-essentials">Parte 4 - Configuración inicial</a></li>
  <li><a href="https://miquelmariano.github.io/cluster-ceph/">Parte 5 - Creación cluster Ceph</a></li>
  <li><a href="https://miquelmariano.github.io/primera-vm-en-vmessentials/">Parte 6 - Desplegar nuestra primera VM</a></li>
  <ul>
      <li><a href="https://miquelmariano.github.io/backup-vme-con-veeam/">Parte 6.1 - Backups con Veeam v13</a></li>
    </ul>
  <li><a href="https://miquelmariano.github.io/backups-en-vm-essentials/">Parte 7 - Backups nativos</a>
    <ul>
      <li><a href="https://miquelmariano.github.io/ampliar-disco-vm-windows-sobre-vme/">Parte 6.1 - Ampliar disco en servidor Windows</a></li>
    </ul>
  </li>
  <li><a href="https://miquelmariano.github.io/ha-en-vm-essentials/">Parte 8 - Pruebas de HA</a></li>
  <li><a href="https://miquelmariano.github.io/migracion-vsphere-vme/">Parte 9 - Migración de VMs desde vSphere</a>
    <ul>
      <li><a href="https://miquelmariano.github.io/migracion-vsphere-vme-veeam/">Parte 9.1 - Migración con Veeam</a></li>
    </ul>
  </li>
  <li>[Parte 10 - Comandos útiles]</li>
  <li><a href="https://miquelmariano.github.io/actualizaciones-vme-manager-y-nodos-hvm">Parte 11 - Gestión de actualizaciones en HPE VM Essentials</a></li>
</ul>

</details>

# Ampliar disco de datos

En este ejemplo partimos de una VM con un disco de 30Gb en el que para ampliarlo seleccionaremos el botón de "Reconfigure" desde el menú "Actions"

![ampliar-disco-windows-01]({{ site.imagesposts2026 }}/09/ampliar-disco-windows-01.png){: .mx-auto.d-block :}

Añadiremos el nuevo tamaño sin modificar ningún otro parámetro

![ampliar-disco-windows-02]({{ site.imagesposts2026 }}/09/ampliar-disco-windows-02.png){: .mx-auto.d-block :}

En la pestaña "history" podremos comprobar que la tarea se ha realizado correctamente

![ampliar-disco-windows-03]({{ site.imagesposts2026 }}/09/ampliar-disco-windows-03.png){: .mx-auto.d-block :}

# Ampliar unidad C

Con el disco ampliado podemos validar que nuestro windows ha detectado correctamente los +2GB adicionales que le hemos asignado.

Tambien vemos que entre la unidad C y el nuevo espacio se ha quedado la partición de recuperación de windows

![ampliar-disco-windows-04]({{ site.imagesposts2026 }}/09/ampliar-disco-windows-04.png){: .mx-auto.d-block :}

La partición de recuperación de windows no se puede desplazar nativamente con la herramienta de diskpart por lo que en la mayoria de casos podemos optar por eliminarla.

- Abre el menú Inicio, busca **cmd** o **Símbolo del sistema**, haz clic derecho sobre él y selecciona Ejecutar como administrador.
- Abre la herramienta de gestión de discos: `diskpart`
- Lista los discos conectados a tu equipo: `list disk`
- Selecciona el disco principal donde está instalado Windows (reemplaza X por el número de tu disco, generalmente 0): `select disk X`
- Muestra la lista de particiones dentro de ese disco: `list partition`
- Identifica la partición de recuperación (suele indicarse como Recuperación o Recovery en la columna Tipo) y selecciónala (reemplaza Y por el número correspondiente): `select partition Y`
- Fuerza la eliminación de la partición de recuperación: `delete partition override`
- Sal de Diskpart: `exit`

![ampliar-disco-windows-05]({{ site.imagesposts2026 }}/09/ampliar-disco-windows-05.png){: .mx-auto.d-block :}

Una vez eliminada la partición de recuperación y teniendo el espacio libre contiguo a C: podremos proceder a la ampliación de la unidad

![ampliar-disco-windows-06]({{ site.imagesposts2026 }}/09/ampliar-disco-windows-06.png){: .mx-auto.d-block :}

Nos vemos en el próximo post ;-)

Un saludo

Miquel.
