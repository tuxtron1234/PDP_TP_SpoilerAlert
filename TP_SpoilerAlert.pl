:- encoding(utf8).

% Punto 1
mira(juan, himym).
mira(juan, futurama).
mira(juan, got).
mira(nico, starWars).
mira(nico, got).
mira(maiu, starWars).
mira(maiu, onePiece).
mira(maiu, got).
mira(gastón, hoc).

mira(pedro,got).

esPopular(got).
esPopular(hoc).
esPopular(starWars).

quiereVer(juan, hoc).
quiereVer(aye, got).
quiereVer(gastón, himym).

episodiosPorTemporada(got, 12, 3).
episodiosPorTemporada(got, 10, 2).
episodiosPorTemporada(himym, 23, 1).
episodiosPorTemporada(drHouse, 16, 8).

:- begin_tests(base_de_conocimientos).

test(nico_mira_got, nondet):-
  mira(Persona, Serie), Persona = nico, Serie = got.

:- end_tests(base_de_conocimientos).

/*
Por principio de Universo Cerrado se asume que todo lo que no esta en la base de conocimiento es falso.
Es decir  no es necesario mencionar que "algo"  no esta incluido o un predicado falso.
Casos(que no se modelan) :
  1. Nadie mira "Mad men".
  2. Alf no ve ninguna serie porque el doctorado le consume toda la vida.
  3. No recordamos cuántos episodios tiene la segunda temporada de “Mad men”.
*/

% Punto 2
pasó(futurama, 2, 3, muerte(seymourDiera)).
pasó(starWars, 10, 9, muerte(emperor)).
pasó(starWars, 1, 2, relación(parentesco, anakin, rey)).
pasó(starWars, 3, 2, relación(parentesco, vader, luke)).
pasó(himym, 1, 1, relación(amorosa, ted, robin)).
pasó(himym, 4, 3, relación(amorosa, swarley, robin)).
pasó(got, 4, 5, relación(amistad, tyrion, dragon)).

pasó(got, 3, 2, plotTwist([sueño, sinPiernas])).
pasó(got, 3, 12, plotTwist([fuego, boda])).
pasó(superCampeones, 9, 9, plotTwist([sueño, coma, sinPiernas])).
pasó(drHouse, 8, 7, plotTwist([coma, pastillas])).

leDijo(gastón, maiu, got, relación(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relación(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)).
leDijo(aye, juan, got, relación(amistad, tyrion, john)).
leDijo(aye, maiu, got, relación(amistad, tyrion, john)).
leDijo(aye, gaston, got, relación(amistad, tyrion, dragon)).

leDijo(nico, juan, futurama, muerte(seymourDiera)).
leDijo(pedro, aye, got, relación(amistad,tyrion,dragon)).
leDijo(pedro, nico, got, relación(parentesco,tyrion,dragon)).

% Punto 3
esSpoiler(Serie, Spoiler):- pasó(Serie, _, _, Spoiler).

:- begin_tests(punto3_EsSpoiler).

test(la_muerte_del_emperor_es_spoiler_para_StarWars, nondet):-
  esSpoiler(Serie, Spoiler), Serie == starWars, Spoiler == muerte(emperor).

test(la_muerte_de_pedro_no_es_spoiler_para_StarWars,fail):-
  esSpoiler(Serie,Spoiler) ,Serie == starWars ,Spoiler == muerte(pedro).

test(la_relación_de_parentesco_entre_anakin_y_el_rey_es_spoiler_para_StarWars, nondet):-
  esSpoiler(Serie, Spoiler), Serie == starWars, Spoiler == relación(parentesco, anakin, rey).

test(la_relación_de_parentesco_entre_anakin_y_lavezzi_no_es_spoiler_para_starWars,fail):-
    esSpoiler(Serie,Spoiler),Serie == starWars ,Spoiler == relación(parentesco,anakin,lavezzi).

:- end_tests(punto3_EsSpoiler).

% Punto 4
leInteresa(Espectador, Serie):- mira(Espectador, Serie).
leInteresa(Espectador, Serie):- quiereVer(Espectador, Serie).

leSpoileo(PersonaMala, Victima, Serie):-
  leInteresa(Victima, Serie),
  leDijo(PersonaMala, Victima, Serie, Spoiler),
  esSpoiler(Serie, Spoiler).

:- begin_tests(punto4_LeSpoileo).

test(gastón_le_dijo_a_maiu_un_spoiler_de_GOT, nondet):-
  leSpoileo(PersonaMala, Victima, Serie), PersonaMala == gastón, Victima == maiu, Serie == got.

test(nico_le_dijo_a_maiu_un_spoiler_de_StarWars, nondet):-
  leSpoileo(PersonaMala, Victima, Serie), PersonaMala == nico, Victima == maiu, Serie == starWars.

test(nico_no_le_dijo_a_maiu_un_spoiler_de_onePiece,fail) :-
     leSpoileo(PersonaMala,Victima,Serie),PersonaMala == nico ,Victima == maiu ,Serie == onePiece.

:- end_tests(punto4_LeSpoileo).

% Punto 5
persona(Persona):- leInteresa(Persona, _).

televidenteResponsable(Persona):-
  persona(Persona),
  not(leSpoileo(Persona, _, _)).

:- begin_tests(punto5_televidenteResponsable).

test(juan_aye_y_maiu_son_televidentes_responsables, set(Personas == [juan, aye, maiu])):-
  televidenteResponsable(Personas).

test(nico_y_gaston_no_son_televidentes_responsables, nondet):-
   not(televidenteResponsable(nico)),
   not(televidenteResponsable(gastón)).

:- end_tests(punto5_televidenteResponsable).

% Punto 6
serie(Serie):- leInteresa(_, Serie).

temporada(Serie, Temporada):- episodiosPorTemporada(Serie, _, Temporada).

sucesoFuerte(Suceso):-
  suceso(Suceso),
  esFuerte(Suceso).

suceso(Suceso):- pasó(_, _, _, Suceso).

esFuerte(muerte(_)).
esFuerte(relación(parentesco, _, _)).
esFuerte(relación(amorosa, _, _)).

vieneZafando(Persona, Serie):-
	leInteresa(Persona, Serie),
	not(leSpoileo(_, Persona, Serie)),
  estáZarpada(Serie).

estáZarpada(Serie):-
  temporada(Serie, Temporada),
  forall(temporada(Serie, Temporada), (pasó(Serie, Temporada, _, Suceso), esFuerte(Suceso))).

estáZarpada(Serie):-
  esPopular(Serie).

:- begin_tests(punto6_vieneZafando).

test(juan_viene_zafando_con_himym_got_y_hoc, set(Series = [himym, got, hoc])):-
	vieneZafando(juan, Series).
%el_Test_de_Abajo_deberia_Ser_con_not

test(nico_viene_zafando_con_StarWars, nondet):-
	vieneZafando(Persona, Serie), Persona == nico, Serie == starWars.

test(maiu_no_viene_zafando_con_ninguna_serie, fail) :-
  vieneZafando(Persona, _) , Persona == maiu.

:- end_tests(punto6_vieneZafando).

% ------------SEGUNDA PARTE-------------

malaGente(Persona):-
  serie(Serie), persona(Persona),
  not(mira(Persona, Serie)),
  leSpoileo(Persona, _, Serie).

malaGente(Persona):-
  leDijo(Persona, _, Serie, _),
  forall(leDijo(Persona, Alguien, Serie,_),
  leSpoileo(Persona, Alguien, Serie)).

:- begin_tests(punto1_malaGente).

test(gastón_es_mala_gente, set(Persona = [nico, gastón])):-
  malaGente(Persona).

test(pedro_no_es_mala_gemte, nondet):-
  not(malaGente(pedro)).

:- end_tests(punto1_malaGente).

/*

member(Valor,Lista).
forall(Antecedente,Consecuente).

esCliche(Serie):- 
    pasó(Serie,_,_,plotTwist([Palabra|ListaPalabras])),

fuerte(Serie):-
        esFuerte(Serie,_),
        not(esCliche(Serie)).
	pasoEnUltimaTemporada(Serie).
% en esCliche no sé si hay que hacer que se relacione con la ultima temporada

PUNTO 3
findall(Formato, Consulta, Lista)  <--- Define una lista a partir de una consulta , podriamos generar una lista de gente mirando y buscar su lenght pero nose bien :S

popular(Serie):-

cantidadMiran*cantidadConversaciones >= cantidadMiranStarW*cantidadConversacionesSW

PUNTO4

amigo(nico, maiu).
amigo(maiu, gaston).
amigo(maiu, juan).
amigo(juan, aye).

fullSpoil(Persona1,Persona2):- <-- persona1 tendria que hacerle spoil a persona2 o sus amigos o los amigos de sus amigos

*/

