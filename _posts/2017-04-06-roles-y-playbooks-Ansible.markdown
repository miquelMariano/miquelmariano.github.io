---
title: ¿Como se usan los roles y playbooks en Ansible?
layout: post
date: 2017-04-06 14:00:00
image: /assets/images/posts/2017/01/ansible_logo.png
headerImage: true
tag:
- ansible
- devops
- automation
---


Queridos lectores del blog, como lo prometido es deuda, aquí tenéis la continuación de mi último post, [Ansible for dummies](https://miquelmariano.github.io/ansible-for-dummies).

En esta ocasión, vamos a profundizar un poco más en la utilización de playbooks y roles para ser mas ágiles en el control de la configuración de nuestra granja de servidores.

Como muchos ya sabréis, Ansible se puede utilizar en modo Ad-Hoc o mediante playbook. El modo ad-hoc nos permite ejecutar directamente comandos en una sola línea sobre nuestros hosts utilizando los módulos que ya tiene Ansible. Este modo se utiliza cuando queremos efectuar una acción simple sobre nuestros hosts, como es hacer un reinicio, verificar la conectividad con nuestro servidor de Ansible o simplemente realizar un ping a los miembros de un inventario.

![ansible-ping]({{ site.imagesposts2017 }}/03/ansible-ping.png)

Otra cosa es querer manejar las configuraciones o realizar despliegues sobre nuestra granja. En este caso, los playbooks son mucho mas atractivos 😉

Los playbooks estan escritos en formato YAML y pueden estar en un solo fichero o siguiendo un modelo estructurado. Cada playbook puede contener uno o más “plays”, que son los que nos van a ayudar a manejar/configurar nuestros diferentes hosts.

![automate-all-things]({{ site.imagesposts2017 }}/03/automate_all_the_things.jpeg)

Aquí un ejemplo de playbook con una estructura simple en un mismo fichero.

``` yaml
--- 

- hosts: webservers 
  vars: 
     http_port: 80 
     max_clients: 200 
     remote_user: root 
  tasks: 
    - name: ensure apache is at the latest version 
      yum: pkg=httpd 
      state=latest 
    - name: write the apache config file 
      template: 
        src=/srv/httpd.j2 
        dest=/etc/httpd.conf 
        notify: 
          - restart apache 
    - name: ensure apache is running service: 
      name=httpd state=started
```

En el ejemplo de arriba hemos creado toda la configuración en un mismo fichero. Esto esta bien si escribimos el playbook para un único despliegue o la configuración es simple. Sin embargo, para escenarios mas complejos es mejor utilizar roles, donde podremos moldear más a nuestro gusto las configuraciones.

Ejemplo de playbook llamando a un role:


``` yaml
---

- hosts: all 
  sudo: yes 
  roles: 
    - { role: apache }
```

# *Roles*

A medida que vamos añadiendo funcionalidad y complejidad a nuestros playbooks, cada vez se hace más difícil manejarlo con un solo fichero. Los roles, nos permiten crear un playbook con una mínima configuración y definir toda la complejidad y lógica de las acciones a más bajo nivel.

Según la propia documentación de Ansible: “Roles in Ansible build on the idea of include files and combine them to form clean, reusable abstractions – they allow you to focus more on the big picture and only dive down into the details when needed.”

Para la correcta utilización de los roles, es necesario crear toda una estructura de carpetas y subcarpetas donde iremos depositando nuestra configuración. Tenemos dos opciones para crear estas carpetas, de forma manual o utilizando ansible-galaxy. [Ansible-galaxy](https://galaxy.ansible.com/) es un sitio para la búsqueda, la reutilización y el intercambio de roles desarrollados por la comunidad.

Para crear un role mediante ansible-galaxy, ejecutamos el siguiente comando dentro de /etc/ansible/roles:

```
ansible-galaxy init webservers
```

Una vez creado el role, tendremos la siguiente estructura. Para entender bien los roles es importante entender dicha estructura:

![ansible-role-structure]({{ site.imagesposts2017 }}/03/ansible-role-structure.png)

+ **Defaults:** Este directorio debe contener un fichero llamado main.yml que contendrá información de las variables globales utilizadas por este role; como el directorio de instalación de apache o el puerto de escucha por defecto, entre otros.

```yaml
--- 

webservers_dir: /var/www/html 
webservers_port: 80

```

+ **Files:** El directorio files contiene los archivos necesarios para un despliegue. Los ficheros del directorio files no se pueden modificar y serán copiados tal cual a los hosts remotos, por ejemplo, un .rpm, el código fuente de una aplicación web, etc.

+ **Templates:** Los templates son parecidos a los files, pero éstos admiten modificaciones. Podemos pasar variables de configuración al template para que éste lo aplique a los hosts. Ansible admite variables en los playbooks y templates utilizando el sistema [Jinja2](http://jinja.pocoo.org/docs/dev/).

```yaml
---

template: 
    src=httpd.conf.j2 
    dest=/etc/httpd/conf/httpd.conf

```

+ **Tasks:** Cada play contiene múltiples tasks y cada task realiza una serie de acciones. Las tareas son básicamente la ejecución de módulos con argumentos específicos. Estos argumentos pueden ser variables definidas previamente. Las tareas se ejecutan en orden contra todos los hosts que cumplan el patrón definido. Las tasks pueden estar definidas en el fichero main.yml o en cualquier otro fichero .yml siempre y cuando se haga referencia a ellos desde el main.yml.

```yaml
---
# These tasks install http and the php modules. 

- name: Install http and php etc 
  yum: 
    name={{ item }} 
    state=present 
  with_items: 
    - httpd 
    - php 
    - php-mysql 
    - git 
    - libsemanage-python 
    - libselinux-python
```

+ **Meta:** Estos archivos describen el entorno (SO, versión, etc), autor, licencia, y también establece las dependencias del role.

```yaml
--- 

dependencies: 
- { role: apt }
```

+ **Vars:** Tiene la misma función que defaults y se usa para almacenar variables. Además, las variables definidas en vars tienen mas prioridad que las variables definidas bajo defaults. Estas definiciones de variables pueden ser llamadas desde las tasks, en templates, etc.


+ **Handlers:** Como ya explicaba en el primer post, los módulos están pensados para mantener la [idempotencia](https://es.wikipedia.org/wiki/Idempotencia), es decir, que una acción no se ejecute mas veces una vez alcanzado el estado deseado. Mediante los “handlers” podemos utilizar la etiqueta “notify” y estas acciones se disparan al final de cada bloque de tareas en los playbooks. Solo se activan una vez, incluso si un mismo “notify” está definido en varias tareas diferentes.

Por ejemplo, varias tareas pueden requerir que Apache se reinicie debido al cambio de archivos de configuración. Pero utilizando handlers, Apache solo se reiniciará una vez y al final con el objetivo de evitar reinicios innecesarios.

Llamada a un handler desde un playbook:

```yaml
--- 
# file: roles/common/handlers/main.yml 
- name: restart httpd 
  service: 
    name=httpd 
    state=restarted
```

En resumen, los handlers son tareas definidas de forma muy similar a las definidas en las tasks e identificadas por un nombre único y básicamente son utilizados para reiniciar servicios sin provocar reinicios innecesarios. Para ejecutar un handler es necesario notificarlo con el tag "notify"; de este modo, solo se ejecutará una vez se hayan completado todas las tareas.

# *Ejecutando un  Playbook*

Par ejecutar un playbook simplemente tendremos que utilizar el comando ansible-playbook + nombre del playbook:

```
ansible-playbook deploy_apache.yml
```

Por defecto, el playbook se ejecutará sobre el fichero hosts predeterminado. Si queremos ejecutarlo sobre otro inventario, simplemente tendremos que añadir el parámetro -i y hacer referencia al nuevo fichero de inventario:

```
ansible-playbook –i production deploy_apache.yml
```

Eso es todo por hoy. 

Un saludo!


Miquel. 