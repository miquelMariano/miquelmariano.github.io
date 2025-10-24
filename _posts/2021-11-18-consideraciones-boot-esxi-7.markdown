---
title: Consideraciones sobre el disco de arranque en ESXi 7.x
date: '2021-11-18 00:00:00'
layout: post
image: /assets/images/posts/2019/07/horizon-logo.png
tag:
- vmware
- vexpert
- esxi

---

En las últimas semanas, han sido varios los usuarios que han reportado en diferentes foros y RRSS errores con las SD y/o USB de arranque al actualizar a vSphere 7.0

En este post vamos a repasar que dice VMware en su guía técnica y las recomendaciones que hace al respecto para poder mitigarlo.

Los dispositivos USB o tarjetas SD han sido utilizadas históricamente para instalar nuestro ESXi y así poder prescindir de discos/controladora en nuestros servidores.
El problema de estos dispositivos es que tienen menos resistencia que un disco tradicional y además pueden presentar problemas de rendimiento a la hora de exigirles una alta frecuencia de IOPS. Ahora, con ESXi 7.x estamos siendo testigos de estos problemas con el arranque con mayor frecuencia que en versiones anteriores.

Antes de profundizar en detalles, es importante comprender el nuevo diseño del sistema de arranque en ESXi 7.x. En versiones anteriores, los tamaños de particiones eran fijos y el número de partición estático. Eso provocaba algunas limitaciones en el uso de otras soluciones cómo NSX-T, vSAN, Tanzu, etc etc lo que restringía la compatibilidad con la instalación de módulos grandes por ejemplo.

De cara a esta necesidad para que los ESXi sean compatibles con otras soluciones de VMware o de terceros es necesario disponer de dispositivos más robustos, flexibles y de alto rendimiento.

Con la nueva arquitectura de particiones en vSphere 7.0, solo la partición de arranque del sistema es de tamaño fijo. El resto de particiones son dinámicas, por lo que el tamaño se determinará en función del tamaño del dispositivo de arranque.

![boot-media-1]({{ site.imagesposts2021 }}/11/boot-media-1.png){: .align-center}

Otro cambio significativo es la partición ESX-OSDATA. Todas las particiones que no son de arranque, como el coredump, locker, scratch ahora se incluyen en esta partición (VMFS-L)

Esta partición debe de crearse en un dispositivo persistente de alta resistencia, ya que el número de IOPS al ESX-OSDATA se ha incrementado notablemente debido a múltiples factores:

- Mayor número de peticiones de health check del estado del dispositivo

- Scripts programados para hacer backups del estado del sistema y timestamp también contribuyen al aumento de IOPS

- Otras funciones que almacenan el estado de la configuración en el ESX-OSData

![boot-media-2]({{ site.imagesposts2021 }}/11/boot-media-2.png){: .align-center}

## Posibles problemas con ESXi 7 con tarjetas SD o dispositivos USB

1. Posible corrupción de la partición VMFS-L (ESX-OSDATA)
Los dispositivos de baja resistencia como tarjetas SD o USB se descastan/rompen rápidamente debido a la alta frecuencia de IOPS. La razón más común son las operaciones de lectura en los archivos VMTools a los que acceden las VMs. Una forma de mitigar esto es descargar estas operaciones en el disco RAM lo que reduce significativamente las IOPS enviadas a las SD o USB. or el momento, la solución está en mover las VMTools a RAMDisk habiliando la opción ToolsRamDisk de forma manual >> [KB83376](https://kb.vmware.com/s/article/83376)

2. "/bootbank" missing
Las tarjetas SD o dispositivos USB suelen tener gran latencia, lo que genera grandes colas en la pila de almacenamiento y el consiguiente timeout. >> [KB83963](https://kb.vmware.com/s/article/83963)

## Plan para remediar el uso de tarjetas SD o unidades USB como medio de arranque

### Limitaciones:
1. El uso de tarjetas SD o unidades USB sin ningún dispositivo adicional para la partición ESX-OSDATA está obsoleto en vSphere 7 Update 3 y no será compatible en futuras versiones

2. En las próximas versiones, la única configuración admitida con SD o USB será con unidades de 8Gb + un dispositivo de almacenamiento persistente conectado localmente para la partición ESX-OSDATA.

3. En cualquier caso, si se utiliza finalmente SD o USB como medio de arranque, hay que seguir estas instrucciones para reducir la cantidad de IOPS enviadas:

[Habilitar ToolsRamDisk](https://kb.vmware.com/s/article/83376)
[Configurar /scratch en almacenamiento persistente](https://kb.vmware.com/s/article/1033696)
[Configurar ESXi Dump Collector](https://docs.vmware.com/en/VMware-vSphere/6.5/com.vmware.vsphere.install.doc/GUID-85D78165-E590-42CF-80AC-E78CBA307232.html)

4. Asegurarse de que nuestros ESXi están actualizados a la versión vSphere 7.0 U2c o superior para evitar el error ["/bootbank" missing](https://kb.vmware.com/s/article/83963)

5. Un dispositivo con tarjeta SD dual no es una solución en la que los clientes deban confiar

6. Si nuestro ESXi ya está actualizado a 7.x, podemos agregar un dispositivo de almacenamiento local y establecer AutoPartition = True. De esta manera, este almacenamiento se usará para la partición ESX-OSDATA >> [KB77009](https://kb.vmware.com/s/article/77009)

## Consideraciones sobre el arranque de ESXi.
A día de hoy, la mejor opción es tener un dispositivo de almacenamiento persistente conectado localmente.

![boot-media-3]({{ site.imagesposts2021 }}/11/boot-media-3.png){: .align-center}
![boot-media-4]({{ site.imagesposts2021 }}/11/boot-media-4.png){: .align-center}

## Arranque de ESXi desde un almacenamiento local en un entorno vSAN
VMware no recomienda arrancar un ESXi desde la misma controladora de discos compartida por los discos de la vSAN. Los clientes pueden considerar la posibilidad de añadir una controladora adicional para gestionar el dispositivo de arranque.

## Conclusión
VMware se está distanciando del soporte de tarjetas SD y dispositivos USB como medios de arranque. La configuración del arranque solo con SD o USB está obsoleta con vSphere 7.0 U3. En futuras versiones, esta configuración no será admitida y se recomienda a los clientes que se migren completamente de tarjetas SD o unidades USB.

Si esta opción no es posible, hay que asegurarse de que la tarjeta SD o USB es de 8Gb y disponemos de un dispositivo de alta resistencia conectado localmente para alojar la partición ESX-OSDATA

Y como nota final, recordar que si estamos en esta situación, deberemos actualizar a la versión 7.0 U2c o superior, ya que contiene correcciones para algunos de los problemas anteriormente descritos.

Espero que os guste.

Un saludo!

Miquel.


P.D. Podeis leer la nota oficial, [aquí](https://blogs.vmware.com/vsphere/2021/09/esxi-7-boot-media-consideration-vmware-technical-guidance.html)


