---
title: Reintentar tarea fallida en Ansible
date: '2019-07-17 00:00:00'
layout: post
image: /assets/images/posts/2019/07/ansible-retry2.png
tag:
- vmware
- vsphere
- vexpert
- devops
o: "{{"
c: "}}"

---

Muchas veces, cuando trabajamos con tareas de Ansible nos encontramos que en más de una ocasión, la acción falla.

Evidentemente, si este fallo es debido a una mala configuración del servidor o que Ansible no se encuentra con el estado esperado, tendremos que revisar qué está pasando para poder solucionaro.

En cambio, muchas otras veces, este error es temporal, o bien porque el servidor de destino está ocupado y no puede procesar la operación o simplemente porque se ha dado algún tipo de timeout y simplemente reintentando la tarea, ésta funcionará correctamente.

Para poder reintentar una tarea de Ansible de forma automática, necesitaremos registrar el resultado de la ejecución con `register: task_result`. Una vez tengamos esta variable, haremos los correspondientes reintentos `until: task_result.rc == 0`, con la opción `retries: xx` dónde `xx` será el número de intentos a hacer. También podemos poner la opción `delay: xx` para indicar cuanto tiempo dejará pasar entre intento y intento.

```yaml
---
- hosts: ESXi
  connection: local
  tasks:
    - name: Unmount datastores ESXi
      command: "{{ page.o }} item {{ page.c }}"
      register: task_result
      until: task_result.rc == 0
      retries: 3
      delay: 10
      with_items:
        - esxcli storage filesystem unmount -l IX_Simplex000_LDEV3000
        - esxcli storage filesystem unmount -l IX_Simplex001_LDEV3001
        - esxcli storage filesystem unmount -l IX_Simplex002_LDEV3002
        - esxcli storage filesystem unmount -l IX_Simplex003_LDEV3003
        - esxcli storage filesystem unmount -l IX_Simplex004_LDEV3004
```

Y éste, seria el comportamiento real de esta tarea:

![ansible-retry]({{ site.imagesposts2019 }}/07/ansible-retry.png)


Espero que os sirva.

Un saludo!

Miquel.


