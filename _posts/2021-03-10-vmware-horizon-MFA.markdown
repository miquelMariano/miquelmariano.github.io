---
title: Acceso seguro a nuestro entrono VDI con DUO Security
date: '2021-03-10 00:00:00'
layout: post
image: /assets/images/posts/2018/12/ssh-banner.jpg
tag:
- vmware
- horizon
- vexpert
- euc
- desktop
- mobility
- mfa
- 2fa
- mfa
- duo
- security
---

En el post de hoy hablaremos de DUO Security, un servicio cloud para dotar de doble factor de autenticación a nuestras aplicaciones. Veremos cómo se hace la configuración básica y cómo podemos proteger nuestro entorno VDI con MFA.

# DUO Security MFA

Extraído de su propia [página web](https://duo.com/product/multi-factor-authentication-mfa) 

DUO Securtiy nos aporta una autenticación multifactor moderna y eficaz. La autenticación multifactor de Duo de Cisco protege sus aplicaciones mediante el uso de una segunda fuente de validación, como un teléfono o un token, para verificar la identidad del usuario antes de otorgar acceso. Duo está diseñado para proporcionar una experiencia de inicio de sesión simple y optimizada para cada usuario y aplicación, y como solución basada en la nube, se integra fácilmente con su tecnología existente.
{: .note}

![duo-02]({{ site.imagesposts2021 }}/03/duo-02.png){: .align-center}

Cómo cualquier servicio cloud, está basado en el pago por uso y la parte buena de DUO es que tiene una versión gratuita para 10 usuarios. Perfecto para realizar nuestros laboratorios y demos

![duo-01]({{ site.imagesposts2021 }}/03/duo-01.png){: .align-center}

# Instalación DUO Authentication Proxy

Una vez nos hayamos registrado en el portal de DUO, el primer paso será conectar nuestro entorno on-premise con la cuenta cloud.

![duo-install-00]({{ site.imagesposts2021 }}/03/duo-install-00.png){: .align-center}

En el [este enlace](https://duo.com/docs/checksums#duo-authentication-proxy) encontraremos todos los binarios para windows y para linux. Es un instalador siguiente > siguiente > fin.

![duo-install-01]({{ site.imagesposts2021 }}/03/duo-install-01.png){: .align-center}
![duo-install-02]({{ site.imagesposts2021 }}/03/duo-install-02.png){: .align-center}

Toda la configuración se encuentra en el fichero `C:\Program Files\Duo Security Authentication Proxy\conf\authproxy.cfg`

La configuración que viene por defecto se puede borrar, ya que sólo son ejemplos

![duo-install-04]({{ site.imagesposts2021 }}/03/duo-install-04.png){: .align-center}

## Configuración SSO con Active Directory

Aquí es dónde configuraremos la conexión de nuestro proxy recién instalado con la cuenta de DUO. 

Single Sign-On > Add source > Add an Acrive Directory > Add Authentication Proxy

![duo-install-05]({{ site.imagesposts2021 }}/03/duo-install-05.png){: .align-center}
![duo-install-06]({{ site.imagesposts2021 }}/03/duo-install-06.png){: .align-center}
![duo-install-07]({{ site.imagesposts2021 }}/03/duo-install-07.png){: .align-center}
![duo-install-08]({{ site.imagesposts2021 }}/03/duo-install-08.png){: .align-center}

Con el proxy ya configurado, haremos la configuración de nuestro Active Directory

![duo-install-09]({{ site.imagesposts2021 }}/03/duo-install-09.png){: .align-center}
![duo-install-10]({{ site.imagesposts2021 }}/03/duo-install-10.png){: .align-center}

Todo el detalle de la config está en esta [documentación oficial](https://duo.com/docs/sso#enable-duo-single-sign-on)

## Sincronizar usuarios AD

Con la configuración de nuestro SSO es el momento de sincronizar nuestros usuarios del directorio activo.

Dashboard > Users > Directory Sync > AD Sync

![duo-install-11]({{ site.imagesposts2021 }}/03/duo-install-11.png){: .align-center}

Asignaremos un nombre a nuestro registro y configuraremos el Proxy para que se conecte con nuestro AD

![duo-install-12]({{ site.imagesposts2021 }}/03/duo-install-12.png){: .align-center}

Los datos de configuración los tendremos que configurar en el fichero de configuración del proxy y para mayor comodidad, el propio asistente nos deja descargar ese fichero pre-configurado para añadir la sección [cloud].

![duo-install-13]({{ site.imagesposts2021 }}/03/duo-install-13.png){: .align-center}
![duo-install-14]({{ site.imagesposts2021 }}/03/duo-install-14.png){: .align-center}

**NOTA:** Es importante que después de cualquier modificación en el fichero de configuración se reinicie el servicio.
{: .note}

Terminamos con la configuración del AD

![duo-install-15]({{ site.imagesposts2021 }}/03/duo-install-15.png){: .align-center}
![duo-install-16]({{ site.imagesposts2021 }}/03/duo-install-16.png){: .align-center}

## Enroll Users

Una vez tengamos nuestros usuarios ya sincronizados con DUO, es el momento de enviarles las instrucciones para que se activen y cada usuario pueda instalar la aplicación móvil.

Dashboard > Users > Bulk Enroll Users

![duo-install-17]({{ site.imagesposts2021 }}/03/duo-install-17.png){: .align-center}

Cada uno de nuestros usuarios recibirá un correo con un enlace único el cual servirá para registrar el usuario y activar la aplicación para la autenticación. Es un wizard sumamente intuitivo para que nuestros usuarios se lo puedan configurar por si mismos.

![duo-install-18]({{ site.imagesposts2021 }}/03/duo-install-18.png){: .align-center}

# Desplegar aplicación View

Con toda la integración finalizada y funcionando, es el momento de proteger nuestra primera aplicación con DUO. En nuestro caso, Horizon View.

Dashboard > Application > Protect an Application

![duo-install-19]({{ site.imagesposts2021 }}/03/duo-install-19.png){: .align-center}
![duo-install-20]({{ site.imagesposts2021 }}/03/duo-install-20.png){: .align-center}
![duo-install-21]({{ site.imagesposts2021 }}/03/duo-install-21.png){: .align-center}

En el fichero de configuración deberemos añadir una sección [radius_server_chagellge] con los parámetros marcados en el portal.
En caso de tener mas de un servidor de conexión, añadiremos un bloque adicional para cada IP

![duo-install-22]({{ site.imagesposts2021 }}/03/duo-install-22.png){: .align-center}

Para mas detalle de esta configuración, podeis consultar la [documentación oficial](https://duo.com/docs/vmwareview)

## Configurar Connection Server

Llegó el momento de integrar nuestro entorno Horizon con 2FA.

Desde el Horizon Administrator, nos dirigiremos a la pestaña Servidores y editaremos la config de nuestros Connection Servers

![duo-install-23]({{ site.imagesposts2021 }}/03/duo-install-23.png){: .align-center}
![duo-install-24]({{ site.imagesposts2021 }}/03/duo-install-24.png){: .align-center}
![duo-install-25]({{ site.imagesposts2021 }}/03/duo-install-25.png){: .align-center}

Añadimos un nuevo servidor radius correspondiente al servidor con DUO Auth. Proxy

![duo-install-26]({{ site.imagesposts2021 }}/03/duo-install-26.png){: .align-center}

El secreto compartido debe coincidir con el definido en el fichero de configuración del proxy, de lo contrario, no establecerá comunicación.

![duo-install-27]({{ site.imagesposts2021 }}/03/duo-install-27.png){: .align-center}

Para entornos productivos, existe la posibilidad de añadir un servidor adicional a la configuración.

![duo-install-28]({{ site.imagesposts2021 }}/03/duo-install-28.png){: .align-center}

# Probar autenticación doble factor

Con todo configurado, vamos a abrir nuestro Horizon Client y probar si la autenticación de doble factor está funcionando.

De entrada, ya podemos ver que nos da información de nuestro servidor RADIUS. Deberemos completar la autenticación principal con los datos de nuestro Active Directory

![duo-install-29]({{ site.imagesposts2021 }}/03/duo-install-29.png){: .align-center}

Una vez autenticada la primera fase, DUO nos permitirá autenticar con doble factor y nos permite 4 posibilidades:

- Notificación push en la aplicación móvil (Opción recomendada)
- Llamada de telefono en el nº registrado para el usuario
- Codigo enviado por SMS
- Codigo aleatorio que nos muestra la aplicación (Si, aunque no aparezca esta opción, podemos poner el código mostrado en la aplicación móvil)

![duo-install-30]({{ site.imagesposts2021 }}/03/duo-install-30.png){: .align-center}

Si optamos por la opcion 1 > Iniciar Sesión, recibiremos esta notificación push en el móvil que deberemos aceptar para poder iniciar sesión.

![duo-install-31]({{ site.imagesposts2021 }}/03/duo-install-31.png){: .align-center}

Y hasta aquí por hoy.

Espero que os guste.

Un saludo!


Miquel.


