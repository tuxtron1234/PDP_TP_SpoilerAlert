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

persona(juan).
persona(nico).
persona(maiu).
persona(gaston).
persona(aye).

/*
Por principio de Universo Cerrado se considera que todo lo negado o desconocido no se incluye en este caso:
  _Nadie mira "Mad men".
  _Alf no ve ninguna serie porque el doctorado le consume toda la vida.
  _No recordamos cuántos episodios tiene la segunda temporada de “Mad men”.
No se modela.
*/

/* paso(Serie, Temporada, Episodio, Lo que paso) */
paso(futurama, 2, 3, muerte(seymourDiera)).
paso(starWars, 10, 9, muerte(emperor)).
paso(starWars, 1, 2, relacion(parentesco, anakin, rey)).
paso(starWars, 3, 2, relacion(parentesco, vader, luke)).
paso(himym, 1, 1, relacion(amorosa, ted, robin)).
paso(himym, 4, 3, relacion(amorosa, swarley, robin)).
paso(got, 4, 5, relacion(amistad, tyrion, dragon)).

/*leDijo/4*/
leDijo(gaston, maiu, got, relacion(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relacion(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)).
leDijo(aye, juan, got, relacion(amistad, tyrion, john)).
leDijo(aye, maiu, got, relacion(amistad, tyrion, john)).
leDijo(aye, gaston, got, relacion(amistad, tyrion, dragon)).

/*esSpoiler(Serie,Spoiler). */
esSpoiler(Serie, Spoiler):- paso(Serie, _, _, Spoiler).

leInteresa(Persona, Serie):- mira(Persona, Serie).
leInteresa(Persona, Serie):- quiereVer(Persona, Serie).

/* leSpoileo(Emisor,Receptor,Serie) */
leSpoileo(Emisor, Receptor, Serie):-
  leInteresa(Receptor, Serie),
  leDijo(Emisor, Receptor, Serie, Spoiler),
  esSpoiler(Serie, Spoiler).

televidenteResponsable(Persona):-
  persona(Persona),
  not(leSpoileo(Persona, _, Serie)).
