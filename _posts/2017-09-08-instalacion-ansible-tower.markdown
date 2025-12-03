---
title: Instalación Ansible Tower steb-by-step
date: '2017-09-08 00:00:00'
layout: post
image: /assets/images/posts/2017/09/tower_logo.png
headerImage: true
tag:
- ansible
- automation
- devops
---

Buenos días a tod@s!!!

Una de las principales quejas de los usuarios Ansible es que no tenía una GUI adecuada. Una buena interfaz de usuario es importante para que los usuarios ocasionales y nuevos se familiaricen con una aplicación antes de sumergirse en las complejidades de la CLI

Ansible en sí era (y sigue siendo) bastante nuevo, por lo que la mayoría de sus usuarios son por definición nuevos usuarios. [Ansible Tower](https://www.ansible.com/tower), es la solución a este problema. Es una completa interfaz de usuario basada en web, que contiene las características más importantes de Ansible.

A continuación os voy a describir el paso a paso para su instalación, pero, no dejéis de consultar su [guía oficial](http://docs.ansible.com/ansible-tower/latest/html/installandreference/index.html) si queréis profundizar un poco mas en el tema.

# *Pre-requisitos*

+ Verificar que tenemos 10Gb de espacio disponible en `/var`

```ssh
[root@miquel-ansible01 /tmp]# df -h /var/
S.ficheros          Tamaño Usados  Disp Uso% Montado en
/dev/mapper/cl-root    17G   3,7G   14G  22% /
```

+ Asegurarnos que tenemos instalado el repositorio EPEL

```ssh
[root@miquel-ansible01 /tmp]# yum install -y epel-release
```

+ [Tener ansible core instalado](https://miquelmariano.github.io/ansible-for-dummies/)
+ Descargar la fuente del paquete desde [Ansible](https://releases.ansible.com/ansible-tower/setup-bundle/)

```ssh
[root@miquel-ansible01 /tmp]# wget https://releases.ansible.com/ansible-tower/setup-bundle/ansible-tower-setup-bundle-latest.el7.tar.gz
```

# *Instalación*

+ Descomprimir paquete

```ssh
[root@miquel-ansible01 /tmp]# tar -xzvf ansible-tower-setup-bundle-latest.el7.tar.gz
```

+ Configurar fichero de inventario modificando los siguientes valores:

```ssh
[root@miquel-ansible01 /tmp/ansible-tower-setup-bundle-3.1.4-1.el7]# vim inventory
```
```vim
admin_password='password'
pg_password='password'
rabbitmq_password='password'
```

+ Arrancar instalación

```ssh
[root@miquel-ansible01 /tmp/ansible-tower-setup-bundle-3.1.4-1.el7]# ./setup.sh
```

Seguro que el proceso de instalación os resulta familiar... :)

![tower-install-process]({{ site.imagesposts2017 }}/09/tower-install-process.png)

Durante la instalación, dará algunos warnings y errores, pero ni caso, el propio playbook está diseñado para contemplar todos los escenarios posibles y al final, terminará correctamente.

![tower-finish-install]({{ site.imagesposts2017 }}/09/tower-finish-install.png)

# *Enjoy and automate*

Ya podremos abrir nuestro navegador web favorito y acceder al portal de login de nuestro Ansible  Tower. El usuario es `admin` y la contraseña, la que hemos editado anteriormente en `admin_password='password'`

![tower-login]({{ site.imagesposts2017 }}/09/tower-login.png)

Lo primero que tendremos que hacer es instalar una licencia válida. El propio asistente nos guia para solicitar una demo, que será gratuita y para manejar hasta 10 hosts

![tower-license]({{ site.imagesposts2017 }}/09/tower-license.png)

Y ya tenemos nuestro nuevo portal Tower listo para usar

![tower-portal]({{ site.imagesposts2017 }}/09/tower-portal.png)

En los próximos posts veremos cuales son los "Primeros pasos con Ansible Tower"

Espero que os sea de utilidad.
Gracias por compartir

Un saludo

Miquel.