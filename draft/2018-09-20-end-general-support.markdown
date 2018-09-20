---
title: End of General Support para vSphere 5.5
date: '2018-02-28 00:00:00'
layout: post
image: /assets/images/posts/2018/09/support.png
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- devops
- backtobasics
category: blog
author: miquelMariano
description: End of General Support para vSphere 5.5
hidden: false
permalink: /eol/
---


El 19 de septiembre, vSphere 5.5 salió de su fase de soporte general y pasó a lo que se denomina "Orientación técnica". En respuesta a esto, muchos ya se han movido a una versión más nueva de la línea vSphere 6.x. Ya sea por preocupaciones de compatibilidad o por una razonable cautela al tocar lo que no se rompe, hay varios de nosotros que estamos en la ola hasta el final. Vamos a hablar sobre lo que realmente significa "Fin del Soporte General" para aquellos que aún ejecutan vSphere 5.5.

Orientación técnica
Primero, aclaremos un error común sobre la orientación técnica. Específicamente, no significa que el producto se vuelva instantáneamente no compatible. Escucho esta palabra para productos que están fuera de la fase de soporte general, pero es engañoso hacerlo. El soporte de VMware aún ayudará en el caso de un problema en un entorno que ejecuta estos productos. Sin embargo, existen algunas limitaciones serias respecto a qué tan lejos está esto ahora que está fuera del Soporte General. Muchas veces, estos casos terminarán requiriendo una actualización de todos modos.

![eol]({{ site.imagesposts2018 }}/09/eol.png)

La documentación de la Política de ciclo de vida de VMware hace un buen trabajo al explicar qué obtienes de la asistencia técnica con productos fuera del soporte general. Esto es lo que dice:

"La orientación técnica está disponible principalmente a través del portal de autoayuda y no se brinda asistencia telefónica. Los clientes también pueden abrir una solicitud de soporte en línea para recibir soporte y soluciones para problemas de baja gravedad solo en configuraciones compatibles. Durante la fase de Orientación técnica, VMware no ofrece nuevo soporte de hardware, actualizaciones de sistema operativo / cliente / invitado, nuevos parches de seguridad o corrección de errores a menos que se indique lo contrario. Esta fase está destinada al uso por parte de clientes que operan en entornos estables con sistemas que funcionan bajo cargas razonablemente estables ".

Muy claro. No Severity 1 llamadas, y no hay parches para ningún problema que se encuentre como un defecto del producto. Esto significa parches de seguridad también! Todavía puede presentar tickets basados ​​en la web y solicitar ayuda para solucionar problemas. Los resultados de estos a menudo consistirán en ayudar a identificar artículos de conocimiento que describan problemas conocidos o configuraciones erróneas del medio ambiente, junto con la guía de configuración o recomendaciones.

La realidad de admitir vSphere 5.5
Lo que no está claro en la declaración anterior son los efectos menos obvios de abrir casos para productos obsoletos. Los ingenieros de soporte son humanos al igual que nuestros clientes, y existen limitaciones al conocimiento que un equipo de técnicos puede mantener en sus filas.

vSphere 5.5 fue lanzado en 2013, y desde entonces se han producido tres versiones más importantes del producto. Muchos ingenieros de soporte entraron durante la era 6.x, y el volumen vSphere 5.5 ha estado disminuyendo constantemente durante años. Esto significa que puede ser difícil y lleva mucho tiempo responder preguntas complejas sobre la línea de productos 5.5. Además, cuando lanzó vSphere 6.x, cambió el juego bastante en términos de arquitectura y técnicas de resolución de problemas. Esto es muy importante para lo que el soporte se acostumbra a ver cuando ayudan a los clientes, y a medida que disminuye el volumen de casos de vSphere 5.5, también lo hace el conocimiento general del soporte.

Es importante saber que si está actualizando desde vSphere 5.5, el soporte de VMware aún está aquí para ayudarlo en caso de que surja un problema. Estamos equipados para manejar los casos de Orientación técnica que se presenten, pero se hace más difícil hacerlo a medida que avanzamos en el período de Orientación técnica, y las preguntas tardan más en responder.

 

Dejando ir
vSphere 5.5 fue un gran lanzamiento, y echo de menos algunas de las formas en que funcionó que cambiaron en 6.x. Sin embargo, debido a la falta de parches de seguridad continuos, compatibilidad reducida y funciones nuevas faltantes, no es una buena opción para los entornos de producción en el futuro. Si aún no ha empezado a planificar una forma de pasar a 6.x, ahora es el momento de hacerlo.

 

Información Adicional
Para obtener más información sobre los ciclos de soporte de productos, ¡revise los enlaces a continuación!



https://www.vmware.com/content/dam/digitalmarketing/vmware/en/pdf/support/product-lifecycle-matrix.pdf



![upgradepath]({{ site.imagesposts2018 }}/09/upgradepath.png)