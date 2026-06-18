# Función Personalizada en Bash/Zsh: `rmk`

Esta documentación detalla la función de automatización `rmk` (*Remove Keep*), utilizada comúnmente en entornos de auditoría de seguridad y hacking ético por profesionales como [S4vitar](https://s4vitar.com). Funciona como el complemento directo del comando `mkt`.

## Descripción del Comando

El objetivo principal de esta función es realizar una **limpieza rápida y controlada** del directorio de trabajo actual al finalizar una auditoría o un laboratorio (como Hack The Box). 

A diferencia de un borrado masivo tradicional (`rm -rf *`), `rmk` vacía el contenido pesado y los archivos temporales de las carpetas internas, pero **mantiene intacta la estructura principal de directorios** (`nmap/`, `content/`, `scripts/`) y evita la eliminación accidental de notas clave o configuraciones del entorno.

### Definición de la Función

Añade el siguiente bloque de código a tu archivo de configuración del shell (`~/.zshrc` o `~/.bashrc`):

```bash
rmk () {
    rm -rf nmap/* content/* scripts/* 2>/dev/null
}
```

### Explicación Técnica del Código:

* **`rm -rf`**: Comando de borrado forzado (`-f`) y recursivo (`-r`). Elimina archivos y subcarpetas sin solicitar confirmación al usuario.
* **`nmap/* content/* scripts/*`**: El uso del comodín asterisco (`*`) asegura que se elimine todo el **contenido interno** de cada una de estas carpetas, pero preservando los directorios raíz vacíos.
* **`2>/dev/null`**: Redirige la salida de errores estándar (*stderr*) al dispositivo nulo. Esto evita que la terminal muestre mensajes de advertencia molestos (como `No such file or directory`) en caso de que alguna de las tres carpetas ya esté completamente vacía o no exista en la ruta actual.

---

## Modos de Uso y Flujo de Trabajo

La función está diseñada para ejecutarse desde la raíz del directorio asignado a la máquina u objetivo evaluado.

### 1. Estado Inicial del Directorio
Durante la auditoría, tus carpetas acumulan múltiples archivos:
* `nmap/`: Archivos de escaneo (`.nmap`, `allPorts.gnmap`, `.xml`).
* `content/`: Diccionarios de fuerza bruta, exploits descargados, notas `index.html`.
* `scripts/`: Scripts automatizados en Python, Bash o binarios compilados.

### 2. Ejecución del Comando
Una vez completado el reporte o terminada la máquina, ejecutas en la terminal:
```bash
rmk
```

### 3. Estado Final del Directorio
Al listar nuevamente el directorio actual con `ll` o `tree`, observarás que el espacio en disco ha sido liberado pero la estructura organizativa se conserva lista para un nuevo uso:
```text
.
├── content/ [VACÍO]
├── nmap/    [VACÍO]
└── scripts/ [VACÍO]
```

---

## Buenas Prácticas y Advertencias

⚠️ **Alerta de Datos:** Debido a que el comando utiliza `rm -rf`, los archivos borrados no van a la papelera de reciclaje y **no se pueden recuperar**. Asegúrate siempre de haber respaldado tus notas finales o flags antes de invocar la función.
