---
title: Instalar vCenter 6.7 via CLI
date: '2018-08-23 00:00:00'
layout: post
image: /assets/images/posts/2018/08/install_cli.png
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- automation
- vcenter
category: blog
author: miquelMariano
description: Instalar vCenter 6.7 via CLI
hidden: false
comments: true
---

Buenos días a tod@s!!

Como sabéis, VCSA se puede [implementar a través de GUI](https://miquelmariano.github.io/2017/07/ncoratutorial-install-vcsa/) sin demasiadas complicaciones desde máquinas Windows, Linux o incluso MAC.

El objetivo del post de hoy es ver cómo podemos desplegar un vCenter en versión 6.7 (6.5 también sigue en mismo procedimiento) de forma desatendida a través de la linea de comandos CLI.

Este proceso utiliza un archivo JSON para definir toda la configuración del nuevo servidor, desde el host ESXi en dónde se desplegará en nuevo apliance, hasta la contraseña de root del VCSA pasando por configuración IP, NTP, etc etc....

Tras jugar un poco con la CLI en el laboratorio, creo que este método de instalación va a ser el elegido en mis futuras implementaciones ;-)

### Antes de empezar

Antes de instalar cualquier VCSA, es necesario asegurarse de que en nuestro DNS está correctamente creado el registro. Durante el proceso de configuración, será necesario conectarse al nuevo vCenter y si el FQDN que hemos especificado no existe, fallará.

### Vistazo rápido a la ISO de instalación

Una vez descargada i montada la ISO de instalación del VCSA, veremos una carpeta llamada vcsa-cli-installer. En su interior, encontraremos carpetas para Linux, Mac y Windows, así como una carpeta de templates.

![cli1]({{ site.imagesposts2018 }}/08/cli1.png)

![cli2]({{ site.imagesposts2018 }}/08/cli2.png)

Vamos a entrar en la carpeta de templates y echar un vistazo a los ficheros de configuración JSON de demo. Dentro de la carpeta de templates, están las subcarpetas para instalar, migrar y actualizar. 

Con la herramienta CLI podremos realizar una nueva instalación, una migración de Windows VC al VCSA o una actualización desde una versión anterior. 

![cli3]({{ site.imagesposts2018 }}/08/cli3.png)

![cli4]({{ site.imagesposts2018 }}/08/cli4.png)

### Crear el archivo de configuración JSON

Dependiendo de la arquitectura que queramos implementar en nuestro entorno, podremos basarnos en uno de los ficheros JSON de demo. Simplemente se trata de hacer una copia del fichero de ejemplo y editarlo con nuestro editor de texto favorito.

En mi caso, instalaré el VC desde 0 sobre un ESXi por lo que utilizaré como base la plantilla llamada `embedded_vCSA_on_ESXi.json` 

Aquí teneis el ejemplo del fichero que yo utilizaré:

```json
{
    "__version": "2.13.0",
    "__comments": "Sample template to deploy a vCenter Server Appliance with an embedded Platform Services Controller on an ESXi host.",
    "new_vcsa": {
        "esxi": {
            "hostname": "192.168.6.35",
            "username": "root",
            "password": "Secret123!",
            "deployment_network": "VLAN6_Formacion",
            "datastore": "FORM02_R5_LUN00"
        },
        "appliance": {
            "__comments": [
                "You must provide the 'deployment_option' key with a value, which will affect the VCSA's configuration parameters, such as the VCSA's number of vCPUs, the memory size, the storage size, and the maximum numbers of ESXi hosts and VMs which can be managed. For a list of acceptable values, run the supported deployment sizes help, i.e. vcsa-deploy --supported-deployment-sizes"
            ],
            "thin_disk_mode": true,
            "deployment_option": "tiny",
            "name": "miquel-vCenter67"
        },
        "network": {
            "ip_family": "ipv4",
            "mode": "static",
            "ip": "192.168.6.140",
            "dns_servers": [
                "192.168.6.100",
                "192.168.6.101"
            ],
            "prefix": "24",
            "gateway": "192.168.6.1",
            "system_name": "192.168.6.140"
        },
        "os": {
            "password": "Secret123!",
            "ntp_servers": [
                "192.168.6.100",
                "192.168.6.101"
            ],
            "ssh_enable": true
        },
        "sso": {
            "password": "Secret123!",
            "domain_name": "vsphere.local"
        }
    },
    "ceip": {
        "description": {
            "__comments": [
                "++++VMware Customer Experience Improvement Program (CEIP)++++",
                "VMware's Customer Experience Improvement Program (CEIP) ",
                "provides VMware with information that enables VMware to ",
                "improve its products and services, to fix problems, ",
                "and to advise you on how best to deploy and use our ",
                "products. As part of CEIP, VMware collects technical ",
                "information about your organization's use of VMware ",
                "products and services on a regular basis in association ",
                "with your organization's VMware license key(s). This ",
                "information does not personally identify any individual. ",
                "",
                "Additional information regarding the data collected ",
                "through CEIP and the purposes for which it is used by ",
                "VMware is set forth in the Trust & Assurance Center at ",
                "http://www.vmware.com/trustvmware/ceip.html . If you ",
                "prefer not to participate in VMware's CEIP for this ",
                "product, you should disable CEIP by setting ",
                "'ceip_enabled': false. You may join or leave VMware's ",
                "CEIP for this product at any time. Please confirm your ",
                "acknowledgement by passing in the parameter ",
                "--acknowledge-ceip in the command line.",
                "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
            ]
        },
        "settings": {
            "ceip_enabled": true
        }
    }
}
```

### Verificar el archivo JSON

Ahora que tenemos el archivo JSON con la configuración, ya ejecutar la herramienta CLI para realizar el despliegue.

Abriremos un CMD y nos posicionaremos en la ubicación `E:\vcsa-cli-installer\win32` (La unidad E: representa donde se ha montado la ISO del instalador)

Para mostrar la ayuda de la herramienta ejecutaremos el comando `vcsa-deploy.exe install -h

Ejecutaremos el siguiente comando para realizar una verificación del archivo de configuración. 

`vcsa-deploy.exe install --acknowledge-ceip --accept-eula --no-esx-ssl-verify --verify-template-only c:\tmp\vcenter67.json`

> En VCSA 6.5 el flag para verificar es --verify-only

![cli5]({{ site.imagesposts2018 }}/08/cli5.png)

### Despliegue y configuración VCSA

Hemos llegado al momento de ejecutar el comando que realmente hará el despliegue y la configuración. El comando es similar al anterior, pero sin el flag de verificación ( --verify-template-only).

`vcsa-deploy.exe install --acknowledge-ceip --accept-eula --no-ssl-certificate-verification c:\temp\embedded_vCSA_on_ESXi.json`

Una vez que se haya iniciado el proceso, es momento de ponerse comodos y esperar, el despliegue tarda alrededor de 15-20 minutos en implementarse, configurarse y que los servicios se inicien.

![cli6]({{ site.imagesposts2018 }}/08/cli6.png)

![cli7]({{ site.imagesposts2018 }}/08/cli7.png)

![cli8]({{ site.imagesposts2018 }}/08/cli8.png)

Llegados a este punto, si todo ha ido correctamente, ya nos podremos conectar mediante vSphere Client al nuevo vCenter recien implementado.

### Resumen

A mi personalmente, cada vez me gustan mas las lineas de comandos, no solo para automatizar los procesos sinó también para reducir el error del factor humano a la hora de picar parámetros durante el wizard de instalación que nos aporta la GUI.

Como hemos visto, una vez sabemos como funciona la herramienta GUI, este método puede volverse muy poderoso y fácil de usar gracias al fichero JSON.

Espero que os sea de utilidad.

Un saludo!

Miquel.



