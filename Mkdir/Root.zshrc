# configuración de Zsh ~/.zshrc
# Función para inicializar entornos de CTF de forma dinámica
ctf-init() {
    if [ -z "$1" ]; then
        echo "❌ Error: Debes proporcionar un nombre para la máquina."
        echo "Uso: ctf-init <nombre_maquina>"
        return 1
    fi

    # Crea la estructura usando el argumento proporcionado
    mkdir -p "$1"/{exploit,files,notes,post,recon}
    echo "[+] Entorno CTF creado en $(pwd)/$1"
    cd "$1" && ls
}
