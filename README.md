[Versión 0.7.2]: #
# meritxell - Bot de Telegram con utilidades y chat de ia

Meritxell es un bot de telegram que permite el uso de varias herramientas útiles como geneadores qr, word to pdf, writter to pdf o un descargador de vídeos. Además es un chat de ia con conexión con la api de Ollama

---
## Estado del proyecto
Actualmente se encuentra en desarrollo. Se puede usar pero algunas herramientas pueden presentar problemas:

Terminado:
- Generador de QRs

En desarrollo:
- Descargador de videos de YT
- Chat de i.a. con Ollama

Futuras herramientas:
- Descargador vídeos m4s

### Ficheros
- meritxell.api: fichero principal del programa
- LICENSE: contenido de la licencia
- README.md: información del proyecto
- .gitignore: define elementos a ignorar


---
## Instalación
No requiere instalación

### Lenguaje
- Bash

### Dependencias propias
Sí, tiene dependencias de:
- [**fecha**](https://github.com/4lexKy/aux_plus/blob/main/fecha) (herramienta propia)
- [**downy**] (herramienta propia)
- [**qr**] (herramienta propia)
- [**pdfs**] (herramienta propia)
### Dependencias externas
Sí, tiene dependencias de:
- [Ollama](https://ollama.com/download)
- curl (Debian/Ubuntu)
- git (Debian/Ubuntu)
- sed (Debian/Ubuntu)
- jq (Debian/Ubuntu)
- base64 (Debian/Ubuntu)

### Sistemas operativos compatibles
Probado en:
- Debian

---
## Recomendación
Para un uso mas ágil se puede crear una carpeta para script de forma que todos los que se añadan se puedan llamar desde la propia terminal como cualquier otro comando.

Esto se puede conseguir añadiendo a ~/.bashrc la línea:

```bash
    export PATH=$PATH:/ruta/a/carpeta/con/scripts
```

---
## Uso
Antes de su uso de debe
- Rellenar código con el número de cuenta del administrador y los usuarios
- Satisfacer dependencias
- Ejecutar en carpeta dedicada (se crearán archivos)
- Dar permisos de ejecución

Ahora se ejecuta de forma normal en una terminal
```bash
    ./meritxell.api
```

Para ejecutar en segundo plano se puede usar la herramienta [segundoPlano](https://github.com/4lexKy/bash_plus/blob/main/segundoPlano)
```bash
    segundoPlano meritxell.api
```

Una vez iniciado el bot, para configurar el menú de delegram se debe escribir "/comds" en el bot. Una vez esté el menú cargado se podrán consultar todos los comandos ahí.

---
## Características
### Chat i.a.
- El bot se comportará como un chat de i.a. habitual
- Con los comandos se podrá cambiar el modelo con el que interactuar
- Solo existe un contexto y se puede borrar cuando se desee

### Descargador
- Próximamente

### Generador de qrs
- Se llama por el chat a /qr para ver las instrucciones
- Se llama a "/qr textoParaConvertirEnQR" para generar el código

---
## Licencia
Este proyecto está licenciado bajo GPLv2 - consulta el archivo LICENSE para más detalles.

---
## Autor
>**Alex**
- Github: [https://github.com/4lexKy](https://github.com/4lexKy)
- Email: [alex.correu@pm.me](mailto:alex.correu@pm.me)

---
