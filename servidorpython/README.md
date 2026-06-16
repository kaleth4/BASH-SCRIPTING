# Servidor HTTP Local para Herramientas de Auditoría

## 📋 Descripción

Script Python que levanta un servidor HTTP local para compartir herramientas de pentesting (.exe y otros archivos) de forma controlada. Incluye la capacidad de abrir automáticamente el navegador web en la dirección correcta para descargar los recursos.

## ✨ Características

- **Servidor HTTP integrado** basado en `http.server` de Python
- **Parámetros configurables** para puerto y directorio
- **Apertura automática del navegador** (opcional) mediante el módulo `webbrowser`
- **Threading** para no bloquear el servidor al abrir el navegador
- **Manejo de errores** para permisos y directorios inexistentes
- **Fácil de usar** con argumentos de línea de comandos

## 📦 Requisitos

- Python 3.6 o superior
- Módulos estándar (sin dependencias externas):
  - `argparse`
  - `os`
  - `http.server`
  - `socketserver`
  - `webbrowser`
  - `threading`
  - `time`

## 🚀 Instalación

1. Descarga o copia el archivo `server.py` en tu máquina
2. Asegúrate de tener Python 3 instalado
3. Coloca tus herramientas (.exe u otros archivos) en la carpeta que desees compartir

## 📖 Uso

### Ver la ayuda completa

```bash
python3 server.py -h
```

### Iniciar el servidor (sin abrir navegador)

```bash
python3 server.py -p 8080 -d ./herramientas
```

### Iniciar el servidor y abrir navegador automáticamente

```bash
python3 server.py -p 8080 -d ./herramientas -n
```

## 🔧 Parámetros

| Parámetro | Corto | Tipo | Defecto | Descripción |
|-----------|-------|------|---------|-------------|
| `--puerto` | `-p` | int | 8080 | Puerto en el que escuchará el servidor |
| `--directorio` | `-d` | str | `.` | Directorio raíz con los archivos a compartir |
| `--navegador` | `-n` | flag | False | Abrir automáticamente el navegador web |

## 💡 Ejemplos de Uso
<img width="1391" height="804" alt="image" src="https://github.com/user-attachments/assets/89c7fe2f-e1f0-42ae-ad17-75a6d6a7e8bf" />

**Compartir archivos en puerto 9000 desde la carpeta actual:**
```bash
python3 server.py -p 9000
```

**Compartir herramientas desde una carpeta específica:**
```bash
python3 server.py -d /ruta/a/herramientas
```

**Iniciar con puerto personalizado y abrir navegador:**
```bash
python3 server.py -p 3000 -d ./tools -n
```

## ⚙️ Cómo Funciona

1. El script parsea los argumentos de línea de comandos
2. Valida que el directorio especificado exista
3. Si se activa la bandera `-n`, inicia un hilo secundario que espera 1 segundo y abre el navegador
4. Levanta el servidor HTTP en el puerto especificado
5. Comparte todos los archivos del directorio indicado
6. Presiona **CTRL+C** para detener el servidor

## ⚠️ Notas Importantes

- El script debe ejecutarse con **permisos suficientes** para usar puertos menores a 1024
- El servidor es **local** (solo accesible desde `localhost` o `127.0.0.1`)
- Para acceso remoto, considera usar configuraciones adicionales o herramientas como `ngrok`
- **Usa este script responsablemente** en contextos de pentesting autorizados

## 🛑 Detener el Servidor

Presiona **CTRL+C** en la terminal donde se ejecuta el script.

---

**Autor:** Script de automatización para auditoría  
**Licencia:** Úsalo bajo tu responsabilidad
