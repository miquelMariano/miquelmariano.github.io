---
title: Ansible - Ejecutar tarea sólo si la acción previa ha cambiado
date: '2018-03-21 00:00:00'
layout: post
image: /assets/images/posts/2018/03/ansible.png
headerImage: true
tag:
- ansible
- automation
---

Buenos dias a tod@as!

En el post de hoy, vamos a ver como conseguir que Ansible ejecute acciones sólo cuando la ejecución de otras acciones haya cambiado.

Acordaros que ansible trabaja con la propiedad de [idempotencia,](https://es.wikipedia.org/wiki/Idempotencia) la cual asegura que ninguna operación se realizará una vez el sistema haya alcanzado el estado deseado. Teniendo esto en cuenta, se podria dar el caso de que quisieramos reiniciar un servicio después de modificar un fichero de configuración. El fichero una vez modificado, ya no se cambiaria más en futuras ejecuciones del playbok, pero sin embargo el servicio, cada vez se reiniciaria.

Por ejemplo, un playbook que cambia el nivel de debug en un servidor ESXi y luego reinicia el servicio "vpxa". Sólo queremos que reinicie el servicio en caso de que realmente se haya cambiado el nivel de debug.

Usando la opción `register` podemos, registrar el resultado de una tarea y, en otra tarea, podemos acceder a esta variable y usarla con `when` para que se ejecute si la acción anterior cambió el estado de las máquinas:

```yaml
- hosts: esxi
  user: root
  serial: 1
  tasks:
     - name: Replace vpxa log level
       replace:
          path: /etc/vmware/vpxa/vpxa.cfg
          regexp: '<level>verbose</level>'
          replace: '<level>info</level>'
          backup: yes
       register: replace_status

     - name: Restart vpxa agent
       shell: /etc/init.d/vpxa restart
       when: replace_status.changed
```

Espero que os sea de utilidad.

Hasta el próximo post

Un saludo!

Miquel.