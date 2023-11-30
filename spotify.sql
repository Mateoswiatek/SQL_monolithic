-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler version: 0.9.4-beta1
-- PostgreSQL version: 14.0
-- Project Site: pgmodeler.io


DROP SCHEMA IF EXISTS kolokwium1 CASCADE;
CREATE SCHEMA kolokwium1;


-- object: kolokwium1.wykonawcy_idwykonawcy_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS kolokwium1.wykonawcy_idwykonawcy_seq CASCADE;
CREATE SEQUENCE kolokwium1.wykonawcy_idwykonawcy_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- object: kolokwium1.wykonawcy | type: TABLE --
-- DROP TABLE IF EXISTS kolokwium1.wykonawcy CASCADE;
CREATE TABLE kolokwium1.wykonawcy (
	idwykonawcy integer NOT NULL DEFAULT nextval('kolokwium1.wykonawcy_idwykonawcy_seq'::regclass),
	nazwa character varying(100) NOT NULL,
	kraj character varying(30) NOT NULL,
	data_debiutu date NOT NULL,
	data_zakonczenia date,
	CONSTRAINT wykonawcy_pk PRIMARY KEY (idwykonawcy)
);


-- object: kolokwium1.utwory_idutworu_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS kolokwium1.utwory_idutworu_seq CASCADE;
CREATE SEQUENCE kolokwium1.utwory_idutworu_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;


-- object: kolokwium1.utwory | type: TABLE --
-- DROP TABLE IF EXISTS kolokwium1.utwory CASCADE;
CREATE TABLE kolokwium1.utwory (
	idutworu integer NOT NULL DEFAULT nextval('kolokwium1.utwory_idutworu_seq'::regclass),
	idalbumu integer NOT NULL,
	nazwa character varying(100) NOT NULL,
	dlugosc integer NOT NULL,
	CONSTRAINT utwory_pk PRIMARY KEY (idutworu)
);


-- object: kolokwium1.playlisty_idplaylisty_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS kolokwium1.playlisty_idplaylisty_seq CASCADE;
CREATE SEQUENCE kolokwium1.playlisty_idplaylisty_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- object: kolokwium1.playlisty | type: TABLE --
-- DROP TABLE IF EXISTS kolokwium1.playlisty CASCADE;
CREATE TABLE kolokwium1.playlisty (
	idplaylisty integer NOT NULL DEFAULT nextval('kolokwium1.playlisty_idplaylisty_seq'::regclass),
	idklienta integer NOT NULL,
	nazwa character varying(30) NOT NULL,
	CONSTRAINT playlisty_pk PRIMARY KEY (idplaylisty)
);


-- object: kolokwium1.albumy_idalbumu_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS kolokwium1.albumy_idalbumu_seq CASCADE;
CREATE SEQUENCE kolokwium1.albumy_idalbumu_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- object: kolokwium1.albumy | type: TABLE --
-- DROP TABLE IF EXISTS kolokwium1.albumy CASCADE;
CREATE TABLE kolokwium1.albumy (
	idalbumu integer NOT NULL DEFAULT nextval('kolokwium1.albumy_idalbumu_seq'::regclass),
	idwykonawcy integer NOT NULL,
	nazwa character varying(50) NOT NULL,
	gatunek character varying(20) NOT NULL,
	data_wydania date NOT NULL,
	CONSTRAINT albumy_pk PRIMARY KEY (idalbumu)
);


-- object: kolokwium1.gatunki_idgatunku_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS kolokwium1.gatunki_idgatunku_seq CASCADE;
CREATE SEQUENCE kolokwium1.gatunki_idgatunku_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- object: kolokwium1.zawartosc | type: TABLE --
-- DROP TABLE IF EXISTS kolokwium1.zawartosc CASCADE;
CREATE TABLE kolokwium1.zawartosc (
	idplaylisty integer NOT NULL,
	idutworu integer NOT NULL,
	CONSTRAINT zawartosc_pk PRIMARY KEY (idplaylisty,idutworu)
);


-- object: kolokwium1.klienci_idklienta_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS kolokwium1.klienci_idklienta_seq CASCADE;
CREATE SEQUENCE kolokwium1.klienci_idklienta_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;


-- object: kolokwium1.klienci | type: TABLE --
-- DROP TABLE IF EXISTS kolokwium1.klienci CASCADE;
CREATE TABLE kolokwium1.klienci (
	idklienta integer NOT NULL DEFAULT nextval('kolokwium1.klienci_idklienta_seq'::regclass),
	login character varying(50) NOT NULL,
	data_rejestracji date NOT NULL,
	data_urodzenia date NOT NULL,
	CONSTRAINT klienci_pk PRIMARY KEY (idklienta)
);


-- object: kolokwium1.oceny | type: TABLE --
-- DROP TABLE IF EXISTS kolokwium1.oceny CASCADE;
CREATE TABLE kolokwium1.oceny (
	idutworu integer NOT NULL,
	idklienta integer NOT NULL,
	lubi boolean NOT NULL,
	CONSTRAINT oceny_pk PRIMARY KEY (idutworu,idklienta)
);


-- object: klienci_login_uindex | type: INDEX --
-- DROP INDEX IF EXISTS kolokwium1.klienci_login_uindex CASCADE;
CREATE UNIQUE INDEX klienci_login_uindex ON kolokwium1.klienci
USING btree
(
	login
)
WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: utwory_albumy_idalbumu_fk | type: CONSTRAINT --
-- ALTER TABLE kolokwium1.utwory DROP CONSTRAINT IF EXISTS utwory_albumy_idalbumu_fk CASCADE;
ALTER TABLE kolokwium1.utwory ADD CONSTRAINT utwory_albumy_idalbumu_fk FOREIGN KEY (idalbumu)
REFERENCES kolokwium1.albumy (idalbumu) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: playlisty_klienci_idklienta_fk | type: CONSTRAINT --
-- ALTER TABLE kolokwium1.playlisty DROP CONSTRAINT IF EXISTS playlisty_klienci_idklienta_fk CASCADE;
ALTER TABLE kolokwium1.playlisty ADD CONSTRAINT playlisty_klienci_idklienta_fk FOREIGN KEY (idklienta)
REFERENCES kolokwium1.klienci (idklienta) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: albumy_wykonawcy_idwykonawcy_fk | type: CONSTRAINT --
-- ALTER TABLE kolokwium1.albumy DROP CONSTRAINT IF EXISTS albumy_wykonawcy_idwykonawcy_fk CASCADE;
ALTER TABLE kolokwium1.albumy ADD CONSTRAINT albumy_wykonawcy_idwykonawcy_fk FOREIGN KEY (idwykonawcy)
REFERENCES kolokwium1.wykonawcy (idwykonawcy) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: zawartosc_playlisty_idplaylisty_fk | type: CONSTRAINT --
-- ALTER TABLE kolokwium1.zawartosc DROP CONSTRAINT IF EXISTS zawartosc_playlisty_idplaylisty_fk CASCADE;
ALTER TABLE kolokwium1.zawartosc ADD CONSTRAINT zawartosc_playlisty_idplaylisty_fk FOREIGN KEY (idplaylisty)
REFERENCES kolokwium1.playlisty (idplaylisty) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: zawartosc_utwory_idutworu_fk | type: CONSTRAINT --
-- ALTER TABLE kolokwium1.zawartosc DROP CONSTRAINT IF EXISTS zawartosc_utwory_idutworu_fk CASCADE;
ALTER TABLE kolokwium1.zawartosc ADD CONSTRAINT zawartosc_utwory_idutworu_fk FOREIGN KEY (idutworu)
REFERENCES kolokwium1.utwory (idutworu) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: oceny_klienci_idklienta_fk | type: CONSTRAINT --
-- ALTER TABLE kolokwium1.oceny DROP CONSTRAINT IF EXISTS oceny_klienci_idklienta_fk CASCADE;
ALTER TABLE kolokwium1.oceny ADD CONSTRAINT oceny_klienci_idklienta_fk FOREIGN KEY (idklienta)
REFERENCES kolokwium1.klienci (idklienta) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: oceny_utwory_idutworu_fk | type: CONSTRAINT --
-- ALTER TABLE kolokwium1.oceny DROP CONSTRAINT IF EXISTS oceny_utwory_idutworu_fk CASCADE;
ALTER TABLE kolokwium1.oceny ADD CONSTRAINT oceny_utwory_idutworu_fk FOREIGN KEY (idutworu)
REFERENCES kolokwium1.utwory (idutworu) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

