Integrantes:    Elvin Quero 14-10869
                Manuel Rodriguez 13-11223
            
# Como ejecutar anibot

Para ejecutar anibot simplemente ejecutar el comando make.
Se generara un archivo llamado "anibot", ejecutelo con la instruccion: "./anibot".
Al ejecutar anibot lo saludara, por favor respondala colocando su respuesta entre "" y utilizando
un "." al final de la respuesta. Por ejemplo: "bien y tu?".
Para limpiar el area de trabajo puede utilizar el comando make  clean.

# Detalles de la implementacion.

El matching de las oraciones que entiende el bot se hizo haciendole split
a la respuesta del usuario y viendo si concuerda con alguna de las frases que
entiende el bot. Esto se realiza en el predicado anibot, encargado de
escribir en pantalla un mensaje y leer una respuesta. Al finalizar la ejecucion
de algun predicado, se vuelve a llamar a anibot para continuar con el chat.
Por convencion se decidio trabajar con todos los strings en minisculas, para evitar
problemas con el match de respuestas y con la busquedas correspondientes.
En algunas respuestas por simplicidad se trabajo un matcher en plural, por ejemplo:
"x estrellas" aunque x puede ser 1, se le debe preguntar al bot sobre 1 estrellas.
A continuacion se listan las frases que el bot maneja y su respectivo
detalle de implementacion.

# Respuestas de saludos
"bien"
"bien y tu?"

# Respuestas para los animes de genero X
En este caso se buscan primero todos los animes del genero X.
Se crea una lista nueva con la popularidad o rating del anime y se ordena la lista. 

"cuales son los animes del genero X?". El bot responde la lista de animes del genero X, sin tomar
en cuenta rating y popularidad.
"cuales son los animes del genero X ordenados por porpularidad y rating?". Ordena la respuesta por 
popularidad y rating de mayor a menor.
"cuales son los animes del genero X ordenados por popularidad y rating de mayor a menor?".
"cuales son los animes del genero X ordenados por popularidad y rating de menor a mayor?".
"cuales son los animes del genero X ordenados por porpularidad?". Ordena la respuesta por 
popularidad de mayor a menor.
"cuales son los animes del genero X ordenados por popularidad de mayor a menor del genero X?".
"cuales son los animes del genero X ordenados por popularidad de menor a mayor del genero X?".
"cuales son los animes del genero X ordenados por rating?". Ordena la respuesta por 
rating de mayor a menor.
"cuales son los animes del genero X ordenados por rating de mayor a menor del genero X?".
"cuales son los animes del genero X ordenados por rating de menor a mayor del genero X?".

# Animes con el mejor rating o mas populares
Se busca el mayor rating o popularidad entre todos los animes y luego
se crea una lista con todos los animes cuyo rating o popularidad sea la mas alta.

"cuales son los mejores ratings?".
"cuales son los mas populares?".

# Listar los animes de genero X y N estrellas
En este caso se verifica que el N este entre 1 y 5, sino el bot respondera
que existe un error.
Si el N es correcto entonces se buscan todos los animes del genero X, luego
se filtran aquellos que no tengan el numero de listas N.

"cuales son los animes del genero X de N estrellas?".

# Animes buenos pero poco conocidos
En este caso se buscan los animes cuyo rating este entre 4 y 5
y su popularidad sea entre 3 y 5.

"cuales animes son buenos pero poco conocidos?".

# Hablar sobre un anime X.
Para hablar sobre un anime primero se busca si el anime existe, en caso que no
se cumpla esta condicion, se le pregunta al usuario el genero y rating con el
que desea agregar el anime sobre el cual pregunto.
En caso de que el anime exista se consulta sobre su generos, su rating y su
popularidad.
Por defecto se añaden los anime con popularidad 1 y además al hablar sobre un anime
se incrementa un predicado que contiene cuantas consultas se han hecho sobre el mismo.
Si la cantidad de consultas llega a 5 se elimina el predicado popularidad del anime
y se agrega uno nuevo con la popularidad actualizada. En caso de que la popularidad
haya alcanzado su maximo, se desprecia el contador de consultas.

"cuentame sobre el anime X".

#Agregar un anime en Oneline
PAra agregar un anime en una sola linea de respuesta. Se debe seguir este formato

"agregar anime X rating Y (de los generos/del genero) Z".
"agregar anime X rating Y (de los generos/del genero) Z" popularidad A.

Donde X es el nombre del anime, pueden ser varias palabras. Y es el rating.
Z son los generos o genero (Ejem: shounen magia fantasia) y A es la popularidad.
La popularidad es opcional. Despues de agregado, se muestra una consulta de ese anime.