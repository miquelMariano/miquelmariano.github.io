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
category: blog
author: miquelMariano
description: Backup & Restore de la configuración de un host ESXi
hidden: false
comments: true
---

Buenos dias a tod@as!!

El post de hoy es corto, pero tremendamente útil si vamos a manipular a bajo nivel un ESXi y no tenemos la certeza de que las operaciones realizadas den su resultado.

Se trata de poder hacer de manera sencilla un backup de la configuración de un ESXi y en caso de necesidad, (esperemos que no) poder hacer la restauración.

El método que aquí os enseño está basado en comandos PowerCLI y básicamente son dos pasos:

* Realizar el backup a un directorio externo de nuestro PC:

```powershell
Get-VMHostFirmware -VMHost $host -BackupConfiguration -DestinationPath C:\HostBackups
```

* Recuperar la configuración del ESXi en base al fichero de backup que previamente hemos extraido:

```powershell
Set-VMHostFirmware -VMHost $Host -Restore -SourcePath c:\Hostbackups\backupfile.tgz -HostUser user -HostPassword password
```

> Hay que decir que para hacer el restore necesitaremos tener el ESXi operativo, es decir, si por cualquier motivo el ESXi no 
> arranca o no es accesible, deberemos reinstalaro y después hacer el Restore.

Espero que os sea de utilidad.

Un saludo!

Miquel.


