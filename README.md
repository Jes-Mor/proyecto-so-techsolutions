# Infraestructura Servidor Web - TechSolutions S.A.

Proyecto integrador para la materia de Sistemas Operativos.

## Descripción
Este repositorio contiene los scripts de automatización para el despliegue de un servidor web bajo Ubuntu Server 24.04 LTS, configurando servicios de Apache, MySQL, SSH y FTP, junto con un sistema de monitoreo básico.

## Integrantes
* Jesús Morales
* Sofía Muñoz

## Contenido
- `provision.sh`: Script principal para la instalación y configuración de servicios.
- `monitoreo.sh`: Script para verificar el uso de recursos y generar logs de alerta.

## Instrucciones de uso
1. Asegúrate de tener permisos de ejecución en los archivos:
   ```bash
   chmod +x provision.sh
   chmod +x monitoreo.sh
