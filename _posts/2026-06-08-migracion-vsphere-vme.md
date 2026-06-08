---
title: Migración de VMs Windows desde vSphere a HPE VM Essentials
subtitle: Migración nativa con planes de migración de VME
date: '2026-06-08 00:00:00'
layout: post
thumbnail-img: https://miquelmariano.github.io/assets/images/posts/2026/04/ha-01.png
cover-img: https://miquelmariano.github.io/assets/images/fondos/07.jpg
share-img: https://miquelmariano.github.io/assets/images/posts/2026/04/ha-01.png
published: true
author: Miquel Mariano
tag:
- kvm
- hpe
- vme
- cloud
- morpheus
- ha
---

Seguimos con la serie de posts sobre HPE VM Essentials, y en esta entrega abordamos uno de los casos de uso más habituales en los proyectos de adopción de la plataforma: **la migración de VMs Windows desde un entorno vSphere existente**.

Como veremos, el proceso requiere una preparación previa en origen que es imprescindible. Si nos saltamos estos pasos, la VM no arrancará en el nuevo hipervisor KVM. Así que vamos paso a paso.

> ⚠️ **OJO**: El trabajo de migración apaga automáticamente la VM origen. Tenerlo en cuenta a la hora de planificar la ventana de mantenimiento.

<details markdown="1">
<summary>VER TODA LA SERIE DE POSTS</summary>
- [Parte 1 - Introducción a HPE Morpheus VM Essentials software](https://miquelmariano.github.io/introduccion-hpe-morpheus-vm-essentials-software/)
- [Parte 2 - Instalación VM Essentials software](https://miquelmariano.github.io/instalacion-nodo-vme/)
- [Parte 3 - Instalación VME Manager](https://miquelmariano.github.io/instalacion-manager/)
- [Parte 4 - Configuración inicial](https://miquelmariano.github.io/configuracion-inicial-primeros-pasos-vm-essentials)
- [Parte 5 - Creación cluster Ceph](https://miquelmariano.github.io/cluster-ceph/)
- [Parte 6 - Desplegar nuestra primera VM](https://miquelmariano.github.io/primera-vm-en-vmessentials/)
- [Parte 7 - Backups](https://miquelmariano.github.io/backups-en-vm-essentials/)
- [Parte 8 - Pruebas de HA](https://miquelmariano.github.io/ha-en-vm-essentials/)
- [Parte 9 - Migración de VMs desde vSphere](https://miquelmariano.github.io/migracion-vsphere-vme/)
- [Parte 9.1 - Migración con Veeam](https://miquelmariano.github.io/migracion-vsphere-vme-veeam/)
- [Parte 10 - Comandos útiles]
- [Parte 11 - Gestión de actualizaciones en HPE VM Essentials](https://miquelmariano.github.io/actualizaciones-vme-manager-y-nodos-hvm)
</details>

# Requisitos previos

Antes de comenzar, verificar que la VM cumple estas condiciones:

- Boot configurado como **EFI o BIOS**
- **Virtualization Based Security (VBS)** habilitado
- **Secure Boot** habilitado
- **TPM deshabilitado**
- Acceso a la **partición de recuperación** de Windows

La documentación oficial de HPE para este proceso la encontraréis [aquí:](https://support.hpe.com/hpesc/public/docDisplay?docId=sd00007735en_us&page=GUID-D3E08022-96A5-4BD8-9DDF-67D942A361C0.html)

# FASE 1 — Inyección de drivers VirtIO

El problema principal al migrar de VMware a KVM es que el hipervisor destino necesita sus propios drivers de almacenamiento (**VirtIO**). Sin ellos, Windows no será capaz de acceder al disco en el nuevo entorno y simplemente no arrancará.

Lo que haremos es inyectar estos drivers directamente en la imagen del sistema operativo **antes de apagar la VM para migrarla**.

## Descargar el ISO de VirtIO

La última versión la encontraréis [aquí:](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.285-1/)

Nos descargaremos el último fichero .iso y lo subiremos a un datastore de nuestro entorno vSphere para montarla como CD-ROM en la VM.

## Arrancar en Windows Recovery Environment (WinRE)

Necesitamos acceder a la CMD en modo recovery para poder inyectar los drivers offline. Hay dos formas de llegar aquí:

**Opción A** — Reiniciar con la tecla `Shift` pulsada en el menú de inicio.

![native-migration-01]({{ site.imagesposts2026 }}/06/native-migration-01.png){: .mx-auto.d-block :}

**Opción B** — Desde `Configuración > Recuperación > Reiniciar ahora`.

![native-migration-02]({{ site.imagesposts2026 }}/06/native-migration-02.png){: .mx-auto.d-block :}

Una vez dentro del menú de recuperación: `Troubleshoot → Advanced Options → Command Prompt`

![native-migration-04]({{ site.imagesposts2026 }}/06/native-migration-04.png){: .mx-auto.d-block :}

![native-migration-05]({{ site.imagesposts2026 }}/06/native-migration-05.png){: .mx-auto.d-block :}

## Verificar visibilidad de discos

Con la CMD abierta, lanzar `diskpart` y listar los discos:

```
diskpart
list disk
```

Pueden ocurrir dos situaciones:

- **El disco aparece listado** → saltar directamente al apartado "Inyectar los drivers"
- **No aparece ningún disco** → continuar con el siguiente apartado

## Montar los drives (solo si el disco no es visible)

Desde vCenter, montar el instalador de VMware Tools en la VM:
`Actions → Guest OS → Install VMware Tools...`

De vuelta en diskpart, localizar la letra del CD-ROM:

```
list volume
```

Anotar la letra asignada al CD-ROM (en el ejemplo: `D:`).
 Salir de diskpart con `exit` y cargar el driver PVSCSI para que Windows pueda ver los discos:

```
drvload "D:\Program Files\VMware\VMware Tools\Drivers\pvscsi\Win10\amd64\pvscsi.inf"
```


> ⚠️ Ajustar la ruta si el CD-ROM tiene otra letra o si hay una versión más reciente en el ISO.

Volver a entrar en diskpart y asignar letra de unidad al volumen principal de Windows:

```
diskpart
list volume
select volume 1
assign letter=c
list volume
exit
```

Desde vCenter, desmontar el instalador de VMware Tools:
`Actions → Guest OS → Unmount VMware Tools Installer`

## Inyectar los drivers VirtIO en la imagen de Windows

Con el disco ya accesible y el ISO de VirtIO montado como CD-ROM, ejecutar los siguientes comandos para inyectar los drivers de almacenamiento en los drivers de arranque del sistema:

```
dism /image:C:\ /add-driver:D:\viostor\2k22\amd64\viostor.inf
dism /image:C:\ /add-driver:D:\vioscsi\2k22\amd64\vioscsi.inf
```

> ⚠️ Ajustar `2k22` según la versión del SO (`2k19`, `2k16`, etc.) y verificar las letras de unidad en cada caso.


Si todo ha ido bien, DISM confirmará con un mensaje de instalación exitosa para cada driver. Cerrar la CMD y pulsar **Continue** para arrancar Windows normalmente.

![native-migration-06]({{ site.imagesposts2026 }}/06/native-migration-06.png){: .mx-auto.d-block :}

---

# FASE 2 — Preparación del SO

Con Windows arrancado normalmente y la ISO de VirtIO todavía montado, instalar los drivers en el SO ejecutando desde la raíz de la ISO:

1. `virtio-win-gt-x64.msi`
2. `virtio-win-guest-tools.exe`

Mantener todas las opciones por defecto durante la instalación.

Una vez completada la instalación, desmontar todos las ISOs de la VM (desde Windows con "Eject" o desde vCenter poniendo el CD-ROM como "Client Device").

## Guardar la configuración de red

> ⚠️ **Problema importante post-migración**: al mover la VM a HPE VME, Windows asignará un nuevo adaptador de red VirtIO (Red Hat VirtIO Ethernet Adapter) y el adaptador VMware original (Intel 82574L) quedará inactivo. Esto provoca que la VM pierda su configuración IP.

Para solucionar esto de forma controlada, ejecutar el siguiente script en PowerShell **como administrador antes de apagar la VM**:

```powershell
.\Manage-NetworkConfig.ps1 -Action save
```

El script guardará la IP, máscara, gateway y DNS en `C:\migration-netcfg.json` para restaurarlos después de la migración.

![native-migration-07]({{ site.imagesposts2026 }}/06/native-migration-07.png){: .mx-auto.d-block :}

Podéis descargar el script [aquí](https://miquelmariano.github.io/assets/images/Manage-NetworkConfig.ps1).

---

# FASE 3 — Añadir el cluster vSphere a HPE VME

Antes de poder crear un plan de migración, necesitamos que VME Manager tenga visibilidad sobre el entorno vSphere origen.

Desde la interfaz de HPE VME: `Infrastructure → Clouds → Add Cloud → VMware vCenter`

Rellenar los datos de conexión:
- **API URL**: URL de vCenter
- **Credentials**: usuario y contraseña con permisos suficientes
- **Version**: 7.0+
- **VDC**: el datacenter correspondiente
- **Cluster**: el cluster donde reside la VM a migrar

Marcar la opción **Inventory Existing Instances** para que VME importe el inventario existente. Una vez completada la sincronización, las VMs del entorno vSphere estarán disponibles en la plataforma.

![native-migration-08]({{ site.imagesposts2026 }}/06/native-migration-08.png){: .mx-auto.d-block :}
![native-migration-09]({{ site.imagesposts2026 }}/06/native-migration-09.png){: .mx-auto.d-block :}
![native-migration-10]({{ site.imagesposts2026 }}/06/native-migration-10.png){: .mx-auto.d-block :}
![native-migration-11]({{ site.imagesposts2026 }}/06/native-migration-11.png){: .mx-auto.d-block :}
![native-migration-12]({{ site.imagesposts2026 }}/06/native-migration-12.png){: .mx-auto.d-block :}
![native-migration-13]({{ site.imagesposts2026 }}/06/native-migration-13.png){: .mx-auto.d-block :}
![native-migration-14]({{ site.imagesposts2026 }}/06/native-migration-14.png){: .mx-auto.d-block :}
![native-migration-15]({{ site.imagesposts2026 }}/06/native-migration-15.png){: .mx-auto.d-block :}

---

# FASE 4 — Crear y ejecutar el Migration Plan

Con la VM apagada y el Cloud de vSphere integrado en VME, es el momento de crear el plan de migración.

Desde la interfaz de HPE VME: `Operations → Migration`

El asistente nos guiará por los siguientes pasos:

1. **Configuration**: nombre y descripción del plan
2. **Choose VMs**: seleccionar la VM (o VMs) a migrar
3. **Map Resources**: mapear el cluster destino, el datastore y la red en HPE VME
4. **Review**: revisión final antes de ejecutar

Una vez configurado, ejecutar el plan con **Start Plan**. 
Durante la ejecución podemos monitorizar el progreso desde la misma pantalla. 
Al finalizar, la VM original en vSphere quedará apagada y la nueva instancia estará disponible en HPE VME.

![native-migration-17]({{ site.imagesposts2026 }}/06/native-migration-17.png){: .mx-auto.d-block :}
![native-migration-18]({{ site.imagesposts2026 }}/06/native-migration-18.png){: .mx-auto.d-block :}
![native-migration-19]({{ site.imagesposts2026 }}/06/native-migration-19.png){: .mx-auto.d-block :}
![native-migration-20]({{ site.imagesposts2026 }}/06/native-migration-20.png){: .mx-auto.d-block :}
![native-migration-21]({{ site.imagesposts2026 }}/06/native-migration-21.png){: .mx-auto.d-block :}
![native-migration-22]({{ site.imagesposts2026 }}/06/native-migration-22.png){: .mx-auto.d-block :}
![native-migration-23]({{ site.imagesposts2026 }}/06/native-migration-23.png){: .mx-auto.d-block :}
![native-migration-24]({{ site.imagesposts2026 }}/06/native-migration-24.png){: .mx-auto.d-block :}
![native-migration-25]({{ site.imagesposts2026 }}/06/native-migration-25.png){: .mx-auto.d-block :}
![native-migration-26]({{ site.imagesposts2026 }}/06/native-migration-26.png){: .mx-auto.d-block :}

---

# FASE 5 — Post-migración

## Restaurar la configuración de red

Con la VM ya arrancada en HPE VME, abrir PowerShell como administrador y ejecutar:

```powershell
.\Manage-NetworkConfig.ps1 -Action restore
```

El script detectará automáticamente el adaptador VirtIO, eliminará cualquier configuración residual y aplicará la IP original guardada antes de la migración.

![native-migration-16]({{ site.imagesposts2026 }}/06/native-migration-16.png){: .mx-auto.d-block :}

## VMware Tools

La herramienta de migración **no desinstala VMware Tools** automáticamente, lo que puede generar errores en el arranque. Dos opciones:

**Opción A — Deshabilitar en el arranque** (mínimo recomendado):
`Settings → Apps → Startup → desactivar "VMware Tools Core Service"`

**Opción B — Desinstalar completamente**: Si la instalación está corrupta y no puede desinstalarse desde el Panel de Control, usar las herramientas recomendadas por Microsoft para desinstalación de programas bloqueados.

---

# Conclusión

El proceso de migración nativo de HPE VME es perfectamente funcional, aunque como hemos visto requiere una preparación cuidadosa en origen. Los puntos críticos a recordar son:

- Los drivers VirtIO **deben inyectarse antes de migrar**, sin ellos Windows no arranca en KVM
- El Migration Plan apaga la VM origen automáticamente, planificar la ventana de mantenimiento
- La red necesita un paso manual post-migración (o el script que hemos preparado)

En el siguiente post veremos una alternativa muy interesante para realizar esta misma migración utilizando **Veeam Backup & Replication**, que nos da más control y flexibilidad sobre el proceso.

Nos vemos en el próximo post ;-)

Un saludo

Miquel.
