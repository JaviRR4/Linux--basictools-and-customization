#!/bin/bash

# Función para mostrar menú
show_menu() {
    echo "Seleccione opción de escaneo:"
    echo "1) Escaneo rápido con nmap (ping scan)"
    echo "2) Escaneo completo con nmap (puertos comunes)"
    echo "3) Escaneo manual con ping"
    echo "4) Escanear rango personalizado"
    echo "5) Salir"
    read -p "Opción: " opcion
}

# Detectar interfaz y subred
interface=$(ip route | grep default | awk '{print $5}' | head -n1)
subred=$(ip -o -f inet addr show $interface | awk '/scope global/ {print $4}' | head -n1)

if [ -z "$subred" ]; then
    echo "[!] No se pudo detectar la subred. Introduce manualmente (ej: 192.168.1.0/24):"
    read -r subred
fi

echo "Usando interfaz: $interface"
echo "Subred detectada: $subred"

while true; do
    show_menu
    case $opcion in
        1)
            echo "[*] Escaneo rápido (ping) en $subred"
            nmap -sn "$subred" | grep "Nmap scan report" | awk '{print $5, $6}'
            ;;
        2)
            echo "[*] Escaneo completo (puertos comunes) en $subred"
            nmap -sS --top-ports 100 "$subred" | grep -E "Nmap scan report|open"
            ;;
        3)
            echo "[*] Escaneo manual con ping en $subred"
            base_ip="${subred%.*}"
            for ip in $(seq 1 254); do
                ping -c 1 -W 1 "${base_ip}.$ip" &> /dev/null && echo "Host activo: ${base_ip}.$ip" &
            done
            wait
            ;;
        4)
            read -p "Introduce rango inicial (ej: 192.168.1.10): " start_ip
            read -p "Introduce rango final (ej: 192.168.1.20): " end_ip

            # Función para convertir IP a número
            ip2num() {
                local IFS=.
                read -r i1 i2 i3 i4 <<< "$1"
                echo $((i1 * 256 ** 3 + i2 * 256 ** 2 + i3 * 256 + i4))
            }

            # Función para convertir número a IP
            num2ip() {
                local num=$1
                echo "$(( (num >> 24) & 255 )).$(( (num >> 16) & 255 )).$(( (num >> 8) & 255 )).$(( num & 255 ))"
            }

            start_num=$(ip2num "$start_ip")
            end_num=$(ip2num "$end_ip")

            if [ $start_num -gt $end_num ]; then
                echo "Error: Rango inicial mayor que rango final."
                continue
            fi

            for ((i=start_num; i<=end_num; i++)); do
                ip=$(num2ip $i)
                ping -c 1 -W 1 "$ip" &> /dev/null && echo "Host activo: $ip" &
            done
            wait
            ;;
        5)
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "Opción inválida."
            ;;
    esac
done
