---
title: PowerCLI, comandos útiles sin scripts
date: '2019-02-26 00:00:00'
layout: post
image: /assets/images/posts/2019/02/onliners-banner.png
headerImage: true
tag:
- vexpert
- automation
- vsphere
- vmware
- powercli
category: blog
author: miquelMariano
description: Hoy, me gustaría compartir con vosotros una lista de commandos que podemos ejecutar sin necesidad de crear ningún script y que nos dan información muy valiosa de nuestro entorno vsphere
hidden: false
comments: true
---

Buenos días a tod@s!!

En el post de hoy me gustaría compartir con todos vosotros una serie de comandos PowerCLI que nos dan información muy útil de nuestro entorno vSphere. Vamos al lío:

Lista de VMs con snapshots:

```powershell
Get-VM | Get-Snapshot | where {$_.Name -notmatch "Restore Point \w"} | Select VM,Name,Description,@{Label="Size";Expression={"{0:N2} GB" -f ($_.SizeGB)}},Created | FT -Autosize
```

Lista de VMs con CD montado:

```powershell
Get-VM | Get-CDDrive | Where-Object {$_.IsoPath -ne $null} | Select Parent,IsoPath 
```

Desmontar todas las ISOs montadas en todas las VMs:

```powershell
Get-VM | Get-CDDrive | where {$_.IsoPath -ne $null} | Set-CDDrive -NoMedia -Confirm:$False
```

Ver estado del servicio SSH:

```powershell
Get-VMHost | Get-VMHostService | Where { $_.Key -eq "TSM-SSH" } |select VMHost, Label, Running
```

Arrancar servicio SSH:

```powershell
Get-VMHost | Foreach {Start-VMHostService -HostService ($_ | Get-VMHostService | Where { $_.Key -eq "TSM-SSH"} )}
```

Apagar servicio SSH:

```powershell
Get-VMHost | Foreach {stop-VMHostService -HostService ($_ | Get-VMHostService | Where { $_.Key -eq "TSM-SSH"} )}
```

Contar numero de VMs por host:

```powershell
Get-VMHost | Sort-Object Name | Select Name,@{N="VM";E={ if ($_.ExtensionData.Vm -ne $null) { $_.ExtensionData.Vm.Count } else {0}}}
```

Contar numero de VMs por datastore:

```powershell
Get-datastore | Sort-Object Name | Select Name,@{N="VM";E={ if ($_.ExtensionData.Vm -ne $null) { $_.ExtensionData.Vm.Count } else {0}}}
```

Ver información hardware de los ESXi:

```powershell
Get-VMHost |Sort Name |Get-View | Select Name, @{N=“Type“;E={$_.Hardware.SystemInfo.Vendor+ “ “ + $_.Hardware.SystemInfo.Model}}, @{N=“CPU“;E={“PROC:“ + $_.Hardware.CpuInfo.NumCpuPackages + “CORES:“ + $_.Hardware.CpuInfo.NumCpuCores + “ MHZ: “ +[math]::round($_.Hardware.CpuInfo.Hz / 1000000, 0)}}, @{N=“MEM“;E={“” + [math]::round($_.Hardware.MemorySize / 1GB, 0) + “GB“}} | FT -autosize
```

Ver estado de las VMware Tools y Virtual Hardware de las VMs encendidas:

```powershell
Get-VM | Select @{N=”VMName”; E={$_.Name}}, @{N=”State”; E={$_.PowerState}},  @{N=”HardwareVersion”; E={$_.Extensiondata.Config.Version}}, @{N=”ToolsVersion”; E={$_.Extensiondata.Config.Tools.ToolsVersion}}, @{N=”ToolsStatus”; E={$_.Extensiondata.Summary.Guest.ToolsStatus}}, @{N=”ToolsVersionStatus”; E={$_.Extensiondata.Summary.Guest.ToolsVersionStatus}}, @{N=”ToolsRunningStatus”; E={$_.Extensiondata.Summary.Guest.ToolsRunningStatus}} | where state -notmatch poweredoff | FT
```

Ver las VMs que se han creado recientemente:

```powershell
Get-VIEvent -maxsamples 10000 | Where {$_.Gettype().Name -eq "VmCreatedEvent"} | Select createdTime, UserName, FullFormattedMessage
```

Ver las VMs que se han eliminado recientemente:

```powershell
Get-VIEvent -maxsamples 10000 | Where {$_.Gettype().Name -eq "VmRemovedEvent"} | Select createdTime, UserName, FullFormattedMessage
```

Ver errores de la última semana:

```powershell
Get-VIEvent -maxsamples 10000 -Type Error -Start (get-date).AddDays(-7) | Select createdTime, fullFormattedMessage
```

Ver VMs con la nic e1000:

```powershell
get-vm | Get-NetworkAdapter | where {$_.type -match "e1000"} | select-object parent,networkname,name,type
```

Búsqueda de VM por su MAC ADDRESS:

```powershell
Get-VM | Get-NetworkAdapter | Where-Object {$_.MacAddress -eq "00:50:56:ba:ca:5b"} | FL
```

Búsqueda de VMs con discos RDM:

```powershell
Get-VM | Get-HardDisk | Where-Object {$_.DiskType -like “Raw*”} | Select @{N=”VMName”;E={$_.Parent}},Name,DiskType,@{N=”LUN_ID”;E={$_.ScsiCanonicalName}},@{N=”VML_ID”;E={$_.DeviceName}},Filename,CapacityGB
```



Espero que os sea de utilidad.

Si vosotros tenéis alguno que queráis compartir, por favor, dejado en los comentarios y lo incorporaremos a la lista.

Muchas gracias.

Un saludo!

Miquel.


