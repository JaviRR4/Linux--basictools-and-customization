#!/bin/bash

# Obtiene la IP local y la subred (ej: 192.168.1.0/24)
subred=$(ip -o -f inet addr show | awk '/scope global/ {print $4}' | head -n1)

if [ -z "$subred" ]; then
    echo "[!] No se pudo detectar la subred. Introduce manualmente:"
    read -p "Subred (ej: 192.168.1.0/24): " subred
fi

echo "[*] Escaneando hosts activos en $subred..."
nmap -sn "$subred" | grep "Nmap scan report" | awk '{print $5, $6}' || {
    echo "[!] nmap no encontrado. Usando ping..."
    for ip in $(seq 1 254); do
        ping -c 1 "${subred%.*}.$ip" | grep "bytes from" | awk '{print $4}' | cut -d ":" -f1 &
    done
    wait
}
