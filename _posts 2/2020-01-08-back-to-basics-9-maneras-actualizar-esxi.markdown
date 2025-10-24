---
title: Back-to-basics 9 - 5 maneras de actualizar un host ESXi
date: '2020-01-08 00:00:00'
layout: post
image: /assets/images/posts/2018/10/balloon.jpeg
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- devops
- backtobasics
---

Buenos días a tod@s. Vamos a empezar el año continuando con la serie [back-to-basics](https://miquelmariano.github.io/tag/#/backtobasics).

En esta ocasión vamos a ver las 5 maneras posibles de actualizar un servidor vSphere ESXi.

### 1. Modo interactivo

El más fácil y mas común. Nos grabamos un CD/DVD con la ISO o directamente creamos un USB bootable. Arrancamos nuestro servidor a través de este medio bootable y seguimos el wizard de actualización. En [este post](https://www.vladan.fr/how-to-upgrade-esxi-6-x-to-6-7-via-iso/) lo encontrareis perfectamente explicado.

### 2. A través de script `ks.cfg` 

Este segundo método está basado en el anterior. Necesitaremos la ISO de instalación de ESXi para arrancar el wizard de instalación. Llegado el momento, podremos ejecutar un script de instalación con todos los parámetros que necesitemos y así poder hacer la instalación/actualización de forma desatendida.

En [este post](https://miquelmariano.github.io/2018/05/30/automate-config-ESXi/) que escribí hace tiempo está el paso a paso de todo el proceso.

### 3. A través de línea de comandos con `esxcli`

Cómo ya sabeis, `esxcli` es la linea de comandos del servidor ESXi a través de esta herramienta, también será posible actualizar nuestros servidores ESXi.

#### Actualización a releases mayores

Para actualizar a versiones superiores (de 6.5 a 6.7 por ejemplo) Teneis [este post](https://miquelmariano.github.io/2018/05/02/update-esxi-offline-bundle/) en dónde se explica los pasos a seguir

#### Actualización de parches ESXi

En caso de ya estar en versión 6.7 y sólo querer actualizar los nuevos parches, cómo por ejemplo instalar el último U3, podremos seguir [el siguiente post](https://miquelmariano.github.io/2019/11/13/actualizacion-esxi-sin-update-manager/)

### 4. vSphere Update Manager

También es muy común actualizar nuestros servidores ESXi con Update Manager. Con este método podremos tanto instalar versiones mayores de ESXi como actualizarlo a nivel de parches.

En este punto, os recomiendo pasaros por [este post](http://www.bujarra.com/actualizando-hosts-vsphere-update-manager-6-5/) de Héctor Herrero ([@nheobug](https://twitter.com/nheobug)), co-autor del libro [VMware por vExperts](https://miquelmariano.github.io/vmwareporvexperts/)

### 5. vSphere Auto Deploy

Por último, la última manera que tenemos de actualizar un servidor ESXi es a través de vSphere Auto Deploy. Es quizas la manera menos trivial de todas, pero que si la conseguimos dominar, nos puede ahorrar mucho tiempo tanto en actualizaciones cómo en nuevos desplieges.

En [este post](https://miquelmariano.github.io/2018/02/14/autodeploy/) publiqué hace ya tiempo información bastante extendida de cómo implementar y configurar Auto Deploy en entornos vSphere 6.x

### Rollback

Para finalizar, os dejo también el [enlace a un post](https://miquelmariano.github.io/2018/11/07/esxi-rollback/) en dónde explicaba cómo hacer rollback de un servidor ESXi.

No es muy habitual, pero en caso de que haya una corrupción a nivel de SO y que el ESXi quede en un estado incoherente, no está de mas tener a mano el procedimiento para hacer rollback.


Y hasta aquí por hoy.

Nos vemos en el próximo post.

Feliz año!!!

Miquel.

