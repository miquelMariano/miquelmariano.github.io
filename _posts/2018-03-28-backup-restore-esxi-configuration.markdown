---
title: Backup & Restore de la configuración de un host ESXi
date: '2018-03-28 00:00:00'
layout: post
image: /assets/images/posts/2018/03/esxi-backup.jpeg
headerImage: true
tag:
- backup
- restore
- esxi
- vexpert
- powercli
---

Buenos dias a tod@as!!

El post de hoy es corto, pero tremendamente útil si vamos a manipular a bajo nivel un ESXi y no tenemos la certeza de que las operaciones realizadas den su resultado.

Se trata de poder hacer de manera sencilla un backup de la configuración de un ESXi y en caso de necesidad, (esperemos que no) poder hacer la restauración.

El método que aquí os enseño está basado en la linea de comando del ESXi, por lo que necesitaremos conectarnos por SSH

# Realizar backup de la configuración:

```ssh
vim-cmd hostsvc/firmware/backup_config
```

La salida del comando nos indicará la ruta desde donde nos podremos descargar el fichero `http://IP_or_FQDN_ESXi/downloads/123456/configBundle-xx.xx.xx.xx.tgz`. También podremos encontrar el fichero en `/scratch/downloads`
{: .notice}

# Recuperar la configuración del ESXi:

### 1 - Tendremos que poner el host en modo mantenimiento

```ssh
vim-cmd hostsvc/maintenance_mode_enter
```

### 2 - Copiamos el fichero de backup en el sistema de ficheros del ESXi mediante SCP (por ejemplo)

### 3 - Ejecutamos el siguiente comando de recuperación

```ssh
vim-cmd hostsvc/firmware/restore_config 1 /tmp/configBundle.tgz
```

Para hacer un restore es necesario que el "build number" del ESXi coincida con el "build number" que tiene el fichero de backup. En caso de haber reinstalado el ESXi y que éste no sea el mismo, forzaremos la recuperación con la opción `1`
{: .notice}

Información extraida de la [KB oficial](https://kb.vmware.com/s/article/2042141?)

Espero que os sea de utilidad.

Un saludo!

Miquel.


