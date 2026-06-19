#!/bin/bash

# ==============================================================================
# SCRIPT DE ENUMERACIÓN DE CONFIGURACIONES OCULTAS (PENTESTING)
# ==============================================================================

# --- Variables Globales ---
OUTPUT_DIR="./pentest_evidence_$(date +%Y%m%d_%H%M%S)"
HOME_DIR="$HOME"

# --- Paleta de Colores para Consola ---
GREEN="\e[32m"
RED="\e[31m"
BLUE="\e[34m"
YELLOW="\e[33m"
RESET="\e[0m"

# --- Banner Inicial ---
print_banner() {
    echo -e "${BLUE}======================================================${RESET}"
    echo -e "${BLUE}[*] SCRIPT DE ENUMERACIÓN DE ARCHIVOS OCULTOS${RESET}"
    echo -e "${BLUE}[*] Directorio objetivo: ${YELLOW}$HOME_DIR${RESET}"
    echo -e "${BLUE}[*] Evidencias en: ${YELLOW}$OUTPUT_DIR${RESET}"
    echo -e "${BLUE}======================================================${RESET}"
}

# --- Inicialización del Entorno ---
setup_environment() {
    if ! mkdir -p "$OUTPUT_DIR"; then
        echo -e "${RED}[-] Error crítico: No se pudo crear el directorio de salida.${RESET}"
        exit 1
    fi
}

# --- Procesar Archivos Críticos Definidos ---
dump_critical_files() {
    local target_files=(
        ".bashrc" ".bash_history" ".bash_profile"
        ".zshrc" ".zsh_history" ".history"
        ".nano_history" ".viminfo"
        ".ssh/id_rsa" ".ssh/id_dsa" ".ssh/id_ed25519"
        ".ssh/authorized_keys" ".ssh/known_hosts"
        ".aws/credentials" ".aws/config"
        ".docker/config.json" ".gitconfig"
    )

    echo -e "\n${BLUE}[*] Fase 1: Extrayendo archivos críticos conocidos...${RESET}"
    
    for file in "${target_files[@]}"; do
        local source_path="$HOME_DIR/$file"
        local dest_path="$OUTPUT_DIR/$file"
        
        if [ -f "$source_path" ] && [ -s "$source_path" ]; then
            mkdir -p "$(dirname "$dest_path")"
            if cp "$source_path" "$dest_path"; then
                echo -e "${GREEN}[+] Copiado con éxito: $file${RESET}"
            else
                echo -e "${RED}[-] Error al copiar: $file${RESET}"
            fi
        else
            echo -e "${YELLOW}[-] No existe o está vacío: $file${RESET}"
        fi
    done
}

# --- Búsqueda Avanzada de Extensiones Sensibles ---
discover_extra_secrets() {
    echo -e "\n${BLUE}[*] Fase 2: Escaneando el directorio en busca de otros secretos (Max: Nivel 2)...${RESET}"
    
    # Busca archivos ocultos que contengan extensiones críticas en sus nombres
    find "$HOME_DIR" -maxdepth 2 -type f -name ".*" 2>/dev/null | \
    grep -E "(\.env|\.git|\.conf|\.secret|\.key|\.pass)" | \
    while read -r extra_file; do
        
        # Calcular ruta relativa para replicar la estructura
        local rel_path="${extra_file#$HOME_DIR/}"
        local dest_path="$OUTPUT_DIR/$rel_path"
        
        echo -e "${GREEN}[+] Extra detectado: $rel_path${RESET}"
        mkdir -p "$(dirname "$dest_path")"
        cp "$extra_file" "$dest_path"
    done
}

# --- Función Principal ---
main() {
    print_banner
    setup_environment
    dump_critical_files
    discover_extra_secrets
    
    echo -e "\n${BLUE}======================================================${RESET}"
    echo -e "${GREEN}[+] Proceso completado con éxito.${RESET}"
    echo -e "${GREEN}[+] Analiza los resultados en: ${YELLOW}$OUTPUT_DIR${RESET}"
    echo -e "${BLUE}======================================================${RESET}"
}

# Ejecutar el script
main
