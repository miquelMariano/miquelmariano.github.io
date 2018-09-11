---
title: ESXi | L1 Terminal Fault or esx.problem.hyperthreading.unmitigated
date: '2017-09-22 00:00:00'
layout: post
image: /assets/images/posts/2018/09/bug.jpg
headerImage: true
tag:
- automation
- ansible
- devops
category: blog
author: miquelMariano
description: ESXi | L1 Terminal Fault or esx.problem.hyperthreading.unmitigated
hidden: false
permalink: /l1/
---

Buenos dias a tod@as!!

Muchos de vosotros, os abreis dado cuenta que al actualizar vuestros hosts ESXi a la última versión os han aparecido unos misteriosos mensajes:

![warning1]({{ site.imagesposts2018 }}/09/esxi-warning1.png)

![warning2]({{ site.imagesposts2018 }}/09/esxi-warning2.png)

Esto es debido al bug *[L1 Terminal Fault - VMM](https://kb.vmware.com/s/article/55806?src=af_5acfd7716582e&cid=70134000001YR6X)*

> The L1 Terminal Fault (aka Foreshadow) bug is another speculative execution side channel attack  
> that affects Intel Core processors and Intel Xeon processors only.

Por suerte, VMWare sacó el 14 de agosto una serie de parches para tratar de mitigar este problema

![tabla]({{ site.imagesposts2018 }}/09/tabla.png)


Un saludo!

Miquel.


