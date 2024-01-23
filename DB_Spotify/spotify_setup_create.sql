-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler version: 0.9.4-beta1
-- PostgreSQL version: 14.0
-- Project Site: pgmodeler.io


DROP SCHEMA IF EXISTS spotify CASCADE;
CREATE SCHEMA spotify;


-- object: spotify.wykonawcy_idwykonawcy_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS spotify.wykonawcy_idwykonawcy_seq CASCADE;
CREATE SEQUENCE spotify.wykonawcy_idwykonawcy_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- object: spotify.wykonawcy | type: TABLE --
-- DROP TABLE IF EXISTS spotify.wykonawcy CASCADE;
CREATE TABLE spotify.wykonawcy (
	idwykonawcy integer NOT NULL DEFAULT nextval('spotify.wykonawcy_idwykonawcy_seq'::regclass),
	nazwa character varying(100) NOT NULL,
	kraj character varying(30) NOT NULL,
	data_debiutu date NOT NULL,
	data_zakonczenia date,
	CONSTRAINT wykonawcy_pk PRIMARY KEY (idwykonawcy)
);


-- object: spotify.utwory_idutworu_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS spotify.utwory_idutworu_seq CASCADE;
CREATE SEQUENCE spotify.utwory_idutworu_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;


-- object: spotify.utwory | type: TABLE --
-- DROP TABLE IF EXISTS spotify.utwory CASCADE;
CREATE TABLE spotify.utwory (
	idutworu integer NOT NULL DEFAULT nextval('spotify.utwory_idutworu_seq'::regclass),
	idalbumu integer NOT NULL,
	nazwa character varying(100) NOT NULL,
	dlugosc integer NOT NULL,
	CONSTRAINT utwory_pk PRIMARY KEY (idutworu)
);


-- object: spotify.playlisty_idplaylisty_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS spotify.playlisty_idplaylisty_seq CASCADE;
CREATE SEQUENCE spotify.playlisty_idplaylisty_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- object: spotify.playlisty | type: TABLE --
-- DROP TABLE IF EXISTS spotify.playlisty CASCADE;
CREATE TABLE spotify.playlisty (
	idplaylisty integer NOT NULL DEFAULT nextval('spotify.playlisty_idplaylisty_seq'::regclass),
	idklienta integer NOT NULL,
	nazwa character varying(30) NOT NULL,
	CONSTRAINT playlisty_pk PRIMARY KEY (idplaylisty)
);


-- object: spotify.albumy_idalbumu_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS spotify.albumy_idalbumu_seq CASCADE;
CREATE SEQUENCE spotify.albumy_idalbumu_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- object: spotify.albumy | type: TABLE --
-- DROP TABLE IF EXISTS spotify.albumy CASCADE;
CREATE TABLE spotify.albumy (
	idalbumu integer NOT NULL DEFAULT nextval('spotify.albumy_idalbumu_seq'::regclass),
	idwykonawcy integer NOT NULL,
	nazwa character varying(100) NOT NULL,
	gatunek character varying(20) NOT NULL,
	data_wydania date NOT NULL,
	CONSTRAINT albumy_pk PRIMARY KEY (idalbumu)
);


-- object: spotify.gatunki_idgatunku_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS spotify.gatunki_idgatunku_seq CASCADE;
CREATE SEQUENCE spotify.gatunki_idgatunku_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- object: spotify.zawartosc | type: TABLE --
-- DROP TABLE IF EXISTS spotify.zawartosc CASCADE;
CREATE TABLE spotify.zawartosc (
	idplaylisty integer NOT NULL,
	idutworu integer NOT NULL,
	CONSTRAINT zawartosc_pk PRIMARY KEY (idplaylisty,idutworu)
);


-- object: spotify.klienci_idklienta_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS spotify.klienci_idklienta_seq CASCADE;
CREATE SEQUENCE spotify.klienci_idklienta_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;


-- object: spotify.klienci | type: TABLE --
-- DROP TABLE IF EXISTS spotify.klienci CASCADE;
CREATE TABLE spotify.klienci (
	idklienta integer NOT NULL DEFAULT nextval('spotify.klienci_idklienta_seq'::regclass),
	login character varying(50) NOT NULL,
	data_rejestracji date NOT NULL,
	data_urodzenia date NOT NULL,
	CONSTRAINT klienci_pk PRIMARY KEY (idklienta)
);


-- object: spotify.oceny | type: TABLE --
-- DROP TABLE IF EXISTS spotify.oceny CASCADE;
CREATE TABLE spotify.oceny (
	idutworu integer NOT NULL,
	idklienta integer NOT NULL,
	lubi boolean NOT NULL,
	CONSTRAINT oceny_pk PRIMARY KEY (idutworu,idklienta)
);


-- object: klienci_login_uindex | type: INDEX --
-- DROP INDEX IF EXISTS spotify.klienci_login_uindex CASCADE;
CREATE UNIQUE INDEX klienci_login_uindex ON spotify.klienci
USING btree
(
	login
)
WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: utwory_albumy_idalbumu_fk | type: CONSTRAINT --
-- ALTER TABLE spotify.utwory DROP CONSTRAINT IF EXISTS utwory_albumy_idalbumu_fk CASCADE;
ALTER TABLE spotify.utwory ADD CONSTRAINT utwory_albumy_idalbumu_fk FOREIGN KEY (idalbumu)
REFERENCES spotify.albumy (idalbumu) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: playlisty_klienci_idklienta_fk | type: CONSTRAINT --
-- ALTER TABLE spotify.playlisty DROP CONSTRAINT IF EXISTS playlisty_klienci_idklienta_fk CASCADE;
ALTER TABLE spotify.playlisty ADD CONSTRAINT playlisty_klienci_idklienta_fk FOREIGN KEY (idklienta)
REFERENCES spotify.klienci (idklienta) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: albumy_wykonawcy_idwykonawcy_fk | type: CONSTRAINT --
-- ALTER TABLE spotify.albumy DROP CONSTRAINT IF EXISTS albumy_wykonawcy_idwykonawcy_fk CASCADE;
ALTER TABLE spotify.albumy ADD CONSTRAINT albumy_wykonawcy_idwykonawcy_fk FOREIGN KEY (idwykonawcy)
REFERENCES spotify.wykonawcy (idwykonawcy) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: zawartosc_playlisty_idplaylisty_fk | type: CONSTRAINT --
-- ALTER TABLE spotify.zawartosc DROP CONSTRAINT IF EXISTS zawartosc_playlisty_idplaylisty_fk CASCADE;
ALTER TABLE spotify.zawartosc ADD CONSTRAINT zawartosc_playlisty_idplaylisty_fk FOREIGN KEY (idplaylisty)
REFERENCES spotify.playlisty (idplaylisty) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: zawartosc_utwory_idutworu_fk | type: CONSTRAINT --
-- ALTER TABLE spotify.zawartosc DROP CONSTRAINT IF EXISTS zawartosc_utwory_idutworu_fk CASCADE;
ALTER TABLE spotify.zawartosc ADD CONSTRAINT zawartosc_utwory_idutworu_fk FOREIGN KEY (idutworu)
REFERENCES spotify.utwory (idutworu) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: oceny_klienci_idklienta_fk | type: CONSTRAINT --
-- ALTER TABLE spotify.oceny DROP CONSTRAINT IF EXISTS oceny_klienci_idklienta_fk CASCADE;
ALTER TABLE spotify.oceny ADD CONSTRAINT oceny_klienci_idklienta_fk FOREIGN KEY (idklienta)
REFERENCES spotify.klienci (idklienta) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: oceny_utwory_idutworu_fk | type: CONSTRAINT --
-- ALTER TABLE spotify.oceny DROP CONSTRAINT IF EXISTS oceny_utwory_idutworu_fk CASCADE;
ALTER TABLE spotify.oceny ADD CONSTRAINT oceny_utwory_idutworu_fk FOREIGN KEY (idutworu)
REFERENCES spotify.utwory (idutworu) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --