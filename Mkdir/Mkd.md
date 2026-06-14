# 📋 Script de Inicialización de Entornos CTF/Auditorías para Zsh

## 🎯 Descripción

Script optimizado para **Zsh** que automatiza la creación de una estructura de directorios estándar para auditorías de seguridad y competiciones CTF (Capture The Flag). Permite organizar tu trabajo de forma consistente y eficiente.

---

## 📁 Estructura de Carpetas Creada

```
maquina_ctf/
├── exploit/      # Scripts y herramientas de explotación
├── files/        # Archivos descargados o capturados
├── notes/        # Notas y apuntes de la auditoría
├── post/         # Acciones post-explotación
└── recon/        # Información de reconocimiento
```

---

## 🚀 Instalación Rápida

### **Opción 1: Script Directo**

Crea un archivo `ctf-init.sh` con el siguiente contenido:

```zsh
#!/bin/zsh

# 1. Definir la variable con el nombre del directorio principal
# Puedes cambiar "maquina_ctf" por el nombre de la máquina objetivo
DIR_PRINCIPAL="maquina_ctf"

# 2. Crear la estructura de carpetas en una sola línea usando expansión de llaves ({})
mkdir -p "$DIR_PRINCIPAL"/{exploit,files,notes,post,recon}

# 3. Confirmación visual en la terminal
echo "[+] Entorno CTF creado exitosamente en: $(pwd)/$DIR_PRINCIPAL"
ls -l "$DIR_PRINCIPAL"
```

**Ejecución:**
```zsh
chmod +x ctf-init.sh
./ctf-init.sh
```

---

### **Opción 2: Función en ~/.zshrc (Recomendado)**

Añade las siguientes líneas al final de tu archivo `~/.zshrc`:

```zsh
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
```

**Aplicar cambios sin reiniciar:**
```zsh
source ~/.zshrc
```

---

## 💡 Uso

Una vez instalada la función, simplemente ejecuta:

```zsh
ctf-init nombre_maquina
```

**Ejemplo:**
```zsh
ctf-init htb_machine
ctf-init vulnhub_target
ctf-init ctf_challenge
```

---

## ✨ Características

✅ Creación automática de estructura de directorios  
✅ Expansión de llaves para máxima eficiencia  
✅ Validación de argumentos  
✅ Cambio automático al directorio creado  
✅ Confirmación visual con listado de carpetas  
✅ Compatible con Zsh moderno  

---

## 🔧 Personalización

Para modificar las carpetas, edita la línea:

```zsh
mkdir -p "$1"/{exploit,files,notes,post,recon}
```

**Ejemplo con carpetas adicionales:**
```zsh
mkdir -p "$1"/{exploit,files,notes,post,recon,tools,payloads,reports}
```

---

## 📝 Notas

- Asegúrate de tener **Zsh** instalado: `zsh --version`
- La función crea las carpetas en el directorio actual
- Puedes ejecutar `ctf-init` múltiples veces sin problemas
- Los directorios existentes no se sobrescriben

---

## 🎓 Casos de Uso

- **HackTheBox** - Organizar máquinas por dificultad
- **VulnHub** - Gestionar múltiples objetivos
- **CTF Competitions** - Estructura uniforme para todos los retos
- **Auditorías de Seguridad** - Documentación profesional

---

¡Optimiza tu flujo de trabajo en auditorías y CTFs! 🔐
