---
title: vAutodeploy, despliegue masivo de VMs con PowerCLI
layout: post
date: 2017-05-05 13:00:00
image: /assets/images/posts/2017/05/vAutodeploy-header.png
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- devops
- automation
- powercli
---

Hola a tod@s!

En el post de hoy os voy a compartir un script que llevo utilizando y mejorando ya mucho tiempo.

Se trata de un script de PowerCLI que me ayuda a desplegar máquinas virtuales de forma masiva. Solo con completar todos los parámetros, es capaz de desplegar n VM en serie.

![vAutodeploy]({{ site.imagesposts2017 }}/05/vAutodeploy.png)

A continuación una breve descripción de cada campo:

**Number of VMs:** Si, tal cual :) es el nº de máquinas que queremos desplegar

**Basename:** Es el nombre base que le vamos a dar a cada VM, al final, el script concatena el basename+sufix para crear la VM

**First sufix value:** Es un número autoincremental por el cual empezará a contar la primera VM a desplegar

**CPUs:** Nº de CPUs que tendrán nuestras VMs a desplegar

**RAM (GB):** Cantidad de RAM asignada a cada VM

**Template/VM:** Las máquinas que se van a desplegar pueden ser a partir de un Template o un clon de una VM existente. 

**CustomSpec:** Será la customización post instalación que se aplicará a las VMs. Podeis leer mas sobre Customization Specifications Manager en [#ElBlogdeNcora](https://www.ncora.com/blog/2016/11/01/customizacion-de-templates-en-vsphere/)

**Datastore:** Almacenamiento donde se ubicarán las VMs

**VLAN:** Puede provocar confusión. Se refiere al port group que tenemos definido en nuestros ESXi

**Network:** Ip que se le asignará a las VMs. El formato tiene que ser X.X.X. ya que el script concatenará este valor con *"First IP"*

**First IP:** Nº autoincremental que se concatena con *"Network"* para asignar IPs a nuestras VMs. En caso de desplegar mas de 1 VM asegurarse de que las IPs correlativas están libres

**Netmask:** Máscara de subred

**Gateway:** Puerta de enlace

**Primary DNS:** DNS Primario

**Secondary DNS:** DNS Secundario

Habrá muchos aspectos que se tendrán/podrán mejorar/depurar, así que espero vuestros comentarios ;-)

Podéis descargaros una copia del repositorio GitHub desde [aquí](https://github.com/miquelMariano/vAutodeploy)
 
Un saludo

Miquel.