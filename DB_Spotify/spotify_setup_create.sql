-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler version: 0.9.4-beta1
-- PostgreSQL version: 14.0
-- Project Site: pgmodeler.io


DROP SCHEMA IF EXISTS spotify CASCADE;
CREATE SCHEMA spotify;
SET search_path TO spotify;

DROP TABLE IF EXISTS wykonawcy;
DROP TABLE IF EXISTS albumy;
DROP TABLE IF EXISTS utwory;
DROP TABLE IF EXISTS zawartosc;
DROP TABLE IF EXISTS playlisty;
DROP TABLE IF EXISTS klienci;
DROP TABLE IF EXISTS oceny;

-- object: wykonawcy_idwykonawcy_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS wykonawcy_idwykonawcy_seq CASCADE;
CREATE SEQUENCE wykonawcy_idwykonawcy_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- object: wykonawcy | type: TABLE --
-- DROP TABLE IF EXISTS wykonawcy CASCADE;
CREATE TABLE wykonawcy (
	idwykonawcy INTEGER NOT NULL DEFAULT nextval('spotify.wykonawcy_idwykonawcy_seq'::regclass),
	nazwa CHARACTER varying(100) NOT NULL,
	kraj CHARACTER varying(30) NOT NULL,
	data_debiutu DATE NOT NULL,
	data_zakonczenia DATE,
	CONSTRAINT wykonawcy_pk PRIMARY KEY (idwykonawcy)
);


-- object: utwory_idutworu_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS utwory_idutworu_seq CASCADE;
CREATE SEQUENCE utwory_idutworu_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;


-- object: utwory | type: TABLE --
-- DROP TABLE IF EXISTS utwory CASCADE;
CREATE TABLE utwory (
	idutworu INTEGER NOT NULL DEFAULT nextval('spotify.utwory_idutworu_seq'::regclass),
	idalbumu INTEGER NOT NULL,
	nazwa CHARACTER varying(100) NOT NULL,
	dlugosc INTEGER NOT NULL,
	CONSTRAINT utwory_pk PRIMARY KEY (idutworu)
);


-- object: playlisty_idplaylisty_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS playlisty_idplaylisty_seq CASCADE;
CREATE SEQUENCE playlisty_idplaylisty_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- object: playlisty | type: TABLE --
-- DROP TABLE IF EXISTS playlisty CASCADE;
CREATE TABLE playlisty (
	idplaylisty INTEGER NOT NULL DEFAULT nextval('spotify.playlisty_idplaylisty_seq'::regclass),
	idklienta INTEGER NOT NULL,
	nazwa CHARACTER varying(30) NOT NULL,
	CONSTRAINT playlisty_pk PRIMARY KEY (idplaylisty)
);


-- object: albumy_idalbumu_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS albumy_idalbumu_seq CASCADE;
CREATE SEQUENCE albumy_idalbumu_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- object: albumy | type: TABLE --
-- DROP TABLE IF EXISTS albumy CASCADE;
CREATE TABLE albumy (
	idalbumu INTEGER NOT NULL DEFAULT nextval('spotify.albumy_idalbumu_seq'::regclass),
	idwykonawcy INTEGER NOT NULL,
	nazwa CHARACTER varying(100) NOT NULL,
	gatunek CHARACTER varying(20) NOT NULL,
	data_wydania DATE NOT NULL,
	CONSTRAINT albumy_pk PRIMARY KEY (idalbumu)
);


-- object: gatunki_idgatunku_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS gatunki_idgatunku_seq CASCADE;
CREATE SEQUENCE gatunki_idgatunku_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- object: zawartosc | type: TABLE --
-- DROP TABLE IF EXISTS zawartosc CASCADE;
CREATE TABLE zawartosc (
	idplaylisty INTEGER NOT NULL,
	idutworu INTEGER NOT NULL,
	CONSTRAINT zawartosc_pk PRIMARY KEY (idplaylisty,idutworu)
);


-- object: klienci_idklienta_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS klienci_idklienta_seq CASCADE;
CREATE SEQUENCE klienci_idklienta_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;


-- object: klienci | type: TABLE --
-- DROP TABLE IF EXISTS klienci CASCADE;
CREATE TABLE klienci (
	idklienta INTEGER NOT NULL DEFAULT nextval('spotify.klienci_idklienta_seq'::regclass),
	login CHARACTER varying(50) NOT NULL,
	data_rejestracji DATE NOT NULL,
	data_urodzenia DATE NOT NULL,
	CONSTRAINT klienci_pk PRIMARY KEY (idklienta)
);


-- object: oceny | type: TABLE --
-- DROP TABLE IF EXISTS oceny CASCADE;
CREATE TABLE oceny (
	idutworu INTEGER NOT NULL,
	idklienta INTEGER NOT NULL,
	lubi BOOLEAN NOT NULL,
	CONSTRAINT oceny_pk PRIMARY KEY (idutworu,idklienta)
);


-- object: klienci_login_uindex | type: INDEX --
-- DROP INDEX IF EXISTS klienci_login_uindex CASCADE;
CREATE UNIQUE INDEX klienci_login_uindex ON klienci
USING btree
(
	login
)
WITH (FILLFACTOR = 90);
-- ddl-END --

-- object: utwory_albumy_idalbumu_fk | type: CONSTRAINT --
-- ALTER TABLE utwory DROP CONSTRAINT IF EXISTS utwory_albumy_idalbumu_fk CASCADE;
ALTER TABLE utwory ADD CONSTRAINT utwory_albumy_idalbumu_fk FOREIGN KEY (idalbumu)
REFERENCES albumy (idalbumu) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-END --

-- object: playlisty_klienci_idklienta_fk | type: CONSTRAINT --
-- ALTER TABLE playlisty DROP CONSTRAINT IF EXISTS playlisty_klienci_idklienta_fk CASCADE;
ALTER TABLE playlisty ADD CONSTRAINT playlisty_klienci_idklienta_fk FOREIGN KEY (idklienta)
REFERENCES klienci (idklienta) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-END --

-- object: albumy_wykonawcy_idwykonawcy_fk | type: CONSTRAINT --
-- ALTER TABLE albumy DROP CONSTRAINT IF EXISTS albumy_wykonawcy_idwykonawcy_fk CASCADE;
ALTER TABLE albumy ADD CONSTRAINT albumy_wykonawcy_idwykonawcy_fk FOREIGN KEY (idwykonawcy)
REFERENCES wykonawcy (idwykonawcy) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-END --

-- object: zawartosc_playlisty_idplaylisty_fk | type: CONSTRAINT --
-- ALTER TABLE zawartosc DROP CONSTRAINT IF EXISTS zawartosc_playlisty_idplaylisty_fk CASCADE;
ALTER TABLE zawartosc ADD CONSTRAINT zawartosc_playlisty_idplaylisty_fk FOREIGN KEY (idplaylisty)
REFERENCES playlisty (idplaylisty) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-END --

-- object: zawartosc_utwory_idutworu_fk | type: CONSTRAINT --
-- ALTER TABLE zawartosc DROP CONSTRAINT IF EXISTS zawartosc_utwory_idutworu_fk CASCADE;
ALTER TABLE zawartosc ADD CONSTRAINT zawartosc_utwory_idutworu_fk FOREIGN KEY (idutworu)
REFERENCES utwory (idutworu) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-END --

-- object: oceny_klienci_idklienta_fk | type: CONSTRAINT --
-- ALTER TABLE oceny DROP CONSTRAINT IF EXISTS oceny_klienci_idklienta_fk CASCADE;
ALTER TABLE oceny ADD CONSTRAINT oceny_klienci_idklienta_fk FOREIGN KEY (idklienta)
REFERENCES klienci (idklienta) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-END --

-- object: oceny_utwory_idutworu_fk | type: CONSTRAINT --
-- ALTER TABLE oceny DROP CONSTRAINT IF EXISTS oceny_utwory_idutworu_fk CASCADE;
ALTER TABLE oceny ADD CONSTRAINT oceny_utwory_idutworu_fk FOREIGN KEY (idutworu)
REFERENCES utwory (idutworu) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-END --