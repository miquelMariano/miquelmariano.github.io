---
title: Lighttpd para visualizar ficheros de texto
date: '2018-02-28 00:00:00'
layout: post
image: 
  path: /assets/images/posts/2019/06/Cisco-and-Ansible-Happy.png
  thumbnail: /assets/images/posts/2019/06/Cisco-and-Ansible-Happy.png
tag:
- vmware
- vsphere
- vexpert
- devops
- backtobasics

---

En el post de hoy, voy a dejaros un pequeño playbook que estoy utilizando para realizar backups automaticamente de algunas configuraciones de switches cisco, tanto de la gama Catalyst (IOS) como Nexus (NXOS)

Deshabilitar firewall | https://linuxize.com/post/how-to-stop-and-disable-firewalld-on-centos-7/
sudo systemctl stop firewalld
sudo systemctl disable firewalld

Instalar lighttpd | https://www.linuxhelp.com/how-to-install-lighttpd-web-server-on-centos-7
yum install lighttpd -y


Deshabilitar ipv6 en el fichero de configuración
server.use-ipv6 = "disable"

systemctl start lighttpd
systemctl enable lighttpd

Habilitar dir-listing en el fichero de configuración
server.dir-listing = "enable"
server.modules += ( "mod_auth" )

Editar mime para mostrar .yml como yaml
vim /etc/lighttpd/conf.d/mime.conf

Crear link simbolico de ansible en cd /var/www/lighttpd/ | https://kb.iu.edu/d/abbe
ln -s source_file myfile

Securizar: https://www.cyberciti.biz/tips/lighttpd-setup-a-password-protected-directory-directories.html



Espero que os sirva.

Un saludo!

Miquel.


