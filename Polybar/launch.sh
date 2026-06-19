#!/usr/bin/env bash

# Terminar instancias previas
killall -q polybar

# Esperar a que se cierren completamente
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Detectar el monitor principal activado en el sistema
export MONITOR=$(xrandr --query | grep " connected" | cut -d" " -f1 | head -n1)

# Lanzar las tres barras pasando la variable del monitor
polybar log -c ~/.config/polybar/config.ini &
polybar med -c ~/.config/polybar/config.ini &
polybar top -c ~/.config/polybar/config.ini &

disown
