import argparse
import os
import http.server
import socketserver
import webbrowser
import threading
import time

def abrir_enlace(puerto):
    # Espera un segundo a que el servidor termine de levantarse por completo
    time.sleep(1)
    url = f"http://localhost:{puerto}"
    print(f"[+] Abriendo enlace de descarga automáticamente: {url}")
    webbrowser.open(url)

def iniciar_servidor():
    parser = argparse.ArgumentParser(
        description="Servidor HTTP local para la transferencia controlada de herramientas de pentesting."
    )
    parser.add_argument(
        "-p", "--puerto", 
        type=int, 
        default=8080, 
        help="Puerto en el que escuchará el servidor (por defecto: 8080)"
    )
    parser.add_argument(
        "-d", "--directorio", 
        type=str, 
        default=".", 
        help="Directorio raíz que contiene los archivos a compartir (por defecto: directorio actual)"
    )
    parser.add_argument(
        "-n", "--navegador", 
        action="store_true", 
        help="Abrir automáticamente el navegador web con el enlace del servidor"
    )
    
    args = parser.parse_args()

    if not os.path.isdir(args.directorio):
        print(f"[-] Error: El directorio '{args.directorio}' no existe.")
        return

    os.chdir(args.directorio)
    Handler = http.server.SimpleHTTPRequestHandler
    
    # Si el usuario activa la bandera -n, se inicia un hilo secundario para abrir el enlace
    if args.navegador:
        hilo_web = threading.Thread(target=abrir_enlace, args=(args.puerto,))
        hilo_web.daemon = True
        hilo_web.start()

    try:
        with socketserver.TCPServer(("", args.puerto), Handler) as httpd:
            print(f"[+] Servidor activo en todos los adaptadores (0.0.0.0) puerto: {args.puerto}")
            print(f"[+] Compartiendo archivos desde: {os.getcwd()}")
            print("[+] Presiona CTRL+C para detener el servidor.")
            httpd.serve_forever()
    except PermissionError:
        print(f"[-] Error: No tienes permisos para usar el puerto {args.puerto}.")
    except KeyboardInterrupt:
        print("\n[-] Servidor detenido por el usuario.")

if __name__ == "__main__":
    iniciar_servidor()
