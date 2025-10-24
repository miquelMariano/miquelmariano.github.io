---
title: Programar backup automático en VCSA 6.5
date: '2017-08-25 00:00:00'
layout: post
image: /assets/images/posts/2017/08/vcenter-backup1.png
headerImage: true
tag:
- vmware
- vexpert
- vcenter
- vcsa
- devops
- automation
---

Buenos dias a tod@s!!

Hace varias semanas, publicamos un [#NcoraTutorial](https://miquelmariano.github.io/2017/03/backup-restore-vCenter-65/) sobre como hacer un backup de la configuración de un vCenter Appliance 6.5

En aquella ocasión, el procedimiento era algo manual ya que se hacia a través de la propia GUI de la administración del appliance.

En esta ocasión, veremos como podemos automatizar ese procedimiento y hacer backup de forma periódica de nuestro VCSA 6.5 usando un [FTP externo](https://miquelmariano.github.io/2017/07/xlight-FTP/)


1) Nos conectamos por SSH a nuestro VCSA 6.5 y crearemos/configuraremos el fichero que contendrá el código. Se podrá ubicar en la ruta que creamos conveniente, en mi caso `/usr/local/bin`.

```
# Commands:
vi /usr/local/bin/vCSA-Backup.sh

# Make the file executable
chmod u+x /usr/local/bin/vCSA-Backup.sh

# Make it only accessible by root
chmod g-rxw /usr/local/bin/vCSA-Backup.sh
chmod o-rxw /usr/local/bin/vCSA-Backup.sh
```

2) Copiaremos el código del [script](https://miquelmariano.github.io/vCSA-Backup) en nuestro fichero

3) Realizamos el primer backup

```
/usr/local/bin/vCSA-Backup.sh
```

...la salida del script será similar a la siguiente:

```
root@vcenter65 [ /tmp ]# ./vCSA-Backup.sh
{"value":"6b0faced3684839d9107f3e2b57a52e7"}Backup job id: 20170717-132629-5318154
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   234    0   234    0     0   3957      0 --:--:-- --:--:-- --:--:--  4034
Backup job state: INPROGRESS
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   280    0   280    0     0   4695      0 --:--:-- --:--:-- --:--:--  4745
Backup job state: INPROGRESS
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   330    0   330    0     0   6201      0 --:--:-- --:--:-- --:--:--  6226
Backup job state: INPROGRESS
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   283    0   283    0     0   5384      0 --:--:-- --:--:-- --:--:--  5442
Backup job state: SUCCEEDED

Backup job completion status: SUCCEEDED
root@vcenter65 [ /tmp ]#

```

4) Configuramos el cron para automatizar periódicamente el backup. Por ejemplo, cada dia a las 2am 

```
#Command:
crontab -e

# Press 'i' to goto insert mode
# Insert you task into crontab
0 2 * * * /usr/local/bin/vCSA-Backup.sh

# Press ':wq'
# Press ENTER
```

Es muy probable, que en el fichero `/var/log/messages` nos encontremos con una salida similar a esta:

```ssh
2017-07-18T03:15:01.417255+00:00 vcenter65 crond[44381]: PAM _pam_load_conf_file: unable to open config for password-auth
2017-07-18T03:15:01.417364+00:00 vcenter65 crond[44381]: PAM _pam_load_conf_file: unable to open config for password-auth
2017-07-18T03:15:01.417418+00:00 vcenter65 crond[44381]: PAM _pam_load_conf_file: unable to open config for password-auth
2017-07-18T03:15:01.417482+00:00 vcenter65 crond[44381]: (root) PAM ERROR (Permission denied)
2017-07-18T03:15:01.417554+00:00 vcenter65 crond[44381]: (root) FAILED to authorize user with PAM (Permission denied)
```

Esto es debido a que en el fichero `/etc/pam.d/crond` hay 3 referencias a “password-auth”, sin embargo no hay ningún archivo en /etc/pam.d llamado "password-auth"

Para solucionarlo, hay que cambiar “password-auth” por “system-auth”, quedando el fichero de la siguiente forma:

```ssh
#
# The PAM configuration file for the cron daemon
#
#
# No PAM authentication called, auth modules not needed
account    required   pam_access.so
account    include    system-auth
session    required   pam_loginuid.so
session    include    system-auth
auth       include    system-auth
~

```

Espero que os sea de utilidad :)


Un saludo!

Miquel.



*[referencia](https://vm.knutsson.it/2017/01/vmware-vcsa-6-5-scheduled-backup/)