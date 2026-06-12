#!/bin/bash
# ==============================================================================
# Detector Avanzado de Sistemas Operativos (Versión Pro)
# ==============================================================================

# 1. Asegurar privilegios de administrador de raíz (mejor que meter sudo en líneas internas)
if [ "$EUID" -ne 0 ]; then
    echo -e "\e[31m[-] Error: Este script requiere privilegios de root (sudo).\e[0m"
    echo "Ejecución correcta: sudo $0"
    exit 1
fi

# 2. Control dinámico del archivo de hosts (Permite pasar un archivo personalizado o usar el de defecto)
ARCHIVO_HOSTS="${1:-live_hosts.txt}"

if [ ! -f "$ARCHIVO_HOSTS" ]; then
    echo -e "\e[31m[-] Error: El archivo con los hosts activos '$ARCHIVO_HOSTS' no existe.\e[0m"
    exit 1
fi

# 3. Preparación de variables de salida
FECHA=$(date +"%Y%m%d_%H%M%S")
REPORTE_OUT="os_detection_${FECHA}.txt"

echo -e "\e[34m[*] Leyendo objetivos desde: $ARCHIVO_HOSTS\e[0m"
echo -e "\e[34m[*] Escaneando sistemas operativos en progreso...\e[0m"
echo "----------------------------------------------------------------------"

# 4. Escaneo Nmap Profesional Optimizado
# -O: Activa detección de Sistema Operativo
# -sV: Detección de versiones (Ayuda a Nmap a estimar el SO mediante los banners de los servicios)
# --max-rtt-timeout 500ms: Reduce el tiempo de espera si un host no responde rápidamente
# --osscan-limit: Si un host no tiene al menos un puerto abierto y uno cerrado, no intenta adivinar el SO (Ahorra muchísimo tiempo)
nmap -iL "$ARCHIVO_HOSTS" -O -sV --osscan-limit --max-rtt-timeout 500ms -oN "$REPORTE_OUT"

# 5. Resumen final en pantalla de lo encontrado
if [ $? -eq 0 ]; then
    echo "----------------------------------------------------------------------"
    echo -e "\e[32m[+] Detección finalizada de forma correcta.\e[0m"
    echo -e "\e[32m[+] Resultados almacenados en: ./$REPORTE_OUT\e[0m"
    echo -e "\n[*] Breve resumen de Sistemas Operativos detectados:"
    # Filtra las líneas que contienen "OS details" o "Running" para dar un vistazo rápido
    grep -E "OS details:|Running:|OS:" "$REPORTE_OUT" | uniq
else
    echo -e "\e[31m[-] Ocurrió un fallo general en la ejecución de Nmap.\e[0m"
fi
