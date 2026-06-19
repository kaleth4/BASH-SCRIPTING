#!/bin/bash

# Configuración de salida
OUTPUT_DIR="./pentest_evidence_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTPUT_DIR"

# Lista de archivos ocultos críticos a buscar
TARGET_FILES=(
    ".bashrc"
    ".bash_history"
    ".bash_profile"
    ".zshrc"
    ".zsh_history"
    ".history"
    ".nano_history"
    ".viminfo"
    ".ssh/id_rsa"
    ".ssh/id_dsa"
    ".ssh/id_ed25519"
    ".ssh/authorized_keys"
    ".ssh/known_hosts"
    ".aws/credentials"
    ".aws/config"
    ".docker/config.json"
    ".gitconfig"
)

echo "[*] Iniciando recolección de archivos ocultos en: $HOME"
echo "[*] Evidencias se guardarán en: $OUTPUT_DIR"
echo "--------------------------------------------------"

# Bucle de recolección
for file in "${TARGET_FILES[@]}"; do
    TARGET_PATH="$HOME/$file"
    
    # Verificar si el archivo existe y no está vacío
    if [ -f "$TARGET_PATH" ] && [ -s "$TARGET_PATH" ]; then
        echo "[+] Encontrado: $file"
        
        # Crear estructura de subdirectorios si es necesario (ej: .ssh/)
        DEST_SUBDIR=$(dirname "$OUTPUT_DIR/$file")
        mkdir -p "$DEST_SUBDIR"
        
        # Copiar manteniendo metadatos básicos
        cp "$TARGET_PATH" "$OUTPUT_DIR/$file"
    else
        echo "[-] No encontrado o vacío: $file"
    fi
done

# Búsqueda automatizada de otros posibles archivos de configuración (.conf, .env, .txt ocultos)
echo "--------------------------------------------------"
echo "[*] Buscando archivos ocultos adicionales (.env, .git, etc.)..."
find "$HOME" -maxdepth 2 -type f -name ".*" 2>/dev/null | grep -E "(\.env|\.git|\.conf|\.secret)" | while read -r extra_file; do
    echo "[+] Extra detectado: ${extra_file#$HOME/}"
    REL_PATH=${extra_file#$HOME/}
    mkdir -p "$(dirname "$OUTPUT_DIR/$REL_PATH")"
    cp "$extra_file" "$OUTPUT_DIR/$REL_PATH"
done

echo "--------------------------------------------------"
echo "[+] Auditoría finalizada. Revisa la carpeta: $OUTPUT_DIR"
