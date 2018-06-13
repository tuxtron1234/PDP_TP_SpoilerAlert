% Punto 1
mira(juan, himym).
mira(juan, futurama).
mira(juan, got).
mira(nico, starWars).
mira(nico, got).
mira(maiu, starWars).
mira(maiu, onePiece).
mira(maiu, got).
mira(gaston, hoc).

esPopular(got).
esPopular(hoc).
esPopular(starWars).

quiereVer(juan, hoc).
quiereVer(aye, got).
quiereVer(gaston, himym).

episodiosPorTemporada(got, 3, 12).
episodiosPorTemporada(got, 2, 10).
episodiosPorTemporada(himym, 1, 23).
episodiosPorTemporada(drHouse, 8, 16).

/*
Por principio de Universo Cerrado se considera que todo lo negado o desconocido no se incluye en este caso:
  _Nadie mira "Mad men".
  _Alf no ve ninguna serie porque el doctorado le consume toda la vida.
  _No recordamos cuántos episodios tiene la segunda temporada de “Mad men”.
No se modela.
*/

% Punto 2
paso(futurama, 2, 3, muerte(seymourDiera)).
paso(starWars, 10, 9, muerte(emperor)).
paso(starWars, 1, 2, relacion(parentesco, anakin, rey)).
paso(starWars, 3, 2, relacion(parentesco, vader, luke)).
paso(himym, 1, 1, relacion(amorosa, ted, robin)).
paso(himym, 4, 3, relacion(amorosa, swarley, robin)).
paso(got, 4, 5, relacion(amistad, tyrion, dragon)).

leDijo(gaston, maiu, got, relacion(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relacion(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)).
leDijo(aye, juan, got, relacion(amistad, tyrion, john)).
leDijo(aye, maiu, got, relacion(amistad, tyrion, john)).
leDijo(aye, gaston, got, relacion(amistad, tyrion, dragon)).

% Punto 3
esSpoiler(Serie, Spoiler):- paso(Serie, _, _, Spoiler).

/*
:- begin_tests(puntoB).

test(hechosVerdaderos,set(Hechos == [muerte(emperor),relacion(parentesco,anakin,rey)])) :-
esSpoiler(_,Hechos).
% test(hechosFalsos,fail,anondet) :-
% esSpoiler(starWars,muerte(emperor)).
:- end_tests(puntoB).
*/

% Punto 4
leInteresa(Espectador, Serie):- mira(Espectador, Serie).
leInteresa(Espectador, Serie):- quiereVer(Espectador, Serie).

leSpoileo(PersonaMala, Victima, Serie):-
  leInteresa(Victima, Serie),
  leDijo(PersonaMala, Victima, Serie, Spoiler),
  esSpoiler(Serie, Spoiler).

% Punto 5
persona(juan).
persona(nico).
persona(maiu).
persona(gaston).
persona(aye).

televidenteResponsable(Persona):-
  persona(Persona),
  not(leSpoileo(Persona, _, _)).

% Punto 6
sucesoFuerte(Serie):- paso(Serie, _, _, muerte(_)).
sucesoFuerte(Serie):- paso(Serie, _, _, relacion(amorosa, _, _)).
sucesoFuerte(Serie):- paso(Serie, _, _, relacion(parentesco, _, _)).

sucesoFuerteOPopular(Serie):- sucesoFuerte(Serie).
sucesoFuerteOPopular(Serie):- esPopular(Serie).

/* vieneZafando/2 */
vieneZafando(Persona, Serie):-
  persona(Persona),
  leInteresa(Persona, Serie),
  not(leSpoileo(_, Persona, Serie)),
  sucesoFuerteOPopular(Serie).
