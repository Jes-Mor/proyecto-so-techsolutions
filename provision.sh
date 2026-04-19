#!/bin/bash 
# Script de aprovisionamiento - TechSolutions S.A. 
# Equipo: Jesus Mario Morales Guzman y Sofia de Jesus Muñoz Morales  |  Materia: Sistemas Operativos 
# Fecha: 18/04/2026

set -e # Detiene la ejecución del script inmediatamente si algún comando devuelve un error.

echo "=============================="
echo "APROVISIONAMIENTO TECHSOLUTIONS"
echo "=============================="

# 1. Actualización del sistema
echo "[1/6] Actualizando sistema..."
# 'update' refresca el índice de repositorios y 'upgrade' instala las versiones más recientes.
apt-get update -qq && apt-get upgrade -y -qq

# 2. Instalar Apache (servidor web)
echo "[2/6] Instalando Apache..."
apt-get install -y apache2
# Habilita el servicio para que inicie con el sistema y lo pone en ejecución.
systemctl enable apache2 && systemctl start apache2

# 3. Instalar MySQL
echo "[3/6] Instalando MySQL..."
apt-get install -y mysql-server
# Habilita el inicio automático del servicio de base de datos.
systemctl enable mysql && systemctl start mysql

# 4. Instalar PHP
echo "[4/6] Instalando PHP..."
apt-get install -y php libapache2-mod-php php-mysql

# 5. Instalar y configurar FTP (vsftpd)
echo '[5/6] Configurando FTP...' 
apt-get install -y vsftpd
# 'sed -i' busca las líneas existentes en el archivo de configuración y las reemplaza por los parámetros requeridos.
sed -i 's/^listen=.*/listen=YES/' /etc/vsftpd.conf
sed -i 's/^listen_ipv6=.*/listen_ipv6=NO/' /etc/vsftpd.conf
sed -i 's/^#*local_enable=.*/local_enable=YES/' /etc/vsftpd.conf
sed -i 's/^#*write_enable=.*/write_enable=YES/' /etc/vsftpd.conf
sed -i 's/^#*chroot_local_user=.*/chroot_local_user=YES/' /etc/vsftpd.conf

# 'echo >>' añade nuevas directivas al final del archivo de configuración.
echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf
echo "user_sub_token=\$USER" >> /etc/vsftpd.conf
echo "local_root=/home/\$USER/ftp" >> /etc/vsftpd.conf

# Reinicia el servicio para aplicar los cambios de configuración.
systemctl restart vsftpd

# 6. Configurar SSH
echo '[6/6] Configurando SSH...'
apt-get install -y openssh-server
# 'sed' ajusta la seguridad: desactiva root, prohíbe contraseñas y fuerza la autenticación por llaves.
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
# Reinicia SSH para aplicar las nuevas políticas de seguridad.
systemctl restart ssh

echo 'Aprovisionamiento completado exitosamente.'
