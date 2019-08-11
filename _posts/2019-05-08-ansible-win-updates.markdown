---
title: Comprobar actualizaciones de windows con Ansible
date: '2019-05-08 00:00:00'
layout: post
image: /assets/images/posts/2019/05/ansible-win.png
tag:
- automation
- devops
- ansible
- windows
- updates
o: "{{"
c: "}}"
---

Buenos dias a tod@as!!

Hace ya tiempo, [en este post](https://miquelmariano.github.io/2017/05/ansible-windows-managed-nodes), vimos como configurar nuestros servidores windows para ser manejados con Ansible.

Hoy os voy a compartir un playbook que he ideado para poder comprobar fácilmente el estado de las actualizaciones de windows en nuestros servidores windows.

En este ejemplo, en mi fichero de inventario he añadido los servidores que quiero comprobar:

```
[dc]
formacion-dc01
formacion-dc02
```

También es importante añadir las credenciales, tal como explicaba en el [post anterior](https://miquelmariano.github.io/2017/05/ansible-windows-managed-nodes)

```
[root@ansible01 /etc/ansible]# cat inventory/group_vars/dc.yml
ansible_ssh_user: administrador
ansible_ssh_pass: my_pass
ansible_ssh_port: 5986
ansible_connection: winrm
ansible_winrm_server_cert_validation: ignore
```

Antes de ejecutar cualquier playbook, es conveniente verificar que la conectividad con nuestros servidores está correcta:

```
[root@ansible01 /etc/ansible]# ansible -m win_ping -i inventory/servers dc

formacion-dc01 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
formacion-dc02 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
[root@miquel-ansible01 /etc/ansible]#
```

Y aqui va el código del playbook:

```yaml
---
##EXAMPLE:  ansible-playbook playbooks/win_update.yml -i inventory/servers -e "servers=dc install_updates=false"

##############################################################################
## Play 1   Search-only, return list of found updates (if any).
##############################################################################
- hosts: "{{ page.o }} servers {{ page.c }}"
  tasks:
    - name: Search-only, return list of found updates (if any).
      win_updates:
        category_names:
          - SecurityUpdates
          - CriticalUpdates
          - UpdateRollups
        state: searched
      register: list_of_found_updates

    - debug:
        var: list_of_found_updates

##############################################################################
### Play 2   Send info with telegram
##############################################################################
- hosts: localhost
  connection: local
  tasks:
    - name: Send telegram notification
      telegram:
        token: 304017237:AAHpKXZBaw_wOF3H-ryhWl3F3wqIVP_Zqf8
        chat_id: 6343788
        msg: Host "{{ page.o }} hostvars[item].inventory_hostname {{ page.c }}" >> "{{ page.o }} hostvars[item].list_of_found_updates.found_update_count {{ page.c }}" updates found.
      with_items:
        -  "{{ page.o }} groups[servers] {{ page.c }}"
      ignore_errors: yes


##############################################################################
#### Play 3    Install all security, critical, and rollup updates when install_updates is true
###############################################################################
- hosts: "{{ page.o }} servers {{ page.c }}"
  tasks:
    - name: Install all security, critical, and rollup updates
      win_updates:
        category_names:
          - SecurityUpdates
          - CriticalUpdates
          - UpdateRollups
        reboot: yes
      when:
          - install_updates == true
```

La salida será algo similar a esto:

Prestar especial atencion en las variables pasadas a la hora de ejecutar el playbook. Definir la variable install_updates a true provocará que se instalen los parches encontrados.
{: .notice}

```
[root@ansible01 /etc/ansible]# ansible-playbook playbooks/win_update.yml -i inventory/servers -e  "servers=dc install_updates=false"

PLAY [dc] ***************************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************
ok: [formacion-dc01]
ok: [formacion-dc02]

TASK [Search-only, return list of found updates (if any).] **************************************************************************************************************************
ok: [formacion-dc01]
ok: [formacion-dc02]

TASK [debug] ************************************************************************************************************************************************************************
ok: [formacion-dc01] => {
    "list_of_found_updates": {
        "changed": false,
        "failed": false,
        "filtered_updates": {},
        "found_update_count": 0,
        "installed_update_count": 0,
        "reboot_required": false,
        "updates": {}
    }
}
ok: [formacion-dc02] => {
    "list_of_found_updates": {
        "changed": false,
        "failed": false,
        "filtered_updates": {},
        "found_update_count": 0,
        "installed_update_count": 0,
        "reboot_required": false,
        "updates": {}
    }
}

PLAY [localhost] ********************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************
ok: [localhost]

TASK [Send telegram notification] ***************************************************************************************************************************************************
changed: [localhost] => (item=formacion-dc01)
changed: [localhost] => (item=formacion-dc02)

PLAY [dc] ***************************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************
ok: [formacion-dc02]
ok: [formacion-dc01]

TASK [Install all security, critical, and rollup updates] ***************************************************************************************************************************
skipping: [formacion-dc01]
skipping: [formacion-dc02]

PLAY RECAP **************************************************************************************************************************************************************************
formacion-dc01             : ok=4    changed=0    unreachable=0    failed=0
formacion-dc02             : ok=4    changed=0    unreachable=0    failed=0
localhost                  : ok=2    changed=1    unreachable=0    failed=0

[root@ansible01 /etc/ansible]#
```

Como habeis podido observar en el play 3, he añadido una parte de [notificaciones con telegram](https://miquelmariano.github.io/2017/08/ansible-telegram), que quedaria de la siguiente manera.

![ansible-telegram]({{ site.imagesposts2019 }}/05/ansible-telegram.png){: .align-center}


Espero que os guste.
Un saludo!

Miquel.


