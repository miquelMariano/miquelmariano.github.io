---
title: Back-to-basics 2 - Licenciemiento vSphere
date: '2018-02-28 00:00:00'
layout: post
image: /assets/images/posts/2018/02/logovsphere65.jpeg
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- devops
- backtobasics
- licensing
category: blog
author: miquelMariano
description: Back-to-basics 2 - Licenciamiento vSphere
hidden: false
comments: true
---

Buenos dias a tod@as!!

Incluso los administradores mas experimentados, a veces, se confunden con las peculiaridades de las licencias vSphere, las opciones disponibles y las características.

En esta segunda entrada de la serie [back-to-basics](https://miquelmariano.github.io/tags/#backtobasics), me gustaria dar un repaso al licenciamiento vSphere. En este caso trataré de explicar las ediciones de VMware vSphere disponibles, sus características, diferencias, en versión 6.5 (lanzado en octubre de 2016).

# Aspectos a tener en cuenta
Resaltemos las reglas principales a tener en cuenta al planear y comprar licencias de VMware vSphere 6.5.

+ Un servidor ESXi debe licenciarse según la cantidad de procesadores físicos (CPU). Cada CPU del servidor requiere una licencia vSphere.
+ La funcionalidad disponible de un servidor ESXi estrá determinada por la licencia de vSphere instalada.
+ Cada licencia de vSphere requiere un paquete de soporte de servicio (al menos por un año).
+ VMware no impone ninguna restricción al tamaño de la memoria (RAM) instalada en el servidor físico ni a la cantidad de máquinas virtuales en ejecución.

> **Nota** . Desde el punto de vista de VMware, la plataforma ESXi ~~no requiere licencia~~ es gratuita. Un usuario puede instalarse un servidor ESXi, que por defecto viene con 60 dias de evaluación y después pasará a ser "free license". A partir de ese momento no dispondrá de ningún tipo de funcionalidad, mas allá de la propia virtualización.

En VMware vSphere 6.5, la cantidad de ediciones vSphere se ha reducido en comparación con las versiones anteriores. En verano de 2016, VMware anunció la eliminación de su edición Enterprise. Por lo tanto, en la actualidad disponemos de las siguientes ediciones:

![enterprise]({{ site.imagesposts2018 }}/02/enterprise.png)

# Kit Essentials

Para cubrir las necesidades de pequeñas y medianas empresas, VMWare ofrece ediciones vSphere 6 Essentials.

+ **VMware vSphere 6 Essentials**
+ **VMware vSphere 6 Essentials Plus**

Estas ediciones permiten licenciar hasta 3 servidores físicos que tengan hasta 2 CPU cada uno. Aquí la diferencia principal está en las características disponibles en comparación con las ediciones enterprise.

![essentials]({{ site.imagesposts2018 }}/02/essentials.png)

La diferencia principal entre la edición Essentials y Essentials Plus es que esta última tiene características vMotion y High Availability (HA). En vSphere Essentials, podrá mover una VM entre ESXi o datastores sólo si está apagada.

# Acceleration Kit

Cuando adquieren kits de licencias especiales (Acceleration Kit), puede actualizar vSphere Essentials a ediciones vSphere completas. Ofrecen las mismas características que las ediciones Enterprise de vSphere, pero cada una está bloqueada a un máximo de 3 hosts ESXi (procesadores de mínimo 2) y 1 servidor estándar vCenter.

![acceleration]({{ site.imagesposts2018 }}/02/accelerationkit.png)

Espero que os sea de utilidad :-)

Hasta el próximo post....

Un saludo!

Miquel.


