---
title: Backup de VMs en HPE VM Essentials con Veeam v13
subtitle: Parte 7.1 - Veeam Plug-in for HPE Morpheus VM Essentials
date: '2026-06-29 00:00:00'
layout: post
thumbnail-img: https://miquelmariano.github.io/assets/images/posts/2026/06/veeams13-vme-00.jpg
cover-img: https://miquelmariano.github.io/assets/images/fondos/09.jpg
share-img: https://miquelmariano.github.io/assets/images/posts/2026/06/veeams13-vme-00.jpg
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

Como muchos ya sabréis, [en el post de hace unas semanas vimos cómo desplegar el nuevo virtual appliance de Veeam Backup & Replication v13](https://miquelmariano.github.io/despliegue-veeam-v13-virtual-appliance-ova/). 

Hoy damos un paso más y vemos cómo proteger nuestras máquinas virtuales que corren sobre HPE VM Essentials (VME), gracias al nuevo Veeam Plug-in for HPE Morpheus VM Essentials.

Este plugin lleva un tiempo en beta y he tenido la suerte de probarlo en mi laboratorio. Ahora que ya está en producción, es el momento de contaros cómo funciona.

<details markdown="1">
<summary>VER TODA LA SERIE DE POSTS</summary>
- [Parte 1 - Introducción a HPE Morpheus VM Essentials software](https://miquelmariano.github.io/introduccion-hpe-morpheus-vm-essentials-software/)
- [Parte 2 - Instalación VM Essentials software](https://miquelmariano.github.io/instalacion-nodo-vme/)
- [Parte 3 - Instalación VME Manager](https://miquelmariano.github.io/instalacion-manager/)
- [Parte 4 - Configuración inicial](https://miquelmariano.github.io/configuracion-inicial-primeros-pasos-vm-essentials)
- [Parte 5 - Creación cluster Ceph](https://miquelmariano.github.io/cluster-ceph/)
- [Parte 6 - Desplegar nuestra primera VM](https://miquelmariano.github.io/primera-vm-en-vmessentials/)
- [Parte 7 - Backups nativos](https://miquelmariano.github.io/backups-en-vm-essentials/)
- [Parte 7.1 - Backups con Veeam v13](https://miquelmariano.github.io/backup-vme-con-veeam/)
- [Parte 8 - Pruebas de HA](https://miquelmariano.github.io/ha-en-vm-essentials/)
- [Parte 9 - Migración de VMs desde vSphere](https://miquelmariano.github.io/migracion-vsphere-vme/)
- [Parte 9.1 - Migración con Veeam](https://miquelmariano.github.io/migracion-vsphere-vme-veeam/)
- [Parte 10 - Comandos útiles]
- [Parte 11 - Gestión de actualizaciones en HPE VM Essentials](https://miquelmariano.github.io/actualizaciones-vme-manager-y-nodos-hvm)
</details>

# ¿Qué es el Veeam Plug-in for HPE VM Essentials?

El plugin es un componente adicional que se instala sobre el servidor de Veeam Backup & Replication y que extiende sus capacidades para proteger máquinas virtuales que corren sobre el hipervisor KVM de HPE VM Essentials.

Sin este plugin, Veeam simplemente no puede descubrir ni proteger los recursos de VME. Es importante tener esto claro: **no viene incluido en el instalador principal de Veeam, hay que descargarlo e instalarlo por separado.**

La arquitectura es sencilla y se basa en dos componentes principales:

- **Plugin module**: Se instala directamente sobre el servidor de Veeam B&R. No requiere un appliance adicional. Es quien gestiona la integración, coordina los checkpoints y orquesta los jobs de backup y restore.
- **Workers**: Son VMs Linux ligeras que actúan como proxies para el movimiento de datos. Veeam las despliega y destruye automáticamente en cada nodo del cluster VME durante la ejecución de los jobs.

![veeam13-vme-00]({{ site.imagesposts2026 }}/06/veeams13-vme-00.jpg){: .mx-auto.d-block :}

# Requisitos previos

Antes de empezar, conviene tener en cuenta los requisitos de plataforma. Según la documentación oficial, la integración es compatible con:

- HPE Morpheus VM Essentials Appliance versiones 8.0.13 o superior
- Host agent versión 3.1.3 o superior
- Paquete morpheus-ws-node versión 3.3.19-1 o superior

# Instalación del plugin

El plugin está disponible tanto para instalaciones Windows como para el nuevo virtual appliance Linux de Veeam v13. En mi caso lo he probado sobre el appliance Linux.

Lo primero es descargar el binario ```.bndl (para Linux) o el .exe (para Windows) desde el portal de descargas de Veeam, en la sección **Additional Downloads** de la página de My Products.
Una vez descargado, la instalación es muy directa:

![veeam13-vme-01]({{ site.imagesposts2026 }}/06/veeams13-vme-01.png){: .mx-auto.d-block :}
![veeam13-vme-02]({{ site.imagesposts2026 }}/06/veeams13-vme-02.png){: .mx-auto.d-block :}
![veeam13-vme-03]({{ site.imagesposts2026 }}/06/veeams13-vme-03.png){: .mx-auto.d-block :}
![veeam13-vme-04]({{ site.imagesposts2026 }}/06/veeams13-vme-04.png){: .mx-auto.d-block :}
![veeam13-vme-05]({{ site.imagesposts2026 }}/06/veeams13-vme-05.png){: .mx-auto.d-block :}
![veeam13-vme-06]({{ site.imagesposts2026 }}/06/veeams13-vme-06.png){: .mx-auto.d-block :}

Tras la instalación, es necesario **reiniciar la consola de administración de Veeam**. 

Al reconectar, nos pedirá actualizar los plugins.

![veeam13-vme-07]({{ site.imagesposts2026 }}/06/veeams13-vme-07.png){: .mx-auto.d-block :}
![veeam13-vme-08]({{ site.imagesposts2026 }}/06/veeams13-vme-08.png){: .mx-auto.d-block :}

# Añadir el servidor VME a Backup Infrastructure

Con el plugin ya instalado, el siguiente paso es registrar nuestro cluster VME en Veeam.

Desde la consola, iremos a **Backup Infrastructure > Managed Servers > Add Server > Virtualization Platforms > HPE Morpheus VM Essentials**

![veeam13-vme-09]({{ site.imagesposts2026 }}/06/veeams13-vme-09.png){: .mx-auto.d-block :}

Aquí hay un detalle muy importante que aprendí a las malas durante las pruebas: hay que especificar el FQDN completo del VME Manager, no solo el nombre corto. Si ponemos únicamente el hostname sin el dominio, el registro fallará o se inventariará incorrectamente.

![veeam13-vme-10]({{ site.imagesposts2026 }}/06/veeams13-vme-10.png){: .mx-auto.d-block :}

Especificaremos las credenciales de una cuenta con el rol System Admin en el VME Manager.
A continuación, seleccionaremos el datastore donde se almacenarán los snapshots temporales de las VMs durante el proceso de backup. Estos snapshots son temporales: Veeam los crea al inicio del job y los elimina automáticamente al finalizar.

![veeam13-vme-11]({{ site.imagesposts2026 }}/06/veeams13-vme-11.png){: .mx-auto.d-block :}
![veeam13-vme-12]({{ site.imagesposts2026 }}/06/veeams13-vme-12.png){: .mx-auto.d-block :}

Si todo va bien, veremos HPE Morpheus VM Essentials disponible en nuestra Backup Infrastructure.

![veeam13-vme-13]({{ site.imagesposts2026 }}/06/veeams13-vme-13.png){: .mx-auto.d-block :}

# Configuración de Workers

Los workers son el componente que hace el trabajo pesado: se encargan del movimiento de datos, la compresión y el cifrado. 

Veeam los despliega automáticamente en cada nodo del cluster durante los jobs y los elimina al terminar.

Para configurarlos, iremos a **Backup Infrastructure > Backup Proxies > Add Proxy > HPE Morpheus VM Essentials worker**

![veeam13-vme-14]({{ site.imagesposts2026 }}/06/veeams13-vme-14.png){: .mx-auto.d-block :}

Aquí definiremos:

- El cluster VME sobre el que desplegar los workers
- El nombre base que se aplicará a cada worker en cada nodo
- Los recursos (vCPU, RAM) que tendrá cada worker

![veeam13-vme-15]({{ site.imagesposts2026 }}/06/veeams13-vme-15.png){: .mx-auto.d-block :}
![veeam13-vme-16]({{ site.imagesposts2026 }}/06/veeams13-vme-16.png){: .mx-auto.d-block :}
![veeam13-vme-17]({{ site.imagesposts2026 }}/06/veeams13-vme-17.png){: .mx-auto.d-block :}
![veeam13-vme-18]({{ site.imagesposts2026 }}/06/veeams13-vme-18.png){: .mx-auto.d-block :}
![veeam13-vme-19]({{ site.imagesposts2026 }}/06/veeams13-vme-19.png){: .mx-auto.d-block :}
![veeam13-vme-20]({{ site.imagesposts2026 }}/06/veeams13-vme-20.png){: .mx-auto.d-block :}
![veeam13-vme-21]({{ site.imagesposts2026 }}/06/veeams13-vme-21.png){: .mx-auto.d-block :}

# Crear el job de backup

Con la infraestructura lista, ya podemos crear nuestro primer job de backup de VMs en VME.
Hacemos clic derecho en **Backup > Virtual Machine > HPE Morpheus VM Essentials**

![veeam13-vme-22]({{ site.imagesposts2026 }}/06/veeams13-vme-22.png){: .mx-auto.d-block :}

El wizard es idéntico al que conocemos para VMware o Nutanix: nombre del job, selección de VMs, destino del backup, guest processing y planificación.

![veeam13-vme-23]({{ site.imagesposts2026 }}/06/veeams13-vme-23.png){: .mx-auto.d-block :}

Seleccionamos las VMs que queremos proteger:

![veeam13-vme-24]({{ site.imagesposts2026 }}/06/veeams13-vme-24.png){: .mx-auto.d-block :}

Configuramos el repositorio de destino. En mi caso utilizo un repositorio local, aunque la integración es totalmente compatible con HPE StoreOnce u otros targets certificados por Veeam.

![veeam13-vme-25]({{ site.imagesposts2026 }}/06/veeams13-vme-25.png){: .mx-auto.d-block :}

Configuramos el guest processing y la planificación según nuestras necesidades, y lanzamos el job.

![veeam13-vme-26]({{ site.imagesposts2026 }}/06/veeams13-vme-26.png){: .mx-auto.d-block :}
![veeam13-vme-27]({{ site.imagesposts2026 }}/06/veeams13-vme-27.png){: .mx-auto.d-block :}

# El job en ejecución

Al lanzar el job, podemos ver cómo Veeam despliega automáticamente los workers en el cluster, realiza el checkpoint de las VMs y transfiere los datos al repositorio.

![veeam13-vme-28]({{ site.imagesposts2026 }}/06/veeams13-vme-28.png){: .mx-auto.d-block :}

# Consideraciones finales

Un par de cosas a tener en mente antes de lanzaros a producción:

- Ceph no está soportado: A dia de hoy, las VMs con discos en Ceph no pueden hacer backup. Si tenéis VMs que "nacieron" en Ceph y las habéis migrado a otro tipo de almacenamiento, el backup funcionará sin problemas. Pero si el disco original sigue siendo Ceph, fallará.

- FQDN completo siempre: al registrar el VME Manager, usad siempre el FQDN completo. Es un detalle pequeño que puede ahorraros un buen rato de troubleshooting.

- Los workers son efímeros: no os extrañe ver VMs apareciendo y desapareciendo en vuestro cluster durante los jobs. Es el comportamiento esperado.

En resumen, la integración funciona muy bien para entornos productivos con VME. El hecho de que el workflow sea idéntico al de otros hipervisores basados en KVM hace que la curva de aprendizaje sea prácticamente cero para quien ya usa Veeam.

Nos vemos en el próximo post ;-)
Un saludo
Miquel.