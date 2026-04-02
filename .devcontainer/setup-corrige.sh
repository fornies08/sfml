#!/bin/bash
set -ex

echo "Inicio del script: $(date)"
echo "🔴 Matando procesos VNC anteriores..."

# Matar bucle while que relanza VNC
pkill -f "while :; do.*tigervncserver :1" 2>/dev/null || true

# Matar procesos VNC directos
pkill -f Xtigervnc 2>/dev/null || true
pkill -f "/usr/bin/perl /usr/bin/tigervncserver :1" 2>/dev/null || true

# Limpiar locks (muy importante)
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 2>/dev/null || true

echo "🟢 Arrancando VNC con depth 24..."
echo "He llegado aquí: $(date)" >> /home/vscode/vnc-loop.log
nohup bash -c '
while :; do
  if ! ss -tuln | grep -q ":5901"; then
    echo "[ $(date) ] VNC NO está activo → arrancando..."
    tigervncserver :1 \
      -geometry 1440x768 \
      -depth 24 \
      -rfbport 5901 \
      -dpi 96 \
      -localhost \
      -SecurityTypes None
  fi
  sleep 5
done' >/home/vscode/.vnc-loop.log 2>&1 &
echo "He lanzado nohup: $(date)" >> /home/vscode/vnc-loop.log
echo "✅ VNC lanzado en background"