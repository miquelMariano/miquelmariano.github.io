---
title: Checkear dead path en ESXi
date: '2017-10-18 00:00:00'
layout: post
image: /assets/images/posts/2017/10/dead-path.jpg
headerImage: true
tag:
- vexpert
- devops
- vsphere
- esxi
- san
- powercli
---

Buenos dias a tod@s!!

En el post de hoy os voy a mostrar la manera que he ideado para poder monitorizar el estado de los paths de los datastores VMFS en nuestros ESXi. Se trata del siguiente [script de PowerCLI](https://github.com/miquelMariano/prtg-scripts/blob/master/vmware/vmware_check_dead_lun_path.ps1)

La configuración del script es de lo mas sencilla, simplemente deberemos de cambiar las variables del apartado `GLOBAL VARS`

La ejecución del script nos creará un log, en el que facilmente podremos identificar si tenemos algún ESXi en nuestra infraestructura con algún path down hacia el almacenamiento

```

16-10-17 17:20:09 |  Disconnect vCenter server!
16-10-17 17:20:09 |  0 paths down on esxi05.ncoraformacion.local
16-10-17 17:20:09 |  ||
16-10-17 17:20:09 |  Starting analysis of ESXi esxi05.ncoraformacion.local analyze | 
16-10-17 17:19:54 |  0 paths down on esxi04.ncoraformacion.local
16-10-17 17:19:54 |  ||
16-10-17 17:19:40 |  Starting analysis of ESXi esxi04.ncoraformacion.local analyze | 
16-10-17 17:19:40 |  28 paths down on esxi03.ncoraformacion.local
16-10-17 17:19:40 |  naa.60060e8012ad9c005040ad9c00000012 naa.60060e8012ad9c005040ad9c00000013 naa.60060e8012ad9c005040ad9c00000014 naa.60060e8012ad9c005040ad9c00000015 naa.60060e8012ad9c005040ad9c000030ff naa.60060e8012ad9c005040ad9c00003000 naa.60060e8012ad9c005040ad9c00003001 naa.60060e8012ad9c005040ad9c00003002 naa.60060e8012ad9c005040ad9c00003003 naa.60060e8012ad9c005040ad9c00003004 naa.60060e8012ad9c005040ad9c00003005 naa.60060e8012ad9c005040ad9c00003006 naa.60060e8012ad9c005040ad9c0000300d naa.60060e8012ad9c005040ad9c0000300e naa.60060e8012ad9c005040ad9c0000300f naa.60060e8012ad9c005040ad9c00003010 naa.60060e8012ad9c005040ad9c00003011 naa.60060e8012ad9c005040ad9c00003012 naa.60060e8012ad9c005040ad9c00003013 naa.60060e8012ad9c005040ad9c00003014 naa.60060e8012ad9c005040ad9c00003015 naa.60060e8012ad9c005040ad9c00003016 naa.60060e8012ad9c005040ad9c00000000 naa.60060e8012ad9c005040ad9c00000000 naa.60060e8012ad9c005040ad9c00000004 naa.60060e8012ad9c005040ad9c00000005 naa.60060e8012ad9c005040ad9c00000006 naa.60060e8012ad9c005040ad9c00000007|Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead|
16-10-17 17:16:43 |  Starting analysis of ESXi esxi03.ncoraformacion.local analyze | 
16-10-17 17:16:43 |  28 paths down on esxi02.ncoraformacion.local
16-10-17 17:16:43 |  naa.60060e8012ad9c005040ad9c00000012 naa.60060e8012ad9c005040ad9c00000013 naa.60060e8012ad9c005040ad9c00000014 naa.60060e8012ad9c005040ad9c00000015 naa.60060e8012ad9c005040ad9c000030ff naa.60060e8012ad9c005040ad9c00003000 naa.60060e8012ad9c005040ad9c00003001 naa.60060e8012ad9c005040ad9c00003002 naa.60060e8012ad9c005040ad9c00003003 naa.60060e8012ad9c005040ad9c00003004 naa.60060e8012ad9c005040ad9c00003005 naa.60060e8012ad9c005040ad9c00003006 naa.60060e8012ad9c005040ad9c0000300d naa.60060e8012ad9c005040ad9c0000300e naa.60060e8012ad9c005040ad9c0000300f naa.60060e8012ad9c005040ad9c00003010 naa.60060e8012ad9c005040ad9c00003011 naa.60060e8012ad9c005040ad9c00003012 naa.60060e8012ad9c005040ad9c00003013 naa.60060e8012ad9c005040ad9c00003014 naa.60060e8012ad9c005040ad9c00003015 naa.60060e8012ad9c005040ad9c00003016 naa.60060e8012ad9c005040ad9c00000000 naa.60060e8012ad9c005040ad9c00000000 naa.60060e8012ad9c005040ad9c00000004 naa.60060e8012ad9c005040ad9c00000005 naa.60060e8012ad9c005040ad9c00000006 naa.60060e8012ad9c005040ad9c00000007|Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead Dead|
16-10-17 14:00:33 |  Starting analysis of ESXi esxi02.ncoraformacion.local analyze | 
16-10-17 14:00:33 |  0 paths down on esxi01.ncoraformacion.local
16-10-17 14:00:33 |  ||
16-10-17 14:00:14 |  Starting analysis of ESXi esxi01.ncoraformacion.local analyze | 
16-10-17 14:00:10 |  vCenter connected!
16-10-17 14:00:08 |  Connecting vCenter...
16-10-17 14:00:00 |  Start Check
```

No hace falta decir que este log, puede ser monitorizado con nuestra herramienta de monitorización preferida, como puede ser [PRTG](https://www.es.paessler.com/prtg) y que nos genere una alerta cada vez que detecte algún "Dead" en el log.

Y hasta aquí por hoy, si os ha resultado de vuestro interés, por favor no dudeis en compartir en vuestras RRSS :-)

Un saludo!



Miquel.