---
title: Puertos TCP y UDP utilizados por Horizon 7
date: '2020-04-01 00:00:00'
layout: post
image: /assets/images/posts/2019/07/horizon-logo.png
tag:
- vmware
- horizon
- vexpert
- euc
- desktop
- mobility
- networking

---

En el post de hoy pretendo recoger de forma fácil todos los requerimientos a nivel de conectividad que necesita un entorno Horizon 7

![horizon7-ports]({{ site.imagesposts2020 }}/04/horizon7-ports.png){: .align-center}

Toda la información aquí expuesta ha sido sacada de la guia oficial [Network Ports in VMware Horizon 7](https://techzone.vmware.com/resource/network-ports-vmware-horizon-7)

# 	Conexiones cliente

###	Conexión interna

| Origen    	      |  Destino    			 |Puerto   |Protocolo  |Descripción    		   |
|:-------------------:|:------------------------:|:-------:|:---------:|:---------------------:|
|Horizon Client       |Horizon Connection Server |443	   |TCP		   |Login	       	  	   |
|Horizon Client       |Horizon Agent			 |22443	   |TCP	y UDP  |Blast Extreme     	   |
|Horizon Client       |Horizon Agent			 |4172	   |TCP	y UDP  |PCoIP			  	   |
|Horizon Client       |Horizon Agent			 |3389	   |TCP		   |RDP				  	   |
|Horizon Client       |Horizon Agent			 |9427	   |TCP		   |CDR (client drive redirection)	y MMR (multimedia redirection)		  |
|Horizon Client       |Horizon Agent			 |3211	   |TCP		   |Redirección USB	  	   |
|Navegador Web        |Horizon Agent			 |8443	   |TCP		   |Horizon 7 HTML Access  |

###	Conexión externa

| Origen    	      |  Destino    			 |Puerto   |Protocolo  |Descripción    		   |
|:-------------------:|:------------------------:|:-------:|:---------:|:---------------------:|
|Horizon Client       |UAG o Security server	 |443	   |TCP		   |Login	       	  	   |
|Horizon Client       |UAG o Security server	 |8443	   |TCP	y UDP  |Blast Extreme     	   |
|Horizon Client       |UAG o Security server	 |4172	   |TCP	y UDP  |PCoIP			  	   |
|Horizon Client       |Horizon Agent			 |3389	   |TCP		   |RDP				  	   |
|Horizon Client       |Horizon Agent			 |9427	   |TCP		   |CDR (client drive redirection)	y MMR (multimedia redirection)		  |
|Horizon Client       |Horizon Agent			 |3211	   |TCP		   |Redirección USB	  	   |
|Navegador Web        |Horizon Agent			 |8443	   |TCP		   |Horizon 7 HTML Access  |

#	Horizon Connection Server

| Origen    		      |  Destino    			 |Puerto   |Protocolo  |Descripción    		   |
|:-----------------------:|:------------------------:|:-------:|:---------:|:---------------------:|
|Horizon Connection Server|Horizon Agent			 |22443	   |TCP	y UDP  |Blast Extreme     	   |
|Horizon Connection Server|Horizon Agent			 |4172	   |TCP	y UDP  |PCoIP			  	   |
|Horizon Connection Server|Horizon Agent			 |3389	   |TCP		   |RDP				  	   |
|Horizon Connection Server|Horizon Agent			 |9427	   |TCP		   |CDR (client drive redirection)	y MMR (multimedia redirection)		  |
|Horizon Connection Server|Horizon Agent			 |3211	   |TCP		   |Redirección USB	  	   |
|Horizon Connection Server|Horizon Agent			 |8443	   |TCP		   |Horizon 7 HTML Access  |
|Horizon Connection Server|vCenter Server			 |443	   |TCP		   |SOAP				   |
|Horizon Connection Server|BBDD (eventos)			 |1443	   |TCP		   |Microsoft SQL Server   |
|Horizon Connection Server|BBDD (eventos)			 |1521	   |TCP		   |Oracle server 		   |
|Horizon Connection Server|JMP server 				 |443	   |TCP		   |					   |
|Horizon Connection Server|View Composer			 |18443	   |TCP		   |SOAP				   |
|Horizon Connection Server|Security Server			 |500	   |UDP		   |IPsec				   |
|Horizon Connection Server|Security Server			 |4500	   |UDP		   |NAT-T ISAKMP		   |
|Horizon Connection Server|UAG						 |9443	   |TCP		   |					   |
|Horizon Connection Server|App Volumes Manager		 |443	   |TCP		   |					   |
|Horizon Connection Server|RSA SecurID Authentication Manager		 |5500	   |UDP		   |Autenticación doble factor					   |

#	View Composer

| Origen    		      |  Destino    			 |Puerto   |Protocolo  |Descripción    		   |
|:-----------------------:|:------------------------:|:-------:|:---------:|:---------------------:|
|View Composer			  |vCenter server 			 |443	   |TCP		   |SOAP			   	   |
|View Composer			  |ESXi						 |902	   |TCP		   |SOAP			   	   |

#	Unified Access Gateway

| Origen    		      |  Destino    			 |Puerto   |Protocolo  |Descripción    		   |
|:-----------------------:|:------------------------:|:-------:|:---------:|:---------------------:|
|Unified Access Gateway	  |Horizon Connection Server |443	   |TCP		   |Login			   	   |
|Unified Access Gateway	  |Horizon Agent			 |22443	   |TCP	y UDP  |Blast Extreme     	   |
|Unified Access Gateway	  |Horizon Agent			 |4172	   |TCP	y UDP  |PCoIP			  	   |
|Unified Access Gateway	  |Horizon Agent			 |3389	   |TCP		   |RDP				  	   |
|Unified Access Gateway	  |Horizon Agent			 |9427	   |TCP		   |CDR (client drive redirection)	y MMR (multimedia redirection)		  |
|Unified Access Gateway	  |Horizon Agent			 |3211	   |TCP		   |Redirección USB	  	   |

# 	App Volumes

| Origen    		      |  Destino    			 |Puerto   |Protocolo  |Descripción    		   |
|:-----------------------:|:------------------------:|:-------:|:---------:|:---------------------:|
|App Volumes Manager	  |vCenter server 			 |443	   |TCP		   |SOAP			   	   |
|App Volumes Manager	  |ESXi						 |443	   |TCP		   |Hostd			   	   |
|App Volumes Manager	  |BBDD			 			 |1443	   |TCP		   |Puerto por defecto MS SQL Server			   	   |

#	Agentes

| Origen    		      |  Destino    			 |Puerto   |Protocolo  |Descripción    				   |
|:-----------------------:|:------------------------:|:-------:|:---------:|:-----------------------------:|
|Horizon Agent   		  |Horizon Connection Server |4002	   |TCP		   |Java Message Service (JMS)	   |
|Horizon Agent   		  |Horizon Connection Server |4001	   |TCP		   |JMS (Legacy)			   	   |
|Horizon Agent   		  |Horizon Connection Server |389	   |TCP		   |						   	   |
|App Volumes Agent 		  |App Volumes Manager		 |443	   |TCP		   |Puerto 80 si la comunicación no usa SSL	   |
|App Volumes Agent 		  |App Volumes Manager		 |5985	   |TCP		   |PowerShell web services 	   |
|DEM Agentes			  |File Share				 |445	   |TCP		   |Acceso al recurso SMB	 	   |



Espero que os sirva.

Un saludo!

Miquel.



