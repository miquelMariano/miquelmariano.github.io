---
title: ansible-vault o como ocultar datos sensibles en nuestros ficheros Ansible
date: '2017-06-23 00:00:00'
layout: post
date: 2017-06-23 00:00:00
image: /assets/images/posts/2017/01/ansible_logo.png
headerImage: true
tag:
- ansible
- devops
- automation
category: blog
author: miquelMariano
description: ansible-vault o como ocultar datos sensibles en nuestros ficheros Ansible
hidden: false
comments: true
---

Siguiendo con temática [Ansible](https://miquelmariano.github.io/tags/#ansible), en el post de hoy vamos a ver la funcionalidad de ansible-vault.

Esta [feature](http://docs.ansible.com/ansible/playbooks_vault.html#id4) lleva disponible desde la versión 1.5 y nos permite encriptar cualquier fichero dentro de la estructura de Ansible

De esta forma, podemos ocultar datos sensibles de nuestro entorno, como contraseñas, IPs, claves SSH...

En el ejemplo que voy a mostrar, vamos a encriptar un fichero de variables que contiene los datos de conexión a mi vCenter

Para crear el fichero ejecutamos `ansible-vault create myfile.yml` y lo protegemos con una contraseña:

```
$ ansible-vault create role/ESXi_reboot/vars/main.yml
$ New Vault password:
$ Confirm New Vault password:
```

Mi fichero contendrá las siguientes variables:

```yaml
---

vCenter_ip: 10.0.0.100
vCenter_user: ncoraadmin
vCenter_pass: MySuperSecretPass
```

Al estar encriptado, al hacer un `cat` o `vim` de este fichero, no será posible descifrar el contenido y mostrará una salida similar a esta

```
$ANSIBLE_VAULT;1.1;AES256
66366638383232353265383039363632326536376163373338306535333634623562346631383266
6463363161666265643532383265663933386262613333350a386665613631363766376532663863
39303539643939303839663134386530653734663835656238343434306636363433333337353962
3332623939303764360a393165346561386663303336356266626130653661303936636334353439
66313263383764393533313439303961666239656432343836316533366330393537376238633864
34633666373036353133636531343162306432626465376337643039633432313465623565333362
38616561316161393531333066633663616437343433396135343364356265303839366664626365
62323961393766663765343166383435646261343735333131336331666665636138346233393132
61373231343662306437303030623035393333636437663165383263383232393735
```

Para editarlo, necesitaremos otra vez del comando `ansible-vault edit myfile.yml` y nos pedira la contraseña de desencriptación

```
$ ansible-vault edit roles/ESXi_reboot/vars/main.yml
$ Vault password:
```

Para poder usar este fichero encriptado, dispondremos de 2 métodos:

Que nos pida credenciales en tiempo de ejecución

```
$ ansible-playbook playbooks/ESXi_config.yml  --ask-vault-pass
$ Vault password:
```

O pasarle por parámetro un fichero .txt que contiene unicamente la contraseña del fichero encriptado. Es importante que este fichero solo contenga una sola linea con la contraseña

```
$ ansible-playbook playbooks/ESXi_config.yml --vault-password-file ~/.vault_pass.txt
```


Un saludo

Miquel.