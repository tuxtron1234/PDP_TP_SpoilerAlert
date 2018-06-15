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

esPopular(got).
esPopular(hoc).
esPopular(starWars).

quiereVer(juan, hoc).
quiereVer(aye, got).
quiereVer(gastón, himym).

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
pasó(futurama, 2, 3, muerte(seymourDiera)).
pasó(starWars, 10, 9, muerte(emperor)).
pasó(starWars, 1, 2, relación(parentesco, anakin, rey)).
pasó(starWars, 3, 2, relación(parentesco, vader, luke)).
pasó(himym, 1, 1, relación(amorosa, ted, robin)).
pasó(himym, 4, 3, relación(amorosa, swarley, robin)).
pasó(got, 4, 5, relación(amistad, tyrion, dragon)).

leDijo(gaston, maiu, got, relación(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relación(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)).
leDijo(aye, juan, got, relación(amistad, tyrion, john)).
leDijo(aye, maiu, got, relación(amistad, tyrion, john)).
leDijo(aye, gaston, got, relación(amistad, tyrion, dragon)).

% Punto 3
esSpoiler(Serie, Spoiler):- pasó(Serie, _, _, Spoiler).

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
persona(gastón).
persona(aye).

televidenteResponsable(Persona):-
  persona(Persona),
  not(leSpoileo(Persona, _, _)).

% Punto 6
sucesoFuerte(Serie):- pasó(Serie, _, _, muerte(_)).
sucesoFuerte(Serie):- pasó(Serie, _, _, relacion(amorosa, _, _)).
sucesoFuerte(Serie):- pasó(Serie, _, _, relacion(parentesco, _, _)).

sucesoFuerteOPopular(Serie):- sucesoFuerte(Serie).
sucesoFuerteOPopular(Serie):- esPopular(Serie).

/* vieneZafando/2 */
vieneZafando(Persona, Serie):-
  persona(Persona),
  leInteresa(Persona, Serie),
  not(leSpoileo(_, Persona, Serie)),
  sucesoFuerteOPopular(Serie).
