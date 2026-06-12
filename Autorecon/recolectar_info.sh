#!/bin/bash
# ==============================================================================
# Script Unificado de Recolección de Información (Versión Pro)
# ==============================================================================

# 1. Verificación de privilegios (Nmap -sS requiere root)
if [ "$EUID" -ne 0 ]; then
    echo -e "\e[31m[-] Error: Este script requiere privilegios de root (sudo).\e[0m"
    exit 1
fi

# 2. Validación de argumento
TARGET="$1"
if [ -z "$TARGET" ]; then
    echo -e "\e[31m[-] Error: Falta el objetivo.\e[0m"
    echo "Uso: $0 <dominio_o_ip>"
    exit 1
fi

# 3. Creación de estructura de directorios única
FECHA=$(date +"%Y%m%d_%H%M%S")
TARGET_LIMPIO=$(echo "$TARGET" | tr -cd 'A-Za-z0-9.-')
DIR_RESULTADOS="resultados_${TARGET_LIMPIO}_${FECHA}"
mkdir -p "$DIR_RESULTADOS"

echo -e "\e[34m[*] Carpeta de reportes asignada: ./$DIR_RESULTADOS\e[0m"
echo "----------------------------------------------------------------------"

# 4. Gestión inteligente del Proyecto Discover (Herramienta Externa)
# Desplazamos esto al inicio para verificar dependencias antes del escaneo activo
if [ ! -d "discover" ]; then
    echo -e "\e[33m[*] Clonando e inicializando el proyecto Discover de Lee Baird...\e[0m"
    git clone https://github.com
    # Nota: No ejecutamos ./update.sh de forma automática aquí porque toma el control
    # de la terminal, actualiza paquetes de Kali e interrumpe este script pasivo.
    echo -e "\e[32m[+] Discover clonado. Puedes usarlo manualmente en ./discover\e[0m"
else
    echo -e "\e[32m[+] El proyecto Discover ya se encuentra disponible en el sistema.\e[0m"
fi
echo "----------------------------------------------------------------------"

# 5. [Fase Activa] Escaneo de red con Nmap
echo -e "\e[34m[*] [1/4] Ejecutando escaneo masivo de puertos con Nmap...\e[0m"
nmap -sS -p 1-65535 -v -oN "$DIR_RESULTADOS/nmap_scan_results.txt" "$TARGET"

# 6. [Fase Pasiva/OSINT] las siguientes herramientas prefieren dominios.
# Si el usuario ingresó una IP, avisamos que estas herramientas podrían no ser precisas.
echo -e "\e[34m[*] [2/4] Iniciando recolección OSINT con theHarvester...\e[0m"
theHarvester -d "$TARGET" -l 500 -b google -f "$DIR_RESULTADOS/harvester_results"

# 7. [Fase DNS] Análisis de infraestructura
echo -e "\e[34m[*] [3/4] Ejecutando dnsenum...\e[0m"
dnsenum --enum "$TARGET" > "$DIR_RESULTADOS/dnsenum_results.txt" 2>&1

echo -e "\e[34m[*] [4/4] Extrayendo datos de whois y registros de red (dig)...\e[0m"
whois "$TARGET" > "$DIR_RESULTADOS/whois_results.txt" 2>&1

{
    echo "=== CONSULTA DNS ANY ==="
    dig "$TARGET" ANY +nocmd +nostats
    echo -e "\n=== REGISTROS MX (CORREO) ==="
    dig "$TARGET" MX +short
    echo -e "\n=== REGISTROS TXT (SEGURIDAD/SPF) ==="
    dig "$TARGET" TXT +short
} > "$DIR_RESULTADOS/dig_results.txt" 2>&1

# 8. Cierre de ejecución
echo "----------------------------------------------------------------------"
echo -e "\e[32m[+] Suite de recolección finalizada con éxito.\e[0m"
echo -e "\e[32m[+] Todos los archivos se consolidaron en: ./$DIR_RESULTADOS\e[0m"
ls -lh "$DIR_RESULTADOS"
