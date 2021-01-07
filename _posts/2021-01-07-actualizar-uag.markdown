---
title: Actualizar Unified Access Gateway
date: '2021-01-07 00:00:00'
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

El componente UAG es quizás uno de los componentes mas fáciles de actualizar de nuestra plataforma de VMware Horizon. Hace ya tiempo, en [este post](https://miquelmariano.github.io/jmp-part6/), ya vimos como hacer su instalación y configuración.

El "proceso" de actualización, es básicamente desplegar un nuevo appliance en última versión e importar la configuración existente. Fácil, ¿no?

Vamos a lío...

# Actualizar Unified Access Gateway

Desde el portal de [my.vmware](my.vmware.com), nos descargaremos la última versión disponible en formato .ova

![update-uag-00]({{ site.imagesposts2021 }}/01/update-uag-00.png){: .align-center}

Es importante que repasemos la [matriz de interoperabilidad de productos VMware](https://www.vmware.com/resources/compatibility/sim/interop_matrix.php), desde aquí, podremos ver qué versión de UAG es compatible con nuestro entorno horizon y el "Upgrade Path" a seguir.

En mi caso, partimos de unos UAG en versión 3.6

![update-uag-01]({{ site.imagesposts2021 }}/01/update-uag-01.png){: .align-center}

Desplegaremos nuestros nuevos UAG igual que hacemos con cualquier otro appliance en formato .ova y seguimos el asistente.

![update-uag-02]({{ site.imagesposts2021 }}/01/update-uag-02.png){: .align-center}
![update-uag-03]({{ site.imagesposts2021 }}/01/update-uag-03.png){: .align-center}
![update-uag-04]({{ site.imagesposts2021 }}/01/update-uag-04.png){: .align-center}
![update-uag-05]({{ site.imagesposts2021 }}/01/update-uag-05.png){: .align-center}
![update-uag-06]({{ site.imagesposts2021 }}/01/update-uag-06.png){: .align-center}
![update-uag-07]({{ site.imagesposts2021 }}/01/update-uag-07.png){: .align-center}
![update-uag-08]({{ site.imagesposts2021 }}/01/update-uag-08.png){: .align-center}
![update-uag-09]({{ site.imagesposts2021 }}/01/update-uag-09.png){: .align-center}
![update-uag-10]({{ site.imagesposts2021 }}/01/update-uag-10.png){: .align-center}
![update-uag-11]({{ site.imagesposts2021 }}/01/update-uag-11.png){: .align-center}

Una vez tengamos desplegado nuestro nuevo UAG y antes de arrancarlo, deberemos exportar la configuración del UAG el cual vamos a substituir.

Configurar manualmente > Exportar la configuración de Unified Access Gateway

Esto nos exportará la configuración en formato .json
![update-uag-12]({{ site.imagesposts2021 }}/01/update-uag-12.png){: .align-center}
![update-uag-13]({{ site.imagesposts2021 }}/01/update-uag-13.png){: .align-center}

Antes de endender el nuevo UAG y ahora que tenemos la configuración exportada, procedemos a apagar el UAG original.
![update-uag-15]({{ site.imagesposts2021 }}/01/update-uag-15.png){: .align-center}

Encendemos el nuevo UAG, hacemos login y nos dirigimos a la opción de "Importar configuración" para hacer la importación del fichero .json que previamente hemos exportado

![update-uag-14]({{ site.imagesposts2021 }}/01/update-uag-14.png){: .align-center}
![update-uag-16]({{ site.imagesposts2021 }}/01/update-uag-16.png){: .align-center}
![update-uag-17]({{ site.imagesposts2021 }}/01/update-uag-17.png){: .align-center}
![update-uag-18]({{ site.imagesposts2021 }}/01/update-uag-18.png){: .align-center}
![update-uag-19]({{ site.imagesposts2021 }}/01/update-uag-19.png){: .align-center}

Si queremos mantener la misma IP, será necesario hacer el cambio. Éste es el único parámetro que no importaremos con el fichero, el restro, estará tal cual al UAG original.

![update-uag-20]({{ site.imagesposts2020 }}/01/update-uag-20.png){: .align-center}

Verificamos los parámetros y que los servicios están OK

![update-uag-21]({{ site.imagesposts2021 }}/01/update-uag-21.png){: .align-center}
![update-uag-22]({{ site.imagesposts2021 }}/01/update-uag-22.png){: .align-center}

En el Horizon Administrator, tendremos que cambiar nuestro nuevo UAG. Será tan fácil como eliminar el registro actual que aparecerá con error y añadir el nuevo UAG

![update-uag-23]({{ site.imagesposts2021 }}/01/update-uag-23.png){: .align-center}
![update-uag-24]({{ site.imagesposts2021 }}/01/update-uag-24.png){: .align-center}
![update-uag-25]({{ site.imagesposts2021 }}/01/update-uag-25.png){: .align-center}
![update-uag-26]({{ site.imagesposts2021 }}/01/update-uag-26.png){: .align-center}
![update-uag-27]({{ site.imagesposts2021 }}/01/update-uag-27.png){: .align-center}

Espero que os sirva.

Un saludo!

Miquel.


