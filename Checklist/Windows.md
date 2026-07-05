# Checklist de Pentesting en Entornos Windows

## 1. Reconocimiento y Enumeración Activa/Pasiva
*   [ ] **Identificación de host:** Escaneo de red para descubrir sistemas Windows vivos.
*   [ ] **Enumeración de puertos:** Identificación de servicios abiertos (SMB, RDP, RPC, WinRM).
*   [ ] **Enumeración de SMB (445):** Identificar versiones del protocolo, firmas SMB requeridas y recursos compartidos públicos.
*   [ ] **Enumeración de usuarios:** Extracción de nombres de usuario mediante consultas nulas de IPC\$ o RPC.
*   [ ] **Enumeración de Active Directory:** Localización de Controladores de Dominio (DC) y servicios LDAP (389/636).
*   [ ] **Búsqueda de Spooler de impresión:** Verificar si el servicio Print Spooler está activo para posibles vectores de ataque (PrintNightmare).

## 2. Acceso Inicial
*   [ ] **Ataques de fuerza bruta / Password Spraying:** Pruebas contra servicios expuestos (RDP, WinRM, SMB) usando diccionarios corporativos.
*   [ ] **Explotación de vulnerabilidades públicas:** Verificar fallos sin parchear (e.g., EternalBlue, BlueKeep) en sistemas antiguos.
*   [ ] **Phishing / Ingeniería Social:** Ejecución de payloads ejecutables, macros de Office o archivos LNK maliciosos.
*   [ ] **Ataques de Coerción de Autenticación:** Forzar al sistema a autenticarse contra un servidor controlado (e.g., PetitPotam, PrinterBug).

## 3. Post-Explotación: Situational Awareness (Reconocimiento Local)
*   [ ] **Información del sistema:** Identificar versión de OS, arquitectura, parches instalados (`systeminfo`, `wmic`).
*   [ ] **Enumeración de privilegios actuales:** Revisar el token de usuario actual y privilegios asignados (`whoami /priv`).
*   [ ] **Conexiones de red:** Listar conexiones activas, tablas de enrutamiento y puertos locales abiertos (`netstat -ano`).
*   [ ] **Procesos y software:** Listar procesos en ejecución y software de seguridad / antivirus activo (`tasklist`, `Get-Process`).
*   [ ] **Defensas del sistema:** Verificar estado de Windows Defender, Firewall de Windows y soluciones EDR.

## 4. Escalada de Privilegios Locales
*   [ ] **Ficheros de configuración desprotegidos:** Buscar contraseñas en archivos Unattend.xml, Web.config o registros de Sysprep.
*   [ ] **Servicios mal configurados:** Validar rutas de servicio sin entrecomillar (Unquoted Service Paths) y permisos de escritura en binarios de servicio.
*   [ ] **Tareas programadas:** Buscar tareas que ejecuten binarios modificables por usuarios legítimos.
*   [ ] **Abuso de privilegios de Token:** Explotar privilegios peligrosos si están habilitados (e.g., SeImpersonatePrivilege, SeDebugPrivilege).
*   [ ] **Kernel Exploits:** Evaluar exploits locales basados en actualizaciones de seguridad faltantes.

## 5. Extracción de Credenciales (Credential Dumping)
*   [ ] **Volcado de LSASS:** Extraer credenciales en memoria utilizando herramientas o utilidades nativas (`procdump`, `comsvcs.dll`).
*   [ ] **Acceso a SAM y SYSTEM:** Extraer los hashes de contraseñas locales desde el registro de Windows.
*   [ ] **Búsqueda en Administrador de Credenciales:** Extraer contraseñas guardadas en el Windows Credential Manager.
*   [ ] **Extracción de secretos LSA:** Buscar contraseñas de cuentas de servicio del sistema.
*   [ ] **Archivos de configuración de navegadores:** Recuperar credenciales almacenadas en Chrome, Edge o Firefox locales.

## 6. Movimiento Lateral y Pivoting
*   [ ] **Ataques de Pass-the-Hash (PtH):** Utilizar hashes NTLM extraídos para autenticarse en otros equipos vía SMB o WMI.
*   [ ] **Ataques de Pass-the-Ticket (PtT):** Utilizar tickets Kerberos (TGT/TGS) para acceder a recursos de la red.
*   [ ] **Sesiones RDP:** Secuestrar sesiones RDP activas o desconectadas (RDP Session Hijacking via tscon).
*   [ ] **Ejecución remota de comandos:** Utilizar herramientas legítimas de administración para ejecutar código a distancia (PsExec, WinRM, WMI).
*   [ ] **Pivoting de red:** Configurar proxies SOCKS o túneles SSH/Chisel para acceder a segmentos de red internos desde el equipo comprometido.

## 7. Persistencia
*   [ ] **Claves de registro Run/RunOnce:** Configurar la ejecución de malware al iniciar sesión el usuario.
*   [ ] **Servicios persistentes:** Crear o modificar un servicio del sistema para que apunte a un backdoor.
*   [ ] **Tareas programadas maliciosas:** Registrar tareas que se ejecuten periódicamente o ante eventos específicos del sistema.
*   [ ] **Instalación de WMI Event Subscriptions:** Utilizar el repositorio WMI para ejecutar código de forma persistente y sigilosa.
*   [ ] **Modificación de accesos directos (LNK):** Alterar las propiedades de iconos comunes para ejecutar scripts adicionales.

## 8. Limpieza de Huellas (Clearing Tracks)
*   [ ] **Borrado de registros de eventos:** Limpiar selectivamente eventos de Seguridad, Aplicación y Sistema (`wevtutil`).
*   [ ] **Eliminación de artefactos:** Borrar herramientas, scripts, archivos temporales y web shells subidos.
*   [ ] **Restauración de configuraciones:** Revertir cambios en el registro, servicios modificados o reglas de firewall creadas.

