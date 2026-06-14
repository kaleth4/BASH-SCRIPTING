#!/bin/zsh

# 1. Definir la variable con el nombre del directorio principal
# Puedes cambiar "maquina_ctf" por el nombre de la máquina objetivo
DIR_PRINCIPAL="maquina_ctf"

# 2. Crear la estructura de carpetas en una sola línea usando expansión de llaves ({})
mkdir -p "$DIR_PRINCIPAL"/{exploit,files,notes,post,recon}

# 3. Confirmación visual en la terminal
echo "[+] Entorno CTF creado exitosamente en: $(pwd)/$DIR_PRINCIPAL"
ls -l "$DIR_PRINCIPAL"

