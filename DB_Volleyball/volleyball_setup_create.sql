BEGIN;
DROP SCHEMA IF EXISTS volleyball CASCADE;
CREATE SCHEMA volleyball;
SET search_path TO volleyball;

DROP TABLE IF EXISTS statystyki;
DROP TABLE IF EXISTS punktujace;
DROP TABLE IF EXISTS mecze;
DROP TABLE IF EXISTS iatkarki;
DROP TABLE IF EXISTS druzyny;

CREATE TABLE druzyny (
  iddruzyny VARCHAR(5) PRIMARY KEY,
  nazwa VARCHAR(40) NOT NULL,
  miasto VARCHAR(30) NOT NULL
);

CREATE TABLE siatkarki (
  numer SMALLINT NOT NULL,
  iddruzyny VARCHAR(5) NOT NULL REFERENCES druzyny,
  imie VARCHAR(12) NOT NULL,
  nazwisko VARCHAR(30) NOT NULL,
  pozycja VARCHAR(12) NOT NULL,
  PRIMARY KEY (numer, iddruzyny)
);

CREATE TABLE mecze (
  idmeczu SMALLINT PRIMARY KEY,
  gospodarze VARCHAR(5) NOT NULL REFERENCES druzyny,
  goscie VARCHAR(5) NOT NULL REFERENCES druzyny,
  termin DATE NOT NULL
);

CREATE TABLE statystyki (
  idmeczu SMALLINT PRIMARY KEY REFERENCES mecze,
  gospodarze SMALLINT[],
  goscie SMALLINT[]
);

CREATE TABLE punktujace (
  numer SMALLINT NOT NULL,
  iddruzyny VARCHAR(5) NOT NULL REFERENCES druzyny,
  idmeczu SMALLINT NOT NULL REFERENCES mecze,
  punkty SMALLINT NOT NULL,
  PRIMARY KEY (numer, iddruzyny, idmeczu),
  FOREIGN KEY (numer, iddruzyny) REFERENCES siatkarki
);

COMMIT;
