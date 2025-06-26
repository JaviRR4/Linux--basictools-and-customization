#!/bin/bash

# Este script te conectará con el nivel siguiente de OverTheWire y guardará la contraseña

# Colores
greenColour="\e[0;32m\033[1m"
endColour="\e[0m"

# Pedir número de nivel (usuario) y puerto
read -p "Introduce el nivel (usuario): " level
read -p "Introduce el puerto SSH: " port
read -sp "Introduce la contraseña: " pass
echo # salto de línea tras leer contraseña

echo -e "\n${greenColour}[+] Over The Wire: Bandit${endColour}"
echo -e "${greenColour}[+] Nivel: $level${endColour}"
echo -e "${greenColour}[+] Puerto: $port${endColour}"

# Añadir la contraseña al archivo (no sobrescribe)
echo "$pass" >> pass"$level".txt

# Conectarse vía ssh
ssh bandit"$level"@bandit.labs.overthewire.org -p "$port"
