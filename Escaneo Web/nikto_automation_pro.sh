#!/bin/bash
# ==============================================================================
# Automatización Avanzada de Escaneo Web con Nikto (Versión Pro)
# ==============================================================================

# 1. Control dinámico del archivo de entrada
ARCHIVO_DOMINIOS="${1:-domains.txt}"

if [ ! -f "$ARCHIVO_DOMINIOS" ]; then
    echo -e "\e[31m[-] Error: El archivo de objetivos '$ARCHIVO_DOMINIOS' no existe.\e[0m"
    echo "Uso opcional: $0 <archivo_personalizado.txt>"
    exit 1
fi

# 2. Creación del directorio con marca de tiempo para evitar sobrescribir
FECHA=$(date +"%Y%m%d_%H%M%S")
DIR_RESULTADOS="resultados_nikto_${FECHA}"
mkdir -p "$DIR_RESULTADOS"

echo -e "\e[34m[*] Carpeta de reportes asignada: ./$DIR_RESULTADOS\e[0m"
echo "----------------------------------------------------------------------"

# 3. Bucle de procesamiento e interactividad limpia
while IFS= read -r objetivo || [ -n "$objetivo" ]; do
    # Ignorar líneas vacías o comentarios que comiencen con #
    [[ -z "$objetivo" || "$objetivo" =~ ^# ]] && continue

    # Sanitizar el nombre del archivo: quita http://, https://, barras y caracteres raros
    OBJETIVO_LIMPIO=$(echo "$objetivo" | sed -e 's|^[^/]*//||' -e 's|[/:]|_|g' | tr -cd 'A-Za-z0-9._-')

    echo -e "\e[34m[*] Escaneando servidor web: $objetivo ...\e[0m"

    # 4. Ejecución optimizada de Nikto
    # -h: Host u objetivo
    # -C all: Fuerza la verificación de todos los directorios CGI comunes
    # -maxtime 10m: Limita el escaneo por host a 10 minutos para evitar que se cuelgue infinitamente
    # -Format txt,html: Exporta los resultados en formato legible y en HTML
    # -o: Especifica las rutas de salida con el nombre limpio de estructura
    nikto -h "$objetivo" -C all -maxtime 10m -Format txt -o "$DIR_RESULTADOS/${OBJETIVO_LIMPIO}.txt"

    echo -e "\e[32m[+] Escaneo finalizado para: $objetivo\e[0m"
    echo "----------------------------------------------------------------------"

done < "$ARCHIVO_DOMINIOS"

# 5. Cierre
echo -e "\e[32m[+] Todos los escaneos web de Nikto han concluido.\e[0m"
echo -e "\e[32m[+] Archivos almacenados en la carpeta: ./$DIR_RESULTADOS\e[0m"
ls -lh "$DIR_RESULTADOS"
