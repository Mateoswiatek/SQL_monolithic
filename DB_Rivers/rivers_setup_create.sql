BEGIN;
DROP SCHEMA IF EXISTS rivers CASCADE;
CREATE SCHEMA rivers;
SET search_path TO rivers;

DROP TABLE IF EXISTS wojewodztwa;
DROP TABLE IF EXISTS powiaty;
DROP TABLE IF EXISTS gminy;
DROP TABLE IF EXISTS rzeki;
DROP TABLE IF EXISTS punkty_pomiarowe;
DROP TABLE IF EXISTS pomiary;
DROP TABLE IF EXISTS ostrzezenia;

CREATE TABLE wojewodztwa (
	identyfikator	INTEGER PRIMARY KEY,
	nazwa 		VARCHAR(30) NOT NULL
);

CREATE TABLE powiaty (
	identyfikator	INTEGER PRIMARY KEY,
	nazwa		VARCHAR(30) NOT NULL,
	id_wojewodztwa INTEGER NOT NULL REFERENCES wojewodztwa
);

CREATE TABLE gminy (
	identyfikator	INTEGER PRIMARY KEY,
	nazwa		VARCHAR(30) NOT NULL,
	id_powiatu	INTEGER NOT NULL REFERENCES powiaty
);

CREATE TABLE rzeki (
	id_rzeki		INTEGER PRIMARY KEY,
	nazwa		VARCHAR(30) NOT NULL
);

CREATE TABLE punkty_pomiarowe (
	id_punktu		INTEGER PRIMARY KEY,
	nr_porzadkowy		INTEGER NOT NULL,
	id_gminy		INTEGER NOT NULL REFERENCES gminy,
	id_rzeki		INTEGER NOT NULL REFERENCES rzeki,
	dlugosc_geogr	float,
	szerokosc_geogr float,
	stan_ostrzegawczy INTEGER NOT NULL,
	stan_alarmowy INTEGER NOT NULL
);

CREATE TABLE pomiary (
	id_pomiaru	INTEGER PRIMARY KEY,
	id_punktu	INTEGER NOT NULL REFERENCES punkty_pomiarowe,
	czas_pomiaru	TIMESTAMP NOT NULL,
	poziom_wody	INTEGER
);

CREATE TABLE ostrzezenia (
	id_ostrzezenia	INTEGER PRIMARY KEY,
	id_punktu		INTEGER NOT NULL REFERENCES punkty_pomiarowe,
	czas_ostrzezenia TIMESTAMP NOT NULL,
	przekroczony_stan_ostrz INTEGER,
	przekroczony_stan_alarm INTEGER,
	zmiana_poziomu float
);

COMMIT;