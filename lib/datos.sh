
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
