---
title: Montar disco virtual .vmdk como unidad local en windows
date: '2021-02-22 00:00:00'
layout: post
tag:
- vmware
- vexpert
---

Hoy vengo a enseñaros una pequeña herramienta que he encontrado y que nos permite montar un disco .vmdk cómo unidad local en nuestro windows.

Esto, nos puede ser útil si queremos explorar ese disco virtual y ver que hay en su interior sin tener que vincularlo a una máquina virtual.

Últimamente estoy inmerso en varios proyectos EUC y estamos implementando muchos entornos con [VMware Horizon](https://miquelmariano.github.io/jmp-part1/) y [AppVolumes](https://miquelmariano.github.io/jmp-part11/). Cómo sabeis, AppVolumes tiene una funcionalidad llamada [writable volume](https://miquelmariano.github.io/jmp-part14/), que nos permite "redirigir" el perfil de nuestros usuarios en un disco .vmdk

En un momento dado, tenia la necesidad de ver el contenido del perfil de un usuario sin molestarle ni cerrarle la sesión. Fué entonces cuando encontré [OSFMount](https://www.osforensics.com/tools/mount-disk-images.html) 

![osfmount1]({{ site.imagesposts2021 }}/02/osfmount1.png){: .align-center}

# OSFMount

Con OSFMount podemos montar archivos de disco en Windows cómo un disco físico o una unidad lógica. De forma predeterminada, los archivos de imagen se montan en modo lectura, para no alterar el contenido original.

También permite el montaje en ectura/escritura en modo caché. Esto almacena los cambios en un archivo "delta" y conserva la integridad de la imagen de disco original.

Podeis descargar el instalador para Windows x64 desde [aquí](https://www.osforensics.com/downloads/osfmount.exe)

![osfmount2]({{ site.imagesposts2021 }}/02/osfmount2.png){: .align-center}

Espero que os sea útil ;-)

Saludos!

Miquel.




