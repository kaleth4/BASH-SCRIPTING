#!/bin/bash
# Escaneo básico de red con Nmap

# Verifica si el usuario introdujo una IP
if [ -z "$1" ]; then
    echo "Uso: $0 <direccion_ip>"
    exit 1
fi

nmap -sS -p 1-65535 -v -oN scan_results.txt "$1"
