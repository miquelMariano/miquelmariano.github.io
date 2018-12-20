---
title: Programar export automático de RVTools
layout: post
date: 2017-04-17 00:00:00
image: /assets/images/posts/2017/04/RVTools_logo.png
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- devops
- automation
- powercli
category: blog
author: miquelMariano
description: Programar export automático de RVTools
hidden: false
comments: true
---

Por si todavía quedan vSphere admins que no sepan lo que son las RVTools, deciros que:

+ RVTools es una aplicación de Windows .NET 4.0 que utiliza el VI SDK para mostrar información sobre entornos virtuales. 
+ Puede interactuar con vCenter o directamente contra un hosts ESXi
+ Es capaz de listar información sobre VMs, CPU, memoria, discos, particiones, red, unidades de disquete, unidades de CD, instantáneas, herramientas de VMware, grupos de recursos, clústeres, hosts ESX, HBA, Nics, Switches, Puertos , Interruptores Distribuidos, Puertos Distribuidos, Consolas de Servicio, Núcleos VM, Almacén de Datastores, información de rutas múltiples, información de licencia y controles de salud. 
+ Con RVTools puede desconectar las unidades de CD-ROM o de disquete de las máquinas virtuales y actualizar las VMware Tools instaladas dentro de cada máquina virtual a la última 
+ Soporta vCenter 6.5 y ESX 6.5.
+ Puede exportar la información a .xls o .csv

Dicho esto, al bueno de [Sneddo](https://github.com/Sneddo) no se le ha ocurrido otra cosa que programar un [script](https://github.com/Sneddo/Powershell/blob/master/VMware/Export-RVTools.ps1) para poder programar un export automático de toda la información de nuestra infraestructura.

¿No os ha pasado alguna vez que se hos ha parado el vCenter (voluntaria o involuntariamente) y luego no sabéis en que ESXi está inventariado para volver a encenderlo?

A mi si, y en un entorno pequeño no cuesta mucho ir conectandote uno a uno a tus ESXi para ver si está y encenderlo. Pero, y si tu infra cuenta con decenas de ESXi en el cúster. Estás buscando una aguja en un pajar!!!

Pues para eso está este script, para poder configurar una tarea programada en nuestro Windows y tener una copia periódica de toda la información de nuestra infraestructura en un excel.

Las únicas variables que tenemos que cambiar del script son el vCenter al que se conectará, el path donde guardará los .xls y la retención (en días) que queramos mantener

```powershell
param
(
   $Servers = @("Server"),
   $BasePath = "C:\Scripts\Powershell\RVToolsExport\Archive",
   $OldFileDays = 30
)
```


Y ahi va el script...


```powershell
<# 
.SYNOPSIS 
   Performs full export from RVTools
.DESCRIPTION
   Performs full export from RVTools. Archives old versions.
.NOTES 
   File Name  : Export-RVTools.ps1 
   Author     : John Sneddon
   Version    : 1.0.0
.PARAMETER Servers
   Specify which vCenter server(s) to connect to
.PARAMETER BasePath
   Specify the path to export to. Server name and date appended.
.PARAMETER OldFileDays
   How many days to retain copies
#>
param
(
   $Servers = @("Server"),
   $BasePath = "C:\Scripts\Powershell\RVToolsExport\Archive",
   $OldFileDays = 30
)

$Date = (Get-Date -f "yyyyMMdd")

foreach ($Server in $Servers)
{
   # Create Directory
   New-Item -Path "$BasePath\$Server\$Date" -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

   # Run Export
   . "C:\Program Files (x86)\RobWare\RVTools\RVTools.exe" -passthroughAuth -s "$Server.internal.southernhealth.org.au" -c ExportAll2csv -d "$BasePath\$Server\$Date"

   # Cleanup old files
   $Items = Get-ChildItem "$BasePath\$server"
   foreach ($item in $items)
   {
      $itemDate = ("{0}/{1}/{2}" -f $item.name.Substring(6,2),$item.name.Substring(4,2),$item.name.Substring(0,4))
      
      if ((((Get-date).AddDays(-$OldFileDays))-(Get-Date($itemDate))).Days -gt 0)
      {
         $item | Remove-Item -Recurse
      }
   }
}
```

Un saludo

Miquel.