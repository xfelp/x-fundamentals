#!/bin/bash

# --- Funciones ---
show_help(){
  cat <<'EOF'
Usos: checksys [-m] [-d] [-p] [-n] [-u] [-a] [-h]

Opciones:
  -m   Mostrar memoria (free -h)
  -d   Mostrar disco (df -h /)
  -p   Mostrar procesos (top en modo batch)
  -n   Mostrar puertos en escucha (ss -tuln)
  -u   Mostrar uptime
  -a   Mostrar TODO (equivale a -m -d -p -n -u)
  -h   Ayuda

Ejemplos:
  checksys -m
  checksys -d -u
EOF
}

mem(){
  echo "=== MEMORIA ==="
  free -h
  echo
}

disk(){
  echo "=== DISCO ==="
  df -h /
  echo
}

procs(){
  echo "=== PROCESOS ==="
  top -b -n 1 | head -15
  echo
}

net(){
  echo "=== PUERTOS EN ESCUCHA ==="
  ss -tuln
  echo
}

up(){
  echo "=== UPTIME ==="
  uptime
  echo
}

# --- Variables de control ---
DO_MEM=0; DO_DISK=0; DO_PROCS=0; DO_NET=0; DO_UP=0; DO_ALL=0

# Si no hay argumentos, mostrar todo
if [[ $# -eq 0 ]]; then
  DO_ALL=1
fi

# --- Procesar opciones ---
while getopts ":mdpnuah" opt; do
  case "$opt" in
    m) DO_MEM=1 ;;
    d) DO_DISK=1 ;;
    p) DO_PROCS=1 ;;
    n) DO_NET=1 ;;
    u) DO_UP=1 ;;
    a) DO_ALL=1 ;;
    h) show_help; exit 0 ;;
    \?|:) echo "Opción inválida: -$OPTARG"; show_help; exit 2 ;;
  esac
done

# --- Ejecución ---
if [[ $DO_ALL -eq 1 ]]; then
  echo "Mi script de Monitoreo"
  echo "---------------------"
  echo "Fecha de hoy: $(date)"
  echo "Nombre de Sistema: $(hostname)"
  echo "---------------------"
  echo
  mem; disk; procs; net; up
  exit 0
fi

[[ $DO_MEM   -eq 1 ]] && mem
[[ $DO_DISK  -eq 1 ]] && disk
[[ $DO_PROCS -eq 1 ]] && procs
[[ $DO_NET   -eq 1 ]] && net
[[ $DO_UP    -eq 1 ]] && up

echo "Fin ejecucion"
