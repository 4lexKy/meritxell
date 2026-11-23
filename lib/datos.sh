
# Copyright 2026 Alex (alex.correu@pm.me)
# SPDX-License-Identifier: GPL-2.0-only
# Este programa es software libre: puedes redistribuirlo y/o modificarlo bajo los términos
# de la Licencia Pública General GNU como publicada por la Free Software Foundation,
# ya sea la versión 2 de la Licencia, o (a tu elección) cualquier versión posterior.

    #   Contenido:  (inicialización de variables, carpeta i archivos)
    #-Datos
    #-Variables y textos
    #-Modelo Predeterminado
    #-Colores a usar
    #-Generación de lista blanca
    #-Generación de carpetas



    #Datos:
source "$(dirname "${BASH_SOURCE[0]}")./infoAcceso/infoAdmin"

    #Variables y textos:
ultimoMensaje=0
contexto=""
bitReset=0
timeoutDeEscuchaTelegram=300

    #Model predeterminat: (descomentar el predeterminat)
modelo=gemma3:270m              # 291 MB
# modelo=gemma3:1b                # 815 MB
# modelo=gemma3:4b                # 3.3 GB
# modelo=codegemma:2b             # 1.6 GB
# modelo=translategemma:4b        # 3.3 GB

    #COLORES
normal="\e[0m"
colorInicio="\e[0;37;45m"
colorOllama="\e[0;34;47m"
colorTelegram="\e[0;37;46m"
colorLinux="\e[0;30;42m"
colorUtiles="\e[0;37;44m"
colorAviso="\e[0;37;41m"

    #Generar listaB
# echo "
#     Personas:
# idTelegram NombreUsuario
# ...
# " > ./interno/listaB
source "$(dirname "${BASH_SOURCE[0]}")./infoAcceso/infoUsuarios"

    #Generar carpetas
mkdir -p ./contexto
mkdir -p ./img
mkdir -p ./temp
mkdir -p ./interno

#   DISTRIBUCION DE CARPETAS
# desarrollo
# contexto
# temp
#   interno
#       listaB
#       listaBnueva
#       listaN
#       historial
#   img
#       ...
#   downloads
#       ...
#   docs
#       ...
#   temp.temp
