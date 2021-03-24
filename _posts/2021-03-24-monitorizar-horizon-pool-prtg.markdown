---
title: Script para monitorizar estadísticas de uso en un pool Horizon
date: '2021-03-24 00:00:00'
layout: post
tag:
- vmware
- horizon
- vexpert
- euc
- desktop
- mobility
- powershell
- powercli
---

Hoy quiero compartir con todos vosotros un script en PowerCLI que he escrito para monitorizar las estadísticas de nuestros pooles de VMware Horizon e integrarlo con PRTG

# VMware PowerCLI para horizon

Hace ya tiempo, compartí un procedimiento de [cómo instalar y configurar VMware PowerCLI](https://miquelmariano.github.io/2019/01/09/instalar-powerCLI-10-windows/). A dia de hoy ya vamos por la versión 7 de powershell y la versión 12 de PowerCLI, pero el procedimiento sigue siendo válido.

Una vez tengamos PowerShell instalado y los módulos también instalados, podremos comprobar que ya está disponible

```powershell
get-module -listavailable
```
![powercli-horizon-01]({{ site.imagesposts2021 }}/03/powercli-horizon-01.png){: .align-center}

Será necesario también instalar las funciones avanzadas para Horizon. En [este post](https://blogs.vmware.com/euc/2020/01/vmware-horizon-7-powercli.html) se explica con detalle.

# El script

La última versión del script, la podreis encontrar [aquí](https://raw.githubusercontent.com/miquelMariano/prtg-scripts/master/vmware/vmware_horizon_pool_stats.ps1)

Básicamente lo que hacemos es pasarle por parámetro las opciones de conexión y eso nos genera un log con toda la información.

Podemos medir la cantidad de escritorios disponibles en el pool, si hay errores de aprovisionamiento o si nuestros usuarios se desconectan sin cerrar sesión entre otras cosas

```
24-03-21 12:46:58 |  Disconnect Connection Server vdi.mydomain.com
24-03-21 12:46:58 |  Total VMs ------------------ 100
24-03-21 12:46:58 |  Available ------------------ 19
24-03-21 12:46:58 |  Connected ------------------ 78
24-03-21 12:46:58 |  Desconnected --------------- 2
24-03-21 12:46:58 |  Maintenance ---------------- 1
24-03-21 12:46:58 |  Provisioning --------------- 0
24-03-21 12:46:58 |  Customizing ---------------- 0
24-03-21 12:46:58 |  Alredy in use -------------- 0
24-03-21 12:46:58 |  Agent unreachable ---------- 0
24-03-21 12:46:58 |  Error ---------------------- 0
24-03-21 12:46:58 |  Deleting ------------------- 0
24-03-21 12:46:58 |  Provisioning error --------- 0
24-03-21 12:46:58 |  Desktop IC-VSAN-025 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-027 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-085 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-070 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-054 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-013 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-077 is in a AVAILABLE state.
24-03-21 12:46:58 |  Desktop IC-VSAN-046 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-038 is in a DISCONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-026 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-005 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-031 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-006 is in a AVAILABLE state.
24-03-21 12:46:58 |  Desktop IC-VSAN-061 is in a AVAILABLE state.
24-03-21 12:46:58 |  Desktop IC-VSAN-011 is in a AVAILABLE state.
24-03-21 12:46:58 |  Desktop IC-VSAN-093 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-088 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-097 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-062 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-019 is in a AVAILABLE state.
24-03-21 12:46:58 |  Desktop IC-VSAN-059 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-078 is in a AVAILABLE state.
24-03-21 12:46:58 |  Desktop IC-VSAN-043 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-053 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-055 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-010 is in a AVAILABLE state.
24-03-21 12:46:58 |  Desktop IC-VSAN-037 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-064 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-051 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-074 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-024 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-065 is in a DISCONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-099 is in a AVAILABLE state.
24-03-21 12:46:58 |  Desktop IC-VSAN-042 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-072 is in a AVAILABLE state.
24-03-21 12:46:58 |  Desktop IC-VSAN-048 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-058 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-014 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-067 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-089 is in a AVAILABLE state.
24-03-21 12:46:58 |  Desktop IC-VSAN-081 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-029 is in a AVAILABLE state.
24-03-21 12:46:58 |  Desktop IC-VSAN-056 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-071 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-004 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-060 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-008 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-001 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-049 is in a AVAILABLE state.
24-03-21 12:46:58 |  Desktop IC-VSAN-007 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-040 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-095 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-002 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-032 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-052 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-041 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-016 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-082 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-084 is in a AVAILABLE state.
24-03-21 12:46:58 |  Desktop IC-VSAN-033 is in a MAINTENANCE state.
24-03-21 12:46:58 |  Desktop IC-VSAN-023 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-083 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-044 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-063 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-045 is in a AVAILABLE state.
24-03-21 12:46:58 |  Desktop IC-VSAN-022 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-086 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-018 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-079 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-047 is in a AVAILABLE state.
24-03-21 12:46:58 |  Desktop IC-VSAN-034 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-009 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-087 is in a AVAILABLE state.
24-03-21 12:46:58 |  Desktop IC-VSAN-003 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-021 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-100 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-094 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-039 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-090 is in a AVAILABLE state.
24-03-21 12:46:58 |  Desktop IC-VSAN-096 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-030 is in a AVAILABLE state.
24-03-21 12:46:58 |  Desktop IC-VSAN-075 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-080 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-012 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-057 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-092 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-073 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-015 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-069 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-076 is in a AVAILABLE state.
24-03-21 12:46:58 |  Desktop IC-VSAN-035 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-098 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-020 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-066 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-036 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-028 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-068 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-050 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-091 is in a CONNECTED state.
24-03-21 12:46:58 |  Desktop IC-VSAN-017 is in a CONNECTED state.
24-03-21 12:46:57 |  Connection Server vdi.mydomain.com connected well!
24-03-21 12:46:55 |  Connecting to Connection Server vdi.mydomain.com...
24-03-21 12:46:55 |  Start Check
```

# Sensor PRTG

El script, está pensado de tal manera que lo podamos ejecutar el sensor [EXE/Script Advanced Sensor](https://www.paessler.com/manuals/prtg/exe_script_advanced_sensor)

La información que recoge y muestra en el log también la expone en formato xml para que el PRTG sea capaz de interpretarlo y hacer una gráfica

El resultado seria el siguiente:

![powercli-horizon-02]({{ site.imagesposts2021 }}/03/powercli-horizon-02.png){: .align-center}

![powercli-horizon-03]({{ site.imagesposts2021 }}/03/powercli-horizon-03.png){: .align-center}

Espero que os sirva.

Un saludo!

Miquel.


