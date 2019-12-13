---
title: Creando un entorno JMP con VMware Horizon - Parte 5 - Instalación y configuración Replica Server (opcional)
date: '2019-12-13 00:00:00'
layout: post
image: /assets/images/posts/2019/07/horizon-logo.png
tag:
- vmware
- horizon
- vexpert
- euc
- desktop
- mobility
permalink: /jmp-part5/

---

En la siguiente serie de posts, pretendo explicar durante las próximas semanas el paso a paso para instalar un entorno JMP (Just-in-Time Management Platform) utilizando VMware Horizon 7 Instant Clones + App Volumes + VMware UEM (User Environment Manager) 

- [Part 1: Introducción]({{ site.url }}/jmp-part1/)
- [Part 2: Preparar servidor SQL]({{ site.url }}/jmp-part2/)
- [Part 3: Preparar Active Directory]({{ site.url }}/jmp-part3/)
- [Part 4: Instalación y configuración Connection Server]({{ site.url }}/jmp-part4/)
- [Part 5: Instalación y configuración Replica Server (opcional)]({{ site.url }}/jmp-part4/)
- Part 6: Instalación y configuración de Security Server (opcional)
- [Part 7: Instalación y configuración de UAG (opcional)]({{ site.url }}/jmp-part7/)
- Part 8: Instalación certificado (opcional)
- [Part 9: Preparar plantilla master para Instant Clone]({{ site.url }}/jmp-part9/)
- [Part 10: Configurar un pool de Instant Clone]({{ site.url }}/jmp-part10/)
- Part 11: Instalar App Volumes
- Part 12: Configuración inicial App Volumes
- Part 13: Crear nuestro primer App Stack
- Part 14: Trabajando con Writable Volumes
- Part 15: User Environment Manager Installation
- Part 16: Primeros pasos con UEM
- Part 17: Instalación y configuración JMP Server
- Part 18: Aprovisionamiento con JMP

# Instalación de un Réplica Server

Para la instalación de un Replica server, utilizaremos el mismo instalador que ya utilizamos para instalar el [primer Connection server]({{ site.url }}/jmp-part4/)

A partir de aquí, simplemente tendremos que seguir el instalador:

![replica1]({{ site.imagesposts2019 }}/09/replica1.png){: .align-center}
![replica2]({{ site.imagesposts2019 }}/09/replica2.png){: .align-center}
![replica3]({{ site.imagesposts2019 }}/09/replica3.png){: .align-center}

En este punto, es dónde indicaremos que vamos a instalar un réplica server:

![replica4]({{ site.imagesposts2019 }}/09/replica4.png){: .align-center}

Proporcionaremos el nombre de un connection server desde el cual queramos replicar:

![replica5]({{ site.imagesposts2019 }}/09/replica5.png){: .align-center}
![replica6]({{ site.imagesposts2019 }}/09/replica6.png){: .align-center}
![replica7]({{ site.imagesposts2019 }}/09/replica7.png){: .align-center}
![replica8]({{ site.imagesposts2019 }}/09/replica8.png){: .align-center}
![replica9]({{ site.imagesposts2019 }}/09/replica9.png){: .align-center}

Una vez finalizado, dese el Horizon Administrator, ya nos aparecerá nuestro nuevo servidor de conexión:

![replica10]({{ site.imagesposts2019 }}/09/replica10.png){: .align-center}

## Comprobación replicación

Al igual que un Active Directory, nuestra plataforma Horizon está basada en una ADAM database, por lo que con el siguiente comando, podremos comprobar el estado de la replicación:

```
repadmin.exe /showrepl localhost:389 DC=vdi,DC=vmware,DC=int
```

![replica11]({{ site.imagesposts2019 }}/09/replica11.png){: .align-center}

También podremos forzarla con este comando:

```
repadmin.exe /replicate localhost-FQDN:389 remote-host-FQDN:389 dc=vdi,dc=vmware,dc=int
```

![replica12]({{ site.imagesposts2019 }}/09/replica12.png){: .align-center}

Si quereis mas información, no dejeis de consultar [esta KB](https://kb.vmware.com/s/article/1021805)
{: .notice}

# Balanceo de carga con NLB de Windows Server

Hace ya tiempo, mi amigo Ricard Ibáñez [escribió un post](https://www.cenabit.com/2018/06/balancear-las-conexiones-en-horizon-view/) sobre varios métodos para balancear nuestros Connection Servers.

Y es que hay que recordar, que aunque tengamos bien configurados y replicados nuestros servidores, por defecto no se balancean las conexiones hacia ellos, es por eso que necesitaremos productos de terceros para conseguir ese balanceo.

![lb]({{ site.imagesposts2019 }}/09/uag0.png){: .align-center}

A continuación veremos cómo configurar el servicio NLB de Windows Server

## Instalar característica de NLB (Net Load Balancer)

Desde el menú de administración del servidor, nos iremos a la opción de "Agregar roles y características"

![nlb1]({{ site.imagesposts2019 }}/09/nlb1.png){: .align-center}
![nlb2]({{ site.imagesposts2019 }}/09/nlb2.png){: .align-center}
![nlb3]({{ site.imagesposts2019 }}/09/nlb3.png){: .align-center}
![nlb4]({{ site.imagesposts2019 }}/09/nlb4.png){: .align-center}
![nlb5]({{ site.imagesposts2019 }}/09/nlb5.png){: .align-center}

En el menú de Características, marcaremos la opción de "Equilibrio de carga de red"

![nlb6]({{ site.imagesposts2019 }}/09/nlb6.png){: .align-center}
![nlb7]({{ site.imagesposts2019 }}/09/nlb7.png){: .align-center}
![nlb8]({{ site.imagesposts2019 }}/09/nlb8.png){: .align-center}
![nlb9]({{ site.imagesposts2019 }}/09/nlb9.png){: .align-center}

Una vez finalizao el asistente, en la carpeta de Herramientas administrativas, nos aparecerá el Administrador de NLB:

![nlb9-1]({{ site.imagesposts2019 }}/09/nlb9-1.png){: .align-center}

## Crear nuevo clúster NLB

![nlb10]({{ site.imagesposts2019 }}/09/nlb10.png){: .align-center}
![nlb11]({{ site.imagesposts2019 }}/09/nlb11.png){: .align-center}
![nlb12]({{ site.imagesposts2019 }}/09/nlb12.png){: .align-center}

**NOTA:** Antes de proceder a continuar con el asistente, será neceario crear una entrada en nuestro DNS y que luego introduciremos en "Nombre completo de Internet"
{: .notice}

![nlb13]({{ site.imagesposts2019 }}/09/nlb13.png){: .align-center}
![nlb14]({{ site.imagesposts2019 }}/09/nlb14.png){: .align-center}
![nlb15]({{ site.imagesposts2019 }}/09/nlb15.png){: .align-center}

## Agregar nuevo miembro al clúster NLB

![nlb16]({{ site.imagesposts2019 }}/09/nlb16.png){: .align-center}
![nlb17]({{ site.imagesposts2019 }}/09/nlb17.png){: .align-center}
![nlb18]({{ site.imagesposts2019 }}/09/nlb18.png){: .align-center}
![nlb19]({{ site.imagesposts2019 }}/09/nlb19.png){: .align-center}
![nlb20]({{ site.imagesposts2019 }}/09/nlb20.png){: .align-center}

Una vez terminada la configuración y tengamos nuestro clúster activo, ya nos podremos conectar a nuestro entorno Horizon a través del balanceador de carga.

![nlb21]({{ site.imagesposts2019 }}/09/nlb21.png){: .align-center}

Espero que os sirva.

Nos vemos en el próximo post: [Part 6: Instalación y configuración de Security Server]({{ site.url }}/jmp-part6/)

Un saludo!

Miquel.


