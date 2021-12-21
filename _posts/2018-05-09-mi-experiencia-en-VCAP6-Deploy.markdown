---
title: Mi experiencia con el VCAP6-DCV Deploy
date: '2018-05-16 00:00:00'
layout: post
image: /assets/images/posts/2018/05/vcap6.png
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- vcap
- vcix6
permalink: /vcap-experience/
---

Buenos días a tod@as!!

El pasado martes, fue uno de esos días en los que te vas a la cama con una satisfacción especial. Fue un día especial en cuanto a lo profesional se refiere.

Tenia programado el examen VCAP6-DCV Deploy, una certificación avanzada de VMWare la cual certifica que el aspirante cuenta con los conocimientos y experiencia necesarios para dominar cualquier aspecto sobre la virtualización del datacenter o Software Defined Data Center (que parece que en inglés mola más :-))

Este nuevo escalón en el sistema de certificaciones de VMWare era un reto para mí y el cual llevaba ya meses (o años) dándole vueltas, pero que por diferentes motivos había ido dejando caer en mi "ToDo List"

![certificationpath]({{ site.imagesposts2018 }}/05/certification-path.png)

El objetivo de este post es compartir mi experiencia, cómo prepararlo y algunos consejos a tener en cuenta sobre el examen.

### Información sobre el examen

En cuanto al examen, no tiene mucho secreto. Está todo perfectamente explicado en la página de mylearn.vmware.com 

Nombre: [VMware Certified Advanced Professional 6 – Data Center Virtualization Deployment](https://www.vmware.com/education-services/certification/vcap6-dcv-deploy-exam.html)

Código del examen: 3V0-623

Certificación requerida: [VCP6-DCV](https://www.vmware.com/education-services/certification/vcp6-dcv-exam.html)

Formato: 100% práctico, utiliza la misma interface que los [HOL](http://labs.hol.vmware.com/HOL/catalogs/catalog/681) de VMWare (recomiendo familiarizarse con este entorno)

Duración: 190 minutos

Puntuación mínima requerida: 300 (sobre un total de 500)

Número de Laboratorios: 27 Laboratorios, en los que nos proponen múltiples tareas a realizar

Precio: 380€

Curso requerido: No es requerido ningún curso oficial.

### Preparación

Como comentaba anteriormente, es una certificación avanzada, por lo que hay que ir mínimamente preparado. No es un examen complicado, pero uno tiene que saber a lo que va, que le preguntarán, y al ser un examen 100% práctico, no confiar en la improvisación (como todos hemos hecho en exámenes tipo test.)

En mi caso, no es una cosa de la que esté demasiado orgulloso, pero hay que decirlo. Me lo preparé mas bien poco. En las últimas semanas llevaba acumulados bastantes proyectos, viajes y mucho curro en general que hicieron que no le pudiera dedicar el tiempo que se merece.

Básicamente mi preparación se basó en los siguientes aspectos, ordenados para mi, de mas a menos prioritario.

1. [Guía de estudio en PDF](https://miquelmariano.github.io/assets/VCAP6-DCV-Deployment-Study-Guide.pdf)

2. Material de los blogs. Estos son los 2 que para mi gusto tienen mejor contenido:

   - [vStellar](http://www.vstellar.com/2017/12/29/vcap6-dcv-deploy-study-guide/)

   - [vJenner](http://www.vjenner.com/vcap6-dcv-deployment-study-guide/)

3. [HOL](http://labs.hol.vmware.com/HOL/catalogs/catalog/681)

4. Manuales oficiales vSphere 6.0

Aunque os los encontrareis en el escritorio del laboratorio el dia del examen, no está de mas que les deis un repaso antes. Os los dejo [aquí](https://miquelmariano.github.io/assets/vsphere-documentation-60.zip)

A parte de material comentado previamente, también es muy importante la práctica. Practicar, practicar, practicar y mas practicar. Hay que tener cierta soltura con el laboratorio y las diferentes interfaces de administración que dispone vSphere. Tendremos "poco" tiempo y esta agilidad sobre el lab será fundamental para ir avanzando.

A mi personalmente, me ha ayudado muchísimo la formación. Pero no como alumno, desde hace mas de 1 año soy instructuctor del curso [Administración de vSphere 6.5](https://www.ncora.com) que ofrecemos desde Ncora de forma trimestral y sin duda, el tener que prepararme continuamente este curso, ha sido fundamental para contrarestar la falta de horas de estudio.

### El dia "D"

El examen fue el pasado 9 de mayo. Lo programé unos 4 meses antes, entre otras cosas, porque en Palma solo hay un centro Pearson VUE y el calendario estaba bastante saturado. También era una medida de presión para estudiar :)

Ese día, es muy probable que durmáis poco, a mi me paso. Yo me lo tomé con calma, tenia el examen a las 10:00, por lo que me levanté, desayuné tranquilamente y me fuí para el centro certificador para llegar unos 20-30 minutos antes.

Tenéis que mentalizaros de que os pasareis mas de 3 horas sentados en una silla, puede que no demasiado cómoda, frente a un monitor y que os enzarzareis en una dura batalla contra el lab. A mí personalmente, tanto el aula como el material (mesa, silla, PC) eran bastante adecuados. La conexión con el lab era bastante fluida, así que todo fue bastante rodado.

Tomáoslo con calma, durante la preparación leí algunas experiencias que contaban lo rudimentario de la conexión con el lab y la lentitud. Supongo que no será lo habitual, pero también hay que contar con ello. No os asustéis.

Como comentaba, 3 horas parecen un mundo, pero si no gestionamos bien el tiempo, se pueden quedar realmente cortas. El examen va a contar con 27 laboratorios y las tareas que nos van a pedir, básicamente son:

* Configuración
* Administración
* Resolución de problemas

Yo me dividí en examen en horas e intenté resolver 8-9 laboratorios por hora para tener un tiempo final para repasar.

Se trata de sumar puntos, por muy perdidos que vayáis en un laboratorio concreto, intentad hacer algo. Aunque no sepáis resolver la parte importante del lab, al tener que hacer múltiples tareas, seguro que podéis "rascar" algo.

No perdáis mucho tiempo en esas cosas que no sabéis. Es mejor ir avanzando en el laboratorio, os ayudará psicológicamente ver que vais avanzando, y después ya volveréis a los lab mas complejos.

Evidentemente no tendréis al Sr. Google para que os ayude, pero si que tendréis toda la documentación de vSphere 6.0 disponible en el escritorio del lab. No tendréis mucho tiempo para consultarla, pero si que para las preguntas de línea de comandos o configuración avanzada os será muy útil.

### El resultado

A diferencia de los VCP, que tras finalizar el examen inmediatamente tenemos el resultado, para el VCAP, el resultado se envía por correo tras la finalización del examen.
En mi caso, no tardó ni una hora (que se hizo eterna) en llegar el ansiado correo con el ansiado resultado.

Y.... ....PASSED!!!!!

![passed]({{ site.imagesposts2018 }}/05/pass.png)

Es una sensación difícil de explicar, solo es una certificación, pero los que estamos en este mundo sabemos lo que cuestan las cosas y la satisfacción tras conseguirlas es tremendamente gratificante.

Desde aquí animo a todos los que os estéis planteando este tipo de examen, ya que es totalmente asequible con un poco de dedicación y si os puedo ayudar en algo, ya sabéis ;-)


Un abrazo!

Miquel.


