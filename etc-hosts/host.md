# README.md - Guía Completa del Archivo /etc/hosts en Auditorías de Seguridad

## 📋 Introducción

El archivo `/etc/hosts` es un componente crítico en la fase de reconocimiento de cualquier laboratorio o auditoría de seguridad. Su función principal es actuar como un sistema de resolución de nombres de dominio (DNS) local y estático, traduciendo nombres de host a direcciones IP directamente en tu máquina operativa antes de realizar consultas a servidores DNS externos.

---

## 📋 Estructura Básica del Archivo

Al editarlo con privilegios elevados (`sudo nano /etc/hosts`), encontrarás un formato simple compuesto por columnas separadas por espacios o tabuladores:

```
[Dirección_IP]    [nombre_de_dominio.com] [alias1] [alias2]
```

### Componentes Principales:

- **127.0.0.1**: Dirección de loopback de IPv4 (apunta a tu propia máquina local).
- **::1**: Dirección de loopback correspondiente para el protocolo IPv6.
- **Mapeos personalizados**: Como el que agregaste en tu captura (`192.168.100.192 autsecurity.as`).

---

## 🛡️ ¿Por Qué es Fundamental en Auditorías de Seguridad y CTFs?

### Virtual Hosting (Vhosts)

Muchos servidores web modernos alojan múltiples sitios web diferentes utilizando una única dirección IP. El servidor decide qué página mostrar basándose en el encabezado `Host` que envía tu navegador. 

**Ejemplo práctico:**
- Sin la línea en `/etc/hosts`: Al acceder a `http://192.168.100.192` verías una página por defecto de Apache.
- Con la línea configurada: Al ingresar a `http://autsecurity.as` accederás a la aplicación objetivo real.

### Habilitación de Herramientas de Fuzzing

Herramientas automatizadas de enumeración web (como **Gobuster**, **Wfuzz** o **Feroxbuster**) y escáneres de vulnerabilidades (**Nuclei**, **Nikto**) requieren la resolución correcta del nombre de dominio para auditar subdominios o configuraciones específicas del servidor virtual.

---

## 💡 Automatización Avanzada desde tu Terminal Zsh

Para evitar tener que abrir manualmente el editor de texto `nano` cada vez que inicias una máquina, puedes agregar esta función rápida a tu archivo de configuración `~/.zshrc`:

```zsh
# Función para agregar rápidamente hosts locales
add-host() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "❌ Uso: add-host <IP> <DOMINIO>"
        return 1
    fi
    echo "$1 $2" | sudo tee -a /etc/hosts
    echo "[+] Host agregado: $1 -> $2"
}
```

### Uso:

```bash
add-host 192.168.100.192 autsecurity.as
```

---

## 🚀 Mejores Prácticas

✅ Siempre utiliza `sudo` para editar el archivo  
✅ Realiza backups antes de cambios significativos  
✅ Verifica la sintaxis correcta (espacios/tabuladores)  
✅ Usa la función automatizada para agilizar tu flujo de trabajo  
✅ Documenta los mapeos agregados para referencia futura  
