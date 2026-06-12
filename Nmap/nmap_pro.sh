#!/bin/bash
# ==============================================================================
# Script de Escaneo Avanzado con Nmap (Versión Pro)
# ==============================================================================

# 1. Validación de privilegios de administrador (Requerido para -sS, -O, -sV)
if [ "$EUID" -ne 0 ]; then
    echo -e "\e[31m[-] Error: Este script debe ejecutarse con privilegios de root (sudo).\e[0m"
    exit 1
fi

# 2. Captura del argumento de entrada (IP o Dominio)
OBJETIVO="$1"

# Si no se pasa un argumento, lo solicita interactivamente
if [ -z "$OBJETIVO" ]; then
    read -p "[?] Introduce la dirección IP o dominio objetivo: " OBJETIVO
fi

# 3. Validación básica del formato IP/Host
if [ -z "$OBJETIVO" ]; then
    echo -e "\e[31m[-] Error: No se especificó ningún objetivo.\e[0m"
    exit 1
fi

# 4. Configuración de variables de salida (Evita que se borren reportes previos)
FECHA=$(date +"%Y%m%d_%H%M%S")
# Limpia caracteres especiales del nombre de host para el nombre del archivo
OBJETIVO_LIMPIO=$(echo "$OBJETIVO" | tr -cd 'A-Za-z0-9.-')
REPORTE_TXT="scan_${OBJETIVO_LIMPIO}_${FECHA}.txt"
REPORTE_XML="scan_${OBJETIVO_LIMPIO}_${FECHA}.xml"

echo -e "\e[34m[*] Iniciando escaneo avanzado sobre: $OBJETIVO\e[0m"
echo -e "\e[34m[*] Los resultados se guardarán en: $REPORTE_TXT y $REPORTE_XML\e[0m"
echo "----------------------------------------------------------------------"

# 5. Ejecución del escaneo optimizado
# -sS: Escaneo SYN (sigiloso y rápido)
# -p 1-65535: Todos los puertos TCP
# -sV: Determinación de versiones de servicios (Esencial para auditorías)
# -O: Detección del Sistema Operativo
# --open: Muestra únicamente los puertos que estén abiertos (Limpia el ruido)
# -v: Nivel de detalle en la terminal
# -oN/-oX: Guarda simultáneamente en formato legible y en XML para herramientas como Zenmap o Metasploit
nmap -sS -p 1-65535 -sV -O --open -v -oN "$REPORTE_TXT" -oX "$REPORTE_XML" "$OBJETIVO"

# 6. Verificación de finalización
if [ $? -eq 0 ]; then
    echo "----------------------------------------------------------------------"
    echo -e "\e[32m[+] Escaneo completado exitosamente.\e[0m"
else
    echo "----------------------------------------------------------------------"
    echo -e "\e[31m[-] Ocurrió un error durante el escaneo.\e[0m"
fi
