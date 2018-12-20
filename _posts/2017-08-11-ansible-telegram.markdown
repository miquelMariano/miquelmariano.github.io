---
title: Módulo de Telegram para Ansible
date: '2017-08-11 00:00:00'
layout: post
image: /assets/images/posts/2017/08/telegram-ansible.png
headerImage: true
tag:
- ansible
- devops
- automation
- telegram
category: blog
author: miquelMariano
description: Módulo de Telegram para Ansible
hidden: false
comments: true
---

Buenos días a tod@s!

El otro dia me enteré que desde la versión 2.2 de Ansible, es posible [integrar notificaciones con Telegram](https://docs.ansible.com/ansible/telegram_module.html)

Para ello, solo necesitamos disponer de un chatbot, que [en su día ya vimos como crear.](https://miquelmariano.github.io/2017/02/notificaciones-automaticas-con-telegram/)

La integración en un playbook seria con el siguiente código:

```yaml
---

- name: Test telegram module
  hosts: localhost
  connection: local
  tasks:
    - name: Send test message
      telegram:
        token: "bot304017237:AAHpKXZBaw_wOF3H-ryhWl3F3wqIVP_Zqf8"
        chat_id: 6343788
        msg: "Message sent from Ansible playbook :)"
        
```

Acuérdate de modificar tu `token` y tu `chat_id` si no quieres que las notificaciones me lleguen a mi :-)

Podrás encontrar mas info sobre Ansible, [aquí](https://miquelmariano.github.io/tags/#ansible)


Un saludo

Miquel.