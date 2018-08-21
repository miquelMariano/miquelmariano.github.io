---
title: Instalar vCenter 6.7 via CLI
date: '2018-08-22 00:00:00'
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
permalink: /cliinstaller/
---

https://virtualtassie.com/2017/vsphere-6-5-cli-vcsa-embedded-deployment-walkthrough/

Buenos dias a tod@s!!

Como sabéis, VCSA se puede [implementar a través de GUI](https://miquelmariano.github.io/2017/07/ncoratutorial-install-vcsa/) sin demasiadas complicaciones desde máquinas Windows, Linux o incluso MAC.

El objetivo del post de hoy es ver cómo podemos desplegar un vCenter en versión 6.7 (6.5 también sigue en mismo procedimiento) de forma desatendida a través de la linea de comandos CLI.

Este proceso utiliza un archivo JSON para definir toda la configuración del nuevo servidor, desde el host ESXi en dónde se desplegará en nuevo apliance, hasta la contraseña de root del VCSA pasando por configuración IP, NTP, etc etc....

Tras jugar un poco con la CLI en el laboratorio, creo que este método de instalación va a ser el elegido en mis futuras implementaciones.

### Primeros pasos

Antes de instalar cualquier VCSA, es necesario asegurarse de que en nuestro DNS está correctamente creado el registro. Durante el proceso de configuración, será necesario conectarse al nuevo vCenter y si el FQDN que hemos especificado no existe, fallará.

### Vistazo rápido de la ISO


A continuación, echemos un vistazo al archivo ISO de VCSA que descargué de VMware. Si montamos el archivo ISO y luego lo abrimos, verá una carpeta llamada vcsa-cli-installer. En su interior, encontrará carpetas para Linux, Mac y Windows, así como una carpeta de plantillas.

![cli1]({{ site.imagesposts2018 }}/08/cli1.png)

![cli2]({{ site.imagesposts2018 }}/08/cli2.png)

Vamos a sumergirnos en la carpeta de plantillas y echar un vistazo, ya que aquí es donde están instalados los archivos de configuración JSON de ejemplo. Dentro de la carpeta de plantillas, hay subcarpetas para instalar, migrar y actualizar. La herramienta CLI se puede usar para realizar una nueva instalación, una migración de Windows VC al dispositivo y una actualización. Dirígete a la carpeta de instalación y verás las plantillas JSON provistas por VMware.

![cli3]({{ site.imagesposts2018 }}/08/cli3.png)

![cli4]({{ site.imagesposts2018 }}/08/cli4.png)

### Crear el archivo JSON

Con los archivos de configuración de JSON, puede abrirlos en cualquier editor de texto para realizar los cambios necesarios. Hay una pequeña descripción para cada configuración en cuanto a lo que se requiere. Recomiendo ver el video al comienzo de esta publicación mientras recorro cada una de las configuraciones. Aunque puede abrir en un editor de texto, encontré un excelente editor en línea JSON (http://www.jsoneditoronline.org/) que también le muestro en mi clip de YouTube.

He puesto la salida de mi archivo JSON completo a continuación. También ingresé en una sección para el servidor NTP, que recomiendo que también lo haga. Asegúrese de poner la coma en la línea sobre la entrada NTP.Servers y guarde el archivo JSON.

La documentación de vSphere 6.5 contiene información para todas las configuraciones que se pueden usar en el archivo JSON - https://pubs.vmware.com/vsphere-65/index.jsp#com.vmware.vsphere.install.doc/GUID- 457EAE1F-B08A-4E64-8506-8A3FA84A0446.html


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

### Usando vcsa-deploy

Ahora que tenemos un archivo JSON que especifica la configuración, podemos sumergirnos en la ejecución de la utilidad CLI para verificar que los datos en el archivo de configuración sean correctos y luego pasar a la implementación del dispositivo.

Abra un símbolo del sistema y busque la siguiente ubicación, donde la unidad representa el archivo ISO de VCSA que montamos anteriormente (para mí esto es E: \) - E: \ vcsa-cli-installer \ win32

Ejecute el siguiente comando para mostrar la ayuda y las opciones disponibles para la configuración de instalación de la herramienta:

`vcsa-deploy.exe install -h`

'vcsa-deploy.exe install --acknowledge-ceip --accept-eula --no-ssl-certificate-verification c:\tmp\vcenter67.json`