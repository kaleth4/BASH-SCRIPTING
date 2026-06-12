#!/bin/bash
# ==============================================================================
# Suite de Auditoría para Escalada de Privilegios en Linux (Versión Pro)
# ==============================================================================

REPORTE_PRIVS="priv_audit_results.txt"

# Asegurar que empezamos limpiando el reporte previo
echo "=== REPORTE DE VECTORES DE ESCALADA DE PRIVILEGIOS ===" > "$REPORTE_PRIVS"
date >> "$REPORTE_PRIVS"

audit_kernel_and_env() {
    echo -e "\e[34m[*] [1/3] Analizando información del Kernel y entorno...\e[0m"
    {
        echo -e "\n--- INFORMACIÓN DEL SISTEMA Y KERNEL ---"
        uname -a
        echo -e "\n--- USUARIO ACTUAL Y GRUPOS ---"
        id
        echo -e "\n--- PERMISOS SUDO (Requiere contraseña si no está en caché) ---"
        timeout 5 sudo -l 2>/dev/null || echo "No se puede listar sudo sin contraseña o timeout excedido."
    } >> "$REPORTE_PRIVS"
}

audit_suid_binaries() {
    echo -e "\e[34m[*] [2/3] Buscando archivos con bits SUID/SGID inusuales (Vectores GTFOBins)...\e[0m"
    echo -e "\n--- BINARIOS SUID DETECTADOS ---" >> "$REPORTE_PRIVS"
    
    # Busca archivos con permisos SUID de forma silenciosa y los registra
    find / -perm -4000 -type f 2>/dev/null | grep -E -v "/(snap|usr/lib|usr/share|var/lib)" >> "$REPORTE_PRIVS"
}

audit_sensitive_files() {
    echo -e "\e[34m[*] [3/3] Buscando archivos confidenciales y contraseñas expuestas...\e[0m"
    {
        echo -e "\n--- VERIFICACIÓN DE PERMISOS EN /etc/passwd Y /etc/shadow ---"
        ls -l /etc/passwd /etc/shadow 2>/dev/null
        
        echo -e "\n--- CAPACIDADES EXTENDIDAS DE ARCHIVOS (Capabilities) ---"
        getcap -r / 2>/dev/null
    } >> "$REPORTE_PRIVS"
}

# Ejecución de la auditoría local
audit_kernel_and_env
audit_suid_binaries
audit_sensitive_files

echo "----------------------------------------------------------------------"
echo -e "\e[32m[+] Auditoría de elevación de privilegios completada.\e[0m"
echo -e "\e[32m[+] Revisa el reporte generado en: ./$REPORTE_PRIVS\e[0m"
