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

episodiosPorTemporada(got, 12, 3).
episodiosPorTemporada(got, 10, 2).
episodiosPorTemporada(himym, 23, 1).
episodiosPorTemporada(drHouse, 16, 8).

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

leDijo(gastón, maiu, got, relación(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relación(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)).
leDijo(aye, juan, got, relación(amistad, tyrion, john)).
leDijo(aye, maiu, got, relación(amistad, tyrion, john)).
leDijo(aye, gaston, got, relación(amistad, tyrion, dragon)).

% Punto 3
esSpoiler(Serie, Spoiler):- pasó(Serie, _, _, Spoiler).

:- begin_tests(punto3_EsSpoiler).

test(la_muerte_del_emperor_es_spoiler_para_StarWars, nondet):-
  esSpoiler(Serie, Spoiler), Serie == starWars, Spoiler == muerte(emperor).

test(la_relación_de_parentesco_entre_anakin_y_el_rey_es_spoiler_para_StarWars, nondet):-
  esSpoiler(Serie, Spoiler), Serie == starWars, Spoiler == relación(parentesco, anakin, rey).

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

:- end_tests(punto4_LeSpoileo).

% Punto 5
persona(Persona):- leInteresa(Persona, _).

televidenteResponsable(Persona):-
  persona(Persona),
  not(leSpoileo(Persona, _, _)).

:- begin_tests(punto5_televidenteResponsable).

test(juan_aye_y_maiu_son_televidentes_responsables, set(Personas == [juan, aye, maiu])):-
  televidenteResponsable(Personas).

:- end_tests(punto5_televidenteResponsable).

% Punto 6
temporadas(Serie, Temporada):- episodiosPorTemporada(Serie, _, Temporada).
temporadas(Serie, Temporada):- pasó(Serie, Temporada, _, _).

esFuerte(Temporada):- pasó(_, Temporada, _, muerte(_)).
esFuerte(Temporada):- pasó(_, Temporada, _, relación(parentesco, _, _)).
esFuerte(Temporada):- pasó(_, Temporada, _, relación(amorosa, _, _)).

/*
sucesoFuerteOPopular(Serie):- sucesoFuerte(Serie).
sucesoFuerteOPopular(Serie):- esPopular(Serie).
*/

/* vieneZafando/2 */
vieneZafando(Persona, Serie):-
  persona(Persona),
  leInteresa(Persona, Serie),
  not(leSpoileo(_, Persona, Serie)),
% sucesoFuerteOPopular(Serie).

/*
:- begin_tests(punto6_vieneZafando).

test(juan_viene_zafando_con_himym_got_y_hoc, set(Series = [himym, got, hoc])):-
	vieneZafando(juan, Series).

test(nico_viene_zafando_con_StarWars, nondet):-
	vieneZafando(Persona, Serie), Persona == nico, Serie == starWars.

:- end_tests(punto6_vieneZafando).
*/
