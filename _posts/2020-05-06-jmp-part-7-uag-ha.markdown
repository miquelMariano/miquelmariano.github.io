---
title: Creando un entorno JMP con VMware Horizon - Parte 7 - Configuración de UAG en HA
date: '2020-05-06 00:00:00'
layout: post
image: /assets/images/posts/2019/07/horizon-logo.png
tag:
- vmware
- horizon
- vexpert
- euc
- desktop
- mobility
permalink: /jmp-part7/

---

En el capítulo de hoy de la serie "Creando un entorno JMP con VMware Horizon" veremos cómo dotar a nuestro UAG de alta disponibilidad y eliminar así un único punto de fallo.

Os dejo a continuación el índice de toda la serie:

- [Part 1: Introducción]({{ site.url }}/jmp-part1/)
- [Part 2: Preparar servidor SQL]({{ site.url }}/jmp-part2/)
- [Part 3: Preparar Active Directory]({{ site.url }}/jmp-part3/)
- [Part 4: Instalación y configuración Connection Server]({{ site.url }}/jmp-part4/)
- [Part 5: Instalación y configuración Replica Server (opcional)]({{ site.url }}/jmp-part5/)
- [Part 6: Instalación y configuración de UAG (opcional)]({{ site.url }}/jmp-part6/)
- [Part 7: Configuración de UAG en HA]({{ site.url }}/jmp-part7/)
- Part 8: Instalación certificado (opcional)
- [Part 9: Preparar plantilla master para Instant Clone]({{ site.url }}/jmp-part9/)
- [Part 10: Configurar un pool de Instant Clone]({{ site.url }}/jmp-part10/)
- [Part 11: Instalar App Volumes]({{ site.url }}/jmp-part11/)
- [Part 12: Configuración inicial App Volumes]({{ site.url }}/jmp-part12/)
- [Part 13: Crear nuestro primer App Stack]({{ site.url }}/jmp-part13/)
- [Part 14: Trabajando con Writable Volumes]({{ site.url }}/jmp-part14/)
- [Part 15: Instalación Dynamic Environment Manager]({{ site.url }}/jmp-part14/)
- Part 16: Primeros pasos con UEM
- Part 17: Instalación y configuración JMP Server
- Part 18: Aprovisionamiento con JMP

# Despliegue de un nuevo UAG

Lo primero que tendremos que hacer para dotar nuestro UAG de alta disponibilidad, será desplegar otra instancia de Unified Access Gateway

Para ello, podremos seguir los pasos descritos en la [Part 7: Instalación y configuración de UAG]({{ site.url }}/jmp-part6/)

![uag-ha01]({{ site.imagesposts2020 }}/05/uag-ha01.png){: .align-center}

# Configuración del nuevo UAG

Una vez realizado el despliegue, para no tener que realizar la configuración desde cero, vamos a utilizar la función de exportar/importar para copiar la configuración del UAG original al que acabamos de instalar.

Haremos la exportación de la config:

![uag-ha02]({{ site.imagesposts2020 }}/05/uag-ha02.png){: .align-center}

Desde el nuevo UAG, realizaremos la importación del fichero .json que acabamos de exportar:

![uag-ha03]({{ site.imagesposts2020 }}/05/uag-ha03.png){: .align-center}

Evidentemente, con este import, la configuración será idéntica, y deberemos de revisar las URLs para cambiar a la IP correcta correspondiente al nuevo UAG.

![uag-ha04]({{ site.imagesposts2020 }}/05/uag-ha04.png){: .align-center}

![uag-ha05]({{ site.imagesposts2020 }}/05/uag-ha05.png){: .align-center}

En el apartado de configuración del sistema, cambiaremos también el nombre de la instancia:

![uag-ha05-1]({{ site.imagesposts2020 }}/05/uag-ha05-1.png){: .align-center}

# Configuración de virtual IP y HA

Con los 2 UAGs ya instalados y configurados, pasaremos a la configuración de la Virtual IP. Los siguientes pasos deben realizarse en ambos UAG y con los mismos parámetros.

En el apartado de Configuración avanzada > Configuración de Alta disponibilidad:

![uag-ha06]({{ site.imagesposts2020 }}/05/uag-ha06.png){: .align-center}

Habilitamos el modo de Alta disponibilidad, añadiremos la VIP y definiremos un ID de grupo (esta configuración debe ser idéntica en ambos nodos)

![uag-ha07]({{ site.imagesposts2020 }}/05/uag-ha07.png){: .align-center}

Si comparamos ambos UAGs, observamos que la configuración de HA se habrán configurado cómo "Principal" y "Copia de seguridad"

![uag-ha08]({{ site.imagesposts2020 }}/05/uag-ha08.png){: .align-center}

![uag-ha09]({{ site.imagesposts2020 }}/05/uag-ha09.png){: .align-center}

# Pruebas de HA

Para probar que la configuración realizada está funcionando correctamente y que realmente tenemos alta disponibilidad, probaremos de apagar uno de nuestros servidores.

En las siguientes capturas, vemos que el UAG02 es realmente el que está activo y el que tiene la VIP levantada.

![uag-ha10]({{ site.imagesposts2020 }}/05/uag-ha10.png){: .align-center}

![uag-ha11]({{ site.imagesposts2020 }}/05/uag-ha11.png){: .align-center}

Si apagamos el UAG02, observamos que la VIP pasa a estar levantada en el UAG01 y el ping no se ha perdido en ningún momento.

![uag-ha12]({{ site.imagesposts2020 }}/05/uag-ha12.png){: .align-center}

Y hasta aquí por hoy. Espero que os haya gustado.

¡Un saludo!

Miquel.


