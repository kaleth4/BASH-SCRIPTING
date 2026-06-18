# Función Personalizada en Bash: `mkt`

Esta documentación detalla una función de automatización en Bash utilizada habitualmente por profesionales de la ciberseguridad y hacking ético (como [S4vitar](https://s4vitar.com)) para agilizar la creación de estructuras de directorios durante una fase de reconocimiento o auditoría.

## Descripción del Comando

El objetivo de la función es automatizar la creación de la estructura base de carpetas necesaria para organizar de forma ordenada los archivos de un laboratorio o máquina objetivo (por ejemplo, en plataformas como Hack The Box o VulnHub).

### Definición de la Función

La función se define dentro del archivo de configuración del shell (como `.bashrc` o `.zshrc`) de la siguiente manera:

```bash
mkt () {
    mkdir {nmap,content,scripts}
}
```

### Explicación de los Componentes:

* **`mkt ()`**: Declara una función personalizada llamada `mkt` (abreviatura común para *Make Target* o *Make Tooling*).
* **`mkdir`**: Comando estándar de Linux empleado para crear nuevos directorios (carpetas).
* **`{nmap,content,scripts}`**: Utiliza la **expansión de llaves** de Bash (*brace expansion*). Esto permite ejecutar el comando `mkdir` una sola vez y crear tres directorios independientes de forma simultánea:
  1. `nmap/`: Destinado a almacenar los escaneos de puertos y servicios realizados con la herramienta Nmap.
  2. `content/`: Diseñado para guardar notas, exploits descargados, respuestas web u otros archivos de datos.
  3. `scripts/`: Reservado para almacenar scripts personalizados o herramientas automatizadas desarrolladas durante la auditoría.

---

## Flujo de Ejecución del Sistema

A continuación se describe el comportamiento del sistema al interactuar con esta función en la terminal:

1. **Verificación de la sintaxis:**
   ```bash
   which mkt | cat -l bash
   ```
   *Muestra la definición exacta de la función y resalta su código con la sintaxis de Bash.*

2. **Invocación del comando:**
   ```bash
   mkt
   ```
   *Crea en un solo paso los tres directorios dentro de la ruta actual de trabajo.*

3. **Verificación de resultados:**
   ```bash
   ll
   ```
   *Al listar detalladamente el directorio actual, el sistema confirma la creación de las carpetas con sus respectivos permisos predeterminados:*
   
   ```text
   drwxr-xr-x root root 0 B Mon Feb  3 19:41:57 2025 content
   drwxr-xr-x root root 0 B Mon Feb  3 19:41:57 2025 nmap
   drwxr-xr-x root root 0 B Mon Feb  3 19:41:57 2025 scripts
   ```
