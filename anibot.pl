:- dynamic anime/1.
:- dynamic genero/1.
:- dynamic generoAnime/2.
:- dynamic rating/2.
:- dynamic popularidad/2.
:- dynamic consultas/2.

%:- set_prolog_flag(double_quotes, chars).
%:- use_module(library(double_quotes)).
% Para hacernos la vida mas facil trabajemos todos los strings en minuscula %

anime(X) :- member(X,["dragon ball", "naruto", "bleach", "hunterxhunter", "hamtaro", "full metal alchemist",
                 "kakegurui", "death note", "evangelion", "code geass"]).
genero(X) :- member(X,["aventura", "shoujo", "shounen", "kodomo", "seinen", "josei", "ficcion",
                    "fantasia", "mecha", "sobrenatural", "magia", "gore"]).
generoAnime("naruto",["shounen","aventura"]).

generoAnime("dragon ball",["shounen"]).
generoAnime("bleach",["shounen", "sobrenatural"]).
generoAnime("hunterxhunter",["seinen", "aventura"]).
generoAnime("hamtaro",["kodomo"]).
generoAnime("full metal alchemist",["shounen", "magia"]).
generoAnime("kakegurui", ["shounen"]).
generoAnime("death note", ["shounen", "sobrenatural"]).
generoAnime("evangelion", ["ficcion"]).
generoAnime("code geass", ["shounen", "fantasia"]).
%Rating 
rating("dragon ball",3).
rating("naruto",1).
rating("bleach",4).
rating("hunterxhunter",5).
rating("hamtaro",2).
rating("full metal alchemist",4).
rating("kakegurui", 3).
rating("death note", 5).
rating("evangelion", 5).
rating("code geass", 3).
%Popularidad
popularidad("dragon ball",7).
popularidad("naruto",5).
popularidad("bleach",8).
popularidad("hunterxhunter",5).
popularidad("hamtaro",10).
popularidad("full metal alchemist", 3).
popularidad("shounen", 2).
popularidad("death note", 9).
popularidad("evangelion",10).
popularidad("code geass", 4).
% base de datos de las respuestas genericas %
respuestas_genericas("No te he entendido, preguntame algo que conozca").
respuestas_genericas("Por favor, preguntame algo que sepa responder").


    


% mayorPopularidad(Mayor) :- Mayor is the integer of the anime with the highest popularity.
mayorPopularidad(Mayor) :-
    findall(Num, popularidad(_,Num), L ), sort(L, L2), reverse(L2, [Mayor|_]).

% mayorRating(Mayor) :- Mayor is the integer of the anime with the highest rating.
mayorRating(Mayor) :-
    findall(Num, rating(_,Num), L ), sort(L, L2), reverse(L2, [Mayor|_]).

% base de datos para las respuestas especificas %

% getname(Lista, Name, Cola):- Lista es una lista de string, Name es el nombre del anime.
%           cola es todo el resto

getname([X|Z], Name, Cola) :-
    X \= "rating", 
    string_concat(X, " ", Xs),   
    getname(Z, Y, Cola),
    string_concat(Xs, Y, NameAux),
    normalize_space(string(Name), NameAux).
    

getname([X|Z], "", [X|Z]) :-
    X = "rating".


% getRating(List, Rating,Resto) :- Lista de strings, Rating es entero con el rating, Resto tiene el resto
%       de las cosas
getRating(["rating", Num| Resto], Rating, Resto) :-
    number_string(Rating, Num), validate_rating(Rating).

% getGeneros(Lista, Lista generos, Resto) :- Lista de strings, Lista de generos que se obtiene, Resto
%          de string
getGeneros(["de", "los", "generos"|Xs],ListaGeneros, Resto ) :-
    getGeneros(Xs, ListaGeneros, Resto).

getGeneros(["del", "genero",X|Xs],ListaGeneros, Resto ) :-
    X \= "popularidad", getGeneros(Xs, Lista, Resto ), genero(X),
    append( [X],Lista, ListaGeneros).

getGeneros(["del", "genero",X|Xs],ListaGeneros, Resto ) :-
    X \= "popularidad", getGeneros(Xs, Lista, Resto ), assert(genero(X)),
    append( [X],Lista, ListaGeneros).

getGeneros([X|Xs],ListaGeneros, Resto ) :-
    X \= "popularidad", getGeneros(Xs, Lista, Resto ), genero(X),
    append( [X],Lista, ListaGeneros).

getGeneros([X], X, []) :- genero(X).

getGeneros([X], X, []) :- assert(genero(X)).

getGeneros([X|Y], [], [X|Y]) :- X = "popularidad".

% addAnime(Nombre,Rating, Lista de Generos, Popularidad):- Agrega un anime con esas cosas
addAnime(Name, Rating, Generos, []) :-
    asserta(anime(Name)), asserta(generoAnime(Name,Generos)),
    asserta(rating(Name, Rating)),
    assert(popularidad(Name,1)),
    split_string(Name, " ", "", Anime),
    append(["cuentame", "sobre", "el", "anime"], Anime, Consulta),
    specific_answer(Consulta).
     
addAnime(Name, Rating,Generos, [X,Y|_]) :-
    asserta(anime(Name)), asserta(generoAnime(Name,Generos)),
    asserta(rating(Name, Rating)),
    number_string(Num, Y), validate_popularity(Num), asserta(popularidad(Name, Num)),
    split_string(Name, " ", "", Anime),
    append(["cuentame", "sobre", "el", "anime"], Anime, Consulta),
    specific_answer(Consulta).
    %write(Consulta).


%specific_answer(Lista de strings) :- accion correspondiente a la lista de strings
specific_answer(["agregar", "el", "anime"|Cola]) :-
    getname(Cola, Name, ColaAux), getRating(ColaAux,Rating, GenerosYPopularidad),
    getGeneros(GenerosYPopularidad, Generos, Popularidad), 
    addAnime(Name, Rating, Generos, Popularidad).

specific_answer(["agrega", "el", "anime"|Cola]) :-
    getname(Cola, Name, ColaAux), getRating(ColaAux,Rating, GenerosYPopularidad),
    getGeneros(GenerosYPopularidad, Generos, Popularidad), 
    addAnime(Name, Rating, Generos, Popularidad).

specific_answer(["agregar", "el", "anime"|_]) :-
    write("Oops, el rating debe ser entre 1 y 5\n y la popularidad entre 1 y 10.\n"),
    anibot("Intenta de nuevo o pide algo nuevo\n").

specific_answer(["agrega", "el", "anime"|_]) :-
    write("Oops, el rating debe ser entre 1 y 5\n y la popularidad entre 1 y 10.\n"),
    anibot("Intenta de nuevo o pide algo nuevo\n").


specific_answer(["bien"]) :-
    anibot("Me alegra mucho. De que quieres hablar?").

specific_answer(["bien", "y", "tu?"]) :-
    anibot("Bien.\n Me alegra mucho. De que quieres hablar?").

% Asumimos que en este caso no importa el rating y la popularidad %
specific_answer(["cuales", "son", "los", "animes", "del", "genero", Genre]) :-
    remove_char(Genre, '?', Gendreaux),
    atom_string(Gendreaux, Genreaux1),
    findall(Anime, anime(Anime), Animes),
    animeygenero(Genreaux1, Animes, AnimesGendre),
    print_by_genre(AnimesGendre).

% Animes ordenados por rating y popularidad %
specific_answer(["cuales", "son", "los", "animes", "del", "genero", Genre, "ordenados", "por", 
                "popularidad", "y", "rating?"]) :-
    anime_by_genre_rating_popularity(Genre, true).

specific_answer(["cuales", "son", "los", "animes", "del", "genero", Genre, "ordenados", "por", 
                "popularidad", "y", "rating", "de", "mayor", "a", "menor?"]) :-      
    anime_by_genre_rating_popularity(Genre, true).

specific_answer(["cuales", "son", "los", "animes", "del", "genero", Genre, "ordenados", "por", 
                "popularidad", "y", "rating", "de", "menor", "a", "mayor?"]) :- 
    anime_by_genre_rating_popularity(Genre, false).


% Animes por genero ordenados por rating %
specific_answer(["cuales", "son", "los", "animes", "ordenados", "por", "rating", "del",
                "genero", Genre]) :-
    anime_by_genre_rating(Genre, true).

specific_answer(["cuales", "son", "los", "animes", "ordenados", "por", "rating", 
                "de", "mayor", "a", "menor", "del", "genero", Genre]) :-
    anime_by_genre_rating(Genre, true).

specific_answer(["cuales", "son", "los", "animes", "ordenados", "por", "rating", 
                "de", "menor", "a", "mayor", "del", "genero", Genre]) :-
    anime_by_genre_rating(Genre, false).

specific_answer(["cuales", "son", "los", "animes", "ordenados", "por", "rating", "del",
                "genero", Genre]) :-
    anime_by_genre_rating(Genre, true).

% Animes por genero ordenados por popularidad %
specific_answer(["cuales", "son", "los", "animes", "ordenados", "por", "popularidad", "del",
                "genero", Genre]) :-
    anime_by_genre_popularity(Genre, true).

specific_answer(["cuales", "son", "los", "animes", "ordenados", "por", "popularidad", "de",
                "mayor", "a", "menor", "del", "genero", Genre]) :-       
    anime_by_genre_popularity(Genre, true).

specific_answer(["cuales", "son", "los", "animes", "ordenados", "por", "popularidad",
                "de", "menor", "a", "mayor", "del", "genero", Genre]) :-
    anime_by_genre_popularity(Genre, false).

% animes por genero ordenados por rating %

specific_answer(["cuales", "son", "los", "mejores" ,"ratings?"]) :-
    mayorRating(Mayor),
    findall((Mayor,Anime), rating(Anime, Mayor), L ),
    write("\n"),
    print_by_rating(L).

specific_answer(["cuales", "son", "los", "mas" ,"populares?"]) :-
    mayorPopularidad(Mayor),
    findall((Mayor,Anime), popularidad(Anime, Mayor), L ),
    write("\n"),
    print_by_popularity(L).

% Animes de X estrellas
specific_answer(["cuales", "son", "los", "animes" , "del", "genero", Genre, "de", X, "estrellas?"]) :-
    atom_number(X, Rating),
    Rating =< 5,
    Rating > 0,
    findall(Anime, anime(Anime), Animes),
    animeygenero(Genre, Animes, AnimesGendre),
    animexestrellas(Rating, AnimesGendre, AnimesEstrellas),
    length(AnimesEstrellas, Length),
    Length >= 1,
    write("Son los siguientes: "), nl,
    print_list(AnimesEstrellas),
    anibot("").

specific_answer(["cuales", "son", "los", "animes" , "del", "genero", _, "de", X, "estrellas?"]) :-
    atom_number(X, Rating),
    Rating > 5,
    anibot("Querido, el rating es hasta 5 estrellas").

specific_answer(["cuales", "son", "los", "animes" , "del", "genero", _, "de", X, "estrellas?"]) :-
    atom_number(X, Rating),
    Rating < 0,
    anibot("No creas que soy tan tonta, el rating no puede ser negativo").

specific_answer(["cuales", "son", "los", "animes" , "del", "genero", _, "de", X, "estrellas?"]) :-
    string_concat("No hay animes de ese genero con ", X, Mensaje),
    string_concat(Mensaje, " estrellas", Mensajeaux),
    anibot(Mensajeaux).

specific_answer(["cuales", "animes" , "son", "buenos", "pero", "poco", "conocidos?"]) :-
    findall([Anime, Popularidad], popularidad(Anime, Popularidad), Animepopularidad),
    list_by_knowing(Animepopularidad, AnimeRating),
    print_by_knowing(AnimeRating),
    anibot("").

specific_answer(["cuentame", "sobre", "el", "anime" | Anime]) :-
    atomic_list_concat(Anime, ' ', Atom), 
    atom_string(Atom, Animestring),
    anime(Animestring),
    write("Genial! Se cual es ese anime, su rating es "),
    rating(Animestring, Rating),
    write(Rating), nl,
    write("Su popularidad es "),
    popularidad(Animestring, Popularidad),
    popularity_message(Popularidad, Msg),
    write(Msg), nl,
    write("y sus generos son "),
    generoAnime(Animestring, Generos),
    atomic_list_concat(Generos, ',', Atomgenero),
    atom_string(Atomgenero, Generostring),
    write(Generostring),
    add_like(Animestring),
    anibot('').

specific_answer(["cuentame", "sobre", "el", "anime" | Anime]) :-
    atomic_list_concat(Anime, ' ', Atom), 
    atom_string(Atom, Animestring),
    write("Disculpa, el anime "),
    write(Animestring),
    write(" No esta en mi base de datos, pero podrias agregarlo si quieres"), nl,
    write("Cuales son sus generos?"), nl,
    read(Genres),
    string_lower(Genres, Genres_Lower),
    split_string(Genres_Lower, " ", "", Genreslist),
    write("Cual es su rating?"), nl,
    read(Ratingint),
    write("Cual es su popularidad?\n"),
    read(Popularity),
    validate_rating(Ratingint),validate_popularity(Popularity),
    asserta(anime(Animestring)),
    asserta(generoAnime(Animestring, Genreslist)),
    asserta(rating(Animestring, Ratingint)),
    asserta(popularidad(Animestring, Popularity)),
    string_concat("Ahora se todo sobre el anime ", Animestring, Msgaux),
    add_like(Animestring),
    anibot(Msgaux).

specific_answer(["cuentame", "sobre", "el", "anime" | _]) :-
    anibot("Amigo el rating debe ser entre 1 y 5. Intenta agregar el anime de nuevo\n").

specific_answer(["salir"]) :-
    halt.

specific_answer(_) :-
    anibot("No he entendido eso.\n Dime algo en que te pueda ayudar").


%   Funcion para determinar el orden a mostrar en los animes por genero y popularidad %

anime_by_genre_popularity(Genre, IsReverse) :-
    remove_char(Genre, '?', Genreaux), 
    atom_string(Genreaux, Genreaux1),
    findall(Anime, anime(Anime), Animes),
    animeygenero(Genreaux1, Animes, AnimesGendre),
    make_popularidad_list(AnimesGendre, AnimesRating),
    sort(AnimesRating, AnimesSorted),
    IsReverse,
    % sort funciona de menor a mayor, hacemos reverse %
    reverse(AnimesSorted, AnimesReverse),
    print_by_rating(AnimesReverse).

anime_by_genre_popularity(Genre, IsReverse) :-
    remove_char(Genre, '?', Genreaux), 
    atom_string(Genreaux, Genreaux1),
    findall(Anime, anime(Anime), Animes),
    animeygenero(Genreaux1, Animes, AnimesGendre),
    make_popularidad_list(AnimesGendre, AnimesRating),
    sort(AnimesRating, AnimesSorted),
    \+ IsReverse,
    print_by_rating(AnimesSorted).

% Funcion para determinar el orden a mostrar de los animes por genero, popularidad y rating %
anime_by_genre_rating_popularity(Genre, IsReverse) :-
    findall(Anime, anime(Anime), Animes),
    animeygenero(Genre, Animes, AnimesGendre),
    make_rating_and_popularity_list(AnimesGendre, AnimeGP),
    sort(AnimeGP, AnimesSorted),
    IsReverse,
    reverse(AnimesSorted, AnimesReverse),
    print_by_rating(AnimesReverse).

anime_by_genre_rating_popularity(Genre, IsReverse) :-
    findall(Anime, anime(Anime), Animes),
    animeygenero(Genre, Animes, AnimesGendre),
    make_rating_and_popularity_list(AnimesGendre, AnimeGP),
    sort(AnimeGP, AnimesSorted),
    \+ IsReverse,
    print_by_rating(AnimesSorted).

% Funcion para determinar el orden a mostrar de los animes por genero y rating %
anime_by_genre_rating(Genre, IsReverse) :-
    remove_char(Genre, '?', Gendreaux),
    atom_string(Gendreaux, Genreaux1),
    findall(Anime, anime(Anime), Animes),
    animeygenero(Genreaux1, Animes, AnimesGendre),
    make_rating_list(AnimesGendre, AnimesRating),
    sort(AnimesRating, AnimesSorted),
    IsReverse,
    % sort funciona de menor a mayor, hacemos reverse %
    reverse(AnimesSorted, AnimesReverse),
    print_by_rating(AnimesReverse).

anime_by_genre_rating(Genre, IsReverse) :-
    remove_char(Genre, '?', Gendreaux),
    atom_string(Gendreaux, Genreaux1),
    findall(Anime, anime(Anime), Animes),
    animeygenero(Genreaux1, Animes, AnimesGendre),
    make_rating_list(AnimesGendre, AnimesRating),
    sort(AnimesRating, AnimesSorted),
    \+ IsReverse,
    print_by_rating(AnimesSorted).

% Funcion para determinar los animes de un genero %

animeygenero(_, [], []).

animeygenero(Gendre, [Anime| Animes], [Anime| AnimesGendre]) :-
    generoAnime(Anime, Gendreaux),
    member(Gendre, Gendreaux), !,
    animeygenero(Gendre, Animes, AnimesGendre).

animeygenero(Gendre, [ _ | Animes], AnimesGendre) :- 
    animeygenero(Gendre, Animes, AnimesGendre).

% Funcion para imprimir los animes por genero %
print_by_genre([]) :-
    write("No conozco ningun anime de ese genero, podrias añadir uno si quieres :D\n"),
    anibot("").

print_by_genre(Animes) :-
    write("Son los siguientes:\n"),
    print_list(Animes),
    anibot("Excelente pregunta, que mas te gustaria saber?").

% Funcion para imprimir los animes por genero ordenados por rating %
print_by_rating([]) :-
    write("No conozco ningun anime de ese genero, podrias añadir uno si quieres :D\n"),
    anibot("").

print_by_popularity(Animes) :-
    write("Son los siguientes:\n"),
    write("Anime\t\t\t Popularity\n"),
    print_list_tuple(Animes),
    anibot("Excelente pregunta, que mas te gustaria saber?").

print_by_rating(Animes) :-
    write("Son los siguientes:\n"),
    write("Anime\t\t\t Rating\n"),
    print_list_tuple(Animes),
    anibot("Excelente pregunta, que mas te gustaria saber?").

% Funcion para imprimir una lista %
print_list([]).
print_list([A|B]) :-
  format("~w\n",A),
  print_list(B).

% Funcion para imprimir una lista de tuplas. Tomando el segundo elemento %
print_list_tuple([]).
print_list_tuple([(A,B)|Z]) :-
    format("~w\t\t\t ~w\n", [B,A]),
    print_list_tuple(Z).

% funcion para crear una lista de tipo (anime, rating) %
make_rating_list([], []).
make_rating_list([Anime | Animes], [(Rating, Anime)| AnimeandRating]) :-
    rating(Anime, Rating),
    make_rating_list(Animes, AnimeandRating).


% funcion para crear una lista de tipo (anime, rating) %
make_popularidad_list([], []).
make_popularidad_list([Anime | Animes], [(Popularidad, Anime)| AnimeandRating]) :-
    popularidad(Anime, Popularidad),
    make_popularidad_list(Animes, AnimeandRating).

% funcion para crear una lista de tipo (rating+popularidad, anime) %
make_rating_and_popularity_list([], []).
make_rating_and_popularity_list([Anime | Animes], [(RandP, Anime) | AnimeRP ]) :-
    rating(Anime, Rating),
    popularidad(Anime, Popularidad),
    RandP is Rating + Popularidad,
    make_rating_and_popularity_list(Animes, AnimeRP).

% Funcion que dado una lista de anime y una cantidad de estrellas X %
% devuelve aquellos animes cuyo rating sea X %

animexestrellas(_, [], []).

animexestrellas(X, [Anime | Animes], [Anime | AnimesEstrellas]) :-
    rating(Anime, Rating),
    X == Rating,
    animexestrellas(X, Animes, AnimesEstrellas).

animexestrellas(X, [ _ | Animes], AnimesEstrellas) :-
    animexestrellas(X, Animes, AnimesEstrellas).

% Funcion que imprime los animes con popularidad baja y rating alto %

print_by_knowing([]) :-
    write("Lo siento pero no hay anime buenos poco conocidos, deberias agregar alguno").

print_by_knowing(AnimeRating) :- 
    write("Te dire cuales son, espero que veas alguno"), nl,
    print_list(AnimeRating).

list_by_knowing([], []).
list_by_knowing([[Anime, Popularidad] | Animepopularidad], [Anime | AnimeRating]) :-
    Popularidad >= 3,
    Popularidad =< 5,
    rating(Anime, Rating),
    Rating >= 4,
    Rating =< 5,
    write(Anime), nl,
    list_by_knowing(Animepopularidad, AnimeRating).

list_by_knowing([ _ | Animepopularidad], AnimeRating) :- 
    list_by_knowing(Animepopularidad, AnimeRating).

% Funcion para saber que mensaje decir dada una popularidad %
popularity_message(Popularidad, "muy poco conocido") :-
    Popularidad >= 1,
    Popularidad =< 2.

popularity_message(Popularidad, "poco conocido") :-
    Popularidad >= 3,
    Popularidad =< 5.

popularity_message(Popularidad, "conocido") :-
    Popularidad >= 6,
    Popularidad =< 7.

popularity_message(Popularidad, "muy conocido") :-
    Popularidad >= 8,
    Popularidad =< 9.

popularity_message(_, "bastante conocido").

% Funcion que lleva la cuenta de cuantas veces se pregunta por un anime %

add_like(Anime) :-
    \+ consultas(Anime, Consulta),
    asserta(consultas(Anime,1)).

add_like(Anime) :-
    consultas(Anime, Consulta),
    popularidad(Anime, Popularidad),
    Consulta == 4,
    Popularidad =< 9,
    retract(consultas(Anime, Consulta)),
    retract(popularidad(Anime, Popularidad)),
    NewPopularidad is Popularidad + 1,
    asserta(popularidad(Anime, NewPopularidad)).

add_like(Anime) :-
    consultas(Anime, Consulta),
    Consulta < 4,
    retract(consultas(Anime, Consulta)),
    NewConsulta is Consulta + 1,
    asserta(consultas(Anime, NewConsulta)).

add_like(_).

validate_rating(Ratingint) :-
    Ratingint >= 1,
    Ratingint =< 5.


validate_popularity(Popularity) :-
    Popularity >= 1,
    Popularity =< 10.

% Funcion para eliminar un caracter de un string %
remove_char(S,C,X) :- 
    atom_concat(L,R,S), 
    atom_concat(C,W,R), 
    atom_concat(L,W,X).

% Funcion para manejar los mensajes del bot %
anibot(Message) :-
    write(Message), nl,
    read(Answer),
    string_lower(Answer, Answer_Lower),
    split_string(Answer_Lower, " ", "", L),
    specific_answer(L).

main :-
    anibot("Hola como estas?").