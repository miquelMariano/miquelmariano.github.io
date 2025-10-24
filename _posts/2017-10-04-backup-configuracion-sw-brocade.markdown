---
title: Backup de la configuración en Brocade FC Switches
date: '2017-10-04 00:00:00'
layout: post
image: /assets/images/posts/2017/10/brocade-logo.png
headerImage: true
tag:
- backup
- brocade
- fabric
- san
- fc
---

Buenos días a tod@s!!!

En el breve post de hoy, veremos como de una forma sencilla podemos realizar un backup de la configuración de los switchs de nuestra SAN.

Para ello los switch Brocade ofrecen la posibilidad de hacer backup mediante scp o ftp. Vamos a ver como implementar los backups mediante el comando `configupload`.

En este ejemplo utilizaremos un FTP como repositorio para guardar el backup:

Si no teneis ningún servidor FTP en vuestra infraestructura, os animo que visiteis [este post](https://miquelmariano.github.io/2017/07/xlight-FTP) donde explico como montar uno "portable"
{: .notice}

```ssh
SW01:admin> configupload
Protocol (scp or ftp) [ftp]: scp
Server Name or IP Address [host]: 192.168.6.38
User Name [user]: brocade
File Name [config_SW01.txt]:

brocade@192.168.6.38's password:

configUpload complete: All config parameters are uploaded
SW01:admin> exit
```

Como veis, no tiene ningún tipo de complicación y podremos hacer backups de forma manual de nuestros switches.


Espero que os sea de utilidad.
Gracias por compartir

Un saludo

Miquel.

P.D. Los que me conoceis, sabeis que no me suelo conformar con "hacer" las cosas "manualmente", así que en breve, os enseñaré [cómo automatizar esta tarea](https://miquelmariano.github.io/2019/04/automatizar-backup-configuracion-sw-brocade) y que periodicamente se ejecute un backup de nuestra configuración ;-)


