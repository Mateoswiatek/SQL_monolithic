-- BY Mateusz Świątek
-- lab 4

CREATE TABLE diety(
    id_diety serial PRIMARY KEY,
    nazwa VARCHAR(150) NOT NULL,
    gluten BOOLEAN NOT NULL,
    laktoza BOOLEAN NOT NULL,
    wege BOOLEAN NOT NULL,
    keto BOOLEAN NOT NULL,
    opakowania_eko BOOLEAN NOT NULL,
    cena_dzien NUMERIC(5,2) NOT NULL
);

CREATE TABLE dania (
    id_dania serial PRIMARY KEY,
    nazwa VARCHAR(255) NOT NULL,
    gramatura INTEGER NOT NULL,
    kalorycznosc INTEGER NOT NULL,
    kuchnia VARCHAR(100),
    wymaga_podgrzania BOOLEAN NOT NULL,
    koszt_produkcji NUMERIC(5,2)
);

CREATE TABLE dostepnosc(
    id_diety INTEGER NOT NULL,
    id_dania INTEGER NOT NULL,
    data_dostawy DATE NOT NULL,
    pora_dnia VARCHAR(100) NOT NULL
);

CREATE TABLE wybory(
    id_zamowienia INTEGER NOT NULL, -- aby potem zamienic CONSTRAINT na ALTER TABLE
    id_dania INTEGER NOT NULL,
    data_dostawy DATE NOT NULL,
    CONSTRAINT wybory_pk PRIMARY KEY(id_zamowienia, id_dania, data_dostawy)
);

-- usuwanie ograniczen
ALTER TABLE dostepnosc
	DROP CONSTRAINT dostepnosc_pk,
	DROP CONSTRAINT dostepnosc_iddiety_fk,
	DROP CONSTRAINT dostepnosc_iddania_fk,
    DROP CONSTRAINT pora_dnia_c;

ALTER TABLE dania
	DROP CONSTRAINT dlugsoc_nazwy_dania_c;

-- usuwanie zawartosci
-- DELETE FROM diety; DELETE FROM dania; DELETE FROM dostepnosc; DELETE FROM wybory;

-- dodawanie ograniczen
ALTER TABLE dostepnosc
	add CONSTRAINT dostepnosc_pk PRIMARY KEY(id_diety, id_dania, data_dostawy),
	add CONSTRAINT dostepnosc_iddiety_fk FOREIGN KEY(id_diety) REFERENCES diety(id_diety),
	add CONSTRAINT dostepnosc_iddania_fk FOREIGN KEY(id_dania) REFERENCES dania(id_dania),
    add CONSTRAINT pora_dnia_c CHECK(pora_dnia IN ('śniadanie', 'drugie śniadanie', 'obiad', 'podwieczorek', 'kolacja')); -- ewentualnie ENUM, lepiej tabele słownikowe

ALTER TABLE dania
	add CONSTRAINT dlugsoc_nazwy_dania_c CHECK(length(nazwa) >= 5);

SELECT * FROM diety;
SELECT * FROM dania;
SELECT * FROM dostepnosc;
SELECT * FROM wybory;

-- INSERT INTO dostepnosc values(1, 1, '2024-01-20', 'śniadaniee'); -- git dziala ograniczenie

-- ===========================================================
-- TEST zad 4b
-- Korzystając z operatorów ANY oraz all (obu) napisz zapytanie SQL pobierające z bazy ID wszystkich
-- dań, które co najmniej raz BYły dostępne na kolację, a które jednocześnie ani razu nie zostały wybrane w
-- roku 2023. Nie używaj złączeń JOIN.
-- ===========================================================

INSERT INTO dania values
    (1, 'danie1', 1, 100, 'Francja', FALSE, 1.0),
    (2, 'danie2', 2, 200, NULL,      FALSE, 2.0),
    (3, 'danie3', 3, 300, 'Polska',  FALSE, 3.0),
    (4, 'danie4', 4, 400, 'Polska',  FALSE, 4.0);

SELECT * FROM dania;

INSERT INTO wybory values
    (1, 1, '2023-07-19'),
    (1, 1, '2023-07-20'),
    (2, 2, '2024-03-20'),
    (2, 2, '2024-03-21'),
    (3, 3, '2019-02-20'),
    (3, 3, '2019-02-22'),
    (4, 4, '2023-02-20'),
    (4, 4, '2023-02-27');

SELECT * FROM wybory;

INSERT INTO diety values
    (1, 'nazwa1'),
    (2, 'nazwa2'),
    (3, 'nazwa3');

SELECT * FROM diety;

INSERT INTO dostepnosc values
    (1, 1, '2023-07-19', 'śniadanie'), -- TF
    (1, 1, '2023-07-20', 'kolacja'),
    (2, 2, '2024-03-20', 'kolacja'), -- TT
    (2, 2, '2024-03-21', 'śniadanie'),
    (3, 3, '2019-02-20', 'obiad'), -- FT
    (3, 3, '2019-02-22', 'śniadanie'),
    (3, 4, '2023-02-20', 'obiad'), -- FF
    (3, 4, '2023-02-27', 'śniadanie');

SELECT * FROM dostepnosc;

-- Pierwszy warunek
SELECT id_dania FROM dostepnosc
WHERE
pora_dnia = 'kolacja';

-- X F: -> te ktore niespelniaja drugiego warunku:
SELECT id_dania FROM wybory WHERE date_part('year', data_dostawy) = 2023;

-- Razem -> tylkok INDEX 2 powinien byc poprawny.

-- ZAD4

SELECT id_dania FROM dostepnosc
WHERE
pora_dnia = 'kolacja'
AND id_dania  != all (SELECT id_dania FROM wybory WHERE date_part('year', data_dostawy) = 2023);