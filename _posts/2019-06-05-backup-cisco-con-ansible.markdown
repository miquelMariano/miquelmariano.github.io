---
title: Backup automático de switches Cisco con Ansible
date: '2019-06-05 00:00:00'
layout: post
image: 
   path: /assets/images/posts/2019/06/Cisco-and-Ansible-Happy.png
   thumbnail: /assets/images/posts/2019/06/Cisco-and-Ansible-Happy.png
headerImage: false
tag:
- cisco
- networking
- devops
- ansible
hidden: false
comments: true
o: "{{"
c: "}}"
---

Buenos días a tod@as!!

En el post de hoy, voy a dejaros un pequeño playbook que estoy utilizando para realizar backups automaticamente de algunas configuraciones de switches cisco, tanto de la gama Catalyst (IOS) como Nexus (NXOS)

Lo primero que necesitaremos es disponer del fichero de inventario correspondiente, con todas las IPs y variables que necesitaremos mas adelante en el playbook.

### Inventario

```
all:vars]
ansible_connection=local

[CPD-1:vars]
username=admin
password=MySuperSecretPassword
backup_folder=/etc/ansible/00-backups-nexus/
cisco_os=nxos

[CPD-2:vars]
username=admin
password=MySuperSecretPassword
backup_folder=/etc/ansible/00-backups-nexus/
cisco_os=nxos

[CPD-3:vars]
username=admin
password=MySuperSecretPassword
backup_folder=/etc/ansible/00-backups-nexus/
cisco_os=nxos

[CPD-4:vars]
username=admin
password=MySuperSecretPassword
backup_folder=/etc/ansible/00-backups-catalyst/
cisco_os=ios

[CPD-1]
NX1-CPD1 host=10.30.30.76
NX2-CPD1 host=10.30.30.75

[CPD-2]
URNX01 host=10.30.30.110
URNX02 host=10.30.30.111
URNX03 host=10.30.30.112
URNX04 host=10.30.30.113

[CPD-3]
CPD3-N5K01 host=10.69.69.220
CPD3-N5K02 host=10.69.69.221
CPD3-N5K01 host=10.69.69.120
CPD3-N5K02 host=10.69.69.121

[CPD-4]
CONTROL01 host=10.30.30.181
```

### ¿Qué son estas variables?

En este inventario, tendremos que definir las siguientes variables:

- `host` La IP de management del SW

- `username` Usuario con privilegios para ejecutar comandos

- `password` Contraseña del usuario proporcionado en la variable anterior

- `backup_folder` Ruta que se creará y donde se almacenaran los ficheros con la información que devuelvan los comandos

- `cisco_os` SO que tienen nuestros SW, utilizaremos esta variable como condicional para ejecutar comandos ios o nxos.    

En mi caso, el fichero de inventario se llama `cisco` (lo sé, soy muy original..)
{: .notice}

### El playbook

A continuacion os paso el playbook `cisco_backup.yml` e intento explicar que hace cada play:

```yaml
---

- hosts: "{{ page.o }} sw {{ page.c }}"
  gather_facts: no
  ignore_errors: yes
  serial: 1
  vars:
    creds:
      host: "{{ page.o }} host {{ page.c }}"
      username: "{{ page.o }} username {{ page.c }}"
      password: "{{ page.o }} password {{ page.c }}"
  tasks:
    - name: Create root directory if don't exist
      file:
        path: "{{ page.o }} backup_folder {{ page.c }}"
        state: directory
        mode: 0755
    
    - name: Create individual device folder if don't exist
      file:
        path: "{{ page.o }} backup_folder {{ page.c }}{{ page.o }} inventory_hostname {{ page.c }}"
        state: directory
        mode: 0755

    - name: Register timestamp variable
      local_action: command date +%Y%m%d-%H:%M
      register: timestamp

    - name: Execute IOS commands
      ios_command:
        provider: "{{ page.o }} creds {{ page.c }}"
        commands: "{{ page.o }} item  {{ page.c }}"
      register: commands_output
      with_items:
        - show run
        - write
        - show vlan
        - show interfaces status
        - show etherchannel summary
        - show logging
        - show version
        - show spanning-tree
        - show spanning-tree blockedports
      when: 
        - cisco_os == 'ios'
    
    - name: Create IOS command folder if don't exist
      file:
        path: "{{ page.o }} backup_folder {{ page.c }}{{ page.o }} inventory_hostname {{ page.c }}/{{ page.o }} commands_output.results[item].item {{ page.c }}"
        state: directory
        mode: 0755
      with_items:
        - 0
        - 1
        - 2 
        - 3
        - 4
        - 5
        - 6
        - 7
        - 8
      when:
        - cisco_os == 'ios'
    
    - name: Save IOS command output on destination file
      copy:
        content: "{{ page.o }} commands_output.results[item].stdout[0] {{ page.c }}"
        dest:  "{{ page.o }} backup_folder {{ page.c }}{{ page.o }} inventory_hostname {{ page.c }}/{{ page.o }} commands_output.results[item].item {{ page.c }}/{{ page.o }} inventory_hostname {{ page.c }}_{{ page.o }} commands_output.results[item].item {{ page.c }}_{{ page.o }} timestamp.stdout {{ page.c }}.txt"
      with_items:
        - 0
        - 1
        - 2
        - 3
        - 4
        - 5
        - 6
        - 7
        - 8 
      when:
        - cisco_os == 'ios'


    - name: Execute NXOS commands
      nxos_command:
        provider: "{{ page.o }} creds {{ page.c }}"
        commands: "{{ page.o }} item  {{ page.c }}"
      register: commands_output
      with_items:
        - show run
        - show vlan
        - show interface status
        - show interface brief
        - show port-channel summary
        - show vpc
        - show vpc peer-keepalive
        - show logging last 100
        - copy r s
        - show version
        - show spanning-tree
        - show spanning-tree blockedports
        - show vpc consistency-parameters global
        - show cdp neighbors
        - show flogi database
        - show zoneset active
        - show fcdomain vsan 13 #Fabric1 URNIETA
        - show fcdomain vsan 24 #Fabric2 URNIETA
        - show fcdomain vsan 10 #Fabric1 TA-SA
        - show fcdomain vsan 20 #Fabric2 TA-SA
      when: 
        - cisco_os == 'nxos'

    - name: Create NXOS command folder if don't exist
      file:
        path: "{{ page.o }} backup_folder {{ page.c }}{{ page.o }} inventory_hostname {{ page.c }}/{{ page.o }} commands_output.results[item].item {{ page.c }}"
        state: directory
        mode: 0755
      with_items:
        - 0
        - 1
        - 2
        - 3
        - 4
        - 5
        - 6
        - 7
        - 8
        - 9
        - 10
        - 11
        - 12
        - 13
        - 14
        - 15
        - 16
        - 17
        - 18
        - 19
      when:
        - cisco_os == 'nxos' 

    - name: Save NXOS command output on destination file
      copy:
        content: "{{ page.o }} commands_output.results[item].stdout[0] {{ page.c }}"
        dest:  "{{ page.o }} backup_folder {{ page.c }}{{ page.o }} inventory_hostname {{ page.c }}/{{ page.o }} commands_output.results[item].item {{ page.c }}/{{ page.o }} inventory_hostname {{ page.c }}_{{ page.o }} commands_output.results[item].item {{ page.c }}_{{ page.o }} timestamp.stdout {{ page.c }}.txt"
      with_items:
        - 0
        - 1 
        - 2
        - 3
        - 4
        - 5
        - 6
        - 7
        - 8
        - 9
        - 10
        - 11
        - 12
        - 13
        - 14
        - 15
        - 16
        - 17
        - 18
        - 19
      when:
        - cisco_os == 'nxos'
```

### ¿Qué hace cada play?

- `Create root directory if don't exist`  Nos creará la carpeta que utilizaremos como raíz para guardar los backups. La variable estará definida en el fichero de inventario.

- `Create individual device folder if don't exist`  En caso de que no exista, dentro del root directory, nos creará una carpeta con el nombre de cada SW

- `Register timestamp variable` Simplemente creará una variable para guardar una marca temporal

- `Execute IOS commands` Aquí es donde ejecutamos todos los comandos IOS sobre nuestros SW y guardamos los resultados en una variable.

- `Create IOS command folder if don't exist` Dentro de la carpeta de cada SW, crearemos otra carpeta con el nombre del comando ejecutado previamente.

- `Save IOS command output on destination file` Guardamos el valor de la variale (dónde está la salida de cada comando) en un fichero .txt en la carpeta formada por /root_dorectory/nombre_sw/nombre_comando/nombre_sw_nombre_comando_timestamp.txt

- `Execute NXOS commands` Lo mismo que hemos explicado para IOS

- `Create NXOS command folder if don't exist` Lo mismo que hemos explicado para IOS

- `Save NXOS command output on destination file` Lo mismo que hemos explicado para IOS

### ¿Y ahora, cómo lo ejecuto?

Para ejecutar este playbook, lo llamaremos de la siguiente manera:

`ansible-playbook /etc/ansible/playbooks/cisco_backup.yml -i /etc/ansible/inventory/cisco -e "sw=nombre_sw_o_grupo"`

la variable `sw` hace raferencia a los equipos o grupos que hemos definido en el fichero de inventario. Por ejemplon `CPD-1`
{: .notice}

### ¿Y si lo quiero programar periodicamente?

Y si queremos programarlo, lo añadiremos al cron de nuestro usuario tal que así:

![crontab]({{ site.imagesposts2019 }}/06/crontab.png)

### Los resultados

Finalmente, así quedaria nuestra estructura de carpetas con los correspondientes .txt que guardan la salida de la ejecución de cada comando.

![output-backup-nexus]({{ site.imagesposts2019 }}/06/output-backup-nexus.png)

En un próximo post, veremos como visualizar facilmente esta información a través de un navegador web ;-)

Espero que os sirva.

Un saludo!

Miquel.


