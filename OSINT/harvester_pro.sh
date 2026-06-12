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
