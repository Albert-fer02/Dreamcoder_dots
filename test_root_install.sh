#!/bin/bash

# Script para probar la instalación de la configuración root
cd /home/dreamcoder08/Documentos/PROYECTOS/Dreamcoder_dots

# Simular entrada del usuario para instalar solo zsh_root
echo -e "1\n2\nzsh_root\n0\n0" | ./dreamcoder-setup.sh
