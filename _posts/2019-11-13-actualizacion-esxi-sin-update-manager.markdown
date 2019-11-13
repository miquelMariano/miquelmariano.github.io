---
title: Instalar parches en ESXi sin Update Manager
date: '2019-11-13 00:00:00'
layout: post
image: /assets/images/posts/2019/07/horizon-logo.png
tag:
- vmware
- vexpert
- update
- esxi

---

Buenos días a tod@s.

Hace ya tiempo, [publiqué un post](https://miquelmariano.github.io/2018/05/02/update-esxi-offline-bundle/) en dónde mostraba como actualizar la versión de nuestros ESXi

Dándole vueltas al tema, me di cuenta de que este procedimiento era muy útil para actualizar la versión de nuestros servidores ESXi, pero que no especificaba cómo actualizar nuestro ESXi sin cambiar a una versión superior.

Algo tan sencillo cómo actualizar a U3 nuestro ESXi 6.7, se puede hacer sin mas problema con Update Manager, pero, ¿y si el host es standalone y no está vinculado a un vCenter? ¿Y si, como yo, estais enamorados de las CLIs? Tranquilos, en este pequeño post, veremos cómo podemos instalar parches a nuestro servidor ESXi sin la necesidad de Update Manager.

# Comprobar versión ESXi

Antes de nada, comprobaremos en que versión de ESXi estamos con el comando `vmware -vl`, en mi caso, partimos de una versión ESXi 6.7 GA

![uppdate-esxi-without-um-1]({{ site.imagesposts2019 }}/11/update-esxi-without-um-1.png){: .align-center}

# Descargar paquete

Para descargarnos el paquete deseado, tendremos que conectarnos [al repositorio de descargas de VMware](https://my.vmware.com/group/vmware/patch#search)

![uppdate-esxi-without-um-2]({{ site.imagesposts2019 }}/11/update-esxi-without-um-2.png){: .align-center}

# Copiar paquete al ESXi

Via WinSCP o FileZilla o con nuestro cliente preferido, podremos subir el paquete a nuestro ESXi:

![uppdate-esxi-without-um-3]({{ site.imagesposts2019 }}/11/update-esxi-without-um-3.png){: .align-center}

![uppdate-esxi-without-um-4]({{ site.imagesposts2019 }}/11/update-esxi-without-um-4.png){: .align-center}

# Instalar paquete

Una vez copiado el paquete en nuestro ESXi, ya sólo nos quedará ejecutar el siguiente comando, para hacer la instalación del mismo:

```ssh
esxcli software vib install -d /vmfs/volumes/LOCAL/update-from-esxi6.7-6.7_update03.zip
```

![uppdate-esxi-without-um-5]({{ site.imagesposts2019 }}/11/update-esxi-without-um-5.png){: .align-center}

# Reiniciar y comprobar actualización

Tras la actualización, nos pedirá un reinicio, y al arrancar de nuevo el servidor ESXi, ya podremos ver que se ha actualizado correctamente:

![uppdate-esxi-without-um-6]({{ site.imagesposts2019 }}/11/update-esxi-without-um-6.png){: .align-center}

Espero que os sirva.

Un saludo!

Miquel.


