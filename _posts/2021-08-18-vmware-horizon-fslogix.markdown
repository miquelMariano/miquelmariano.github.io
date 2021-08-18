---
title: Gestión de perfiles de usuario con Microsoft FSLogix
date: '2021-08-18 00:00:00'
layout: post
image: /assets/images/posts/2018/12/ssh-banner.jpg
tag:
- vmware
- horizon
- vexpert
- euc
- desktop
- mobility
- fslogix
---

# Que es FSLogix?

Cogiendo la definición oficial de la [documentación de Microsoft](https://docs.microsoft.com/en-us/fslogix/overview)

"FSLogix is a set of solutions that enhance, enable, and simplify non-persistent Windows computing environments. FSLogix solutions are appropriate for Virtual environments in both public and private clouds. FSLogix solutions may also be used to create more portable computing sessions when using physical devices."

Dicho de otra manera. FSLogix, es una solución de gestión de perfiles de usuarios que almacena todos los datos del usuario en un disco VDH montado independientemente. Para los que son del mundo Horizon, seria (salvando las distancias) como el persistent disk que teniamos antaño con los Linked Clone

# Cómo encaja FSLogix en el resto de productos del stack Horizon?

Me he encontrado por ahi este maravilloso diagrama que me parece que explica a la perfección en que lugar queda FSLogix

![fslogix-schema]({{ site.imagesposts2021 }}/04/fslogix-schema.png){: .align-center}

Básicamente, con FSLogix capturaremos los datos de usuario (Escritorio, Mis Documentos, Descargas, etc etc...) y también la configuración, el AppData del usuario.

Luego está DEM que gestiona las configuraciones pre-definidas y el propio entorno del usuario, aunque también pueda capturar la configuración (AppData)

Por último, aunque APP Volumes también permite "Writtable Volumes", nació cómo una funcionalidad nativa de virtualización de aplicaciones.

# Requisitos para usar FSLogix

Para poder usar FSLogix necesitaremos una de las siguientes licencias de microsoft:

- Microsoft 365 E3/E5
- Microsoft 365 A3/A5/ Student Use Benefits
- Microsoft 365 F1/F3
- Microsoft 365 Business
- Windows 10 Enterprise E3/E5
- Windows 10 Education A3/A5
- Windows 10 VDA per user
- Remote Desktop Services (RDS) Client Access License (CAL)
- Remote Desktop Services (RDS) Subscriber Access License (SAL)
- Azure Virtual Desktop per-user access license

# Instalación de FSLogix

Antes de empezar, nos descargaremos los binarios directamente desde [aquí](https://aka.ms/fslogix_download). A fecha de edición de este post, la última versión es la 2.9.7838.44263

## Instalamos el agente en la plantilla maestra

![fslogix-00]({{ site.imagesposts2021 }}/08/fslogix-00.png){: .align-center}
![fslogix-01]({{ site.imagesposts2021 }}/08/fslogix-01.png){: .align-center}
![fslogix-02]({{ site.imagesposts2021 }}/08/fslogix-02.png){: .align-center}
![fslogix-03]({{ site.imagesposts2021 }}/08/fslogix-03.png){: .align-center}

## Preparamos el recurso compartido para guardar los discos VDH

![fslogix-04]({{ site.imagesposts2021 }}/08/fslogix-04.png){: .align-center}
![fslogix-05]({{ site.imagesposts2021 }}/08/fslogix-05.png){: .align-center}

Los permisos necesarios son:

- CREATOR OWNER = Modify – Subfolders and files only
- Domain Admins = Full Control – This folder, subfolders and files
- Domain Users = Modify – This folder only

![fslogix-06]({{ site.imagesposts2021 }}/08/fslogix-06.png){: .align-center}

## Copiaremos las plantillas admx en el dominio

![fslogix-07]({{ site.imagesposts2021 }}/08/fslogix-07.png){: .align-center}
![fslogix-08]({{ site.imagesposts2021 }}/08/fslogix-08.png){: .align-center}

## Creamos nueva GPO de equipo para los escritorios Instant Clone

La configuración básica cuenta con 2 configuraciones

- Habilitar el uso de profile containers
- Indicar la ruta dónde se guardarán

![fslogix-09]({{ site.imagesposts2021 }}/08/fslogix-09.png){: .align-center}
![fslogix-10]({{ site.imagesposts2021 }}/08/fslogix-10.png){: .align-center}
![fslogix-11]({{ site.imagesposts2021 }}/08/fslogix-11.png){: .align-center}
![fslogix-12]({{ site.imagesposts2021 }}/08/fslogix-12.png){: .align-center}

## Comprobamos que el disco se crea, se vincula a nuestro VDI y se guarda en el share configurado

![fslogix-13]({{ site.imagesposts2021 }}/08/fslogix-13.png){: .align-center}

# Bibliografía

https://docs.microsoft.com/en-us/fslogix/overview

https://docs.microsoft.com/es-es/azure/virtual-desktop/fslogix-containers-azure-files

https://techzone.vmware.com/resource/integrating-fslogix-profile-containers-vmware-horizon#_Toc50543891

Espero que os guste.

Un saludo!

Miquel.