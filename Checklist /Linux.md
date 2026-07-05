# Checklist de Pentesting: Entornos Linux (Fase por Fase)

## 1. Reconocimiento y Enumeración de Servicios
*   [ ] **Identificación de Hosts:** Escaneo de red para descubrir sistemas Linux activos.
*   [ ] **Mapeo de Puertos y Versiones:** Detección de puertos abiertos y banners de servicios (SSH, HTTP, FTP, Rpcbind).
*   [ ] **Enumeración de SSH (22):** Identificación de algoritmos de cifrado débiles y versiones vulnerables de OpenSSH.
*   [ ] **Enumeración de Servicios Web:** Escaneo de directorios ocultos, servidores de aplicaciones (Apache, Nginx, Tomcat) y archivos expuestos.
*   [ ] **Enumeración de NFS/SAMBA (2049 / 445):** Identificación de carpetas compartidas con permisos laxos o montajes anónimos.
*   [ ] **Enumeración de SNMP (161):** Intrusión mediante cadenas de comunidad por defecto (public/private) para extraer datos del sistema.

## 2. Acceso Inicial
*   [ ] **Ataques de Fuerza Bruta / Credenciales por Defecto:** Pruebas contra SSH, bases de datos o paneles web utilizando diccionarios.
*   [ ] **Explotación de Vulnerabilidades Web:** Ejecución de fallos como Command Injection, LFI/RFI, SSRF o deserialización de datos.
*   [ ] **Explotación de Servicios Públicos:** Abuso de fallos conocidos sin parchear (CVEs) en software expuesto a la red.
*   [ ] **Abuso de Claves SSH Expuestas:** Búsqueda de claves privadas (`id_rsa`) desprotegidas en repositorios o servidores web.

## 3. Post-Explotación: Reconocimiento Local (Situational Awareness)
*   [ ] **Información del Sistema:** Identificación de la distribución, versión del Kernel y arquitectura (`uname -a`, `cat /etc/*release`).
*   [ ] **Entorno de Usuario:** Identificación del usuario actual, privilegios y membresía a grupos (`whoami`, `id`, `groups`).
*   [ ] **Variables de Entorno:** Revisión de rutas de ejecución y variables críticas (`env`, `echo $PATH`).
*   [ ] **Conexiones y Red Local:** Listado de conexiones activas, interfaces de red y tablas ARP (`netstat -tulnp`, `ss -altn`, `ip a`).
*   [ ] **Procesos en Ejecución:** Identificación de software ejecutándose como `root` o servicios locales internos (`ps aux`).
*   [ ] **Software Instalado y Parches:** Listado de paquetes del sistema y compiladores disponibles (`dpkg -l`, `rpm -qa`, `gcc --version`).

## 4. Escalada de Privilegios Locales
*   [ ] **Archivos con Bits SUID/SGID:** Búsqueda de binarios que se ejecutan con privilegios de propietario (`find / -perm -4000 -type f`).
*   [ ] **Malas Configuraciones de SUDO:** Revisión de comandos que el usuario actual puede ejecutar como root (`sudo -l`).
*   [ ] **Permisos de Escritura en Archivos Críticos:** Validación de permisos en archivos como `/etc/passwd`, `/etc/shadow` o `/etc/crontab`.
*   [ ] **Tareas Programadas (Cron Jobs):** Inspección de scripts ejecutados por `root` que sean modificables por usuarios comunes.
*   [ ] **Vulnerabilidades de Kernel:** Evaluación de exploits locales de kernel basados en la versión de Linux detectada (e.g., Dirty COW).
*   [ ] **Rutas de Bibliotecas (LD_PRELOAD / LD_LIBRARY_PATH):** Verificación de configuraciones de Sudo que permitan inyección de librerías.

## 5. Extracción de Credenciales (Credential Dumping)
*   [ ] **Lectura de Memoria / Archivos Core:** Extracción de credenciales en texto plano de procesos en memoria (gdb, sshd o apache).
*   [ ] **Archivos de Configuración de Aplicaciones:** Búsqueda de contraseñas de bases de datos o APIs en código fuente (`/var/www/html/`, `.env`).
*   [ ] **Historiales de Consola:** Inspección de archivos de comandos anteriores en busca de credenciales (`.bash_history`, `.zsh_history`).
*   [ ] **Extracción de Hashes Locales:** Lectura de `/etc/shadow` tras obtener privilegios elevados para posterior cracking offline.
*   [ ] **Claves de Memoria Caché (SSSD/Kerberos):** Extracción de credenciales integradas en entornos corporativos (Active Directory/LDAP).

## 6. Movimiento Lateral y Pivoting
*   [ ] **Reutilización de Credenciales / Claves SSH:** Uso de contraseñas o llaves encontradas para saltar a otros servidores de la red.
*   [ ] **Escaneo de Red Interna:** Uso de herramientas nativas (`bash`, `ping`, `nc`) para mapear la red interna desde el host comprometido.
*   [ ] **Configuración de Túneles y Proxies:** Establecimiento de herramientas de pivoting (Chisel, SSH Port Forwarding, Socat) para redirigir tráfico.
*   [ ] **Abuso de Confianza de Dominios/NFS:** Explotación de relaciones de confianza mutua entre servidores para acceder directamente.

## 7. Persistencia
*   [ ] **Modificación de SSH Autorizado:** Inserción de una clave pública propia en el archivo `~/.ssh/authorized_keys`.
*   [ ] **Puertas Traseras en Cron:** Creación de una tarea programada oculta que envíe una reverse shell periódicamente.
*   [ ] **Manipulación de Archivos de Perfil:** Inyección de comandos maliciosos en `.bashrc` o `/etc/profile` para ejecutarse al iniciar sesión.
*   [ ] **Creación de Servicios Systemd:** Configuración de un servicio malicioso que se inicie automáticamente con el sistema operativo.
*   [ ] **Abuso de Web Shells:** Escritura de scripts ocultos (PHP, Python, JSP) en directorios del servidor web accesible externamente.

## 8. Limpieza de Huellas (Clearing Tracks)
*   [ ] **Manipulación de Historial de Comandos:** Eliminación selectiva de comandos del archivo de historial actual (`history -d`, `unset HISTFILE`).
*   [ ] **Limpieza de Archivos de Log:** Modificación selectiva de registros del sistema (`/var/log/auth.log`, `/var/log/syslog`).
*   [ ] **Eliminación de Herramientas y Payloads:** Borrado seguro de scripts, binarios y archivos temporales creados en `/tmp` o `/dev/shm`.
