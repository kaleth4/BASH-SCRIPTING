import argparse
import os
import http.server
import socketserver

def iniciar_servidor():
    # Configuración de los parámetros y la ayuda (-h)
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
    
    args = parser.parse_args()

    # Verificar que el directorio objetivo existe
    if not os.path.isdir(args.directorio):
        print(f"[-] Error: El directorio '{args.directorio}' no existe.")
        return

    # Cambiar al directorio especificado para servir los archivos desde allí
    os.chdir(args.directorio)
    
    Handler = http.server.SimpleHTTPRequestHandler
    
    # Configurar el servidor para permitir conexiones
    try:
        with socketserver.TCPServer(("", args.puerto), Handler) as httpd:
            print(f"[+] Servidor activo en todos los adaptadores (0.0.0.0) puerto: {args.puerto}")
            print(f"[+] Compartiendo archivos desde el directorio: {os.getcwd()}")
            print("[+] Presiona CTRL+C para detener el servidor.")
            httpd.serve_forever()
    except PermissionError:
        print(f"[-] Error: No tienes permisos para usar el puerto {args.puerto} (intenta con un puerto > 1024).")
    except KeyboardInterrupt:
        print("\n[-] Servidor detenido por el usuario.")

if __name__ == "__main__":
    iniciar_servidor()
