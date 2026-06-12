#!/bin/bash
# ==============================================================================
# Script de Recolección OSINT con theHarvester (Versión Pro)
# ==============================================================================

# 1. Captura del dominio objetivo
DOMINIO="$1"

if [ -z "$DOMINIO" ]; then
    read -p "[?] Introduce el dominio objetivo (ej. miempresa.com): " DOMINIO
fi

if [ -z "$DOMINIO" ]; then
    echo -e "\e[31m[-] Error: No se especificó ningún dominio.\e[0m"
    exit 1
fi

# 2. Configuración de nombres de archivo únicos
FECHA=$(date +"%Y%m%d_%H%M%S")
DOMINIO_LIMPIO=$(echo "$DOMINIO" | tr -cd 'A-Za-z0-9.-')
REPORTE_BASE="osint_${DOMINIO_LIMPIO}_${FECHA}"

echo -e "\e[34m[*] Iniciando recolección de información sobre: $DOMINIO\e[0m"
echo -e "\e[34m[*] Buscando en múltiples fuentes públicas...\e[0m"
echo "----------------------------------------------------------------------"

# 3. Ejecución avanzada de theHarvester
# -d: El dominio objetivo
# -l 500: Límite de resultados por buscador
# -b: "all" busca en todas las fuentes gratuitas disponibles (Google, Bing, DuckDuckGo, Yahoo, etc.)
# -f: Guarda los resultados tanto en .html como en .xml automáticamente usando el nombre base
theHarvester -d "$DOMINIO" -l 500 -b all -f "$REPORTE_BASE"

# 4. Verificación de resultados
echo "----------------------------------------------------------------------"
if [ -f "${REPORTE_BASE}.html" ] || [ -f "${REPORTE_BASE}.xml" ]; then
    echo -e "\e[32m[+] Recolección finalizada con éxito.\e[0m"
    echo -e "\e[32m[+] Reportes generados: ${REPORTE_BASE}.html y ${REPORTE_BASE}.xml\e[0m"
else
    echo -e "\e[33m[!] Proceso terminado. Revisa la terminal para ver si hubo bloqueos o captchas.\e[0m"
fi
