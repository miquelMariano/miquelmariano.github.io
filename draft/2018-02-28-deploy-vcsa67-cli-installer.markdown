---
title: Automatizando configuración de VMWare ESXi tras instalación
date: '2018-02-28 00:00:00'
layout: post
image: /assets/images/posts/2018/05/esxi_auto.png
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- devops
- backtobasics
category: blog
author: miquelMariano
description: Automatizando configuración de VMWare ESXi tras instalación
hidden: false
permalink: /cliinstaller/
---

https://virtualtassie.com/2017/vsphere-6-5-cli-vcsa-embedded-deployment-walkthrough/


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


>vcsa-deploy.exe install --acknowledge-ceip --accept-eula --no-ssl-certificate-verification c:\tmp\vcenter67.json