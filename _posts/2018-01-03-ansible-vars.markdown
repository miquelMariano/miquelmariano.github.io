---
title: Uso de variables con Ansible
date: '2018-01-03 00:00:00'
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
comments: true
o: "{{"
c: "}}"
---

Buenos dias a tod@as!!

Para permitir mas flexibilidad en playbooks y roles, Ansible tiene la capacidad de trabajar con [variables](http://docs.ansible.com/ansible/latest/playbooks_variables.html). Estas variables se pueden usar para recorrer una serie de valores determinados, acceder a informacion diversa, como el hostname o la ip de un sistema, e incluso reemplacer ciertas cadenas en una plantilla por valores específicos.

Las variables se pueden proporcionar a través del inventario, de un archivo de variables, o se pueden incluir por linea de comandos al llamar un playbook.

> Hay que tener en cuenta que los nombres de las variables deben ser letras, números o guiones bajos.
> Y que las variables siempre deben comenzar con una letra.


Dicho esto, la pregunta es ¿cómo usar variables? ¿Y cómo conseguirlas en primer lugar?

# Variables y loops

En general, los bucles son uno de los casos de uso mas comunes de variables. Si bien no estamos utilizando variables proporcionadas externamente, voy a intentar dar una primera idea de como usarlas.

Por ejemplo, voy a copiar un conjunto de archivos, es posible escribir una tarea para cada archivo o simplemente recorrerlos:

```yaml
tasks:
  - name: Copia ficheros
    copy: 
      src: /etc/tmp/{{ page.o }} item {{ page.c }}
      dest: /tmp/{{ page.o }} item {{ page.c }}
    with_items:
      - prueba1.txt
      - prueba2.txt
```

> Primer concepto básico: Las variables se pueden usar en los argumentos del módulo y se referencian 
> entre llaves {{ page.o }} variable {{ page.c }}

# Variables y templates

Las variables se pueden usar también para substituir parámetros en ficheros de configuración con valores específicos del sistema, extraidos directamente en tiempo de ejecución. Imaginemos por un momento, un archivo que debe contener el hostname del servidor. Todas las máquinas son casi idénticas excepto por el nombre de host, por lo que esta variable no podrá estar predefinida, sinó que deberemos capturarla en tiempo de ejecución

En este caso, es mejor tener una copia del archivo de configuración, con una variable como place-maker en lugar de los nombres de host: aquí es donde las plantillas entran en juego:

```ssh
$ cat template.j2
My host name is {{ page.o }} ansible_hostname {{ page.c }}.
```

El módulo de Ansible para usar plantillas y sustitución de variables es el [módulo template](http://docs.ansible.com/ansible/latest/template_module.html):

```yaml
tasks:
  - name: copy template
    template: 
        src: template.j2 
        dest: /tmp/tmp.conf
```
Cuando esta tarea se ejecute, copiará el fichero template.j2 con el nombre tmp.conf y substituirá la variable {{ page.o }} ansible_hostname {{ page.c }} por el nombre de host de cada servidor donde se ejecute.

> Los templates tinen que tener la extensión .j2 y utilizan el lenguage jinja2. Podeis leer mas en la [web 
> oficial](http://jinja.pocoo.org/docs/2.10/) del proyecto

# Usando variables dentro de condicionales

Las variables se pueden usar dentro de condiciones, lo que garantiza que ciertas tareas solo se ejecuten cuando, la variable solicitada se establece en un valor determinado:

```yaml
tasks:
  - name: Install Apache on Solaris
    pkg5: 
      name: web/server/apache-24
    when: ansible_os_family == "Solaris"
 
  - name: Install Apache on RHEL
    yum:  
      name: httpd
    when: ansible_os_family == "RedHat"
```

> En este caso, la primera tarea solo se aplica en servidores Solaris, mientras que la segunda solo se ejecuta en máquinas Red Hat.

# Usando variables del sistema

Para usar variables en Ansible, evidentemente, tienen que haber sido definidas previamente. Hasta ahora hemos visto algunos casos de uso de variables, pero no cómo obtenerlas.

Por defecto, Ansible ya define un amplio conjunto de variables individuales para cada host. Cada vez que se ejecuta en un sistema, toda la información sobre el sistema se recopila y establece como una variable. Estas variables se pueden consultar a través del [módulo setup](http://docs.ansible.com/ansible/latest/setup_module.html):

```ssh
$ ansible neon -m setup
neon | success >> {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "192.168.122.203"
        ], 
        "ansible_all_ipv6_addresses": [
            "fe80::5054:ff:feba:9db3"
        ], 
        "ansible_architecture": "x86_64", 
        "ansible_bios_date": "04/01/2014", 
...
```

Todas estas variables se pueden usar en templates, playbooks, roles o como comentábamos antes, en tareas condicionales. 

# Variables desde la línea de comandos

Otra manera de definir variables en Ansible es llamar a los playbooks con la opción `--extra-vars` o `-e` en su formato abreviado:

```ssh
$ ansible-playbook --extra-vars "cli_var=production"
```

> La referencia a esta variable, es otra vez, entre llaves {{ page.o }} variable {{ page.c }}

```ssh
$ cat template.j2
environment: {{ page.o }} cli_var {{ page.c }}.
```

# Variables en playbooks

Una forma de definir variables mas directamente, es en los playbooks, con la clave `vars`:

```yaml
...
hosts: all 
vars:
  play_var: bar 
 
tasks:
...
```

Estas variables, también pueden ampliarse incluyendo un archivo .yml

```yaml
...
hosts: all
include_vars: setupvariables.yml
 
tasks:
...
```

Incluir mas archivos con más variables resulta extremadamente útil cuando las variables para cada sistema se guardan en un archivo específico, como $HOSTNAME.yml, porque el archivo incluido puede volver a ser una variable:

```yaml
...
hosts: all
include_vars: "{{ page.o }} ansible_hostname {{ page.c }}.yml"
 
tasks:
...
```

En este caso, el playbook lee las variables específicas para cada host correspondiente, definidas en un fichero externo de variables.

# Variables en el inventario

En ocasiones, puede cobrar sentido definir variables directamente en un fichero de inventario previamente definido:

```yaml
[clients]
helium intevent_var=helium_123
neon invent_var=bar
```

> El inventario trata más o menos cualquier argumento que no sea específico de Ansible como variable de host.

También es posible establecer variables para hostgroups completos:

```yaml
[clients]
helium
neon
 
[clients:vars]
invent_var=group-foo
```

Un ejemplo claro de variables en el inventario seria cuando diferentes equipos usan el mismo conjunto de roles y playbooks, pero tienen diferentes configuraciones de máquina que necesitan un tratamiento específico en cada caso. 

# Configurar variables en el sistema: local facts

Cuando Ansible accede a un host remoto, busca el directorio /etc/ansible/facts.d y se leen todos los archivos que terminan en .fact:

```ssh
$ cat /etc/ansible/facts.d/variables.fact 
[system]
foo: bar
dim: dum
```

Las variables que muestra el [módulo setup](http://docs.ansible.com/ansible/latest/setup_module.html) serian las siguientes:

```ssh
$ ansible neon -m setup
...
      "type": "loopback"
  }, 
  "ansible_local": {
      "variables": {
          "system": {
              "dim": "dum", 
              "foo": "bar"
          }
     }
  }, 
  "ansible_machine": "x86_64", 
...
```

# Usar el resultado de una tarea como variable

Los [resultados de una tarea](http://docs.ansible.com/ansible/latest/common_return_values.html) durante la ejecución de un playbook también se pueden [registrar](http://docs.ansible.com/ansible/latest/playbooks_variables.html#registered-variables) dentro de una variable. Junto con los condicionales, esto permite que un playbook reaccione de una forma u otra en funcion de los resultados de las otras tareas.

Por ejemplo, necesitamos que el servicio httpd esté ejecutandose. Si el servicio no se ejecuta, todo el servidor debe apagarse inmediatamente para garantizar que no se produzcan corrupción en los datos. El playbook correspondiente verifica el servicio httpd, ignora los errores pero en su lugar analiza el resultado y apaga la máquina si el servicio no se puede iniciar:

```yaml
---
- name: register example
  hosts: all 
  sudo: yes
 
  tasks:
    - name: start service
      service: name=httpd state=started
      ignore_errors: True
      register: service_result
 
    - name: shutdown
      command: "shutdown -h +1m"
      when: service_result | failed
```

Otro ejemplo sería para eliminar el host del balanceador en caso de que el servidor web no esté disponible. O para verificar si la base de datos está disponible y de lo contrario cerrar inmediatamente el firewall frontal.

# Conclusión

Las variables son una característica muy poderosa que nos ayuda a enriquecer la funcionalidad de Ansible. Junto con los templates y el lenguaje Jinja2, las posibilidades son casi infinitas.

Tarde o temprano, cada administrador tendrá que dejar atrás los simples roles y playbooks y comenzar a sumergirse en variables, templates y loops para hacer la automatización del sistema aún más fácil y dinámica.

Espero que esta pequeña guia os pueda ser de utilidad.

Un saludo!

Miquel.


