---
title: Uso de condicionales con Ansible
date: '2018-06-12 00:00:00'
layout: post
image: /assets/images/posts/2018/06/ansible_logo.png
headerImage: true
tag:
- ansible
- devops
- automation
category: blog
author: miquelMariano
description: Uso de condicionales con Ansible
hidden: false
o: "{{"
c: "}}"
permalink: /conditionals/
---

Buenas a tod@as!

Hace ya tiempo, escribí un post, por el cual os recomiendo que os paseis, sobre el [uso de variables en Ansible](https://miquelmariano.github.io//2018/01/ansible-vars/)

En el artículo de hoy, vamos a ir un paso mas allá y veremos como tratarlas en expresiones condicionales. A veces nos puede resultar necesario almacenar el resultado de una tarea y que otras tareas puedan acceder a ella y en función del valor hacer, una cosa u otra. Vamos a ver algunos pequeños ejemplos del uso de variables en condicionales:

### Cuando la variable es igual a otro valor

```yaml
- hosts: all
  vars:
    test1: "Hello World"
  tasks:
  - name: Cuando la variable es igual a otro valor
    debug:
      msg: "Equals"
    when: test1 == "Hello World"
```

### Cuando la variable no es igual a otro valor

```yaml
- hosts: all
  vars:
    test1: "Bye World"
  tasks:
  - name: Cuando la variable no es igual a otro valor
    debug:
      msg: "Not Equals"
    when: test1 != "Hello World"
```

### Cuando la variable contiene una deterninada cadena

```yaml
- hosts: all
  vars:
    test1: "Bye World"
  tasks:
  - name: Cuando la variable contiene una deterninada cadena
    debug:
      msg: "Equals"
    when: test1.find("World") != -1
```

```yaml
- hosts: all
  tasks:
  - shell: cat /etc/temp.txt
    register: output
  - name: Cuando la variable contiene una deterninada cadena
    debug:
      msg: "Equals"
    when: output.stdout.find("World") != -1
```

### Cuando la variable está vacía

```yaml
- hosts: all
  tasks:
  - shell: cat /etc/temp.txt
    register: output
  - name: Cuando la variable está vacía
    debug:
      msg: "empty"
    when: output.stdout == ""
```


Espero que os sea de utilidad. Hasta el próximo post :-)

Un saludo!!!


Miquel.