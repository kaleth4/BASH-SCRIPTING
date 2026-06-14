# Función para agregar rápidamente hosts locales
add-host() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "❌ Uso: add-host <IP> <DOMINIO>"
        return 1
    fi
    echo "$1 $2" | sudo tee -a /etc/hosts
    echo "[+] Host agregado: $1 -> $2"
}
