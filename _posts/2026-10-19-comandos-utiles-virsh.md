---
title: Comandos útiles virsh
subtitle: Parte 10 - Lista de comandos mas útiles para gestionar VM Essentials
date: '2026-10-19 00:00:00'
layout: post
thumbnail-img: https://miquelmariano.github.io/assets/images/posts/2025/10/hpe_morpheus_01.jpg
cover-img: https://miquelmariano.github.io/assets/images/fondos/10.jpg
share-img: https://miquelmariano.github.io/assets/images/posts/2025/10/hpe_morpheus_01.jpg
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

HPE VM Essentials (Morpheus) corre sobre KVM/libvirt, así que cada nodo del clúster se puede gobernar con `virsh`. La consola de gestión (el manager) cubre el 90 % del día a día, pero cuando algo se tuerce (una VM que no arranca, un checkpoint huérfano de Veeam, una migración desde vSphere que te deja sin red) `virsh` es la herramienta que te saca del apuro. 

Este post porma parte de la serie sobre HPE VM Essentials y a continuación podeis ver el índice de toda la serie:

<details>
<summary>VER TODA LA SERIE DE POSTS SOBRE VME</summary>

<ul>
  <li><a href="https://miquelmariano.github.io/introduccion-hpe-morpheus-vm-essentials-software/">Parte 1 - Introducción a HPE Morpheus VM Essentials software</a></li>
  <li><a href="https://miquelmariano.github.io/instalacion-nodo-vme/">Parte 2 - Instalación VM Essentials software</a></li>
  <li><a href="https://miquelmariano.github.io/instalacion-manager/">Parte 3 - Instalación VME Manager</a></li>
  <li><a href="https://miquelmariano.github.io/configuracion-inicial-primeros-pasos-vm-essentials">Parte 4 - Configuración inicial</a></li>
  <li><a href="https://miquelmariano.github.io/cluster-ceph/">Parte 5 - Creación cluster Ceph</a></li>
  <li><a href="https://miquelmariano.github.io/primera-vm-en-vmessentials/">Parte 6 - Desplegar nuestra primera VM</a></li>
  <ul>
      <li><a href="https://miquelmariano.github.io/ampliar-disco-vm-windows-sobre-vme/">Parte 6.1 - Ampliar disco en servidor Windows</a></li>
    </ul>
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

{: .box-note}
- Todos los comandos se lanzan en el nodo donde corre la VM, con sudo.
- Lo que cambies con virsh no pasa por el manager de VME. Para tareas rutinarias (cambiar CPU, RAM, discos o NICs) usa la consola de VME. Reserva virsh para diagnóstico y para los casos en que el manager no llega.
- Los ejemplos son de mi laboratorio. Sustituye nombres, IDs, IPs y credenciales por los tuyos.

# Listar y monitorizar VMs

`virsh list`
Lista las VMs en ejecución. Con `--all` incluye también las apagadas.

```ssh
 Id   Name             State
----------------------------------
 1    vme-manager-01   running
 7    encora-01        running
 134  FS-restored      running
 -    veeam-worker-01  shut off
 ````

El `Id` es el identificador de dominio que luego puedes usar en lugar del nombre en cualquier comando. Ojo: cambia cada vez que la VM se apaga y se vuelve a encender.

`virsh dominfo`
Estado actual (running, paused, shut off...).

```ssh
sudo virsh domstate FS-restored
```

`virsh domstats`
Estadísticas de CPU, memoria, disco y red.

```ssh
sudo virsh domstats FS-restored
```

# Controlar el estado de una VM

| Comando | Qué hace |
| :--- | :--- |
| `virsh start VM` | Arranca una VM apagada |
| `virsh shutdown VM` | Apagado ordenado (necesita ACPI o guest agent en el guest) |
| `virsh destroy VM` | Apagado forzoso, como tirar del cable. Úsalo con cuidado |
| `virsh reboot VM` | Reinicio ordenado |
| `virsh suspend VM` | Pausa la VM en memoria |
| `virsh resume VM` | Reanuda una VM pausada |

Si `shutdown` no hace nada, el guest no está procesando ACPI. Es habitual en Windows con el agente sin instalar o con la VM bloqueada en la pantalla de login.

# Editar la configuración de una VM

`virsh edit`
Abre el XML de la VM en tu editor. Edítala con la VM apagada y ten presente que el manager puede sobrescribir cambios manuales.

```ssh
sudo virsh edit FS-restored
```

`virsh setvcpus`
Cambia el número de vCPUs. Con la VM apagada, añade --config para que persista.

```ssh
sudo virsh setvcpus FS-restored 4 --config
```

`virsh setmem`
Cambia la memoria asignada. Por defecto el valor va en KiB y no puede superar el máximo definido para la VM.

```ssh
sudo virsh setmem FS-restored 8388608 --config
```

8388608 KiB son 8 GiB.

# Almacenamiento y red

`virsh attach-disk`
Añade un disco o una ISO a una VM.

```ssh
virsh attach-disk FS-restored /ruta/disco.qcow2 vdb --persistent
virsh attach-disk FS-restored /ruta/virtio-win.iso sdz --type cdrom --mode readonly
```

`virsh detach-disk`
Quita un disco por su target.

```ssh
sudo virsh detach-disk FS-restored vdb --persistent
```

`virsh attach-interface`
Añade una interfaz de red.

```ssh
sudo virsh attach-interface FS-restored network default --model virtio --persistent
```

`virsh detach-interface`
Quita una interfaz. Necesita el tipo y, si hay varias, la MAC.

```ssh
sudo virsh detach-interface FS-restored network --mac 52:54:00:aa:bb:cc --persistent
```

La MAC la ves con virsh domiflist FS-restored.

# Comandos adicionales

`virsh autostart`
Controla si la VM arranca con el host.

```ssh
sudo virsh autostart FS-restored
sudo virsh autostart --disable FS-restored
```

# Eliminar una VM sin dejar rastro

Primero se para y luego se elimina la definición junto con todo lo asociado.

```ssh
sudo virsh list --all
sudo virsh destroy 2
sudo virsh undefine hpe-vme-manager --remove-all-storage --wipe-storage --snapshots-metadata --managed-save
```

Salida:

```ssh
Domain 'hpe-vme-manager' has been undefined
Wiping volume 'vda'(/var/morpheus/kvm/local/hpe-vm-essentials-8.1.2-1.qcow2) ... Done.
Volume 'vda'(/var/morpheus/kvm/local/hpe-vm-essentials-8.1.2-1.qcow2) removed.
```

Qué hace cada opción:
- `--remove-all-storage`: busca todos los discos asociados a la VM y los elimina.
- `--wipe-storage`: sobrescribe los datos del disco antes de borrar el fichero, para evitar su recuperación.
- `--snapshots-metadata`: borra cualquier registro de snapshots.
- `--managed-save`: elimina el estado guardado si la VM se había pausado alguna vez.

Es irreversible. Comprueba dos veces el nombre antes de lanzarlo.

# Ver en qué host está corriendo una VM

En un clúster de varios nodos, virsh solo ve lo que corre en el nodo local. Yo uso un pequeño script (`allssh.sh`) que ejecuta un comando en todos los nodos por SSH y lo agrupa por host:

``ssh
allssh.sh "sudo virsh list --all"
================== 10.10.10.101 =================
 Id   Name              State
----------------------------------
 13   ges-WinSrv2019    running
 28   mmr-test-03       running
 -    veeam-worker-01   shut off
================== 10.10.10.102 =================
 3    mmr-checkmk-01    running
 4    Win2025STD        running
```

Si no tienes un script así, un bucle sencillo hace lo mismo: `for h in 10.10.10.101 10.10.10.102 10.10.10.103; do ssh vmeadmin@$h "sudo virsh list --all"; done`.

# Ver en qué datastore está una VM
Con `domblklist`

```ssh
sudo virsh domblklist mmr-test-03 --details
 Type   Device   Target   Source
----------------------------------------------------------------------
 file   disk     sda      /mnt/116b3df5-a376-43a2-a527-345e0edb4381/mmr-test-03/hvm_21-disk-0-da7951f
ssh

El UUID de la ruta (`116b3df5-...`) es el del pool, es decir, el datastore.

Listar los datastores del clúster

```ssh
sudo virsh pool-list --all
 Name                  State    Autostart
-------------------------------------------
 HPEVME-Datastore-00   active   yes
 HPEVME-Datastore-01   active   yes
 HPEVME-Datastore-02   active   yes
 local                 active   yes
 morpheus-cloud-init   active   yes
 morpheus-images       active   yes
````

Información de un datastore

```ssh
sudo virsh pool-info HPEVME-Datastore-00
Name:        HPEVME-Datastore-00
UUID:        116b3df5-a376-43a2-a527-345e0edb4381
State:       running
Capacity:    499.97 GiB
Allocation:  188.24 GiB
Available:   311.73 GiB
````

Cruzando el UUID con la ruta del disco sabes exactamente dónde vive la VM.

# Conectar por VNC directamente a una VM
Cuando el manager no te da consola (o la VM está en una pantalla en la que necesitas ver qué pasa), puedes conectar por VNC al hypervisor. El VNC solo escucha en localhost del nodo, así que hay que localizar la VM, su puerto y su contraseña, y abrir un túnel SSH.

### 1. Encontrar el host y la VM
`sudo virsh list --all`

###2. Obtener el display VNC
`sudo virsh domdisplay vme-manager-01`
`sudo virsh vncdisplay vme-manager-01`

```ssh
vnc://127.0.0.1:2
127.0.0.1:2
````

El display `:2` corresponde al puerto `5900 + 2 = 5902`.

### 3. Obtener puerto y contraseña
`sudo virsh dumpxml --security-info vme-manager-01 | grep -A2 graphics``

```ssh
<graphics type='vnc' port='5902' autoport='no' listen='127.0.0.1' passwd='<PASSWORD>'>
  <listen type='address' address='127.0.0.1'/>
</graphics>
````

### 4. Abrir el túnel desde tu equipo (en macOS, Linux y Windows 10/11 con OpenSSH el comando es el mismo)
`ssh -L 5902:127.0.0.1:5902 vmeadmin@<IP_DEL_NODO>``

### 5. Conectar el visor VNC a `127.0.0.1:5902` con la contraseña del paso 3.

# Ejecutar comandos dentro de una VM con el guest agent de QEMU

Si la VM tiene el agente instalado (virtio-win-guest-tools o qemu-guest-agent), puedes lanzar comandos dentro del guest sin login y sin red. Me salvó en una migración desde vSphere de un controlador de dominio: sin red, sin cuenta local y sin poder iniciar sesión, pude ejecutar mi script de configuración de red directamente desde el host.

### Comprobar que el agente responde
`sudo virsh qemu-agent-command 134 '{"execute":"guest-ping"}' --timeout 10`

Si todo va bien devuelve `{"return":{}}`. El `134` es el ID de dominio que ves en `virsh list`.

### Ejecutar un comando
`guest-exec` es asíncrono: lanza el proceso y devuelve un PID. Después se consulta el resultado con guest-exec-status, y la salida viene en base64`.

```ssh
sudo virsh qemu-agent-command 134 '{"execute":"guest-exec","arguments":{"path":"C:\\Windows\\System32\\hostname.exe","capture-output":true}}'
# {"return":{"pid":1234}}

sudo virsh qemu-agent-command 134 '{"execute":"guest-exec-status","arguments":{"pid":1234}}' | jq -r '.return."out-data"' | base64 -d
````

Una función para no repetirte: `gexec`

Para no escribir JSON a mano cada vez, esta función lanza cualquier comando de PowerShell, espera a que termine (hasta 120 s) y muestra la salida, los errores y el código de salida.

```ssh
gexec() {
  local JSON PID R
  JSON=$(jq -nc --arg c "$1" '{execute:"guest-exec",arguments:{path:"C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",arg:["-NoProfile","-ExecutionPolicy","Bypass","-Command",$c],"capture-output":true}}')
  PID=$(sudo virsh qemu-agent-command 134 "$JSON" | jq -r '.return.pid')
  for i in $(seq 1 120); do
    R=$(sudo virsh qemu-agent-command 134 "{\"execute\":\"guest-exec-status\",\"arguments\":{\"pid\":$PID}}")
    [ "$(echo "$R" | jq -r '.return.exited')" = "true" ] && break
    sleep 1
  done
  echo "$R" | jq -r '.return."out-data" // empty' | base64 -d
  echo "$R" | jq -r '.return."err-data" // empty' | base64 -d
  echo "exitcode: $(echo "$R" | jq -r '.return.exitcode')"
}
````

El ID del dominio (`134`) está fijo en la función. Cámbialo por el de tu VM, o pásalo como variable.
Ejemplos de uso:

```ssh
# Ver los adaptadores de red
gexec 'Get-NetAdapter | ft Name,InterfaceDescription,MacAddress,Status -AutoSize | Out-String -Width 200'

# Lanzar un script de restauración de red
gexec 'Set-Location C:\Users\encora\Downloads; .\Manage-NetworkConfig.ps1 -action restore'
````

Puntos a tener en cuenta:
- El comando corre como SYSTEM, así que tiene permisos totales pero no hereda el perfil de ningún usuario.
- Si la VM viene de vSphere, el agente solo estará si lo instalaste antes de migrar. Mejor instalar VirtIO y el guest agent antes de la migración.
- Al migrar a VME el NIC cambia (de vmxnet3 a VirtIO). La configuración IP no se hereda: déjala anotada o con un script preparado.

Y hasta aquí por hoy. Y vosotros teneis vuestros propios trucos con VME, cuéntamelos en los comentarios.

Un saludo
Miquel.