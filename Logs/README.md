## **Técnicas para Manipular Logs del Sistema**

Los logs son una de las principales fuentes de evidencia forense. **Eliminarlos o modificarlos** puede ayudar a ocultar actividades.

### ** Borrar Logs del Sistema**
#### **Métodos comunes:**
- **Eliminar logs específicos** (requiere `sudo`):
  ```bash
  sudo rm /var/log/auth.log
  sudo rm /var/log/syslog
  ```
  
---


  ### ** Redirigir Comandos a un Archivo Temporal**
Si se ejecutan comandos críticos, pueden **redirigirse a `/dev/null`** para evitar que se registren:
```bash
ls -la > /dev/null 2>&1
```
---

- **Temporalmente deshabilitar el historial**:
  ```bash
  unset HISTFILE  # Elimina el archivo de historial temporalmente
  set +o history  # Desactiva el registro de comandos
  ls -la          # No se registrará
  set -o history  # Reactiva el historial
  ```

- **Borrar el historial actual**:
  ```bash
  history -c  # Borra el historial en memoria
  > ~/.bash_history  # Vacía el archivo (requiere permisos)
  ```

---

### **Modificar el Historial Existente**
Si ya hay un historial, puede **editarse manualmente** o **eliminarse por completo**.

#### **Comandos útiles:**
```bash
# Mostrar historial actual
history

# Eliminar una línea específica (ej. línea 5)
history -d 5

# Borrar todas las líneas desde la 1 hasta la última
for i in $(seq 1 $(history | wc -l)); do history -d 1; done

# Eliminar el archivo de historial (requiere permisos)
rm ~/.bash_history
```

---
