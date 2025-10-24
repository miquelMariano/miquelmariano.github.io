---
title: Back-to-basics 10 - ¿Cómo eliminar correctamente un datastore VMFS?
date: '2020-03-18 00:00:00'
layout: post
image: /assets/images/posts/2018/03/logs.png
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- devops
- backtobasics
---

Por suerte, VMWare ha mejorado mucho versión a versión en cuanto a almacenamiento y ya no es tan frecuente ver errores o inestabilidades en un ESXi si se le quita bruscamente su almacenamiento. Ha habido mucha mejora en cómo los ESXi se comportan ante un APD (All path down) o eventos PDL (Permanent Device Lost) pero aún se ve algún que otro caso de tener que reiniciar un host ESXi tras eliminar de forma incorrecta un datastore.

En esta nueva entrada de la serie [back-to-basics](https://miquelmariano.github.io/tags/#backtobasics), me gustaría enseñaros el procedimiento correcto para desmontar un datastore VMFS.


### 1. Mover todas las VMs y ficheros

Es obvio. Antes de eliminar cualquier datastore, deberemos primero vaciar todas las VMs y ficheros que residan en él para evitar perderlos.

Mover máquinas virtuales es fácil, simplemente tendremos que ejecutar un vMotion para cambiar el almacenamiento a otro datastore.

En caso de tener ISOs u otros ficheros en los cuales no podemos hacer vMotion, desde el propio vCenter dispondremos de la opción de "Transferir a"

![basics10-01]({{ site.imagesposts2020 }}/03/basics10-01.png){: .align-center}

Seleccionaremos el datastore de destino y "Aceptar"

![basics10-02]({{ site.imagesposts2020 }}/03/basics10-02.png){: .align-center}

### 2. Desmontar

Una vez hayamos desalojado todo el contenido del datastore, podremos proceder a desmontarlo.

Con el botón secundario, opción "Desmontar almacén de datos..."

![basics10-03]({{ site.imagesposts2020 }}/03/basics10-03.png){: .align-center}

Seleccionaremos todos los hosts de los cuales queramos desmontar el datastore

![basics10-04]({{ site.imagesposts2020 }}/03/basics10-04.png){: .align-center}

Una vez finalizado, nos aparecerá el datastore desmontado como "inaccesible"

![basics10-05]({{ site.imagesposts2020 }}/03/basics10-05.png){: .align-center}

### 3. Detach LUNS

Hacer el "Detach" significa que aunque el host ESXi todavía tenga visibilidad física de la LUN, a nivel de SO no será accesible.

Localizaremos la LUN correspondiente y opción "separar"

![basics10-06]({{ site.imagesposts2020 }}/03/basics10-06.png){: .align-center}

### 4. Eliminar presentación de LUNS

Una vez tengamos desmontada y desvinculada la LUN de nuestros hosts ESXi, será el momento de eliminar la presentación física.

Este procedimiento se hace desde nuestro sistema de almacenamiento y dependiendo del fabricante, el procedimiento será uno u otro.

Básicament en este punto, le eliminaremos al ESXi el acceso físico al disco.

### 5. Rescan

Para finalizar, será necesario hacer un rescan a nuestro clúster.

Seleccionaremos la opción Almacenamiento > Volver a examinar almacenamiento...

![basics10-07]({{ site.imagesposts2020 }}/03/basics10-07.png){: .align-center}

Y podremos observar que la LUN ya ha sido eliminada de nuestro inventario. En mi caso, era la LUN25

![basics10-08]({{ site.imagesposts2020 }}/03/basics10-08.png){: .align-center}

### 6. ¿Y la opción de eliminar?

Llegados a este punto, muchos os preguntareis porqué no he mencionado la opción de "Eliminar almacén de datos"

Esá opcion está ahi, y se puede usar, pero a mí personalmente no me gusta y os recomiendo que no useis. Ahi van mis motivos:

- La opción de eliminar, a parte de des-inventariar el datastore del vCenter, nos borrará el sistema de ficheros VMFS. Esto significa que se va a formatear la LUN y perderemos de forma permanente todo su contenido. Es una opción irreversible.

- Al formatear la LUN, ya no se podrá volver a montar ni será nunca mas accesible, habrá que crear de nuevo el sistema de ficheros VMFS

- En caso de que ese datastore está presentado a diferentes entornos (diferentes hosts de diferentes vCenter) le estaremos quitando "a lo bruto" un datastore a un host ESXi, que cómo comentaba al principio del host, puede provocar errores de APD o PDL o incluso inestabilidad en el host.

Por todo esto, os recomiendo no "Eliminar almacén de datos" si no estáis completamente seguros de que ese datastore nunca mas se va a volver a necesitar. El eliminar, es una acción irreversible.

Espero que os haya gustado.

Hasta el próximo post!


Un saludo!

Miquel.


