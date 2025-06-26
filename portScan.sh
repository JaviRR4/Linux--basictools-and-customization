#!/bin/bash
function control_c(){
  echo -e "\n\n[!]Saliendo...\n"
  exit 1
}

#Control+C
trap ctrl_c INT

for port in $(seq 1 65535); do
  (echo '' > /dev/tcp/127.0.0.1/$port) 2>/dev/null && echo "[+] $port - OPEN"
done
