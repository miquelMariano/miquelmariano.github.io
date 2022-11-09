---
title: Script para apagar/encender VM repositorio immutable Veeam
date: '2022-11-09 00:00:00'
layout: post
tag:
- vmware
- vsphere
- vexpert
- veeam
- ramsonware
- immutable
---

Hace varios meses, en [este post](https://miquelmariano.github.io/2022/04/05/veeam11-immutable-repository-hardening/) vimos como instalar y configurar un repositorio immutable con la nueva versión de Veeam 11.

Hoy vengo a dar una vuelta de tuerca más a este asunto y veremos como a demás de hacer el repositorio immutable lo podemos dejar offline mientras no tengamos trabajos de protección en ejecución.

Para ello, configuraremos unos scripts pre y post ejecución del trabajo de backup que lo que harán será arrancar y apagar la VM que tiene el repositorio immutable.

Pero antes de nada, os recomiendo que actualiceis vuestra versión de PowerCLI a la última disponible. En [este post](https://miquelmariano.github.io/2019/01/09/instalar-powerCLI-10-windows/) explico como hacerlo.

Vamos al lio ;-)

El script lo podreis encontrar [aquí](https://raw.githubusercontent.com/miquelMariano/vSphere-PowerCLI/master/start-stop-vm/start-stop-vm.ps1) y es muy fácil de utilizar, simplemente pasando por parámetro ciertas variables nos servirá para encender o apagar cualquier VM.

Por ejemplo:
```
.\start-stop-vm.ps1 -vCenter "172.16.99.111" -vCenteruser "administrator@vsphere.local" -vm "HB-VeeamImmutable-Semanal-OF"  -status "off"
.\start-stop-vm.ps1 -vCenter "172.16.99.111" -vCenteruser "administrator@vsphere.local" -vm "HB-VeeamImmutable-Semanal-OF"  -status "on"
```


Simplemente editaremos nuestros backups con destino al repositorio immutable y configuraremos el script tanto antes como después del procesamiento del job.

![immutable-offline-01]({{ site.imagesposts2022 }}/11/immutable-offline-01.png){: .align-center}

`"C:\Program Files\PowerShell\7\pwsh.exe" -ExecutionPolicy ByPass -Command " & c:\encora\scripts\start-stop-vm.ps1 -vCenter '172.16.99.111' -vCenteruser 'administrator@vsphere.local' -vm 'HB-VeeamImmutable-Semanal-OF'  -status 'on' -ErrorAction Stop"

Antes:
`C:\scripts\start-stop-vm.ps1 -vCenter "192.168.33.90" -vCenteruser "veeam_user@vsphere.local" -vm "SRVIMMUTABLE01"  -status "on"`

Después
`C:\scripts\start-stop-vm.ps1 -vCenter "192.168.33.90" -vCenteruser "veam_user@vsphere.local" -vm "SRVIMMUTABLE01"  -status "off"`

Y ya con esto, podremos ver en los logs como se ejecuta el script y nos arranca/apaga la VM que tiene el repositorio immutable

![immutable-offline-02]({{ site.imagesposts2022 }}/11/immutable-offline-02.png){: .align-center}

Y ahora que habeis llegado hasta aquí, os recomiendo que os paseis por todos los posts relacionados con los [Repositorios Immutables de Veeam](https://miquelmariano.github.io/tag/#/immutable) que ya tenemos publicados en este blog

Muchas gracias

Un saludo!!!