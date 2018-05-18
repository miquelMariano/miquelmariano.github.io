---
title: Uso de variables y condicionales con Ansible
date: '2020-01-03 00:00:00'
layout: post
image: /assets/images/posts/2017/11/ansible.png
headerImage: true
tag:
- ansible
- devops
- automation
category: blog
author: miquelMariano
description: Uso de variables con Ansible
hidden: false
o: "{{"
c: "}}"
permalink: /conditionals/
---
http://www.mydailytutorials.com/working-ansible-variables-conditionals/


Buenas a tod@as!

Hace ya tiempo, escribí un post, por el cual os recomiendo que os paseis, sobre el [uso de variables en Ansible](https://miquelmariano.github.io//2018/01/ansible-vars/)

En el artículo de hoy, vamos a ir un paso mas allá y veremos como tratarlas en expresiones condicionales. A veces nos puede resultar necesario almacenar el resultado de una tarea y que otras tareas puedan acceder a ella y en función del valor hacer una cosa u otra. Vamos a ver algunos pequeños ejemplos del uso de estas variables en condicionales:

### Ansible cuando la variable es igual a otro valor

```yaml
- hosts: all
  vars:
    test1: "Hello World"
  tasks:
  - name: Ansible when variable equals example
    debug:
      msg: "Equals"
    when: test1 == "Hello World"
```

### Ansible cuando la variable no es igual a otro valor

```yaml
- hosts: all
  vars:
    test1: "Bye World"
  tasks:
  - name: Ansible when variable not equals example
    debug:
      msg: "Not Equals"
    when: test1 != "Hello World"
```

### Ansible cuando la variable contiene cadena

```yaml
- hosts: all
  vars:
    test1: "Bye World"
  tasks:
  - name: Ansible when variable contains string example example
    debug:
      msg: "Equals"
    when: test1.find("World") != -1
```

```yaml
- hosts: all
  tasks:
  - shell: cat /etc/temp.txt
    register: output
  - name: Ansible when variable contains string example example
    debug:
      msg: "Equals"
    when: output.stdout.find("World") != -1
```

### Ansible cuando la variable está vacía

```yaml
- hosts: all
  tasks:
  - shell: cat /etc/temp.txt
    register: output
  - name: Ansible when variable is empty example
    debug:
      msg: "empty"
    when: output.stdout == ""
```






Hasta el próximo post :-)

Un saludo!!!


Miquel.