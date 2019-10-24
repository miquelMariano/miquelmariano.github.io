---
title: Configuración y administración vSphere Auto Deploy en vSphere 6.0
date: '2018-02-14 00:00:00'
layout: post
image: /assets/images/posts/2018/01/autodeploy.png
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- vcap
---

Auto deploy usa [PXE](https://es.wikipedia.org/wiki/Preboot_Execution_Environment) para el despliegue de ESXi en una red. Cuanto un host se despliega mediante Auto deploy, la información de estado se carga en memoria durante el arranque. El estado, por defecto, no se almacena de forma permanente en el host.

Podemos usar Host Profile con Auto deploy para customizar el estado de nuestros hosts ESXi. A demás, desde  el menú de configuración avanzada de un ESXi, podemos configurar el host sin estado, o con un estado al arrancar.

En este post, veremos como se configura auto deploy y como se usa para provisionar nuevos hosts ESXi.

### Habilitar Auto Deploy en vCenter

Para habilitar el servicio Auto deploy, hacemos login en nuestro vCenter a través del web client.

Administración > Configuración del sistema > Servicios > Auto Deploy

Hacemos click en el desplegable de "Acciones" y le damos a "Iniciar"

![autodeploy1]({{ site.imagesposts2018 }}/02/autodeploy1.png){: .align-center}

Adicionalmente, en caso de tener nuestra instancia sobre VCSA, también podremos habilitar el servicio de la siguiente manera:

```sshCommand>
Command> shell.set --enabled True
Command> shell
    ---------- !!!! WARNING WARNING WARNING !!!! ----------

Your use of "pi shell" has been logged!

The "pi shell" is intended for advanced troubleshooting operations and while
supported in this release, is a deprecated interface, and may be removed in a
future version of the product.  For alternative commands, exit the "pi shell"
and run the "help" command.

The "pi shell" command launches a root bash shell.  Commands within the shell
are not audited, and improper use of this command can severely harm the
system.

Help us improve the product!  If your scenario requires "pi shell," please
submit a Service Request, or post your scenario to the
https://communities.vmware.com/community/vmtn/vcenter/vc forum and add
"appliance" tag.

miquel-vcsa60:~ # service vmware-rbd-watchdog start
Starting /usr/bin/rbd-watchdog-linux:                                                                                    done
miquel-vcsa60:~ #
```

Una vez arrancado el servicio, podemos configurar el arranque automático desde el menú "Editar tipo de inicio"

![autodeploy2]({{ site.imagesposts2018 }}/02/autodeploy2.png){: .align-center}
![autodeploy3]({{ site.imagesposts2018 }}/02/autodeploy3.png){: .align-center}

Para configurar Autodeploy, navegaremos desde el web client Home > Lista de inventarios globales > Instancias de vCenter Server > seleccionamos nuestro vCenter > Pestaña configuración > Auto Deploy

Descargaremos el fichero TFTP Boot Zip para posteriormente subirlo en nuestro servidor DHCP/TFTP.

![autodeploy4]({{ site.imagesposts2018 }}/02/autodeploy4.png){: .align-center}

### Configurar DHCP y TFTP

Una vez arrancado y configurado el servicio auto deploy, el proximo paso es desplegar y configurar nuestro servidor DHCP y TFTP para poder arrancar por [PXE](https://es.wikipedia.org/wiki/Preboot_Execution_Environment) nuestros ESXi.

En mi caso, estoy utilizando un Windows 2016 R2 para levantar los servicios de DHCP y TFTP.

Lo primero, configuraremos el servicio TFTP. Estoy utilizando WinAgent TFTP Server como servidor, es gratis y se puede descargar desde [aquí.](undionly.kpxe.vmw-hardwired)

Instalamos el TFTP server y arrancamos la aplicación.

> El ejecutable se encuentra en C:\Program Files (x86)\WinAgents\TFTP Server 4. Para mas comodidad, os podeis crear un icono en 
> vuestro escritorio.

![autodeploy5]({{ site.imagesposts2018 }}/02/autodeploy5.png){: .align-center}

La primera vez, tendremos que arrancar el servicio

![autodeploy105]({{ site.imagesposts2018 }}/02/autodeploy105.png){: .align-center}

Ahora es el momento de descomprimir el fichero TFTP Boot Zip que previamente hemos descargado en el directorio de trabajo de nuestro servidor TFTP. Debaría quedar una cosa similar a esta:

![autodeploy6]({{ site.imagesposts2018 }}/02/autodeploy6.png){: .align-center}

![autodeploy106]({{ site.imagesposts2018 }}/02/autodeploy106.png){: .align-center}

![autodeploy1006]({{ site.imagesposts2018 }}/02/autodeploy1006.png){: .align-center}

Llegados a este punto, ya tenemos nuestro TFTP configurado y listo para usar, el próximo paso será configurar nuestro servidor DHCP.

En el laboratorio utilizaremos el propio servidor DHCP del Windows server 2016, así que una vez implementado el role, abriremos la consola del DHCP server.

Expandimos IPv4 y con el botón secundario y creamos un nuevo ámbito.

![autodeploy7]({{ site.imagesposts2018 }}/02/autodeploy7.png){: .align-center}

Seguiremos el asistente de configuración hasta llegar a este punto:

![autodeploy8]({{ site.imagesposts2018 }}/02/autodeploy8.png){: .align-center}

Una vez creado nuestro ámbito, con el botón secundario podremos configurar sus opciones

![autodeploy9]({{ site.imagesposts2018 }}/02/autodeploy9.png){: .align-center}

En la opción 066, definiremos nuestro Boot Server. Aquí tenemos que poner la IP/FQDN de nuestro servidor TFTP. Como en este caso ambos servicios están sobre el mismo servidor, pondremos el nombre del servidor DHCP/TFTP

![autodeploy10]({{ site.imagesposts2018 }}/02/autodeploy10.png){: .align-center}

En la opción 067, definiremos el fichero undionly.kpxe.vmw-hardwired. Este binario, se usará para que arranquen los hosts ESXi.

![autodeploy11]({{ site.imagesposts2018 }}/02/autodeploy11.png){: .align-center}

Una vez finalizado, deberiamos tener una configuración similar a esta:

![autodeploy12]({{ site.imagesposts2018 }}/02/autodeploy12.png){: .align-center}

Y si todo ha ido bien, nuestro servidor deberia arrancar por PXE e intentar "hablar" con el servidor TFTP server. Evidentemente, todavía no hemos subido ninguna imagen de ESXi y no va a pasar de ahi

![autodeploy13]({{ site.imagesposts2018 }}/02/autodeploy13.png){: .align-center}

A partir de aqui, necesitaremos disponer de PowerCLI y de los cmdlets para Auto Deploy. Podremos ver las opciones disponibles con el comando 

```powershell
Get-DeployCommand
```

![autodeploy14]({{ site.imagesposts2018 }}/02/autodeploy14.png){: .align-center}

Lo primero que haremos, será subir la iso de ESXi. 

> Podremos descargar la versión offline de ESXi desde el portal de [My VMWare](https://my.vmware.com)

Conectamos con nuestro vcenter

```powershell
Connect-VIserver <<vcenter name>>
```
![autodeploy15]({{ site.imagesposts2018 }}/02/autodeploy15.png){: .align-center}

Añadimos el paquete offline del ESXi

```powershell
Add-EsxSoftwareDepot "file location"
```
![autodeploy16]({{ site.imagesposts2018 }}/02/autodeploy16.png){: .align-center}

Confirmamos que el paquete se ha subido correctamente

```powershell
Get-EsxImageProfile
```
![autodeploy17]({{ site.imagesposts2018 }}/02/autodeploy17.png){: .align-center}

En este punto necesitaremos crear un conjunto de reglas y asociar un perfil de host, pero la infraestructura de Auto Deploy está lista.

### Stateful vs. Stateless

Un host desplegado con Auto Deploy se puede dejar en "stateful" (con estado) o "stateless" (sin estado)

Los desplieques "stateful" provisionan el host  y aplican un Host Profile el cual, tanto la imagen del ESXi como la configuración se almacenan en el disco local. Una vez instalado el host y ha arrancado desde el disco, ya no se requiere Auto Deploy.

En cambio, en los despliegues "stateless", mediante Auto Deploy se provisiona el host profile y cada vez que el ESXi arranque, necesitará de Autodeploy. Es posible configurar una caché que permite al host arrancar en caso de que AutoDeploy no esté disponible.

Para configurar "stateful" o "stateless", es necesario que Host Profile esté configurado inicialmente. Editamos un host profile existente via web client > Host Profiles > Edit > Advanced Configuration Settings > System Image Cache Configuration

![autodeploy117]({{ site.imagesposts2018 }}/02/autodeploy117.png){: .align-center}

### Crear/modificar reglas y conjunto de reglas

Ahora que tenemos Auto Depooy configurado y la imagen offline del ESXi correctamente subida, necesitaremos crear una regla para el despliegue.

Las reglas se utilizan para determinar que hosts de los que estan arrancando deben tener cada versión especifica de ESXi. Dos parametros importantes son necesarios. `Items` y `patterns`

Items determina que objeto asociaremos a cada ESXi y patterns determina que ESXi será parte de cada regla específica.

Como parte del plan, es posible añadir un host esxi directamente en vCenter una vez el ESXi está instalado e incluirlo en un cluster o carpeta. En mi caso, he creado una carpeta llamada "Auto Deploy"

![autodeploy18]({{ site.imagesposts2018 }}/02/autodeploy18.png){: .align-center}

Una vez creada, lanzaremos el siguiente comando desde PowerCLI. Deberemos especificar la imagen del ESXi, la carpeta y la IP que utilizará el host

```powershell
New-DeployRule -Name “test” -Item “ESXi-image“, “Auto Deploy” -Pattern “ipv4=192.168.7.200-192.168.7.20”
``` 
![autodeploy18]({{ site.imagesposts2018 }}/02/autodeploy18.png){: .align-center}

y aplicamos la regla para que el set esté activo

```powershell
Add-DeployRule -DeployRule “test”
```

![autodeploy20]({{ site.imagesposts2018 }}/02/autodeploy20.png){: .align-center}

Si no nos hemos saltado ningún paso, es el momento de probar nuestra configuración.
Crearemos una VM nueva en nuestro vCenter y selecionaremos ESXi 6.0 como SO y la arrancaremos.

Nuestro DHCP le deberia de asignar una IP y poder contactar con el TFTP server para recibir la imagen ESXi.

![autodeploy21]({{ site.imagesposts2018 }}/02/autodeploy21.png){: .align-center}

![autodeploy22]({{ site.imagesposts2018 }}/02/autodeploy22.png){: .align-center}

Y hasta aquí por hoy.

Un saludo!!!

Miquel.




























