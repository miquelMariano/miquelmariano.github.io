---
title: Actualizar Horizon 7.x a Horizon 8 (2006)
date: '2020-09-03 00:00:00'
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

Buenos días a todos, recientemente se ha publicado la nueva versión de Horizon 8 y en este post me gustaria enseñaros cómo es el proceso de actualización.

Lo primero que tendremos que verificar es el "update path" y consultar en la [guía de compatibilidad](https://www.vmware.com/resources/compatibility/sim/interop_matrix.php) a ver si desde nuestra versión actual es posible actualizar a Horzion 8
![update01]({{ site.imagesposts2020 }}/08/update01.png){: .align-center}

Una vez comprobada la compatibilidad, podremos comprobar en la [update sequence for Horizon](https://kb.vmware.com/s/article/78445) el orden correcto para actualizar nuestros componentes.
![update02]({{ site.imagesposts2020 }}/08/update02.png){: .align-center}

El primer componente a actualizar será el Horizon Composer, en mi caso, partimos de la versión 7.e
![update03]({{ site.imagesposts2020 }}/08/update03.png){: .align-center}

Seguimos el asistente, no tiene ningún tipo de complicación
![update04]({{ site.imagesposts2020 }}/08/update04.png){: .align-center}
![update05]({{ site.imagesposts2020 }}/08/update05.png){: .align-center}
![update06]({{ site.imagesposts2020 }}/08/update06.png){: .align-center}
![update07]({{ site.imagesposts2020 }}/08/update07.png){: .align-center}
![update08]({{ site.imagesposts2020 }}/08/update08.png){: .align-center}
![update09]({{ site.imagesposts2020 }}/08/update09.png){: .align-center}
![update10]({{ site.imagesposts2020 }}/08/update10.png){: .align-center}
![update11]({{ site.imagesposts2020 }}/08/update11.png){: .align-center}

Vemos que ya tenemos el Composer en versión 8
![update12]({{ site.imagesposts2020 }}/08/update12.png){: .align-center}

Será necesario desde el horizon administrator, volver a aceptar el certificado autofirmado que se ha regenerado en el servidor
![update13]({{ site.imagesposts2020 }}/08/update13.png){: .align-center}

El siguiente componente es el Horizon Connection Server, también en versión 7.7
![update14]({{ site.imagesposts2020 }}/08/update14.png){: .align-center}

Y seguimos el wizard...
![update15]({{ site.imagesposts2020 }}/08/update15.png){: .align-center}
![update16]({{ site.imagesposts2020 }}/08/update16.png){: .align-center}
![update17]({{ site.imagesposts2020 }}/08/update17.png){: .align-center}
![update18]({{ site.imagesposts2020 }}/08/update18.png){: .align-center}
![update19]({{ site.imagesposts2020 }}/08/update19.png){: .align-center}
![update20]({{ site.imagesposts2020 }}/08/update20.png){: .align-center}
![update21]({{ site.imagesposts2020 }}/08/update21.png){: .align-center}
![update22]({{ site.imagesposts2020 }}/08/update22.png){: .align-center}
![update23]({{ site.imagesposts2020 }}/08/update23.png){: .align-center}

El icono del escritorio se actualizará a la nueva versión
![update24]({{ site.imagesposts2020 }}/08/update24.png){: .align-center}

Y veremos que el portal de acceso al Horizon Administrator también ha cambiado.
![update25]({{ site.imagesposts2020 }}/08/update25.png){: .align-center}

Horizon Conection Server actualizado a la versión 8
![update26]({{ site.imagesposts2020 }}/08/update26.png){: .align-center}

Al entrar a nuestros pool de Linked Clone nos aparecerá el siguiente mensaje. Nos está avisando que la tecnología Linked Clone ya no estará disponible en la próxima versión, así que será necesario migrar nuestros escritorios a Instant Clone

Podeis pasaros por [este hilo](https://miquelmariano.github.io/jmp-part1/) si quereis mas información sobre la tecnología Instant Clone
![update27]({{ site.imagesposts2020 }}/08/update27.png){: .align-center}

El último componente es el Horizon Agent, que tendremos que actulizar en nuestra plantilla Gold Image
![update28]({{ site.imagesposts2020 }}/08/update28.png){: .align-center}
![update29]({{ site.imagesposts2020 }}/08/update29.png){: .align-center}
![update30]({{ site.imagesposts2020 }}/08/update30.png){: .align-center}
![update31]({{ site.imagesposts2020 }}/08/update31.png){: .align-center}
![update32]({{ site.imagesposts2020 }}/08/update32.png){: .align-center}
![update33]({{ site.imagesposts2020 }}/08/update33.png){: .align-center}
![update34]({{ site.imagesposts2020 }}/08/update34.png){: .align-center}
![update35]({{ site.imagesposts2020 }}/08/update35.png){: .align-center}
![update36]({{ site.imagesposts2020 }}/08/update36.png){: .align-center}
![update37]({{ site.imagesposts2020 }}/08/update37.png){: .align-center}

Una vez finalizado, haremos un recompose a todo el Pool y ya tendremos nuestro entorno Horizon actualizado a la nueva versión 8

Espero que os sirva.

Un saludo!

Miquel.


