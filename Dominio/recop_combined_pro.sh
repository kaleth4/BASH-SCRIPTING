#!/bin/bash
# ==============================================================================
# Script de Reconocimiento DNS y Dominio Combinado (Versión Pro)
# ==============================================================================

# 1. Validación de argumento de entrada
DOMAIN="$1"
if [ -z "$DOMAIN" ]; then
    echo -e "\e[31m[-] Error: Debes especificar un dominio.\e[0m"
    echo "Uso: $0 miempresa.com"
    exit 1
fi

# 2. Creación del entorno de trabajo (Evita mezclar archivos)
FECHA=$(date +"%Y%m%d_%H%M%S")
DOMAIN_LIMPIO=$(echo "$DOMAIN" | tr -cd 'A-Za-z0-9.-')
DIRECTORIO_OUT="recon_${DOMAIN_LIMPIO}_${FECHA}"
mkdir -p "$DIRECTORIO_OUT"

echo -e "\e[34m[*] Creando directorio de resultados: ./$DIRECTORIO_OUT\e[0m"
echo "----------------------------------------------------------------------"

# 3. Ejecución de dnsenum
echo -e "\e[34m[*] [1/3] Ejecutando dnsenum sobre $DOMAIN...\e[0m"
# Añadimos --enum para un escaneo profundo estándar
dnsenum --enum "$DOMAIN" > "${DIRECTORIO_OUT}/dnsenum_results.txt" 2>&1

# 4. Ejecución de whois
echo -e "\e[34m[*] [2/3] Ejecutando whois sobre $DOMAIN...\e[0m"
whois "$DOMAIN" > "${DIRECTORIO_OUT}/whois_results.txt" 2>&1

# 5. Ejecución de dig optimizada
echo -e "\e[34m[*] [3/3] Ejecutando consultas dig estructuradas...\e[0m"
# Guardamos ANY, pero también registros clave por separado por si ANY es bloqueado
{
    echo "=== CONSULTA ANY ==="
    dig "$DOMAIN" ANY +nocmd +nostats
    echo -e "\n=== REGISTROS MX ==="
    dig "$DOMAIN" MX +short
    echo -e "\n=== REGISTROS TXT (SPF/DMARC) ==="
    dig "$DOMAIN" TXT +short
} > "${DIRECTORIO_OUT}/dig_results.txt"

# 6. Finalización y resumen
echo "----------------------------------------------------------------------"
echo -e "\e[32m[+] Reconocimiento finalizado correctamente.\e[0m"
echo -e "\e[32m[+] Todos los reportes se han guardado dentro de la carpeta: $DIRECTORIO_OUT\e[0m"
ls -lh "$DIRECTORIO_OUT"
