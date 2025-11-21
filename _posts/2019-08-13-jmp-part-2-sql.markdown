---
title: Creando un entorno JMP con VMware Horizon - Parte 2 - Preparar servidor SQL
date: '2019-08-13 00:00:00'
layout: post
image: /assets/images/posts/2019/07/horizon-logo.png
tag:
- vmware
- horizon
- vexpert
- euc
- desktop
- mobility
permalink: /jmp-part2/

---

Buenos dias a tod@s!!

En la siguiente serie de posts, pretendo explicar durante las próximas semanas el paso a paso para instalar un entorno JMP (Just-in-Time Management Platform) utilizando VMware Horizon 7 Instant Clones + App Volumes + VMware UEM (User Environment Manager) 

- [Part 1: Introducción]({{ site.url }}/jmp-part1/)
- [Part 2: Preparar servidor SQL]({{ site.url }}/jmp-part2/)
- [Part 3: Preparar Active Directory]({{ site.url }}/jmp-part3/)
- [Part 4: Instalación y configuración Connection Server]({{ site.url }}/jmp-part4/)
- [Part 5: Instalación y configuración Replica Server (opcional)]({{ site.url }}/jmp-part5/)
- [Part 6: Instalación y configuración de UAG (opcional)]({{ site.url }}/jmp-part6/)
- [Part 7: Configuración de UAG en HA]({{ site.url }}/jmp-part7/)
- [Part 8: Instalación certificado (opcional)]({{ site.url }}/jmp-part8/)
- [Part 9: Preparar plantilla master para Instant Clone]({{ site.url }}/jmp-part9/)
- [Part 10: Configurar un pool de Instant Clone]({{ site.url }}/jmp-part10/)
- [Part 11: Instalar App Volumes]({{ site.url }}/jmp-part11/)
- [Part 12: Configuración inicial App Volumes]({{ site.url }}/jmp-part12/)
- [Part 13: Crear nuestro primer App Stack]({{ site.url }}/jmp-part13/)
- [Part 14: Trabajando con Writable Volumes]({{ site.url }}/jmp-part14/)
- [Part 15: Instalación Dynamic Environment Manager]({{ site.url }}/jmp-part15/)
- [Part 16: Primeros pasos con DEM]({{ site.url }}/jmp-part16/)

- [Bonus 1: Gestión de perfiles con Microsoft FSLogix](https://miquelmariano.github.io/gestion-de-perfiles-con-fslogix/)

# Instalación servidor SQL Express 2017

En el entorno que vamos a crear, muchos de los servicios requieren de una BBDD para guardar sus configuraciones. Para no ir dejando servidores de BBDD instalados en local en cada servidor, me he decidido por centralizar y crear un único servidor de BBDD con SQL Express 2017.

Antes de nada, necesitaremos tener en nuestro servidor, el framework .NET 3.5 instalado. Cómo sabeis, en las versiones modernas de windows viene como característica y su instalación es de lo mas sencilla:

![sql1]({{ site.imagesposts2019 }}/08/sql1.png){: .align-center}

![sql2]({{ site.imagesposts2019 }}/08/sql2.png){: .align-center}

![sql3]({{ site.imagesposts2019 }}/08/sql3.png){: .align-center}

![sql4]({{ site.imagesposts2019 }}/08/sql4.png){: .align-center}

![sql5]({{ site.imagesposts2019 }}/08/sql5.png){: .align-center}

![sql6]({{ site.imagesposts2019 }}/08/sql6.png){: .align-center}

![sql7]({{ site.imagesposts2019 }}/08/sql7.png){: .align-center}

![sql8]({{ site.imagesposts2019 }}/08/sql8.png){: .align-center}

![sql9]({{ site.imagesposts2019 }}/08/sql9.png){: .align-center}

Una vez habilitado .NET 3.5, podremos empezar con la instalación de SQL Server Express 2017

Nos podremos descargar el instalador [desde aquí](https://www.microsoft.com/es-es/sql-server/sql-server-editions-express)

Al tratarse de un laboratorio, con los parámetros por defecto que nos propone el instalador será suficiente.

![sql10]({{ site.imagesposts2019 }}/08/sql10.png){: .align-center}

![sql11]({{ site.imagesposts2019 }}/08/sql11.png){: .align-center}

![sql12]({{ site.imagesposts2019 }}/08/sql12.png){: .align-center}

![sql13]({{ site.imagesposts2019 }}/08/sql13.png){: .align-center}

![sql14]({{ site.imagesposts2019 }}/08/sql14.png){: .align-center}

Habilitaremos las conexiones TCP/IP y fijaremos el puerto de escucha el 1433. Hay servicios que no soportan puerto dinámico, por lo que si lo dejamos configurado en este punto, ya nos evitamos problemas en un futuro.

![sql15]({{ site.imagesposts2019 }}/08/sql15.png){: .align-center}

![sql16]({{ site.imagesposts2019 }}/08/sql16.png){: .align-center}

![sql17]({{ site.imagesposts2019 }}/08/sql17.png){: .align-center}

También dejaremos instalado el SQL Management Studio en este mismo servidor.

La descarga la podremos realizar [desde aquí](https://docs.microsoft.com/es-es/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-2017) y la instalación tampoco tiene mucho mas misterio que ir siguiendo el asistente.

![sql18]({{ site.imagesposts2019 }}/08/sql18.png){: .align-center}

![sql19]({{ site.imagesposts2019 }}/08/sql19.png){: .align-center}

![sql20]({{ site.imagesposts2019 }}/08/sql20.png){: .align-center}

Para finalizar, es interesante también habilitar el SQL Browser para que las aplicaciones puedan hacer descubrimiento de este servidor.

![sql21]({{ site.imagesposts2019 }}/08/sql21.png){: .align-center}


Espero que os sirva.

Nos vemos en el próximo post: [Part 3: Preparar Active Directory]({{ site.url }}/jmp-part3/)

Un saludo!

Miquel.


