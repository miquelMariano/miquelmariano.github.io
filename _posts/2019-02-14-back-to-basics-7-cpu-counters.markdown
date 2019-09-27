---
title: Back-to-basics 7 - Contadores importantes de CPU en una VM
date: '2019-02-14 00:00:00'
layout: post
image: /assets/images/posts/2019/02/performance.jpg
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- devops
- backtobasics
---

Buenos dias a tod@as!!

En esta séptima entrada de la serie [back-to-basics](https://miquelmariano.github.io/tags/#backtobasics), me gustaria hablar un poco de los conadores de CPU mas importantes quen podemos encontrar en una máquina virtual.

Todo esto viene a raíz de un debate que tuvimos hace unas semanas el bueno de [Pablo](https://twitter.com/eclat2k) y yo.

¿Por que el valor %WAIT es tan alto en todas nuestras VMs?

![esxtop1]({{ site.imagesposts2019 }}/02/esxtop1.png)

Wait = esperar, no. Eso es malo, fué lo primero que pensamos. 

Investigando un poco mas, vimos que este contador es un poco "trampa" ya que incluye el tiempo %IDLE, es decir, el tiempo que la máquina está ociosa a que el SO le "mande" hacer algo.

En la captura he puesto anteriormente también he marcado el contador %VMWAIT, que este si nos da un indicativo de que puede haber algún tipo de problema. Este contador nos indica el tiempo que una VM está esperando al VMkernel para que le asigne recursos.

Hay que tener en cuenta, que este contador es por world, por lo tento tendremos que expandir la VM para ver el detalle.

![esxtop2]({{ site.imagesposts2019 }}/02/esxtop2.png)

Otros contadores importantes a nivel de CPU podrian ser:

* RUN - Tiempo que una VM está consumiendo recursos de CPU
* WAIT - Tiempo que una VM está esperando al VMkernel
* READY - Tiempo que la VM está esperando recursos de CPU
* CO-STOP - Tiempo que la VM está esperando que se alineen las CPU para asignarselas (solo en VM con mas de 1 CPU)

En resumen:

%WAIT + %RDY +v%CSTP + %RUN = 100%
{: .notice}

Espero que os sirva de ayuda

Un saludo!

Miquel.


