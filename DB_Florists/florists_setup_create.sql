BEGIN;
DROP SCHEMA IF EXISTS florists CASCADE;
CREATE SCHEMA florists;
SET search_path TO florists;

DROP TABLE IF EXISTS klienci CASCADE;
DROP TABLE IF EXISTS zamowienia CASCADE;
DROP TABLE IF EXISTS odbiorcy CASCADE;
DROP TABLE IF EXISTS kompozycje CASCADE;
DROP TABLE IF EXISTS zapotrzebowanie CASCADE;
DROP TABLE IF EXISTS historia CASCADE;


CREATE TABLE klienci (
    idklienta VARCHAR(10) PRIMARY KEY, -- ew przerobic na inta i rzutowanie jako domylsna wartosc
    haslo VARCHAR(10) NOT NULL,
    nazwa VARCHAR(40) NOT NULL,
    miasto VARCHAR(40) NOT NULL,
    kod VARCHAR(6) NOT NULL,
    adres VARCHAR(40) NOT NULL,
    email VARCHAR(40),
    telefon VARCHAR(16) NOT NULL,
    fax VARCHAR(16),
    nip CHAR(13),
    regon CHAR(9)
);

CREATE TABLE kompozycje (
    idkompozycji CHAR(5) PRIMARY KEY,
    nazwa VARCHAR(40) NOT NULL,
    opis VARCHAR(100),
    cena NUMERIC(7,2),
    minimum INTEGER,
    stan INTEGER
);

CREATE TABLE odbiorcy (
    idodbiorcy SERIAL PRIMARY KEY,
    nazwa VARCHAR(40) NOT NULL,
    miasto VARCHAR(40) NOT NULL,
    kod CHAR(6) NOT NULL,
    adres  VARCHAR(40)
);


CREATE TABLE zamowienia (
    idzamowienia SERIAL PRIMARY KEY,
    idklienta VARCHAR(10) NOT NULL,
    idodbiorcy INTEGER NOT NULL,
    idkompozycji CHAR(5) NOT NULL,
    termin DATE NOT NULL,
    cena NUMERIC(7,2),
    zaplacone BOOLEAN,
    uwagi VARCHAR(200)
);

CREATE TABLE historia (
    idzamowienia INTEGER PRIMARY KEY,
    idklienta VARCHAR(10),
    idkompozycji CHAR(5),
    cena NUMERIC(7,2),
    termin DATE
);

CREATE TABLE zapotrzebowanie (
    idkompozycji CHAR(5) PRIMARY KEY,
    data DATE
);


ALTER TABLE klienci
    ADD CONSTRAINT klienci_min_haslo CHECK(length(haslo) >= 4);

ALTER TABLE kompozycje
    ADD CONSTRAINT kompozycje_min_cena CHECK(cena >= 40.00);

ALTER TABLE zamowienia
    ADD CONSTRAINT zamowienia_idklienta_fk FOREIGN KEY(idklienta) REFERENCES klienci(idklienta) ON UPDATE cascade,
    ADD CONSTRAINT zamowienia_idodbiorcy_fk FOREIGN KEY(idodbiorcy) REFERENCES odbiorcy(idodbiorcy) ON UPDATE cascade,
    ADD CONSTRAINT zamowienia_idkompozycji_fk FOREIGN KEY(idkompozycji) REFERENCES kompozycje(idkompozycji) ON UPDATE cascade;

ALTER TABLE zapotrzebowanie
    ADD CONSTRAINT zapotrzebowanie_idkompozycji_fk FOREIGN KEY(idkompozycji) REFERENCES kompozycje(idkompozycji) ON UPDATE cascade;


COMMIT;