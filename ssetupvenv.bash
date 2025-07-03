#!/bin/bash

# Default values
PROJECT_DIR=$(pwd)
REQUIREMENTS_FILE="requirements.txt"

usage() {
    echo "Uso: $0 [-d proyecto_dir] [-r requirements_file]"
    exit 1
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--dir) PROJECT_DIR="$2"; shift ;;
        -r|--requirements) REQUIREMENTS_FILE="$2"; shift ;;
        -h|--help) usage ;;
        *) echo "Opción desconocida: $1"; usage ;;
    esac
    shift
done

cd "$PROJECT_DIR" || { echo "No se puede acceder a $PROJECT_DIR"; exit 1; }

# Crear venv si no existe
if [ ! -d "venv" ]; then
    echo "[+] Creando entorno virtual en $PROJECT_DIR/venv ..."
    python3 -m venv venv || { echo "Error creando venv"; exit 1; }
else
    echo "[*] Entorno virtual ya existe."
fi

source venv/bin/activate

# Instalar dependencias si existe el archivo especificado
if [ -f "$REQUIREMENTS_FILE" ]; then
    echo "[+] Instalando dependencias desde $REQUIREMENTS_FILE..."
    pip install --upgrade pip
    pip install -r "$REQUIREMENTS_FILE" || { echo "Error instalando dependencias"; exit 1; }
else
    echo "[!] No se encontró $REQUIREMENTS_FILE, omitiendo instalación."
fi

echo "[✓] Entorno listo y dependencias instaladas."
echo "Para activar el entorno, usa:"
echo "    source $PROJECT_DIR/venv/bin/activate"
