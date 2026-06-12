#!/bin/bash
# ==============================================================================
# Escáner Avanzado de Vulnerabilidades con Nmap NSE (Versión Pro)
# ==============================================================================

# 1. Asegurar privilegios de root (Esencial para escaneos NSE avanzados)
if [ "$EUID" -ne 0 ]; then
    echo -e "\e[31m[-] Error: Este script requiere privilegios de root (sudo).\e[0m"
    echo "Ejecución: sudo $0"
    exit 1
fi

# 2. Control dinámico del archivo de entrada
ARCHIVO_IPS="${1:-ip_addresses.txt}"

if [ ! -f "$ARCHIVO_IPS" ]; then
    echo -e "\e[31m[-] Error: El archivo de objetivos '$ARCHIVO_IPS' no existe.\e[0m"
    exit 1
fi

# 3. Configuración de reportes únicos
FECHA=$(date +"%Y%m%d_%H%M%S")
REPORTE_TXT="vulnerabilidades_${FECHA}.txt"
REPORTE_XML="vulnerabilidades_${FECHA}.xml"

echo -e "\e[34m[*] Leyendo objetivos desde: $ARCHIVO_IPS\e[0m"
echo -e "\e[34m[*] Lanzando motor de scripts de vulnerabilidades (NSE)...\e[0m"
echo -e "\e[33m[!] Nota: Este análisis puede tomar tiempo dependiendo de los servicios abiertos.\e[0m"
echo "----------------------------------------------------------------------"

# 4. Escaneo de vulnerabilidades optimizado
# -sV: OBLIGATORIO. Determina las versiones de los servicios para que los scripts 'vuln' puedan cruzarlos con sus bases de datos.
# --script vuln: Ejecuta el paquete completo de detección de vulnerabilidades.
# --script-args vuln.short: Hace que la salida sea más limpia, mostrando solo si es vulnerable o no.
# -oN/-oX: Guarda en formato legible y XML (para importar después en herramientas de reporte o bases de datos).
nmap -iL "$ARCHIVO_IPS" -sV --script vuln --script-args vuln.short -oN "$REPORTE_TXT" -oX "$REPORTE_XML"

# 5. Resumen de resultados en pantalla
if [ $? -eq 0 ]; then
    echo "----------------------------------------------------------------------"
    echo -e "\e[32m[+] Análisis de vulnerabilidades finalizado.\e[0m"
    echo -e "\e[32m[+] Reportes generados: $REPORTE_TXT y $REPORTE_XML\e[0m"
    
    # Intenta filtrar líneas clave para darte un resumen rápido en consola
    echo -e "\n[*] Resumen rápido de vulnerabilidades críticas potenciales detectadas:"
    grep -E "VULNERABLE:|State: VULNERABLE|CVE-" "$REPORTE_TXT" || echo "No se detectaron firmas de vulnerabilidades obvias en primera instancia."
else
    echo -e "\e[31m[-] Ocurrió un error inesperado durante la ejecución de Nmap.\e[0m"
fi
