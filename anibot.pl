:- dynamic anime/1.
:- dynamic genero/1.
:- dynamic generoAnime/2.
:- dynamic rating/2.
:- dynamic popularidad/2.

% Para hacernos la vida mas facil trabajemos todos los strings en minuscula %

anime(X) :- member(X,['dragon ball', 'naruto', 'bleach', 'hunterxhunter', 'hamtaro', 'full metal alchemist']).
genero(X) :- member(X,['aventura', 'shoujo', 'shounen', 'kodomo', 'seinen', 'josei', 'ficcion',
                    'fantasia', 'mecha', 'sobrenatural', 'magia', 'gore']).
generoAnime('naruto',['shounen','aventura']).
generoAnime('dragon ball',['shounen']).
generoAnime('bleach',['shounen', 'sobrenatural']).
generoAnime('hunterxhunter',['seinen', 'aventura']).
generoAnime('hamtaro',['kodomo']).
generoAnime('full metal alchemist',['shounen', 'magia']).
rating('dragon ball',3).
rating('naruto',1).
rating('bleach',4).
rating('hunterxhunter',5).
rating('hamtaro',2).
rating('full metal alchemist',4).
popularidad('dragon ball',7).
popularidad('naruto',5).
popularidad('bleach',8).
popularidad('hunterxhunter',3).
popularidad('hamtaro',10).
popularidad('full metal alchemist',1).

% base de datos de las respuestas genericas %
respuestas_genericas('No te he entendido, preguntame algo que conozca').
respuestas_genericas('Por favor, preguntame algo que sepa responder').

% base de datos para las respuestas especificas %
specific_answer(["bien"]) :-
    anibot('Me alegra mucho. De que quieres hablar?').

specific_answer(["bien", "y", "tu?"]) :-
    anibot('Bien.\n Me alegra mucho. De que quieres hablar?').

% Asumimos que en este caso no importa el rating y la popularidad %
specific_answer(["cuales", "son", "los", "animes", "del", "genero", Genre]) :-
    remove_char(Genre, '?', Gendreaux),
    findall(Anime, anime(Anime), Animes),
    animeygenero(Gendreaux, Animes, AnimesGendre),
    print_by_genre(AnimesGendre).

% Animes por genero ordenados por rating %
specific_answer(["cuales", "son", "los", "animes", "ordenados", "por", "rating", "del",
                "genero", Genre]) :-
    remove_char(Genre, '?', Gendreaux),
    findall(Anime, anime(Anime), Animes),
    animeygenero(Gendreaux, Animes, AnimesGendre),
    make_rating_list(AnimesGendre, AnimesRating),
    sort(AnimesRating, AnimesSorted),
    % sort funciona de menor a mayor, hacemos reverse %
    reverse(AnimesSorted, AnimesReverse),
    print_by_rating(AnimesReverse).

specific_answer(["salir"]) :-
    halt.

specific_answer(_) :-
    anibot('No he entendido eso.\n Dime algo en que te pueda ayudar').

% Funcion para determinar los animes de un genero %

animeygenero(_, [], []).

animeygenero(Gendre, [Anime| Animes], [Anime| AnimesGendre]) :-
    generoAnime(Anime, Gendreaux),
    member(Gendre, Gendreaux), !,
    animeygenero(Gendre, Animes, AnimesGendre).

animeygenero(Gendre, [Anime| Animes], AnimesGendre) :- 
    animeygenero(Gendre, Animes, AnimesGendre).

% Funcion para imprimir los animes por genero %
print_by_genre([]) :-
    write('No conozco ningun anime de ese genero, podrias añadir uno si quieres :D\n'),
    anibot('').

print_by_genre(Animes) :-
    write('Son los siguientes:\n'),
    print_list(Animes),
    anibot('Excelente pregunta, que mas te gustaria saber?').

% Funcion para imprimir los animes por genero ordenados por rating %
print_by_rating([]) :-
    write('No conozco ningun anime de ese genero, podrias añadir uno si quieres :D\n'),
    anibot('').

print_by_rating(Animes) :-
    write('Son los siguientes:\n'),
    print_list_tuple(Animes),
    anibot('Excelente pregunta, que mas te gustaria saber?').

% Funcion para imprimir una lista %
print_list([]).
print_list([A|B]) :-
  format('~w\n',A),
  print_list(B).

% Funcion para imprimir una lista de tuplas. Tomando el segundo elemento %
print_list_tuple([]).
print_list_tuple([(A,B)|Z]) :-
  format('~w\n', B),
  print_list_tuple(Z).

% funcion para crear una lista de tipo (anime, rating) %
make_rating_list([], []).
make_rating_list([Anime | Animes], [(Rating, Anime)| AnimeandRating]) :-
    rating(Anime, Rating),
    make_rating_list(Animes, AnimeandRating).

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
    split_string(Answer_Lower, ' ', '', L),
    specific_answer(L).

main :-
    anibot('Hola como estas?').