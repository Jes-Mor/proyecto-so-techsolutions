#!/bin/bash 
# Script de monitoreo - TechSolutions S.A. 

# Definición de variables: ruta del log, umbral de alerta (80%) y formato de fecha actual.
LOG='/var/log/techsolutions_monitor.log' 
UMBRAL_CPU=80 
FECHA=$(date '+%Y-%m-%d %H:%M:%S') 
 
# Recolección de métricas del sistema
# CPU: 'top -bn1' ejecuta el comando una sola vez, 'grep' y 'awk' extraen el porcentaje.
CPU=$(LC_ALL=C top -bn1 | grep 'Cpu(s)' | awk '{print $2}' | cut -d'%' -f1) 
# RAM: 'free -m' muestra memoria en MB, 'awk' realiza el cálculo porcentual.
RAM=$(LC_ALL=C free -m | awk 'NR==2{printf "%.1f", $3*100/$2}') 
# Disco: 'df -h /' analiza el uso de espacio en la partición raíz.
DISCO=$(df -h / | awk 'NR==2{print $5}') 
# Red: lee las estadísticas de la interfaz 'enp0s3' directamente del kernel.
RED=$(cat /proc/net/dev | grep enp0s3 | awk '{print $2}') 
 
# Registra los valores capturados en el archivo de log.
echo "[$FECHA] CPU: $CPU%  RAM: $RAM  Disco: $DISCO  Red_RX: $RED bytes" >> $LOG
 
# Lógica de alerta: compara el uso de CPU con el umbral.

# 'bc -l' es necesario para realizar comparaciones con decimales.
if (( $(echo "$CPU > $UMBRAL_CPU" | bc -l) )); then 
  # Escribe la alerta en el log y envía un mensaje a todos los usuarios logueados mediante 'wall'.
  echo "[$FECHA] ALERTA: CPU al $CPU% - supera umbral de $UMBRAL_CPU%" >> $LOG
  echo "ALERTA CPU ALTA: $CPU%" | wall
fi
