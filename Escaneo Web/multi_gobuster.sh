#!/bin/bash

# Colores para una salida profesional en la terminal
VERDE="\e[0;32m\e[1m"
AZUL="\e[0;34m\e[1m"
AMARILLO="\e[0;33m\e[1m"
ROJO="\e[0;31m\e[1m"
RESET="\e[0m"

echo -e "${AZUL}[+]===================================================[+]"
echo -e "      AUDITORÍA WEB AUTOMATIZADA CON MULTI-GOBUSTER      "
echo -e "[+]===================================================[+]${RESET}\n"

# 1. Solicitar el objetivo al usuario
read -p "$(echo -e ${AMARILLO}"[?] Introduce la IP o Dominio del objetivo (ej. 57.128.254.142 o dom.com): "${RESET})" TARGET

# Validar entrada vacía
if [ -z "$TARGET" ]; then
    echo -e "${ROJO}[!] Error: No introdujiste ningún objetivo. Saliendo...${RESET}"
    exit 1
fi

# Asegurar que el objetivo lleve el protocolo http:// si no se especificó
if [[ ! "$TARGET" =~ ^http:// && ! "$TARGET" =~ ^https:// ]]; then
    TARGET="http://$TARGET"
fi

# 2. Definir una lista de wordlists estratégicas de Kali Linux
WORDLISTS=(
    "/usr/share/wordlists/dirb/common.txt"
    "/usr/share/wordlists/dirb/big.txt"
    "/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"
    "/usr/share/wordlists/seclists/Discovery/Web-Content/api-endpoints.txt"
)

# Extensiones a buscar
EXTENSIONS="json,api,txt,bak,php,html"

# Crear directorio exclusivo para guardar los reportes limpios
OUTPUT_DIR="gobuster_scans"
mkdir -p "$OUTPUT_DIR"

echo -e "\n${VERDE}[*] Objetivo fijado: $TARGET"
echo -e "[*] Los resultados se guardarán en la carpeta: ./$OUTPUT_DIR/${RESET}\n"

# 3. Bucle para recorrer y ejecutar cada diccionario
for WORDLIST in "${WORDLISTS[@]}"; do
    # Verificar si el diccionario existe en el sistema actual antes de lanzarlo
    if [ -f "$WORDLIST" ]; then
        # Extraer el nombre del diccionario para nombrar el archivo de salida
        LIST_NAME=$(basename "$WORDLIST" .txt)
        OUTPUT_FILE="$OUTPUT_DIR/scan_${LIST_NAME}.txt"
        
        echo -e "${AZUL}[--->] Iniciando escaneo con: $WORDLIST ...${RESET}"
        
        # Ejecución del comando original optimizado
        gobuster dir -u "$TARGET" -w "$WORDLIST" -x "$EXTENSIONS" -t 50 -k -o "$OUTPUT_FILE"
        
        if [ -s "$OUTPUT_FILE" ]; then
            echo -e "${VERDE}[✓] Escaneo finalizado. Resultados guardados en: $OUTPUT_FILE${RESET}\n"
        else
            echo -e "${AMARILLO}[!] Escaneo finalizado sin resultados significativos con esta lista.${RESET}\n"
            rm -f "$OUTPUT_FILE" # Limpia archivos vacíos
        fi
    else
        echo -e "${ROJO}[!] Saltando diccionario (No instalado en tu sistema): $WORDLIST${RESET}\n"
    fi
done

echo -e "${VERDE}[+] Auditoría completada con éxito. Revisa la carpeta '$OUTPUT_DIR'.${RESET}"
