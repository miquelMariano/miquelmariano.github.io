---
title: Migración de VMs Windows desde vSphere con Veeam
subtitle: Parte 9.1 - Full VM Restore to HPE Morpheus VM Essentials
date: '2026-07-20 00:00:00'
layout: post
thumbnail-img: https://miquelmariano.github.io/assets/images/posts/2026/04/ha-01.png
cover-img: https://miquelmariano.github.io/assets/images/fondos/08.jpg
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
- veeam
---

En el [post anterior](https://miquelmariano.github.io/migracion-vsphere-vme/) vimos cómo migrar VMs desde vSphere utilizando la herramienta nativa de Migration Plans que incluye HPE VME. En esta entrega veremos una alternativa igual de válida y que en muchos entornos ya está disponible: **migrar usando Veeam Backup & Replication**.

La idea es aprovechar Veeam como vehículo de transporte. En lugar de usar el migration tool nativo, [realizamos un backup](https://miquelmariano.github.io/backup-vme-con-veeam/) de la VM en origen y la restauramos directamente sobre HPE VME mediante la opción **Full VM Restore to HPE Morpheus VM Essentials**. El resultado es el mismo, pero el proceso nos da más control y la posibilidad de partir de un punto de restauración limpio y consistente.

> ⚠️ **OJO**: Los pasos de preparación previa (inyección de drivers VirtIO) son **exactamente los mismos** que en la [migración nativa]https://miquelmariano.github.io/migracion-vsphere-vme/. Sin estos pasos, la VM no arrancará en KVM independientemente del método de migración que usemos.

<details>
<summary>VER TODA LA SERIE DE POSTS</summary>

<ul>
  <li><a href="https://miquelmariano.github.io/introduccion-hpe-morpheus-vm-essentials-software/">Parte 1 - Introducción a HPE Morpheus VM Essentials software</a></li>
  <li><a href="https://miquelmariano.github.io/instalacion-nodo-vme/">Parte 2 - Instalación VM Essentials software</a></li>
  <li><a href="https://miquelmariano.github.io/instalacion-manager/">Parte 3 - Instalación VME Manager</a></li>
  <li><a href="https://miquelmariano.github.io/configuracion-inicial-primeros-pasos-vm-essentials">Parte 4 - Configuración inicial</a></li>
  <li><a href="https://miquelmariano.github.io/cluster-ceph/">Parte 5 - Creación cluster Ceph</a></li>
  <li><a href="https://miquelmariano.github.io/primera-vm-en-vmessentials/">Parte 6 - Desplegar nuestra primera VM</a></li>
  <li><a href="https://miquelmariano.github.io/backups-en-vm-essentials/">Parte 7 - Backups nativos</a>
    <ul>
      <li><a href="https://miquelmariano.github.io/backup-vme-con-veeam/">Parte 7.1 - Backups con Veeam v13</a></li>
    </ul>
  </li>
  <li><a href="https://miquelmariano.github.io/ha-en-vm-essentials/">Parte 8 - Pruebas de HA</a></li>
  <li><a href="https://miquelmariano.github.io/migracion-vsphere-vme/">Parte 9 - Migración de VMs desde vSphere</a>
    <ul>
      <li><a href="https://miquelmariano.github.io/migracion-vsphere-vme-veeam/">Parte 9.1 - Migración con Veeam</a></li>
    </ul>
  </li>
  <li>[Parte 10 - Comandos útiles]</li>
  <li><a href="https://miquelmariano.github.io/actualizaciones-vme-manager-y-nodos-hvm">Parte 11 - Gestión de actualizaciones en HPE VM Essentials</a></li>
</ul>

</details>

---

# Requisitos previos y preparación de la VM

La preparación previa [es idéntica a la del post anterior](https://miquelmariano.github.io/migracion-vsphere-vme/). Resumiendo:

- Descargar el ISO de VirtIO desde [fedorapeople.org](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.285-1/)
- Montar el ISO en la VM y arrancar en **Windows RE** (reiniciar con `Shift` pulsado o desde `Configuración → Recuperación → Reiniciar ahora`)
- Inyectar los drivers VirtIO en la imagen de arranque:

```
dism /image:C:\ /add-driver:D:\viostor\2k22\amd64\viostor.inf
dism /image:C:\ /add-driver:D:\vioscsi\2k22\amd64\vioscsi.inf
```

- Arrancar Windows normalmente e instalar `virtio-win-gt-x64.msi` y `virtio-win-guest-tools.exe` desde la raíz del ISO
- Desmontar todos los ISOs
- Guardar la configuración de red con el [script](https://miquelmariano.github.io/assets/images/Manage-NetworkConfig.ps1):

```powershell
.\Manage-NetworkConfig.ps1 -Action save
```

---

# Backup final en frío

Con la VM preparada y el script de red ejecutado, el siguiente paso es **apagarla y hacer un último backup en frío**. Esto es importante porque queremos capturar el estado final de la VM ya con los drivers VirtIO instalados.

Desde Veeam, lanzar un backup bajo demanda de la VM sobre el job que la tenga asignada y esperar a que complete.

Este punto de restauración en frío será el que usemos para la migración.

# Restauración a HPE Morpheus VM Essentials

Veeam tiene integración nativa con HPE Morpheus VM Essentials como destino de restauración. El proceso es el siguiente.

## Iniciar el asistente

Desde la consola de Veeam, localizar el backup de la VM a migrar, hacer clic derecho y seleccionar:

`Restore entire VM → HPE Morpheus VM Essentials...`

![restore-veeam-01]({{ site.imagesposts2026 }}/07/restore-veeam-01.png){: .mx-auto.d-block :}

## Virtual Machines

En el primer paso del asistente, verificar que la VM correcta está seleccionada y el restore point corresponde al backup en frío que acabamos de hacer.

![restore-veeam-02]({{ site.imagesposts2026 }}/07/restore-veeam-02.png){: .mx-auto.d-block :}


## Restore Mode

Seleccionar **Restore to a new location, or with different settings**. Esta opción nos permite personalizar el cluster destino, el almacenamiento y la red, que es exactamente lo que necesitamos al cambiar de plataforma.

![restore-veeam-03]({{ site.imagesposts2026 }}/07/restore-veeam-03.png){: .mx-auto.d-block :}

## Cluster

Seleccionar el cluster de HPE VME donde queremos alojar la VM. Veeam mostrará los clusters disponibles que tenga integrados como infraestructura de backup.

![restore-veeam-04]({{ site.imagesposts2026 }}/07/restore-veeam-04.png){: .mx-auto.d-block :}

## Storage

Seleccionar el datastore de HPE VME donde se almacenarán los discos de la VM. Veeam mostrará los datastores disponibles en el cluster seleccionado.

![restore-veeam-05]({{ site.imagesposts2026 }}/07/restore-veeam-05.png){: .mx-auto.d-block :}

## Name

Por defecto se mantiene el nombre original de la VM. Podemos cambiarlo si fuera necesario. También tenemos la opción de **Restore tags and labels** para mantener los metadatos originales.

![restore-veeam-06]({{ site.imagesposts2026 }}/07/restore-veeam-06.png){: .mx-auto.d-block :}

## Network

Este paso es importante. Veeam intentará mapear automáticamente la red origen con la red destino en HPE VME. Revisar que el mapeo es correcto y ajustar si fuera necesario.

![restore-veeam-07]({{ site.imagesposts2026 }}/07/restore-veeam-07.png){: .mx-auto.d-block :}

## Reason

Campo opcional para registrar el motivo de la operación. Recomendable rellenarlo con algo descriptivo como "Migración desde vSphere - [nombre VM]" para trazabilidad.

![restore-veeam-08]({{ site.imagesposts2026 }}/07/restore-veeam-08.png){: .mx-auto.d-block :}

## Summary y ejecución

En la pantalla de resumen podemos revisar toda la configuración antes de ejecutar. Activar la opción **Power on target VM after restoring** si queremos que la VM arranque automáticamente al finalizar.

Hacer clic en **Finish** para iniciar la restauración. Desde el panel de **Restore session** podremos monitorizar el progreso en tiempo real.

El proceso tarda en función del tamaño de la VM. Una vez completado, el estado de la sesión pasará a **Success**.

![restore-veeam-09]({{ site.imagesposts2026 }}/07/restore-veeam-09.png){: .mx-auto.d-block :}

![restore-veeam-10]({{ site.imagesposts2026 }}/07/restore-veeam-10.png){: .mx-auto.d-block :}

![restore-veeam-11]({{ site.imagesposts2026 }}/07/restore-veeam-11.png){: .mx-auto.d-block :}

---

# Post-migración

## Restaurar la configuración de red

Con la VM arrancada en HPE VME, abrir PowerShell como administrador y ejecutar:

```powershell
.\Manage-NetworkConfig.ps1 -Action restore
```

El [script](https://miquelmariano.github.io/assets/images/Manage-NetworkConfig.ps1) detectará el adaptador **Red Hat VirtIO Ethernet Adapter**, eliminará cualquier configuración residual y aplicará la IP, máscara, gateway y DNS guardados antes de la migración.

![restore-veeam-12]({{ site.imagesposts2026 }}/07/restore-veeam-12.png){: .mx-auto.d-block :}

## VMware Tools

Al igual que en la migración nativa, Veeam tampoco desinstala VMware Tools durante el proceso de restore. Para evitar errores en el arranque:

**Opción A — Deshabilitar en el arranque** (mínimo recomendado):
`Settings → Apps → Startup → desactivar "VMware Tools Core Service"`

**Opción B — Desinstalar completamente**: Usar las herramientas recomendadas por Microsoft si la instalación está corrupta.

---

# Conclusión

Hemos visto que Veeam nos ofrece una forma elegante y controlada de realizar la misma migración, aprovechando una infraestructura de backup que probablemente ya está operativa en el entorno. La integración de Veeam con HPE Morpheus VM Essentials como destino de restore es madura y funciona a la perfección.

Los puntos clave a recordar son:

- Los drivers VirtIO son **obligatorios en ambos métodos**
- El backup en frío previo a la migración garantiza consistencia
- La restauración de red post-migración es necesaria en ambos casos

Nos vemos en el próximo post ;-)

Un saludo

Miquel.
