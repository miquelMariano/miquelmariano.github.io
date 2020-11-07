---
title: Instalación de Ansible AWX sobre Centos 7 con Docker
date: '2020-01-15 00:00:00'
layout: post
tag:
- ansible
- devops
- automation
- awx
---

Buenos días a tod@os. Hace ya bastante tiempo, [escribí un post](https://miquelmariano.github.io/2019/01/23/ansible-awx-instalation/) en dónde contaba cómo instalar AWX sobre Centos 7, utilizando paquetes RPM.

El proyecto Ansible AWX está en constante evolución y es por eso que continuamente es necesario actualizar nuestro entorno. No hay mas que echar un vistazo a todas las [releases](https://github.com/ansible/awx/releases) para darse cuenta de lo rápido que evoluciona.

Es por eso, que el post inicial se ha quedado un poco desfasado y en esta ocasión os mostraré cómo instalar Ansible AWX mediante Docker, que es una de las formas que recomiendan oficialmente. También veremos cómo hacer la actualización de versión y cómo migrar los datos de una instancia a otra.

## Instalar repositorio EPEL
```
yum install -y epel-release
```

## Instalar pre-requisitos de Ansible AWX:
```
yum install -y git gcc gcc-c++ nodejs gettext device-mapper-persistent-data lvm2 bzip2 python-pip yum-utils ansible python3 libselinux-python3 python36-docker
```

## Instalar Docker CE (Comunity Edition):
```
yum-config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce
systemctl enable --now docker.service
```

## Instalar Docker-Compose
```
pip3 install docker-compose
```

En caso de que recibamos algún tipo de error y no se instale correctamente, deberemos instalar una versión anterior, probar con el siguiente comando:

```
pip install docker-compose==1.23.2
```

## Instalando Ansible AWX on CentOS 7:

### Cambiamos el directorio de trabajo
```
cd /tmp
```

### Nos descargamos la última versión del repositorio oficial y la descomprimimos

``` 
LATEST_AWX=$(curl -s https://api.github.com/repos/ansible/awx/tags |egrep name |head -1 |awk '{print $2}' |tr -d '"|,')
curl -L -o ansible-awx-$LATEST_AWX.tar.gz https://github.com/ansible/awx/archive/$LATEST_AWX.tar.gz
tar xvfz ansible-awx-$LATEST_AWX.tar.gz
rm -f ansible-awx-$LATEST_AWX.tar.gz
```

Si queremos instalar cualquier otra version, simplemente tendremos que dar a la variable LATEST_AWX el valor de la versión que queramos instalar. [Aquí](https://github.com/ansible/awx/releases) encontrareis todas las releases disponibles.


### Entramos en la carpeta de instalación y lanzamos el deploy
```  
cd awx-$LATEST_AWX/installer
ansible-playbook -i inventory install.yml
```

### Comprobamos que los contenedores estén arrancados
```
docker ps
```

### Configuramos firewall
```
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
```

## Acceso al portal.

Para acceder a Ansible AWX, desde nuestro navegador favorito accederemos a `https://ip-de-mi-servidor/`

Las credenciales por defecto son:

Usuario: Admin
Passsword: Password.

![awx01]({{ site.imagesposts2020 }}/01/awx01.png)
![awx01]({{ site.imagesposts2020 }}/01/awx02.png)
![awx01]({{ site.imagesposts2020 }}/01/awx03.png)

### Actualizar version de Ansible AWX y migrar datos a otra instancia.

Para actualizar la versión de nuestra instancia de Ansible AWX, no existe un procedimiento cómo tal. El proceso para por destruir nuestros contenedores Docker y volver a generarlos con los binarios de la versión mas reciente siguiendo el anterior procedimiento.

Lo que sí existe, es un procedimiento para migrar los datos de una instancia de AWX a otra. Cosa que nos va a ir de lujo en cualquier actualización de versión.

En [este enlace](https://github.com/ansible/awx/blob/devel/DATA_MIGRATION.md
) encontrareis el procedimiento oficial, el cual básicemente explica cómo hacer un backup y luego un restore de la configuración de nuestro Ansible AWX.

## Instalación y configuración de Tower CLI
```
pip3 install ansible-tower-cli
tower-cli config username admin
tower-cli config password password
tower-cli config verify_ssl False
tower-cli config
```

Podreis encontrar información extensa sobre la configuración de Tower CLI en [este post](http://yallalabs.com/devops/how-to-install-configure-tower-cli-tool-ansible-tower-awx/)

## Backup de la configuración
```
tower-cli receive --tower-host http://192.168.6.156 --all >  /tmp/test.json
```

## Restore de la configuración
```
time tower-cli send --tower-host http://192.168.6.152 /tmp/test.json
```

## Bibliografía

Este procedimiento es el resultado de la recopilación de información de los siguientes posts:

[https://github.com/ansible/awx](https://github.com/ansible/awx)

[https://medium.com/swlh/ansible-awx-installation-5861b115455a](https://github.com/ansible/awx)

[https://ahmermansoor.blogspot.com/2019/09/install-ansible-awx-with-docker-compose-on-centos-7.html](https://github.com/ansible/awx)

[https://www.unixarena.com/2019/03/backup-restore-ansible-awx-tower-cli.html/](https://www.unixarena.com/2019/03/backup-restore-ansible-awx-tower-cli.html/)

Espero que os guste.

Un saludo!

Miquel.



