---
title: Cómo instalar y configurar VMware PowerCLI 11.1
date: '2019-01-09 00:00:00'
layout: post
image: /assets/images/posts/2019/01/PowerShell6-banner.jpg
headerImage: true
tag:
- vexpert
- automation
- vsphere
- vmware
---

Buenos días a tod@as!!
En el post de hoy veremos cómo instalar la última versión de PowerCLI 11.1 sobre windows.

Como sabéis, VMware PowerCLI es un conjunto de módulos de Powershell que se utilizan para gestionar, administrar, mantener y monitorizar un entorno VMware. 
Los que ya estéis familiarizados, habréis descubierto que es una poderosa herramienta para cualquier administrador de sistemas y puede utilizarse para recopilar información detallada y/o ejecutar comandos en múltiples máquinas virtuales, hosts etc, etc...

Tradicionalmente, PowerCLI se instalaba sobre un sistema Windows y VMWare nos proporcionaba un instalador .msi en el que sólo había que seguir el tradicional wizard siguiente>siguiente>fin.

Desde la versión 6.5.1, eso cambió, y PowerCLI se instala directamente desde PowerShell. Eso abre un ámplio abanico de posibilidades ya que también desde la llegada de PowerShell 6.0 Core, se puede instalar sobre Linux e incluso sobre MAC, pero bueno, eso lo veremos en otro post.

Para instralar PowerCLI 11.1 (última version disponible a fecha de hoy) hay que tener PowerShell 3.0 o superior. A continuación vamos a ver cómo instalar la última versión de PowerShell para windows.

### 1) Instalación PowerShell 6.0 Core

Inicialmente, con el comando `$psversiontable` veremos que versión tenemos actualmente de PowerShell, en mi caso una 5.1

![ps6-0]({{ site.imagesposts2019 }}/01/PowerShell6-0.png)

Descargamos PowerShell Core desde [aquí](https://github.com/PowerShell/PowerShell) y seguimos el wizard de instalación.

![ps6-1]({{ site.imagesposts2019 }}/01/PowerShell6-1.png)

![ps6-2]({{ site.imagesposts2019 }}/01/PowerShell6-2.png)

![ps6-3]({{ site.imagesposts2019 }}/01/PowerShell6-3.png)

![ps6-4]({{ site.imagesposts2019 }}/01/PowerShell6-4.png)

![ps6-5]({{ site.imagesposts2019 }}/01/PowerShell6-5.png)

![ps6-6]({{ site.imagesposts2019 }}/01/PowerShell6-6.png)

![ps6-7]({{ site.imagesposts2019 }}/01/PowerShell6-7.png)

![ps6-8]({{ site.imagesposts2019 }}/01/PowerShell6-8.png)

### 2) Instalación PowerCLI 11.1

Nos descargamos modulos PowerCLI en ubicación local. En mi caso me he creado una carpeta en C:\PS y el comando es el siguiente:

```powershell
Save-Module -Name VMware.PowerCLI -Path <path>
```

![ps6-9]({{ site.imagesposts2019 }}/01/PowerShell6-9.png)

Una vez descargados los módulos, los podremos instalar con el siguiente comando:

```powershell
Install-Module -Name VMware.PowerCLI
```

Es probable que nos de un error de privilegios, por lo que tendremos que cerrar y volver a abrir la consola en modo administrador.

![ps6-10]({{ site.imagesposts2019 }}/01/PowerShell6-10.png)

Instalación completada.

![ps6-11]({{ site.imagesposts2019 }}/01/PowerShell6-11.png)

Listamos los modulos instalados y su correspondiente versión con el siguiente comando:

```powershell
Get-Module -ListAvailable -Name VMware*
```

![ps6-12]({{ site.imagesposts2019 }}/01/PowerShell6-12.png)

Finalmente, es probable que tengamos que configurar PowerCLI para que ignore los certificados autorirmados, lo haremos con el siguiente comando:


```powershell
Set-PowerCLIConfiguration -InvalidCertificateAction:Ignore
```

Y si ha ido todo bien, con el comando `connect-viserver <vcenter-ip>` ya nos podremos conectar a nuestro entorno.

![ps6-13]({{ site.imagesposts2019 }}/01/PowerShell6-13.png)

Espero que os sea de utilidad.

Un saludo!

Miquel.


