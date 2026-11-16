

    # FUNCIONES
#Llamar a las funciones con:
#   enviarMensaje "$botToken" "$chatOrigen" "$respuestaIa" "$idMensaje"
#


    # FUNCIONES DEL CASE/SWITCH PRINCIPAL
function caseUtils()  #ARGs: - $respuestaIa (no es necesario pasar nada, es una global, para recordarla la pongo)
{
    respuestaIa+="/yt URL -> Descarga vídeo de YouTube\n"
    respuestaIa+="/qr TEXT -> Genera codis QR.\n"
    respuestaIa+="\n"
    respuestaIa+="*No implementats:*\n"
    respuestaIa+="/wordToLibre -> Converteix de word a libreoffice.\n"
    respuestaIa+="/bar -> Genera codis de barres."
}
function caseQR()  #ARGs: - $respuestaIa (no es necesario pasar nada, es una global, para recordarla la pongo)
{
    #Informamos de que está trabajando el bot
    mostrarEscribiendoInfinito "$botToken" "$chatOrigen" &
    pidEscribiendo=$!

    #Generando código QR
    rutaQR="./temp/qr.png"
    qrencode -o $rutaQR "${texto#* }" -s 25

    #Enviando Código
    imagenAenviar="$rutaQR"
    textoInformativo="QR con info: "
    textoInformativo+=${texto#* }
    enviarImagen "$botToken" "$chatOrigen" "$imagenAenviar" "$textoInformativo" "$idMensaje"
    respuestaIa=""
    rm -f $rutaQR

    #Gestion de los procesos en segundo plano
    kill "$pidEscribiendo" > /dev/null
}

    # FUNCIONES AUXILIARES
function mostrarPesoEnHumano()  #ARGs: $peso
{
    #Adaptación de variables pasadas como argumento
    peso=$1

    #Obtenemos unidades y convertimos de Bytes a las unidades
#     if (( peso >= 1024**4 )); then # 1024*1024*1024*1024 = 1.048.576.000.000 = 1 TB
#         unidades="TB"
#         echo $unidades
#         (( peso = peso / 1024**4 ))
    if (( peso >= 1073741824 )); then # 1024*1024*1024 = 1.073.741.824 = 1 GB
        unidades="GB"
        peso=$(echo "scale=1;$peso/(1024^3)" | bc)  #scale son los decimales
    elif (( peso >= 1024**2 )); then # 1024*1024 = 1 048 576 = 1 MB
        unidades="MB"
        peso=$(echo "scale=0;$peso/(1024^2)" | bc)
    elif (( peso >= 1024 )); then
        unidades="KB"
        peso=$(echo "scale=0;$peso/1024" | bc)
    else
        unidades="By"
    fi

    echo "$peso $unidades"
}
function escaparMarkdown()  #ARGs: $texto
{
    #Adaptación de variables pasadas como argumento
    texto=$1

    #Sabiduría
#   '...' -> no interpretan su interior
#             Si pones \n no añadiria salto de linea
#   sed -> Uso: -e 's/*/\\*/g'
#               -> sustituye (s) todas las coincidencias (g)
#               -> de * por \* (se escapa la barra -> \\*)
#          Para interpretar: (echo sin -e)
#               -> \
#               necesita-> escapar con \\

    #Caracteres escapados y no escapados:
#  \ -> \\
#  / -> /   #sin escape
#    -e 's/`/\\\\`/g' #funciona, necesito usar ` normal
#  * -> \\* que muestra \*
#  ** -> \*\* -> *
#  _ -> \_
#  { -> \}
#  { -> \{
#  [ -> \[
#  ] -> \]
#  ) -> \)
#  ( -> \(
#  " -> \"
#    -e 's/#/hola/g' \ #Funciona, se muestra solo
#    -e 's/+/\\\\+/g' \ #Funciona, se muestra solo
#    -e 's/-/\\\\-/g' \ #Funciona, se muestra solo
#    -e 's/\./\\\\./g' \ #Funciona, se muestra solo
#    -e 's/\!/\\\\!/g' #Funciona, se muestra solo
#    -e 's/|/\\\\|/g' \ #Funciona, se muestra solo
#    -e 's/>/\\\\>/g' \ #Funciona, se muestra solo
#    -e 's/~/\\\\~/g' #Funciona, se muestra solo
#    -e 's/(/\\(/g' \ #Funciona, se muestra solo
#    -e 's/)/\\)/g' \ #Funciona, se muestra solo
    texto=$(echo -E $texto | sed -e 's/\\/\\\\/g' \
                            -e 's/\//\//g' \
                            -e 's/\*/\\\\*/g' \
                            -e 's/\\\\\*\\\\\*/*/g' \
                            -e 's/_/\\\\_/g' \
                            -e 's/{/\\{/g' \
                            -e 's/}/\\}/g' \
                            -e 's/\[/\\\\[/g' \
                            -e 's/\]/\\]/g' \
                            -e 's/"/\\"/g'
           )
    echo -e $texto
}
function mostrarEscribiendo()  #ARGs: $botToken $chatOrigen
{
    #Adaptación de variables pasadas como argumento
    botToken=$1
    chatOrigen=$2

    curl -s -X POST https://api.telegram.org/$botToken/sendChatAction -H "Content-Type: application/json" -d "{\"chat_id\":\"$chatOrigen\",\"action\":\"typing\" }" > /dev/null
}
function mostrarEscribiendoInfinito()  #ARGs: $botToken $chatOrigen
{
    #Adaptación de variables pasadas como argumento
    botToken=$1
    chatOrigen=$2

    for((;;)); do
        #El "escribiendo" dura unos 5 segundo
        mostrarEscribiendo "$botToken" "$chatOrigen"
        echo -n "#" >&2
        sleep 4
    done
}
function enListaBlanca()  #ARGs: $idAutor $chatOrigen
{
    autorizado=0
    while IFS= read -r linea; do
#         read -r idUsuario nombreUsuario _ <<< "$linea" #Lee raro, a veces lo mete todo en idUsuario
        idUsuario="${linea%% *}"              # Primera palabra (antes del primer espacio) (la ia sabe cosas)
        nombreUsuario="${linea#* }"           # Todo después del primer espacio (la ia sabe cosas)
        if [[ "$idAutor" == "$idUsuario" ]]; then   #Si es un usuario conocido
            autorizado=1
        fi
        if [[ "$chatOrigen" == "$idUsuario" ]]; then #Si es un grupo conocido
            autorizado=1
        fi
    done < ./interno/listaB

    if [[ "$autorizado" == "1" ]]; then #Si es un grupo conocido
        return 1
    else
        return 0
    fi
}


    # FUNCIONES PRINCIPALES
function enviarMensaje() #ARGs: $botToken $chatOrigen $respuestaIa $idMensaje
{
    #Adaptación de variables pasadas como argumento
    botToken=$1
    chatOrigen=$2
    respuestaIa=$3
    idMensaje=$4

    curl -s -X POST https://api.telegram.org/$botToken/sendMessage -H "Content-Type: application/json" -d "{\"chat_id\":\"$chatOrigen\",\"text\":\"$respuestaIa\",\"reply_to_message_id\": \"$idMensaje\", \"parse_mode\":\"Markdown\"}" > /dev/null #El ! hay que escaparlo
}
function enviarMensajeSinCitar()  #ARGs: $botToken $chatOrigen $respuestaIa
{
    #Adaptación de variables pasadas como argumento
    botToken=$1
    chatOrigen=$2
    respuestaIa=$3

    curl -s -X POST https://api.telegram.org/$botToken/sendMessage -H "Content-Type: application/json" -d "{\"chat_id\":\"$chatOrigen\",\"text\":\"$respuestaIa\", \"parse_mode\":\"Markdown\"}" > /dev/null #El ! hay que escaparlo
}
function descargarFichero()  #ARGs: $idFichero $botToken $idAutor
{
    #Adaptación de variables pasadas como argumento
    idFichero=$1
    botToken=$2
    idAutor=$3

        #Descargamos fichero
    #Obtiene nombre e ID
    idFichero=$(echo "$res" | jq -c '.result[0].message.document[0].file_id')
    nomFich=$(echo "$res" | jq -c '.result[0].message.document[0].file_name')
    #Obtenemos datos del fichero
    varJson=$(curl -s "https://api.telegram.org/$botToken/getFile?file_id=$idFichero")
    #Extraemos ruta del fichero
    rutaFich=$(echo "$varJson" | jq -r '.result.file_path')
    #Extraemos el nombre original
#     nomFich=$(echo "$varJson" | jq -r '.result.file_name')
    #Generamos nombre del fichero
    nomFich="./temp/$idAutor$(fecha)$nomFich"
    #Descargamos el fichero
    curl -s "https://api.telegram.org/file/$botToken/$rutaFich" -o "$nomFich"

    echo $nomFich
}
function descargarImagen()  #ARGs: $idImagen $botToken $idAutor
{
    #Adaptación de variables pasadas como argumento
    idImagen=$1
    botToken=$2
    idAutor=$3

        #Descargamos imagen
    #Obtenemos datos de la imagen
    varJson=$(curl -s "https://api.telegram.org/$botToken/getFile?file_id=$idImagen")
    #Extraemos ruta de la imagen
    rutaImg=$(echo "$varJson" | jq -r '.result.file_path')
    #Generamos nombre de la imagen
    nomImg="./img/$idAutor$(fecha).png"
    #Descargamos la image
    curl -s "https://api.telegram.org/file/$botToken/$rutaImg" -o "$nomImg"

    echo $nomImg
}
function llamadaModelo()  #ARGs: $colorOllama $modelo $contexto $texto $botToken $chatOrigen $idAutor
{
    #Adaptación de variables pasadas como argumento
    colorOllama=$1
    modelo=$2
    contexto=$3
    texto=$4
    botToken=$5
    chatOrigen=$6
    idAutor=$7

    #pasa a ollama
    fecha $colorOllama >&2
    echo "Llamando al modelo..." >&2

    echo "{ \"model\": \"$modelo\", \"messages\": [$contexto{\"role\":\"user\",\"content\":\"$texto\"}], \"stream\": false}" > "./temp/consulta$idAutor.temp"

    #Modelo con contexto en segundo plano
    exec 3< <(curl -s -X POST http://localhost:11434/api/chat -H "Content-Type: application/json" -d @"./temp/consulta$idAutor.temp" )
    pidIA=$!

    #Modelo con contexto en segundo plano ( contexto sin imagenes )
#     exec 3< <(curl -s http://localhost:11434/api/chat -d "{ \"model\": \"$modelo\", \"messages\": [$contexto{\"role\": \"user\",\"content\": \"$texto\"}], \"stream\": false}")
#     pidIA=$!

    #Informamos de que está pensando en segundo plano
    fecha $colorOllama >&2
    echo -n "Pensant..." >&2
    mostrarEscribiendoInfinito "$botToken" "$chatOrigen" &
    pidEscribiendo=$!

    #Gestion de los procesos en segundo plano
    wait $pidIA
    kill "$pidEscribiendo" > /dev/null
    echo >&2
    respuestaIa=$(cat <&3)                  #Leemos descriptor
    exec 3<&-                               #Eliminamos descriptor
    rm -f "./temp/consulta$idAutor.temp"    #Eliminamos el archivo temporal

    #Extraigo texto de respuesta
    respuestaIa=$(echo $respuestaIa | jq -r '.message.content')

    #Pasamos respuesta para poder ser enviada
    echo $respuestaIa >&1

    #Escapamos la respuesta de la ia antes de guardarla
    respuestaIa=$(escaparMarkdown "$respuestaIA")

    #Augmentar contexto
    nuevoFragmento='{"role": "user","content":"'$texto'"},{"role": "assistant","content":"'$respuestaIa'"},'
    echo -n $nuevoFragmento >> "contexto/ctxt$idAutor.txt"

    #Vaciado de variables
    contexto=""

        #Modelo sin contexto (1 solo mensaje y se olvida)
    #respuestaIa=$( curl -s http://localhost:11434/api/generate -d "{\"model\": \"$modelo\",\"prompt\": \"${texto}\", \"stream\": false}" )
    #respuestaIa=$(echo $respuestaIa | jq -r '.response')

    fecha $colorOllama >&2
    echo "Respuesta generada" >&2
}
function llamadaModeloImagen()  #ARGs: $colorOllama $modelo $contexto $comentarioFoto $botToken $chatOrigen $idAutor $rutaImagen
{
    #Adaptación de variables pasadas como argumento
    colorOllama=$1
    modelo=$2
    contexto=$3
    comentarioFoto=$4
    botToken=$5
    chatOrigen=$6
    idAutor=$7
    rutaImagen=$8

    #pasa a ollama
    fecha $colorOllama >&2
    echo "Llamando al modelo..." >&2

    #Procesar imagen
    img=$(base64 < $rutaImagen | tr -d '\n')

    #Creamos consulta con contexto e imagen adjunta
    echo "{ \"model\": \"$modelo\", \"messages\": [$contexto{\"role\":\"user\",\"content\":\"$comentarioFoto\",\"images\": [\"$img\"]}], \"stream\": false}" > "./temp/img$idAutor.temp"

    #Modelo con contexto en segundo plano
    exec 3< <(curl -s -X POST http://localhost:11434/api/chat -H "Content-Type: application/json" -d @"./temp/img$idAutor.temp" )
    pidIA=$!

    #Informamos de que está pensando en segundo plano
    fecha $colorOllama >&2
    echo -n "Pensant..." >&2
    mostrarEscribiendoInfinito "$botToken" "$chatOrigen" &
    pidEscribiendo=$!

    #Gestion de los procesos en segundo plano
    wait $pidIA
    kill "$pidEscribiendo" > /dev/null
    echo >&2
    respuestaIa=$(cat <&3)          #Leemos descriptor
    exec 3<&-                       #Eliminamos descriptor
    rm -f "./temp/img$idAutor.temp" #Eliminamos el archivo temporal


    #Extraigo texto de respuesta
    respuestaIa=$(echo $respuestaIa | jq -r '.message.content')

    #Pasamos respuesta para poder ser enviada
    echo $respuestaIa >&1

    #Augmentar contexto
    nuevoFragmento='{"role": "user","content": "'$comentarioFoto'","images": ["'$img'"]},{"role": "assistant","content":"'$respuestaIa'"},'
    echo -n $nuevoFragmento >> "contexto/ctxt$idAutor.txt"

    #Vaciado de variables
    contexto=""

        #Modelo sin contexto (1 solo mensaje y se olvida)
    #respuestaIa=$( curl -s http://localhost:11434/api/generate -d "{\"model\": \"$modelo\",\"prompt\": \"${comentarioFoto}\", \"stream\": false}" )
    #respuestaIa=$(echo $respuestaIa | jq -r '.response')

    fecha $colorOllama >&2
    echo "Respuesta generada" >&2
}
function enviarDocumento() #ARGs: $botToken $chatOrigen $ficheroAenviar $textoInformativo $idMensaje
{
    #Adaptación de variables pasadas como argumento
    botToken=$1
    chatOrigen=$2
    ficheroAenviar=$3
    textoInformativo=$4
    idMensaje=$5

    curl -s -X POST "https://api.telegram.org/$botToken/sendDocument" \
    -F chat_id="${chatOrigen}" \
    -F document=@"$ficheroAenviar" \
    -F caption="${textoInformativo}" \
    -F reply_to_message_id="${idMensaje}" \
    -F parse_mode="Markdown" > /dev/null
}
function enviarImagen() #ARGs: $botToken $chatOrigen $imagenAenviar $textoInformativo $idMensaje
{
    #Adaptación de variables pasadas como argumento
    botToken=$1
    chatOrigen=$2
    imagenAenviar=$3
    textoInformativo=$4
    idMensaje=$5

    curl -s -X POST "https://api.telegram.org/$botToken/sendPhoto" \
    -F chat_id="${chatOrigen}" \
    -F photo=@"$imagenAenviar" \
    -F caption="${textoInformativo}" \
    -F reply_to_message_id="${idMensaje}" \
    -F parse_mode="Markdown" > /dev/null
}
trap ctrl_c SIGINT SIGTERM
ctrl_c() { #Captura el Ctrl+c i informa
    respuestaIa=$(fecha)"La API *meritxell.api* $version 🔴 desactivada."
    enviarMensajeSinCitar "$botToken" "$idChatEstadisticas" "$respuestaIa"
    echo
    fecha $colorAviso
    echo -e "Eixint"
    echo
    exit
}



