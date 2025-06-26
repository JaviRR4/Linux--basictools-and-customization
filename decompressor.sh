## Decompressor recursive, simple tool for ctf's

#!/bin/bash

function control_c() {
    echo -e "\n\n[!] Saliendo...\n"
    exit 1
}

trap control_c INT

archivo_actual="data.gz"
echo "[*] Archivo inicial: $archivo_actual"

while true; do
    # Obtener nombre del archivo contenido
    archivo_extraido=$(7z l "$archivo_actual" 2>/dev/null | awk '/^----------/{flag=1; next} flag && NF {print $NF; exit}')

    if [[ -z "$archivo_extraido" ]]; then
        echo "[!] No se pudo obtener contenido de $archivo_actual o ya no hay más archivos."
        break
    fi

    echo -e "\n[+] Descomprimiendo: $archivo_actual → $archivo_extraido"
    7z x -y "$archivo_actual" &>/dev/null

    # Si el archivo extraído no existe, terminar
    if [[ ! -f "$archivo_extraido" ]]; then
        echo "[!] Archivo extraído no encontrado: $archivo_extraido"
        break
    fi

    archivo_actual="$archivo_extraido"
done

echo -e "\n✅ Proceso de descompresión terminado."
