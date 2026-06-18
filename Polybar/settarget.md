# Función Personalizada en Bash/Zsh: `settarget`

Esta documentación detalla la función de automatización `settarget`, popularizada por el instructor de ciberseguridad [S4vitar](https://s4vitar.com). Se utiliza en entornos de escritorio personalizados (como BSPWM o i3wm) para actualizar dinámicamente el objetivo de auditoría actual en la barra de estado del sistema ([Polybar](https://github.com)).

## Descripción del Comando

El objetivo de esta función es registrar la Dirección IP y el nombre de la máquina o infraestructura que se está auditando en un archivo de texto plano (`target.txt`). Posteriormente, un script enlazado a la barra de estado lee este archivo de forma continua para reflejar visualmente el objetivo en la pantalla del auditor.

### Definición de la Función

Añade el siguiente bloque de código a tu archivo de configuración del shell (`~/.zshrc` o `~/.bashrc`):

```bash
settarget () {
    if [ "\$1" ] && [ "\$2" ]; then
        echo "\$1 \$2" > ~/.config/bin/target.txt
    elif [ "\$1" ]; then
        echo "\$1" > ~/.config/bin/target.txt
    else
        echo "No target" > ~/.config/bin/target.txt
    fi
}
```

### Explicación Lógica del Código:

La función evalúa los argumentos proporcionados mediante una estructura condicional (`if-elif-else`):

* **`if [ "$1" ] && [ "$2" ]`**: Si el usuario proporciona tanto la Dirección IP (`$1`) como el nombre de la máquina (`$2`), concatena ambos valores y los sobreescribe en el archivo de texto.
* **`elif [ "$1" ]`**: Si el usuario solo proporciona un argumento (por ejemplo, solo la IP o solo el nombre), guarda únicamente ese valor en el archivo.
* **`else`**: Si se ejecuta el comando sin ningún parámetro, borra el objetivo anterior y escribe la cadena `"No target"`, indicando que no hay ninguna auditoría activa.
* **`> ~/.config/bin/target.txt`**: El operador de redirección simple (`>`) asegura que el archivo se limpie por completo y se reemplace con la nueva información, evitando acumular datos antiguos.

---

## Modos de Uso en la Terminal

Dependiendo de la fase de la auditoría, la función se puede invocar de tres formas distintas:

### 1. Establecer IP y Nombre del Objetivo
Se utiliza al iniciar un laboratorio o máquina en plataformas como Hack The Box o VulnHub.
```bash
settarget 10.10.11.20 "Máquina_Linux"
```
* **Resultado en `target.txt`:** `10.10.11.20 Máquina_Linux`

### 2. Establecer únicamente un Parámetro
Útil si solo se conoce la dirección IP en la fase inicial de reconocimiento.
```bash
settarget 10.129.72.91
```
* **Resultado en `target.txt`:** `10.129.72.91`

### 3. Limpiar el Objetivo Actual
Se ejecuta al finalizar la auditoría para restablecer el estado de la barra visual.
```bash
settarget
```
* **Resultado en `target.txt`:** `No target`

---

## Integración con la Barra de Estado (Polybar)

Para que esta función muestre la información en tiempo real en tu entorno de escritorio, debes configurar un módulo de tipo `custom/script` en tu archivo `~/.config/polybar/config.ini`:

```ini
[module/target]
type = custom/script
exec = cat ~/.config/bin/target.txt 2>/dev/null || echo "No target"
interval = 2
format-prefix = "🎯 "
format-prefix-foreground = #FF0000
format-foreground = #FFFFFF
```

* **`exec = cat ...`**: Comando que lee e imprime el contenido del archivo de texto.
* **`interval = 2`**: Actualiza la barra cada 2 segundos para reflejar los cambios casi instantáneamente al usar la función en la terminal.
