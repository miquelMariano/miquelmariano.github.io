---
title: Back-to-basics 1 - Ficheros de una VM
date: '2018-01-17 00:00:00'
layout: post
image: /assets/images/posts/2018/01/vmfiles1.png
headerImage: true
tag:
- vmware
- vsphere
- vexpert
- devops
- backtobasics
---

Buenos dias a tod@as!!

En esta [serie que voy a empezar](https://miquelmariano.github.io/tag/#backtobasics), me gustaría dar un repaso a los principales conceptos y aspectos que hay que tener en cuenta en un entorno vSphere.

En este primer post, vamos a recordar los diferentes ficheros que conforman una Máquina Virtual y para que sirven.

Los archivos que conforman una Máquina Virtual, generalmente, residen dentro de la carpeta (nombre de su VM) colocada en un datastore. Los archivos presentes en esta carpeta dependerán del estado en el que se encuentre la VM (Encendido / Apagado / Suspendido) y la acción que se está realizando en un momento determinado.

![vmfiles]({{ site.imagesposts2018 }}/01/vmfiles.jpg)

# Ficheros de configuración

+ **vm_name.vmx:**	El fichero de configuración de una máquina virtual contiene todos los detalles para que la VM pueda arrancar. Información del Virtual Hardware, SO, Networking, Almacenamiento, ...
Cada vez que creamos una VM, el fichero .vmx aparece automaticamente y contiene la información de todas las configuraciones que hemos ido perfilando durante el wizard de creación
+ **vm_name.vmtx:** El fichero .vmx se convierte en .vmtx cuanto una VM se convierte a plantilla. Contiene los detalles de configuración de esta VM convertida a plantilla
+ **vm_name.vmxf**	Es un XML que contiene configuración y opciones adicionales de una VM
+ **vm_name.nvram**	Corresponde al fichero de configuración de la BIOS o EFI que utiliza la VM
+ **vm_name.vmss:** Corresponde al fichero del estado suspendido de una VM. Almacena información cuando una VM está en estado “suspended”. Si la VM está en otro estado, este fichero no existe

# Ficheros de disco

+ **vm name.vmdk:**	LLamado "descriptor" o "puntero", es un fichero de texto plano que contiene la información sobre los discos de una VM
+ **vm name-flat.vmdk:** En una VM, es el equivalente a un disco duro físico. Es donde se escriben los datos. No busqueis este fichero en el explorador del vSphere Client. Es el fichero donde apunta el "descriptor" y en el vSphere Client se presenta como un único fichero

# Ficheros de Snapshot

+ **vm name.vmsd:**	Es el fichero de metadatos donde se almacena la información sobre los snapshots de una VM.
+ **vm name-Snapshotn.vmsn:** Este fichero, captura el estado de la memoria de una VM en caso de que se haya marcado la opción “Snapshot the virtual machine’s memory” en la creación del snapshot. Empieza en 1 y n se va incrementando cada vez que se realiza un snapshot.
+ **vm name-00000n-delta.vmdk:** El fichero -delta.vmdk se crea cuando la VM tiene snapshot. El fichero .vmdk queda bloqueado en escrituras y todos los cambios se escriben en este disco -delta.vmdk. De esta manera, nos permite restaurar una VM a un estado anterior.
+ **vm name-00000n.vmdk:**	Es el fichero "descriptor" de los discos delta.

# Ficheros de Log

+ **vmware.log:** Es el fichero actual de logs de la VM. Se utiliza para tareas de troubleshooting.
+ **vmware-n.log:**	Son los logs antiguos de la VM. Podeis leer mas sobre este tema en [este post, en el blog de Ncora](https://www.ncora.com/blog/configuracion-de-logs-en-maquinas-virtuales/)

# Otros ficheros

+ **vm name-ctk.vmdk:**	Este fichero se crea cuando  "Changed block tracking" (CBT) está habilitado en la VM. CBT es una funcionalidad que nos aporta VMware y es utilizada para los principales proveedores de software de backup para realizar copias incrementales.
+ ***.vswp:** El fichero swap de una VM es utilizado para garantizar los recursos de memoria de una VM en caso de que haya mucha saturación en un host ESXi. Se crea cuando la VM pasa a estado "PowerOn" y no tiene ningún tipo de reserva de memoria.
 

Espero que os sea de utilidad. Hasta el próximo post.

Un saludo!

Miquel.

