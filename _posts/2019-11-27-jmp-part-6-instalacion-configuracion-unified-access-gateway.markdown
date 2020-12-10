---
title: Creando un entorno JMP con VMware Horizon - Parte 6 - Instalación y configuración de UAG
date: '2019-11-27 00:00:00'
layout: post
image: /assets/images/posts/2019/07/horizon-logo.png
tag:
- vmware
- horizon
- vexpert
- euc
- desktop
- mobility
permalink: /jmp-part6/

---

Buenos días a tod@s!!

En la siguiente serie de posts, pretendo explicar durante las próximas semanas el paso a paso para instalar un entorno JMP (Just-in-Time Management Platform) utilizando VMware Horizon 7 Instant Clones + App Volumes + VMware UEM (User Environment Manager) 

- [Part 1: Introducción]({{ site.url }}/jmp-part1/)
- [Part 2: Preparar servidor SQL]({{ site.url }}/jmp-part2/)
- [Part 3: Preparar Active Directory]({{ site.url }}/jmp-part3/)
- [Part 4: Instalación y configuración Connection Server]({{ site.url }}/jmp-part4/)
- [Part 5: Instalación y configuración Replica Server (opcional)]({{ site.url }}/jmp-part5/)
- [Part 6: Instalación y configuración de UAG (opcional)]({{ site.url }}/jmp-part6/)
- [Part 7: Configuración de UAG en HA]({{ site.url }}/jmp-part7/)
- Part 8: Instalación certificado (opcional)
- [Part 9: Preparar plantilla master para Instant Clone]({{ site.url }}/jmp-part9/)
- [Part 10: Configurar un pool de Instant Clone]({{ site.url }}/jmp-part10/)
- [Part 11: Instalar App Volumes]({{ site.url }}/jmp-part11/)
- [Part 12: Configuración inicial App Volumes]({{ site.url }}/jmp-part12/)
- [Part 13: Crear nuestro primer App Stack]({{ site.url }}/jmp-part13/)
- [Part 14: Trabajando con Writable Volumes]({{ site.url }}/jmp-part14/)
- [Part 15: Instalación Dynamic Environment Manager]({{ site.url }}/jmp-part15/)
- [Part 16: Primeros pasos con DEM]({{ site.url }}/jmp-part16/)

# Instalación y configuración de UAG (Unified Access Gateway)

Unified Access Gateway (UGA) es un componente dentro de la infraestructura Horizon que nos proveerá de conectividad remota hacia nuestros escritorios VDI

![uag0]({{ site.imagesposts2019 }}/09/uag0.png){: .align-center}

UAG, viene a reemplazar los [ya conocidos Horizon Security Servers]({{ site.url }}/jmp-part6/) y algunos de los beneficios que nos aportan son:

* El emparejamiento ya no es 1:1 como se hacia con la topología de Security Server. Con UAG, un único appliance puede estar emparejado a múltiples connections servers a través de un balanceador.

* La conectividad entre UAG y connection server solo requiere del puerto TCP443 lo que simplifica muchísimo las reglas a nivel de firewall. Eso si, seguiremos necesitando los puertos 4172, 22443, etc. hacia los Horizon Agents.

* Adicionalmente y para una mayor securización, UAG soporta métodos de autenticación como RSA SecurID, Radius, CAC, etc...

Con todo lo que he expuesto anteriormente, no quiero dar a entender que Horizon Security Server ya no se pueda utilizar. Sigue siendo un producto válido que VMware sigue desarrollando y soportando.
{: .notice}

### Configuración firewall

En el siguiente esquema, podreis ver una representación de la topología para dar acceso a nuestro entorno VDI desde internet

![uag3]({{ site.imagesposts2019 }}/09/uag3.png){: .align-center}

Los puertos necesarios para la correcta configuración son los siguientes, y están sacados de la [documentación oficial:](https://docs.vmware.com/en/Unified-Access-Gateway/3.6/com.vmware.uag-36-deploy-config.doc/GUID-F197EB60-3A0C-41DF-8E3E-C99CCBA6A06E.html)

Acceso desde cualquier dispositivo de internet hacia el UAG appliance o balanceador:

* TCP and UDP 443 (incluye Blast Extreme)
* TCP and UDP 4172. UDP 4172 debe estar permitido en ambas direcciones. (PCoIP)
* TCP and UDP 8443 (para HTML Blast)

Acceso desde los UAG appliance hacia los connection servers:

* TCP 443 

Acceso desde los UAG appliance hacia los escritorios:

* TCP and UDP 4172 (PCoIP). UDP 4172 debe estar permitido en ambas direcciones.
* TCP 32111 (USB Redirection) 
* TCP and UDP 22443 (Blast Extreme) 
* TCP 9427 (MMR and CDR) 

### Despliegue OVA

Nos descargaremos la OVA desde nuestro portal de [my.vmware](https://my.vmware.com)

![uag1]({{ site.imagesposts2019 }}/09/uag1.png){: .align-center}
![uag2]({{ site.imagesposts2019 }}/09/uag2.png){: .align-center}

El despliegue es relativamente sencillo y simplemente seguiremos el wizard de implementación de OVA en nuestro vCenter:

![uag4]({{ site.imagesposts2019 }}/09/uag4.png){: .align-center}
![uag5]({{ site.imagesposts2019 }}/09/uag5.png){: .align-center}
![uag6]({{ site.imagesposts2019 }}/09/uag6.png){: .align-center}
![uag7]({{ site.imagesposts2019 }}/09/uag7.png){: .align-center}
![uag8]({{ site.imagesposts2019 }}/09/uag8.png){: .align-center}
![uag9]({{ site.imagesposts2019 }}/09/uag9.png){: .align-center}
![uag10]({{ site.imagesposts2019 }}/09/uag10.png){: .align-center}
![uag11]({{ site.imagesposts2019 }}/09/uag11.png){: .align-center}
![uag12]({{ site.imagesposts2019 }}/09/uag12.png){: .align-center}
![uag13]({{ site.imagesposts2019 }}/09/uag13.png){: .align-center}
![uag14]({{ site.imagesposts2019 }}/09/uag14.png){: .align-center}
![uag15]({{ site.imagesposts2019 }}/09/uag15.png){: .align-center}

### Interfaz de administración

Una vez finalizada la instalación, accederemos a nuestro UAG desde la siguiente URL

```
https://uag.demo.corp:9443/admin/index.html#/Login
```
![uag16]({{ site.imagesposts2019 }}/09/uag16.png){: .align-center}

Nos dirigiremos a la opción de "Configurar manualmente"

![uag17]({{ site.imagesposts2019 }}/09/uag17.png){: .align-center}

y "Configuración Horizon", en donde empezaremos a rellenar los campos.

![uag18]({{ site.imagesposts2019 }}/09/uag18.png){: .align-center}
![uag19]({{ site.imagesposts2019 }}/09/uag19.png){: .align-center}
![uag20]({{ site.imagesposts2019 }}/09/uag20.png){: .align-center}

La huella digital la encontraremos al explorar nuestro certificado, desde un navegador web:

![uag21]({{ site.imagesposts2019 }}/09/uag21.png){: .align-center}
![uag22]({{ site.imagesposts2019 }}/09/uag22.png){: .align-center}

Colocaremos la URL del protocolo Blast:

![uag23]({{ site.imagesposts2019 }}/09/uag23.png){: .align-center}

Y si todo va bien, nos aparecerá el semáforo en verde de que todo está OK:

![uag24]({{ site.imagesposts2019 }}/09/uag24.png){: .align-center}
![uag25]({{ site.imagesposts2019 }}/09/uag25.png){: .align-center}

Es importante desmarcar todos los túneles, de lo contrario recibiremos un error al conectar con nuestro Horizon Client

![uag26]({{ site.imagesposts2019 }}/09/uag26.png){: .align-center}
![uag26-1]({{ site.imagesposts2019 }}/09/uag26-1.png){: .align-center}

Ahora será el momento de registrar nuestro gateway en nuestro entorno Horizon:

![uag27]({{ site.imagesposts2019 }}/09/uag27.png){: .align-center}
![uag28]({{ site.imagesposts2019 }}/09/uag28.png){: .align-center}
![uag29]({{ site.imagesposts2019 }}/09/uag29.png){: .align-center}

Y hasta aquí por hoy.

Espero que os sirva.

En el próximo post veremos cómo dotar de alta disponibilidad a nuestro UAG > [Part 7: Configuración de UAG en HA]({{ site.url }}/jmp-part7/)

Un saludo!

Miquel.


