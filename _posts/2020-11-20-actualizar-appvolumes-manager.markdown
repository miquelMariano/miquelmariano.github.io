---
title: Actualización VMware App Volumes manager
date: '2020-11-20 00:00:00'
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

En posts anteriores, ya vimos [cómo instalar App Volumes]({{ site.url }}/jmp-part11/) y también [cómo configurarlo en HA](https://miquelmariano.github.io/2020/10/21/vmware-app-volumes-en-ha/). Hoy veremos de forma fácil y rápida, cómo actualizar nuestros servidores de App Volumes.

**Nota:** A dia de hoy, la última versión disponible de App Volumes es la 4.2.0.48.
{: .note}


Vamos al lio:

# Actualización VMware App Volumes Manager

En mi caso, partimos de una versión no demasiada antigua, la 4.1.0.59. En cualquier caso, os recomiendo visitar el [Upgrade Path del producto](https://www.vmware.com/resources/compatibility/sim/interop_matrix.php#upgrade&solution=131) para verificar que no haya "saltos" intermedios.

![update_appvolumes_00]({{ site.imagesposts2020 }}/11/update_appvolumes_00.png){: .align-center}

Al tener una arquitectura en HA, lo primero que vamos a hacer es sacar del balanceador el servidor que vayamos a actualizar.
![update_appvolumes_01]({{ site.imagesposts2020 }}/11/update_appvolumes_01.png){: .align-center}

Ejecutamos el instalador y nos dejamos quiar por el asistente. El propio asistente ya detectará una instalación previa y simplemente tenemos que hacer el famoso next > next > next > finish
![update_appvolumes_02]({{ site.imagesposts2020 }}/11/update_appvolumes_02.png){: .align-center}
![update_appvolumes_03]({{ site.imagesposts2020 }}/11/update_appvolumes_03.png){: .align-center}
![update_appvolumes_04]({{ site.imagesposts2020 }}/11/update_appvolumes_04.png){: .align-center}
![update_appvolumes_05]({{ site.imagesposts2020 }}/11/update_appvolumes_05.png){: .align-center}
![update_appvolumes_06]({{ site.imagesposts2020 }}/11/update_appvolumes_06.png){: .align-center}
![update_appvolumes_07]({{ site.imagesposts2020 }}/11/update_appvolumes_07.png){: .align-center}
![update_appvolumes_08]({{ site.imagesposts2020 }}/11/update_appvolumes_08.png){: .align-center}
![update_appvolumes_09]({{ site.imagesposts2020 }}/11/update_appvolumes_09.png){: .align-center}
![update_appvolumes_10]({{ site.imagesposts2020 }}/11/update_appvolumes_10.png){: .align-center}
![update_appvolumes_11]({{ site.imagesposts2020 }}/11/update_appvolumes_11.png){: .align-center}
![update_appvolumes_12]({{ site.imagesposts2020 }}/11/update_appvolumes_12.png){: .align-center}
![update_appvolumes_13]({{ site.imagesposts2020 }}/11/update_appvolumes_13.png){: .align-center}

Una vez finalizado, veremos en la pestaña "Managers" cómo el primero de ellos ya está a la última versión
![update_appvolumes_14]({{ site.imagesposts2020 }}/11/update_appvolumes_14.png){: .align-center}

Para finalizar, tendremos que meter de nuevo el servidor en el balanceador.
![update_appvolumes_15]({{ site.imagesposts2020 }}/11/update_appvolumes_15.png){: .align-center}

Finalmente, repetiremos estos mismos pasos en el otro u otros managers que conformen nuestra infraestructura de App Volumes.

Y hasta aquí el post de hoy, nos "vemos" en el próximo post ;-)

Un saludo!

Miquel.


