---
title: Configuración de Windows para ser manejado con Ansible
layout: post
date: 2017-05-17 18:00:00
image: /assets/images/posts/2017/05/ansible-win.png
headerImage: true
tag:
- ansible
- automation
- devops
- windows
---

Buenos dias queridos lectores!

En el post de hoy vamos a ver como con unos sencillos pasos, podremos configurar nuestros servidores windows para que puedan ser manejados desde Ansible.

### Preparar servidores widows

Inicialmente será necesario configurar el [WinRM](https://msdn.microsoft.com/en-us/library/aa384426%28v=vs.85%29.aspx?f=255&MSPPError=-2147217396
) de tal forma que acepte conexiones desde nuestro nodo de control.

Los chicos de Ansible, se han currado un [script en PowerShell](https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1), con lo que solo con descargarlo y ejecutarlo ya tendremos esta parte configurada 

![WinRM]({{ site.imagesposts2017 }}/05/WinRM.png)

### Preparar servidor Ansible

Para ello, hay que instalar el gestor de paquetes de python-pip y todos los modulos necesarios, como pywinrm o kerberos:

```
$ yum install -y python-pip
$ pip install https://github.com/diyan/pywinrm/archive/master.zip#egg=pywinrm
$ yum -y install gcc python-devel krb5-devel krb5-workstation
$ pip install kerberos
```

### Crear inventario

Antes de crear o modificar nuestro fichero de inventario, deberemos crear las variables necesarias para conectarnos a nuestros windows, para ello, en el mismo directorio donde tengamos nuestro fiehero de inventario, crearemos la carpeta group_vars y el fichero de variables:

```
$ vim inventory/group_vars/windows.yml
```

Este fichero de variables deberá contener los siguientes datos:

```yaml
ansible_ssh_user: administrador
ansible_ssh_pass: MySuperSecretPass123!
ansible_ssh_port: 5986
ansible_connection: winrm
ansible_winrm_server_cert_validation: ignore
```

En nuestro fiechero de inventario, deberemos crear un bloque con el mismo nombre que el fichero de variables, en nuestro caso 'windows'

```ini
[windows]
demo01
demo02
demo03
```

### Comprobar

Para comprobar que podemos conectarnos sin problemas a nuestros Windows, podremos ejecutar el siguiente comando desde nuestro servidor Ansible:

```
$ curl -vk -d "" -u administrator:MySuperSecretPass123! http://myserver.ncora.local:5985/wsman
```
...y deberiamos ver una salida similar a esta:

![curl]({{ site.imagesposts2017 }}/05/curl.png)

### Enjoy

Si hemos seguido todos los pasos y ya tenemos nuesto entorno configurado para que pueda ser manejado con Ansible, no nos queda nada mas que empezar a ejecutar comandos sobre nuestra granja. De manera ad-hoc:

```
$ ansible -m win_ping -i inventory/servers windows -vvv

$ ansible -m win_file -a 'path=c:\\test.txt state=touch' -i inventory/servers windows

$ nsible -m win_updates -a 'category_names=SecurityUpdates' -i inventory/servers windows

$ ansible -m win_updates -a 'category_names=CriticalUpdates' -i inventory/servers windows
```

...o através de nuestros [playbooks y roles](https://miquelmariano.github.io/2017/04/roles-y-playbooks-Ansible/) pada dotar a nuestras tareas de mas complejidad

Recordad que hay una [extensa lista](http://docs.ansible.com/ansible/list_of_windows_modules.html) de módulos para windows que nos simplificarán mucho la vida a la hora de administrar nuestra granja.

Un saludo y hasta el próximo post

Miquel.