SET search_path TO siatkowka, kwiaciarnia, public;

// Problem, bo zamiast w kwiaciarni mam wszystko w publicu.
ALTER ROLE matrxteo SET search_path TO siatkowka, kwiaciarnia, public, spotify; 


SELECT table_name, table_schema
FROM information_schema.tables ORDER BY table_schema DESC;


SELECT * FROM mecze;
SELECT * FROM czekoladki;
SELECT * FROM czekoladki;

SELECT k.nazwa FROM klienci k;

SELECT *
FROM siatkowka.druzyny;

SELECT nazwa, miasto, nazwisko, imie, numer
FROM siatkowka.druzyny JOIN siatkarki ON nazwisko > 'K' AND miasto < 'M';

SELECT nazwa, miasto, nazwisko, imie, numer
FROM siatkowka.druzyny JOIN siatkowka.siatkarki
ON nazwisko like '%k%' OR nazwa like '%k%';

SELECT nazwisko, imie, nazwa
FROM siatkowka.siatkarki JOIN siatkowka.druzyny USING(iddruzyny)
WHERE pozycja = 'rozgrywająca';

SELECT numer, iddruzySny, nazwisko, imie, punkty
FROM siatkowka.siatkarki JOIN siatkowka.punktujace USING(numer, iddruzyny);

SELECT nazwisko, imie, punkty
FROM siatkowka.siatkarki NATURAL JOIN siatkowka.punktujace;

nazwisko, imie, termin, punkty
SELECT *
FROM siatkowka.siatkarki NATURAL JOIN siatkowka.punktujace NATURAL JOIN siatkowka.mecze
ORDER BY termin;

SELECT d1.nazwa, d2.nazwa, termin
FROM siatkowka.druzyny d1 JOIN siatkowka.mecze ON d1.iddruzyny = gospodarze
JOIN siatkowka.druzyny d2 ON d2.iddruzyny = goscie;

SELECT imie, nazwisko, idmeczu
FROM siatkowka.siatkarki LEFT JOIN siatkowka.punktujace USING(numer, iddruzyny);


SELECT COUNT(*) FROM siatkowka.siatkarki;

SELECT COUNT(*) FROM siatkowka.siatkarki NATURAL JOIN siatkowka.punktujace
WHERE iddruzyny = 'musz' AND idmeczu = 1;

SELECT AVG(punkty) FROM siatkowka.punktujace;
SELECT MAX(punkty) FROM siatkowka.punktujace;
SELECT MIN(punkty) FROM siatkowka.punktujace;

SELECT MIN(punkty) AS minimum, MAX(punkty) AS maksimum FROM siatkowka.punktujace;


SELECT MIN(gospodarze[1]) AS "I set", MIN(gospodarze[2]) AS "II set",
MIN(gospodarze[3]) AS "III set", MIN(gospodarze[4]) AS "IV set",
MIN(gospodarze[5]) AS "V set"
FROM siatkowka.statystyki;


SELECT nazwisko, imie, AVG(punkty), COUNT(distinct punkty)
FROM punktujace NATURAL JOIN siatkarki
WHERE iddruzyny = 'musz'
GROUP BY nazwisko, imie;

SELECT nazwisko, imie,
(SELECT MAX(punkty) FROM punktujace
WHERE punktujace.numer = siatkarki.numer
AND punktujace.iddruzyny = siatkarki.iddruzyny) AS maksimum
FROM siatkarki ORDER BY 3 DESC

SELECT nazwisko, imie, punkty,
(SELECT MAX(punkty)
FROM punktujace
WHERE punktujace.numer = siatkarki.numer
AND punktujace.iddruzyny = siatkarki.iddruzyny) AS maksimum
FROM siatkarki NATURAL JOIN punktujace ORDER BY 1;

SELECT nazwisko, imie, SUM(punkty), nazwa
FROM siatkarki NATURAL JOIN druzyny NATURAL JOIN punktujace
GROUP BY nazwisko, imie, nazwa
HAVING SUM(punkty) > 200
ORDER BY SUM(punkty) DESC;

SELECT nazwisko, imie, SUM(punkty)
FROM siatkarki NATURAL JOIN punktujace
GROUP BY nazwisko, imie
HAVING COUNT(*) > 10
ORDER BY SUM(punkty) DESC;



Zad 3.3
SELECT distinct miejscowosc FROM klienci;
SELECT nazwa, telefon FROM klienci WHERE telefon similar TO '% __';
SELECT nazwa, telefon FROM klienci WHERE telefon similar TO '% ___';



LABY 4:
4.2
SELECT * FROM klienci k JOIN zamowienia z ON z.idklienta=k.idklienta WHERE k.nazwa LIKE '%Antoni';
SELECT * FROM klienci k JOIN zamowienia z ON z.idklienta=k.idklienta WHERE k.ulica LIKE '%/%';
SELECT * FROM klienci k JOIN zamowienia z ON z.idklienta=k.idklienta WHERE k.miejscowosc='Kraków' AND date_part('month', z.datarealizacji) = 11 AND date_part('year', z.datarealizacji) = 2013;

4.3.1
SELECT k.idklienta, k.nazwa, k.ulica, k.miejscowosc, z.datarealizacji FROM klienci k JOIN zamowienia z ON z.idklienta=k.idklienta WHERE z.datarealizacji >= current_date - INTERVAL '5 year';
albo:
SELECT k.idklienta, k.nazwa, k.ulica, k.miejscowosc, z.datarealizacji FROM klienci k JOIN zamowienia z ON z.idklienta=k.idklienta WHERE z.datarealizacji >= DATE '2013-11-30' - INTERVAL '5 year';


4.3.2
SELECT k.idklienta, k.nazwa, k.ulica, k.miejscowosc, z.datarealizacji, p.nazwa FROM klienci k JOIN zamowienia z ON z.idklienta=k.idklienta JOIN artykuly a ON a.idzamowienia=z.idzamowienia JOIN pudelka p ON a.idpudelka=p.idpudelka WHERE p.nazwa IN ('Kremowa fantazja', 'Kolekcja jesienna');
albo: 
SELECT k.idklienta, k.nazwa, k.ulica, k.miejscowosc, z.datarealizacji, a.idpudelka FROM klienci k JOIN zamowienia z ON z.idklienta=k.idklienta JOIN artykuly a ON a.idzamowienia=z.idzamowienia WHERE a.idpudelka IN ('fudg', 'autu');

4.3.3
SELECT k.idklienta, z.idklienta, k.nazwa, k.ulica, k.miejscowosc FROM zamowienia z JOIN klienci k ON z.idklienta=k.idklienta;

4.3.4 ~
SELECT k.idklienta, z.idklienta, k.nazwa, k.ulica, k.miejscowosc FROM zamowienia z LEFT JOIN klienci k ON z.idklienta=k.idklienta;
4.3.5
SELECT * FROM zamowienia z JOIN klienci k ON z.idklienta=k.idklienta WHERE date_part('year', z.datarealizacji) = 2013 AND date_part('month', z.datarealizacji) = 11;
4.3.6
SELECT * FROM klienci k NATURAL JOIN zamowienia z NATURAL JOIN artykuly WHERE (idpudelka IN ('fudg', 'autu') AND sztuk > 1);


SELECT distinct k.nazwa, k.ulica, k.miejscowosc, c.orzechy  FROM klienci k NATURAL JOIN zamowienia z NATURAL JOIN artykuly JOIN zawartosc USING(idpudelka) JOIN czekoladki c USING(idczekoladki) WHERE czekoladki like 'migda_y';


LABY5
5.1.1
SELECT * FROM czekoladki;

SELECT COUNT(*) FROM czekoladki;
5.1.2
SELECT COUNT(nadzienie) FROM czekoladki;

SELECT COUNT(*) FROM czekoladki
WHERE nadzienie IS NOT NULL;

5.1.3
SELECT idpudelka, sztuk FROM zawartosc
ORDER BY sztuk DESC LIMIT 1;
5.1.4
SELECT distinct idpudelka, (SELECT SUM(sztuk) FROM zawartosc z WHERE z.idpudelka = zawartosc.idpudelka) FROM zawartosc
ORDER BY SUM;

SELECT idpudelka, SUM(sztuk) FROM zawartosc
GROUP BY idpudelka
ORDER BY SUM;

5.2.1
SELECT idpudelka, SUM(masa) FROM zawartosc NATURAL JOIN czekoladki
GROUP BY idpudelka;
5.2.2
SELECT idpudelka, SUM(masa) FROM zawartosc NATURAL JOIN czekoladki
GROUP BY idpudelka
ORDER BY SUM DESC LIMIT 1;
5.2.3
SELECT AVG(masa) FROM zawartosc NATURAL JOIN czekoladki;
5.2.4
SELECT idpudelka, AVG(masa)/SUM(sztuk) FROM zawartosc NATURAL JOIN czekoladki
GROUP BY idpudelka;

5.3.1
SELECT datarealizacji, COUNT(*) AS ilosczamowien FROM zamowienia
GROUP BY datarealizacji
ORDER BY datarealizacji;
5.3.2
SELECT COUNT(*) FROM zamowienia;
5.3.3
-- SELECT * FROM zamowienia NATURAL JOIN artykuly NATURAL JOIN pudelka;
-- SELECT idzamowienia, sztuk*cena AS wartosc FROM zamowienia NATURAL JOIN artykuly NATURAL JOIN pudelka;
SELECT SUM(sztuk*cena) FROM zamowienia NATURAL JOIN artykuly NATURAL JOIN pudelka;
5.3.4
SELECT * FROM klienci NATURAL JOIN zamowienia NATURAL JOIN artykuly JOIN pudelka USING(idpudelka)
ORDER BY idklienta;

SELECT idklienta, idzamowienia, (SELECT SUM(sztuk*cena) AS wartosc FROM artykuly a NATURAL JOIN pudelka
WHERE a.idzamowienia = idzamowienia) AS wartosc FROM klienci LEFT JOIN zamowienia USING(idklienta)
--GROUP BY idklienta
ORDER BY idklienta;

SELECT SUM(sztuk*cena) AS wartosc FROM artykuly a NATURAL JOIN pudelka
WHERE a.idzamowienia = 1
GROUP BY idzamowienia;

--SELECT idzamowienia, sztuk, cena FROM artykuly a NATURAL JOIN pudelka
--ORDER BY idzamowienia;

5.4.1
SELECT * FROM zawartosc
ORDER BY idczekoladki, sztuk;

SELECT idczekoladki, COUNT(*) AS ilosc FROM zawartosc
GROUP BY idczekoladki
ORDER BY ilosc DESC LIMIT 1;

SELECT idczekoladki FROM zawartosc
GROUP BY idczekoladki
ORDER BY COUNT(*) DESC LIMIT 1;

5.4.2
SELECT * FROM zawartosc NATURAL JOIN czekoladki
WHERE orzechy IS NULL;

SELECT idpudelka, COUNT(*) FROM zawartosc
GROUP BY idpudelka
ORDER BY COUNT(*) DESC;

SELECT idpudelka, COUNT(*) FROM zawartosc NATURAL JOIN czekoladki
WHERE orzechy IS NULL
GROUP BY idpudelka
ORDER BY COUNT(*) DESC;

SELECT idpudelka FROM zawartosc NATURAL JOIN czekoladki
WHERE orzechy IS NULL
GROUP BY idpudelka
ORDER BY COUNT(*) DESC LIMIT 1;

5.4.3
-- b01 nie jest w zadnym pudelku
SELECT * FROM czekoladki LEFT JOIN zawartosc USING(idczekoladki);


6.1.1
SELECT * FROM czekoladki WHERE idczekoladki = 'W98';
INSERT INTO czekoladki values('W98', 'Biały kieł', 'biała', 'laskowe', 'marcepan', 'Rozpływające się w rękach i kieszeniach', 0.45, 20);

6.1.2
SELECT * FROM klienci;
INSERT INTO klienci values
    (90, 'Matusiak Edward', 'Kropiwnickiego 6/3', 'Leningrad', '31-471', '031 423 45 38'),
    (91, 'Matusiak Alina', 'Kropiwnickiego 6/3', 'Leningrad', '31-471', '031 423 45 38'),
    (92, 'Kimono Franek', 'Karateków 8', 'Mistrz', '30-029', '501 498 324');
SELECT * FROM klienci WHERE idklienta >89;

6.1.3
SELECT * FROM klienci WHERE 
INSERT INTO klienci values(93, 'Matusiak Iza',
    (SELECT ulica FROM klienci WHERE idklienta = 90),
    (SELECT miejscowosc FROM klienci WHERE idklienta = 90),
    (SELECT kod FROM klienci WHERE idklienta = 90),
    (SELECT telefon FROM klienci WHERE idklienta = 90));
SELECT * FROM klienci WHERE nazwa LIKE '%Matusiak%';

SELECT * FROM klienci WHERE idklienta >89;
DELETE FROM klienci WHERE idklienta = 93;
SELECT * FROM klienci WHERE idklienta >89;
INSERT INTO klienci(idklienta, nazwa, ulica, miejscowosc, kod, telefon)
SELECT 93, 'Matusiak Alina', ulica, miejscowosc, kod, telefon
FROM klienci 
WHERE idklienta = 90;
SELECT * FROM klienci WHERE idklienta >89;

6.2
SELECT * FROM czekoladki;
INSERT INTO czekoladki values
    ('X91', 'Nieznana Nieznajoma', NULL, NULL, NULL, 'Niewidzialna czekoladka wspomagajaca odchudzanie.', 0.26, 0),
    ('M98', 'Mleczny Raj', 'Mleczna', NULL, NULL, 'Aksamitna mleczna czekolada w ksztalcie butelki z mlekiem.', 0.26, 36);
SELECT * FROM czekoladki WHERE idczekoladki IN('X91', 'M98');

6.3
DELETE FROM czekoladki WHERE idczekoladki IN('X91', 'M98');

INSERT INTO czekoladki(idczekoladki, nazwa, czekolada, opis, koszt, masa)
values
    ('X91', 'Nieznana Nieznajoma', NULL, 'Niewidzialna czekoladka wspomagajaca odchudzanie.', 0.26, 0),
    ('M98', 'Mleczny Raj', 'Mleczna', 'Aksamitna mleczna czekolada w ksztalcie butelki z mlekiem.', 0.26, 36);
SELECT * FROM czekoladki WHERE idczekoladki IN('X91', 'M98');


6.4.1
SELECT * FROM klienci WHERE idklienta > 89;
UPDATE klienci set nazwa = 'Nowak Iza' 
WHERE idklienta = 93;

6.4.2
SELECT * FROM czekoladki WHERE idczekoladki IN('W98', 'M98', 'X91');
UPDATE czekoladki set koszt = koszt*0.9
WHERE idczekoladki IN('W98', 'M98', 'X91');
SELECT * FROM czekoladki WHERE idczekoladki IN('W98', 'M98', 'X91');

6.4.3
SELECT * FROM czekoladki WHERE idczekoladki IN('W98', 'X91');
UPDATE czekoladki set koszt = (SELECT koszt FROM czekoladki WHERE idczekoladki = 'W98')
WHERE idczekoladki = 'X91';
SELECT * FROM czekoladki WHERE idczekoladki IN('W98', 'X91');

6.4.4
SELECT * FROM klienci WHERE miejscowosc LIKE '%grad%';
UPDATE klienci set miejscowosc = 'Piotrograd'
WHERE miejscowosc LIKE '%eningrad%';
SELECT * FROM klienci WHERE miejscowosc LIKE '%grad%';

6.4.5
SELECT substr(idczekoladki, 2,2)::NUMERIC FROM czekoladki;
SELECT * FROM czekoladki WHERE substr(idczekoladki, 2,2)::NUMERIC > 90;
UPDATE czekoladki set koszt = koszt + 0.15
WHERE substr(idczekoladki, 2,2)::NUMERIC > 90;
SELECT * FROM czekoladki WHERE substr(idczekoladki, 2,2)::NUMERIC > 90;

6.5.1
SELECT * FROM klienci WHERE nazwa LIKE '%Matusiak%';
DELETE FROM klienci WHERE nazwa LIKE '%Matusiak%';
SELECT * FROM klienci WHERE nazwa LIKE '%Matusiak%';

6.5.2
SELECT * FROM klienci WHERE idklienta > 91;
DELETE FROM klienci WHERE idklienta > 91;
SELECT * FROM klienci WHERE idklienta > 91;

6.5.3
SELECT * FROM czekoladki WHERE koszt >=0.45 OR masa >= 36 OR masa = 0;
DELETE FROM czekoladki WHERE koszt >=0.45 OR masa >= 36 OR masa = 0;

6.6
SELECT * FROM pudelka;
id1 = 'new1';
id2 = 'new2';

INSERT INTO pudelka values
    ('new1', 'nazwa1', 'opis1', 100, 149),
    ('new2', 'nazwa2', 'opis2', 200, 249);

SELECT * FROM zawartosc
ORDER BY idczekoladki;

DELETE FROM zawartosc WHERE idpudelka IN('new1', 'new2');
SELECT * FROM zawartosc WHERE idpudelka IN('new1', 'new2');

INSERT INTO zawartosc values
    ('new1', 'b02', 5),
    ('new1', 'b03', 6),
    ('new1', 'b04', 1),
    ('new1', 'm05', 2),

    ('new1', 'd01', 3),
    ('new1', 'd02', 4),
    ('new1', 'd03', 5),
    ('new1', 'd04', 6);
SELECT * FROM zawartosc WHERE idpudelka IN('new1', 'new2');

6.7 

??? 

SELECT * FROM zawartosc WHERE idpudelka IN('new1', 'new2')
COPY TO /;






codeshare - stronka do wrzucania kodu (udostępniania).

dodać dane jakie ma jakiś inny rekord. (wyciągamy kolejne dane). można pozapytaniami, ale można inaczej

INSERT INTO klienci(.....)
SELECT 93, 'Matusiak Alina', ulica, miejscowosc, kod, telefon
FROM klienci 
wehere idkleinta = 90;



SELECT gospodarze[2:3] FROM statystyki LIMIT 5;
SELECT distinct ON (czekolada, koszt) * FROM czekoladki;


SELECT (substr('B', 1, 1) = 'B')::INT;
SELECT ('Basadas' LIKE 'B%')::INT;



INSERT INTO pudelka values
    ('xxx', 'nazwa1', NULL, 100, 149);

SELECT * FROM pudelka WHERE idpudelka = 'xxx';
SELECT COUNT(*) FROM pudelka;
SELECT COUNT(opis) FROM pudelka;




SELECT age(current_date, '2002-01-07');

SELECT * FROM siatkarki
WHERE nazwisko ~ '^[A-C]';


SELECT DATE '2001-10-01' - DATE '2001-09-28';



2.6.1
SELECT idCzekoladki, nazwa, masa, koszt FROM czekoladki
WHERE masa between 15 AND 24 OR koszt between 0.15 AND 0.24;

2.6.2
SELECT idCzekoladki, nazwa, masa, koszt FROM czekoladki
WHERE
    (masa between 15 AND 24 AND koszt between 0.15 AND 0.24)
    OR
    (masa between 25 AND 35 AND koszt between 0.25 AND 0.35);

2.6.4
SELECT idCzekoladki, nazwa, masa, koszt FROM czekoladki
WHERE (masa between 25 AND 35 AND koszt NOT between 0.25 AND 0.35);

2.6.5
SELECT idCzekoladki, nazwa, masa, koszt FROM czekoladki
WHERE (masa between 25 AND 35
AND koszt NOT between 0.15 AND 0.24
AND koszt NOT between 0.25 AND 0.35);

3.1.1
SELECT idZamowienia, dataRealizacji FROM zamowienia
WHERE dataRealizacji BETWEEN '2013-11-12' AND '2013-11-20';
3.1.2
SELECT idZamowienia, dataRealizacji FROM zamowienia
WHERE
    dataRealizacji BETWEEN '2013-12-01' AND '2013-12-06'
 OR dataRealizacji BETWEEN '2013-12-15' AND '2013-12-20';

3.1.3
SELECT idZamowienia, dataRealizacji FROM zamowienia
WHERE
dataRealizacji BETWEEN '2013-12-01' AND '2013-12-31';

SELECT idzamowienia, datarealizacji
FROM zamowienia
WHERE datarealizacji::VARCHAR LIKE '2013-12-__';

3.1.4
SELECT idZamowienia, dataRealizacji FROM zamowienia
WHERE
date_part('year', dataRealizacji) = 2013
AND DATE_PART('month', dataRealizacji) = 11;

SELECT idZamowienia, dataRealizacji FROM zamowienia
WHERE dataRealizacji::VARCHAR like '2013-11-__';



3.1.5
SELECT idzamowienia, datarealizacji
FROM zamowienia
WHERE
date_part('year', datarealizacji) = 2013
AND
date_part('month', datarealizacji) IN (11, 12);

3.1.6
SELECT idZamowienia, dataRealizacji
FROM zamowienia
WHERE date_part('day', dataRealizacji) IN (17, 18, 19);

SELECT idZamowienia, dataRealizacji
FROM zamowienia
WHERE date_part('day', dataRealizacji) between 17 AND 19;


3.1.7
SELECT idZamowienia, dataRealizacji
FROM zamowienia
WHERE date_part('week', dataRealizacji) IN (46, 47);

3.2.1
SELECT idCzekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE nazwa like 'S%';

3.2.4
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE nazwa ~ '^(A|B|C)'

SELECT idCzekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE substr(nazwa, 1, 1) IN ('A', 'B', 'C');

3.2.5
SELECT idCzekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE lower(nazwa) like '%orzech%';

SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE nazwa ILIKE '%orzech%'

3.2.6
SELECT idCzekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE nazwa like 'S%m%';


3.2.7
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE nazwa ~* '(^| )maliny|truskawki'

SELECT idCzekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE nazwa like '%maliny%' OR nazwa like '%truskawki%';

3.2.8
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE nazwa !~ '^[D-KST]'

3.2.9
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE nazwa ilike 's_od%';

3.2.10
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE nazwa NOT like '% %';

3.3.1
SELECT distinct miejscowosc
FROM klienci
WHERE miejscowosc like '% %';

3.3.2
SELECT nazwa, telefon
FROM klienci
WHERE telefon like '% __';

SELECT nazwa, telefon
FROM klienci
WHERE telefon LIKE '___ ___ __ __'

SELECT nazwa, telefon
FROM klienci
WHERE telefon ~ '^[0-9]{3} [0-9]{3} [0-9]{2} [0-9]{2}$'

3.3.3
SELECT nazwa, telefon
FROM klienci
WHERE telefon like '% ___';

SELECT nazwa, telefon
FROM klienci
WHERE telefon LIKE '___ ___ ___'

SELECT nazwa, telefon
FROM klienci
WHERE telefon ~ '^[0-9]{3} [0-9]{3} [0-9]{3}$'

3.4.1
(SELECT idCzekoladki, nazwa, masa, koszt
FROM czekoladki
WHERE masa between 15 AND 24)
UNION
(SELECT idCzekoladki, nazwa, masa, koszt
FROM czekoladki
WHERE koszt between 0.15 AND 0.24);

3.4.2
(SELECT idCzekoladki, nazwa, masa, koszt
FROM czekoladki
WHERE masa between 25 AND 35)
INTERSECT
(SELECT idCzekoladki, nazwa, masa, koszt
FROM czekoladki
WHERE koszt NOT between 0.25 AND 0.35);

3.4.3
(
    (SELECT idczekoladki, nazwa, masa, koszt
    FROM czekoladki
    WHERE masa BETWEEN 15 AND 24)
    INTERSECT
    (SELECT idczekoladki, nazwa, masa, koszt
    FROM czekoladki
    WHERE koszt BETWEEN 0.15 AND 0.24)
)
UNION
(
    (SELECT idczekoladki, nazwa, masa, koszt
    FROM czekoladki
    WHERE masa BETWEEN 25 AND 35)
    INTERSECT
    (SELECT idczekoladki, nazwa, masa, koszt
    FROM czekoladki
    WHERE koszt BETWEEN 0.25 AND 0.35)
)

3.4.4
(SELECT idCzekoladki, nazwa, masa, koszt
FROM czekoladki
WHERE masa between 15 AND 24)
INTERSECT
(SELECT idCzekoladki, nazwa, masa, koszt
FROM czekoladki
WHERE koszt between 0.15 AND 0.24)

3.4.5
(SELECT idCzekoladki, nazwa, masa, koszt
FROM czekoladki
WHERE masa between 25 AND 35)
EXCEPT
(SELECT idCzekoladki, nazwa, masa, koszt
FROM czekoladki
WHERE koszt between 0.15 AND 0.24)
EXCEPT
(SELECT idCzekoladki, nazwa, masa, koszt
FROM czekoladki
WHERE koszt between 0.29 AND 0.35)



9.1

CREATE SCHEMA kwiaciarnia;

CREATE TABLE kwiaciarnia.klienci (
    idklienta VARCHAR(10) NOT NULL,
    haslo   VARCHAR(10) NOT NULL,
    nazwa   VARCHAR(40) NOT NULL,
    miasto  VARCHAR(40) NOT NULL,
    kod     CHAR(6)     NOT NULL,
    adres   VARCHAR(40) NOT NULL,
    email   VARCHAR(40) NOT NULL,
    telefon VARCHAR(16) NOT NULL,
    fax     VARCHAR(16),
    nip     CHAR(13),
    region  CHAR(9),
    CONSTRAINT haslo_min CHECK (length((haslo)::TEXT) > 4)
);

CREATE TABLE kwiaciarnia.zamowienia (
    idzamowienia    INT         NOT NULL,
    idkleinta       VARCHAR(10) NOT NULL,
    idodbiorcy      INT         NOT NULL,
    idkompozycji    CHAR(5)     NOT NULL,
    termin          DATE        NOT NULL,
    cena            NUMERIC(7, 2) NOT NULL,
    zaplacone       BOOLEAN,
    uwagi           VARCHAR(200)
);

CREATE TABLE kwiaciarnia.odbiorcy (
    idodbiorcy  INT         NOT NULL,
    nazwa       VARCHAR(40) NOT NULL,
    miasto      VARCHAR(40) NOT NULL,
    kod         CHAR(6)     NOT NULL,
    adres       VARCHAR(40) NOT NULL
);


CREATE sequence odbiorcy_idodbiorcy_seq
    start with 1
    increment BY 1
    no minvalue
    no maxvalue
    cache 1;

CREATE TABLE kwiaciarnia.kompozycje (
    idkompozycji CHAR(5) NOT NULL,
    nazwa   VARCHAR(40) NOT NULL,
    opis    VARCHAR(100),
    cena    NUMERIC(7, 2),
    minimum INT,
    stan    INT
    CONSTRAINT cena_min CHECK (cena >= 40.00)
);

CREATE TABLE kwiaciarnia.zapotrzebowanie (
    idkompozycji    CHAR(5),
    data            DATE
);

CREATE TABLE kwiaciarnia.historia (
    idzamowienia    INT , NOT NULL,
    idklienta       CHAR(10),
    idkompozycji    CHAR(5),
    cena            NUMERIC(10, 2),
    termin          DATE
);

ALTER TABLE only kwiaciarnia.odbiorcy ALTER column idodbiorcy set DEFAULT
nextval('kwiaciarnia.odbiorcy_idodbiorcy_seq'::regclass) -- ??? 


ALTER TABLE kwiaciarnia.klienci
    add CONSTRAINT klienci_pkey PRIMARY KEY (idklienta);

ALTER TABLE kwiaciarnia.zamowienia
    add CONSTRAINT zamowienia_pkey PRIMARY KEY (idzamowienia);


ALTER TABLE kwiaciarnia.historia
    add CONSTRAINT historia_pkey PRIMARY KEY (idzamowienia);

ALTER TABLE kwiaciarnia.kompozycje
    add CONSTRAINT kompozycje_pkey PRIMARY KEY (idkompozycji);

ALTER TABLE kwiaciarnia.odbiorcy
    add CONSTRAINT odbiorcy_pkey PRIMARY KEY (idodbiorcy);

ALTER TABLE kwiacairnia.zapotrzebowanie
    add CONSTRAINT zapotrzebowanie_pkey PRIMARY KEY (idkompozycji);


ALTER TABLE kwiaciarnia.zamowienia add CONSTRAINT zamowienia_idklienta_fkey FOREIGN KEY (idklienta)
REFERENCES klienci;
ALTER TABLE kwiaciarnia.zamowienia add CONSTRAINT zamowienia_idodbiorcy_fkey FOREIGN KEY (idodbiorcy)
REFERENCES odbiorcy;
ALTER TABLE kwiaciarnia.zamowienia add CONSTRAINT zamowienia_idkompozycji_fkey FOREIGN KEY (idkompozycji)
REFERENCES odbiorcy;

ALTER TABLE kwiaciarnia.zapotrzebowanie add CONSTRAINT zapotrzebowanie_idkompozycji_fkey FOREIGN KEY (idkompozycji)
REFERENCES kompozycje;


9.2
copy kwiaciarnia.kleinci FROM stdin with (delimiter ';', NULL 'BRAK DANYCH');
copy kwiaciarnia.kompozycje FROM stdin with (delimiter ';', NULL 'BRAK DANYCH');
copy kwiaciarnia.odbiorcy FROM stdin with (delimiter ';', NULL 'BRAK DANYCH'); -- ?? tu coś z serialem trzeba dorobic
copy kwiaciarnia.zamowienia FROM stdin with (delimiter ';', NULL 'BRAK DANYCH');
copy kwiaciarnia.historia FROM stdin with (delimiter ';', NULL 'BRAK DANYCH');







10.1
-- bierzemy unikatowe nazwy pudełek, w których znajdują się czekoladki które są jedymi z trzech najdroższych.
-- zwraca 3 rekordy, które są zamieniane na "listę"

-- bierzemy nazwę czekoladki której koszt jest największy - nazwa najdroższej czekoladki.

-- nazwę czekokladek oraz idppudełka w któym wstępuje dla trzech najdroższych czekoladek.

-- nazwa oraz koszt dla wszystkich czekoladek, trzecia kolumna TO maksymalna cena.


-- NATURAL joiny się gubiły, bo BYło więcej kolumn. 


10.2
SELECT * FROM zamowienia JOIN klienci USING(idklienta);

SELECT dataRealizacji, idzamowienia
FROM zamowienia
JOIN klienci USING(idklienta)
WHERE nazwa ~~* '%antoni%';

SELECT * FROM zamowienia JOIN klienci USING(idklienta)
WHERE ulica ~~ '%/%';


SELECT dataRealizacji, idzamowienia FROM zamowienia JOIN klienci USING(idklienta)
WHERE miejscowosc = 'Kraków'
AND dataRealizacji::VARCHAR ~~ '2013-11-__';

10.3.1
SELECT * FROM zamowienia JOIN klienci USING(idklienta);
SELECT nazwa, ulica, miejscowosc, dataRealizacji FROM zamowienia 
JOIN klienci USING(idklienta)
WHERE dataRealizacji = '2013-11-12';

10.3.2
SELECT nazwa, ulica, miejscowosc, dataRealizacji FROM zamowienia 
JOIN klienci USING(idklienta)
WHERE date_part('year', dataRealizacji) = 2013
AND date_part('month', dataRealizacji) = 11;

10.3.3
SELECT * FROM zamowienia 
JOIN klienci USING(idklienta)
WHERE idzamowienia IN (
SELECT idzamowienia FROM artykuly
JOIN pudelka USING(idpudelka) WHERE nazwa IN ('Kremowa fantazja', 'Kolekcja jesienna'));

10.3.4
-- nazwa, ulica, miejscowosc, dataRealizacji
SELECT * FROM zamowienia 
JOIN klienci USING(idklienta)
WHERE idzamowienia IN (
    SELECT idzamowienia FROM artykuly
    WHERE idpudelka IN (SELECT idpudelka FROM pudelka WHERE nazwa IN ('Kremowa fantazja', 'Kolekcja jesienna'))
    AND sztuk > 1);

10.3.5
SELECT * FROM zamowienia JOIN klienci USING(idklienta) WHERE idzamowienia IN (
    SELECT idzamowienia FROM artykuly
    JOIN zawartosc USING(idpudelka)
    JOIN czekoladki USING(idczekoladki)
    WHERE orzechy = 'migdały');

10.3.6
SELECT * FROM klienci WHERE idklienta IN (SELECT idklienta FROM zamowienia);
-- z EXISTS
SELECT k.* FROM klienci k WHERE EXISTS (SELECT z.* FROM zamowienia z WHERE z.idklienta = k.idklienta);

10.3.7
SELECT * FROM klienci WHERE idklienta NOT IN (SELECT idklienta FROM zamowienia);
-- z EXISTS
SELECT k.* FROM klienci k WHERE NOT EXISTS (SELECT z.* FROM zamowienia z WHERE z.idklienta = k.idklienta)


10.4
10.4.1
SELECT p.nazwa, p.opis, p.cena FROM pudelka p
JOIN zawartosc USING(idpudelka)
JOIN czekoladki USING(idczekoladki)
WHERE idczekoladki = 'd09';

10.4.2
SELECT p.nazwa, p.opis, p.cena FROM pudelka p
JOIN zawartosc USING(idpudelka)
JOIN czekoladki c USING(idczekoladki)
WHERE c.nazwa = 'Gorzka truskawkowa';

10.4.3
SELECT p.nazwa, p.opis, p.cena FROM pudelka p
JOIN zawartosc USING(idpudelka)
JOIN czekoladki c USING(idczekoladki)
WHERE c.nazwa IN (SELECT nazwa FROM czekoladki WHERE nazwa ~~ 'S%');



11.1
/*
CREATE FUNCTION masaPudelka(idpudelka CHAR(4)) RETURNS NUMERIC(7,2) AS 
$$
DECLARE
    summasa NUMERIC(7,2) := 0;
    w RECORD;
BEGIN
    FOR w IN SELECT idczekoladki, sztuk FROM zawartosc z WHERE z.idpudelka = idpudelka
    LOOP
        summasa := summasa + w.sztuk * (SELECT masa FROM czekoladki c WHERE c.idczekoladki = w.idczekoladki);
    END LOOP;
    RETURN summasa;
END;
$$
LANGUAGE PLPGSQL
*/

CREATE OR REPLACE FUNCTION masaPudelka2(IN arg1 CHARACTER(4))
RETURNS INTEGER AS
$$
DECLARE 
    wynik INTEGER;
BEGIN
    SELECT SUM(c.masa*z.sztuk) INTO wynik
    FROM
        pudelka p
        JOIN zawartosc z USING (idpudelka)
        JOIN czekoladki c USING (idczekoladki)
    WHERE p.idpudelka = arg1;

    RETURN wynik;
END;
$$ LANGUAGE PLPGSQL;

SELECT masaPudelka2('alls');


11.2
CREATE OR REPLACE FUNCTION zysk(IN idpudelka_ CHAR(4))
RETURNS NUMERIC(7, 2) AS
$$
DECLARE 
    naszKoszt NUMERIC(7,2);
BEGIN
    SELECT SUM(c.koszt * z.sztuk) INTO naszKoszt
    FROM zawartosc z JOIN czekoladki c USING(idczekoladki)
    WHERE z.idpudelka = idpudelka_;

    RETURN (SELECT cena FROM pudelka WHERE idpudelka = idpudelka_) - naszKoszt - 0.90;
    
END;
$$ LANGUAGE PLPGSQL;

SELECT zysk('alls');

SELECT SUM(zysk(idpudelka)*sztuk) FROM zamowienia JOIN artykuly USING(idzamowienia)
WHERE datarealizacji = '2013-10-30';

/* 
SELECT *
    FROM zawartosc z JOIN czekoladki c USING(idczekoladki)
    WHERE z.idpudelka = 'alls';

(SELECT  cena FROM pudelka WHERE idpudelka = 'alls'); 
*/

11.3.1

CREATE OR REPLACE FUNCTION sumaZamowien(IN idklienta_ INTEGER)
RETURNS NUMERIC(7,2) AS
$$
DECLARE
    sumaZamowien_ NUMERIC(7,2);
BEGIN
    SELECT SUM(sztuk * cena) INTO sumaZamowien_
        FROM zamowienia
        JOIN artykuly USING(idzamowienia)
        JOIN pudelka USING(idpudelka)
        WHERE idklienta = idklienta_;

    RETURN sumaZamowien_;
END;
$$ LANGUAGE PLPGSQL;

SELECT sumaZamowien(7);

-- SELECT sztuk, cena FROM zamowienia JOIN artykuly USING(idzamowienia) JOIN pudelka USING(idpudelka) WHERE idklienta = 7;

/*
-- klient co ma najwiecej zamowien,
-- id4 => 6
-- id2 => 4 
-- id3 => 3
-- id7 => 2
-- id8 => 1
SELECT idklienta, COUNT(*) FROM zamowienia GROUP BY idklienta
ORDER BY COUNT(*) DESC; 
*/

11.3.2

CREATE OR REPLACE FUNCTION rabat(IN idklienta_ INTEGER)
RETURNS NUMERIC(7,2) AS
$$
DECLARE
    _wartosc NUMERIC(7,2);
    -- rabat_pr NUMERIC(7,2);
BEGIN
    SELECT sumaZamowien(idklienta_) INTO _wartosc;
    -- RETURN _wartosc * rabat_pr; - rabat TO bylo TO CASE.
    RETURN _wartosc * CASE -- obliczanie rabatu w procentach
            WHEN _wartosc between 101 AND 200 THEN 0.04
            WHEN _wartosc between 201 AND 400 THEN 0.07
            ELSE 0.08
        END CASE;
END;
$$ LANGUAGE PLPGSQL;


-- niby powinno dzialc ale chyba jednak nie
CREATE OR REPLACE FUNCTION rabat(IN idklienta_ INTEGER)
RETURNS NUMERIC(7,2) AS
$$
DECLARE
    _wartosc NUMERIC(7,2);
    -- rabat_pr NUMERIC(7,2);
BEGIN
    SELECT sumaZamowien(idklienta_) INTO _wartosc;
    -- RETURN _wartosc * rabat_pr; - rabat TO bylo TO CASE.
    RETURN _wartosc * CASE _wartosc -- obliczanie rabatu w procentach
            WHEN between 101 AND 200 THEN 0.04
            WHEN between 201 AND 400 THEN 0.07
            ELSE 0.08
        END CASE;
END;
$$ LANGUAGE PLPGSQL;


SELECT sumaZamowien(7);
SELECT rabat(7);

11.4.1
CREATE OR REPLACE FUNCTION podwyzka() RETURNS INTEGER AS
$$
DECLARE
    w RECORD;
    _podwyzka NUMERIC(7,2)
BEGIN
    FOR w IN SELECT * FROM czekoladki
    LOOP
        CASE
            WHEN w.koszt < 20 THEN w.koszt := w.koszt +
    END LOOP;
    
END;
$$ LANGUAGE PLPGSQL;




-- OSTATNIE LABY
-- nie będzie triggerow, 
-- nie bedzie sprowadzania do postaci normalnej.

-- z algebry zależności będzie


-- http://20.123.196.72:9001/p/AGH-MP-LAB12-a
-- LAB12 a

F. zwracac musi abstrakcyjny typ TRIGGER

TRIGGER moze sie odpalić przed lub po akcji

Zwracane typy : NEW, OLD


CREATE TABLE wazne (
    id SERIAL PRIMARY KEY,
    dane TEXT
);

INSERT INTO wazne ( dane) 
VALUES 
    ('Dane 1'), 
    ( 'Dane 2'), 
    ( 'Dane 3');


CREATE TABLE zapas (
    id SERIAL PRIMARY KEY,
    stary_id INT,
    dane TEXT,
    czas TIMESTAMP
);


Cel: TRIGGER, który przy UPDATE tabeli WAZNE przepisze dane do tabeli ZAPAS i doda znacznik czasowy.



CREATE OR REPLACE FUNCTION on_update_wazne()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO zapas(stary_id,dane,  czas)
    VALUES (OLD.id, OLD.dane, CURRENT_TIMESTAMP);
    RETURN OLD; 
END;
$$ LANGUAGE PLPGSQL;



CREATE TRIGGER wazneAfterUpdate
AFTER UPDATE  ON wazne
FOR EACH ROW
EXECUTE FUNCTION on_update_wazne();


CREATE OR REPLACE FUNCTION on_delete_wazne()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO zapas(stary_id,dane,  czas_)
    VALUES (OLD.id, OLD.dane, CURRENT_TIMESTAMP);
    RETURN OLD;
END;
$$ LANGUAGE PLPGSQL;


CREATE TRIGGER wazneAfterDelete
AFTER DELETE ON wazne
FOR EACH ROW
EXECUTE FUNCTION on_delete_wazne();

SELECT * FROM wazne;
UPDATE wazne set dane='poprawione' WHERE id<3;

DROP TRIGGER wazneAfterUpdate ON wazne;
DROP FUNCTION on_update_wazne;
DROP FUNCTION on_delete_wazne;Welcome TO Etherpad!

CREATE OR REPLACE FUNCTION on_update_wazne()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO zapas(stary_id,dane,  czas)
    VALUES (OLD.id, OLD.dane, CURRENT_TIMESTAMP);
    RETURN OLD; 
END;
$$ LANGUAGE PLPGSQL;



CREATE TRIGGER wazneAfterUpdate
AFTER UPDATE  ON wazne
FOR EACH ROW
EXECUTE FUNCTION on_update_wazne();


CREATE OR REPLACE FUNCTION on_delete_wazne()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO zapas(stary_id,dane,  czas_)
    VALUES (OLD.id, OLD.dane, CURRENT_TIMESTAMP);
    RETURN OLD;
END;
$$ LANGUAGE PLPGSQL;


CREATE TRIGGER wazneAfterDelete
AFTER DELETE ON wazne
FOR EACH ROW
EXECUTE FUNCTION on_delete_wazne();

SELECT * FROM wazne;
UPDATE wazne set dane='poprawione' WHERE id<3;

DROP TRIGGER wazneAfterUpdate ON wazne;
DROP FUNCTION on_update_wazne;
DROP FUNCTION on_delete_wazne;Welcome TO Etherpad!


-- http://20.123.196.72:9001/p/AGH-MP-LAB12-b
-- LAB12 b


CREATE TABLE wazne (
    id SERIAL PRIMARY KEY,
    dane TEXT
);

INSERT INTO wazne ( dane) 
VALUES 
    ('Dane 1'), 
    ( 'Dane 2'), 
    ( 'Dane 3');


CREATE TABLE zapas (
    id SERIAL PRIMARY KEY,
    stary_id INT,
    dane TEXT,
    czas TIMESTAMP,
    akcja VARCHAR(20)
);

Cel: TRIGGER ma przepisywać do 'zapas' dane z 'wazne' oraz  komentarz co się działo  ('zmieniony', 'skasowany')
Cel: Można następnie stworzyc jeden TRIGGER implementujący obywdie wersje w jednym bloku kodu.




CREATE OR REPLACE FUNCTION on_update_wazne()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO zapas(stary_id,dane,  czas,akcja)
    VALUES (OLD.id, OLD.dane, CURRENT_TIMESTAMP,'wstawiony');
    RETURN OLD; 
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER wazneAfterUpdate
AFTER UPDATE OR DELETE ON wazne
FOR EACH ROW
EXECUTE FUNCTION on_update_wazne();


CREATE OR REPLACE FUNCTION on_delete_wazne()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO zapas(stary_id,dane,  czas,akcja)
    VALUES (OLD.id, OLD.dane, CURRENT_TIMESTAMP,'usuniety');
    RETURN OLD; 
END;
$$ LANGUAGE PLPGSQL;

DROP TRIGGER wazneAfterDelete ON wazne

CREATE TRIGGER wazneAfterDelete
BEFORE  DELETE ON wazne
FOR EACH ROW
EXECUTE FUNCTION on_delete_wazne();

CREATE TRIGGER wazneAfterInsert
AFTER  DELETE ON wazne
FOR EACH ROW
EXECUTE FUNCTION on_udate_wazne();







CREATE TABLE nowa_tabela (
    nazwa VARCHAR(20),
    numer SERIAL PRIMARY KEY
);

INSERT INTO nowa_tabela VALUES ('ala');

ALTER TABLE nowa_tabela add column 
liczba INTEGER;
ALTER TABLE nowa_tabela add column 
liczba2 INTEGER DEFAULT 2;

ALTER TABLE nowa_tabela ALTER column liczba2 add CHECK(liczba < 18);
ALTER TABLE nowa_tabela ALTER column liczba2 set NOT NULL;
INSERT INTO nowa_tabela values('ola', DEFAULT, NULL, NULL);
ALTER TABLE nowa_tabela ALTER column liczba2 DROP NOT NULL;
INSERT INTO nowa_tabela values('ola', DEFAULT, NULL, NULL);

DELETE FROM nowa_tabela WHERE liczba2 IS NULL;

INSERT INTO nowa_tabela values('ola', DEFAULT, 20, NULL);



INSERT INTO nowa_tabela values('ola', DEFAULT, 20, NULL);

SELECT * FROM nowa_tabela;
UPDATE nowa_tabela set liczba = 20;
-- Sprawdź nazwę ograniczenia CHECK
SELECT constraint_name FROM information_schema.check_constraints
WHERE constraint_name ~ 'pelnoletni';

ALTER TABLE nowa_tabela add CONSTRAINT pelnoletni CHECK(liczba > 18);
ALTER TABLE nowa_tabela DROP CONSTRAINT pelnoletni;
ALTER TABLE nowa_tabela ALTER column liczba set NOT NULL;


CREATE TABLE maz(
    id INTEGER PRIMARY KEY,
    idzony INTEGER
);
CREATE TABLE zona(
    id INTEGER PRIMARY KEY,
    idmeza INTEGER
);
ALTER TABLE maz 
    add FOREIGN KEY(idzony) REFERENCES zona;

ALTER TABLE zona add CONSTRAINT zona_idmeza_fkey
    FOREIGN KEY(idmeza) REFERENCES maz;

ALTER TABLE zona DROP CONSTRAINT FOREIGN KEY(idmeza);

DROP TABLE maz ;

SELECT constraint_name
FROM information_schema.table_constraints
WHERE table_name = 'zona' AND constraint_type = 'FOREIGN KEY';

ALTER TABLE zona DROP CONSTRAINT zona_idmeza_fkey1;


CREATE TABLE dzialy(
    iddzialu    CHAR(5)     PRIMARY KEY,
    nazwa       VARCHAR(32) NOT NULL,
    lokalizacja VARCHAR(23) NOT NULL,
    kierownik   INTEGER     NOT NULL
);

CREATE TABLE pracownicy(
    idpracownika    INTEGER     PRIMARY KEY,
    nazwisko        VARCHAR(32) NOT NULL,
    imie            VARCHAR(16) NOT NULL,
    dataUrodzenia   DATE        NOT NULL,
    dzial           CHAR(5)     NOT NULL,
    stanowisko      VARCHAR(24),
    pobory          NUMERIC(7,2)
);

ALTER TABLE dzialy add CONSTRAINT dzial_fk
    FOREIGN KEY(kierownik) REFERENCES pracownicy(idpracownika) ON UPDATE cascade deferrable;
ALTER TABLE pracownicy add CONSTRAINT pracownicy_fk
    FOREIGN KEY(dzial) REFERENCES dzialy(iddzialu) ON UPDATE cascade deferrable;


SELECT * FROM dzialy;
SELECT * FROM pracownicy;

CREATE schema testowe;
ALTER ROLE matrxteo SET search_path TO testowe; 
CREATE TABLE test(
    INDEX serial PRIMARY KEY
);
-- Sprawdź, czy tabela istnieje w danym schemacie
SELECT table_name, table_schema
FROM information_schema.tables WHERE table_name = 'test';

SELECT * FROM test;
DROP TABLE test;
SELECT table_name, table_schema
FROM information_schema.tables WHERE table_name = 'test';


CREATE TABLE klienci(
    idklienta VARCHAR(10) PRIMARY KEY,
    haslo VARCHAR(10) NOT NULL,
    nazwa VARCHAR(40) NOT NULL,
    miasto VARCHAR(40) NOT NULL,
    kod CHAR(6) NOT NULL,
    adres VARCHAR(40) NOT NULL,
    email VARCHAR(40),
    telefon VARCHAR(16) NOT NULL,
    fax VARCHAR(16),
    nip CHAR(13),
    regon CHAR(9)
);

CREATE TABLE kompozycje(
    idkompozycji CHAR(5) PRIMARY KEY,
    nazwa VARCHAR(40) NOT NULL,
    opic VARCHAR(100),
    cena NUMERIC(7,2),
    minimm INTEGER,
    stan INTEGER
);

CREATE TABLE odbiorcy(
    idodbiorcy serial PRIMARY KEY,
    nazwa VARCHAR(40) NOT NULL,
    miasto VARCHAR(40) NOT NULL,
    kod CHAR(6) NOT NULL,
    adres VARCHAR(40) NOT NULL
);

CREATE TABLE zapotrzebowanie(
    idkompozycji CHAR(5) PRIMARY KEY,
    data DATE
);

CREATE TABLE historia(
    idzamowienia INTEGER PRIMARY KEY,
    idklienta VARCHAR(10),
    idkompozycji CHAR(5),
    cena NUMERIC(7,2),
    termin DATE
);

CREATE TABLE zamowienia(
    idzamowienia INTEGER PRIMARY KEY,
    idklienta VARCHAR(10) NOT NULL,
    idodbiorcy INTEGER NOT NULL,
    idkompozycji CHAR(5) NOT NULL,
    termin DATE NOT NULL,
    cen NUMERIC(7,2),
    zaplacone BOOLEAN DEFAULT FALSE,
    uwagi VARCHAR(200)
);

ALTER TABLE historia add CONSTRAINT historia_fk FOREIGN KEY(idzamowienia) REFERENCES zamowienia(idzamowienia);
ALTER TABLE zapotrzebowanie add CONSTRAINT zapotrzebowanie_fk FOREIGN KEY(idkompozycji) REFERENCES kompozycje(idkompozycji);


ALTER TABLE klienci add CONSTRAINT min_dl_hasla CHECK(length(haslo) >= 4);
ALTER TABLE kompozycje add CONSTRAINT min_cena CHECK(cena >= 40.00);

ALTER TABLE zamowienia
    add CONSTRAINT zamowienia_klient_fk     FOREIGN KEY(idklienta)    REFERENCES klienci(idklienta),
    add CONSTRAINT zamowienia_odbiorca_fk   FOREIGN KEY(idodbiorcy)   REFERENCES odbiorcy(idodbiorcy),
    add CONSTRAINT zamowienia_kompozycja_fk FOREIGN KEY(idkompozycji) REFERENCES kompozycje(idkompozycji);


SELECT constraint_name, constraint_type, table_name
FROM information_schema.table_constraints
WHERE table_name = 'zamowienia';

--gdy dodawany jest zamowienie, sprawdzamy czy mamy tyle na stanie,
--jesli tak TO apceptuejmy, odejmujemy od stanu tyle ile zeszlo, jesli
--spadnie ponizej normy minimum TO dajemy do zapotrzebowania 2*minium? i tyle

-- dorobic

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


ALTER TABLE dostepnosc
	add CONSTRAINT dostepnosc_pk PRIMARY KEY(id_diety, id_dania, data_dostawy),
	add CONSTRAINT dostepnosc_iddiety_fk FOREIGN KEY(id_diety) REFERENCES diety(id_diety),
	add CONSTRAINT dostepnosc_iddania_fk FOREIGN KEY(id_dania) REFERENCES dania(id_dania),
    add CONSTRAINT pora_dnia_c CHECK(pora_dnia IN ('śniadanie', 'drugie śniadanie', 'obiad', 'podwieczorek', 'kolacja')); -- ewentualnie ENUM, lepiej tabele słownikowe

ALTER TABLE dania
	add CONSTRAINT dlugsoc_nazwy_dania_c CHECK(length(nazwa) >= 5);

-- ALTER TABLE dania DROP CONSTRAINT pora_dnia_c;
INSERT INTO dania values(1, 'danie1', 20, 300, 'Polska', FALSE, 20.5);
SELECT * FROM dania;

ALTER TABLE diety add column nazwa VARCHAR(100);
INSERT INTO diety values(1, 'nazwa');
-- DELETE FROM diety WHERE id_diety = 1;

INSERT INTO dostepnosc values(1, 1, '2024-01-20', 'śniadanie');

SELECT * FROM diety;
SELECT * FROM dania;
SELECT * FROM dostepnosc;

INSERT INTO dostepnosc values(1, 1, '2024-01-20', 'śniadaniee'); -- git dziala ograniczenie

-- ===========================================================
-- TEST zad 4b
-- Korzystając z operatorów ANY oraz all (obu) napisz zapytanie SQL pobierające z bazy ID wszystkich
-- dań, które co najmniej raz BYły dostępne na kolację, a które jednocześnie ani razu nie zostały wybrane w
-- roku 2023. Nie używaj złączeń JOIN.
-- ===========================================================

SELECT * FROM dostepnosc;
DELETE FROM dostepnosc;

INSERT INTO dania values
    (1, 'danie1', 1, 100, 'Francja', FALSE, 1.0)
    (2, 'danie2', 2, 200, NULL,      FALSE, 2.0);
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


SELECT * FROM dostepnosc;

-- TF
INSERT INTO dostepnosc values(1, 1, '2023-07-19', 'śniadanie');
INSERT INTO dostepnosc values(1, 1, '2023-07-20', 'kolacja');
-- TT
INSERT INTO dostepnosc values(2, 2, '2024-03-20', 'kolacja');
INSERT INTO dostepnosc values(2, 2, '2024-03-21', 'śniadanie');
-- FT
INSERT INTO dostepnosc values(3, 3, '2019-02-20', 'obiad');
INSERT INTO dostepnosc values(3, 3, '2019-02-22', 'śniadanie');
-- FF
INSERT INTO dostepnosc values(3, 4, '2023-02-20', 'obiad');
INSERT INTO dostepnosc values(3, 4, '2023-02-27', 'śniadanie');

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

CREATE temporary TABLE test(
    id serial
);
INSERT INTO test values
    (DEFAULT),
    (DEFAULT),
    (DEFAULT),
    (DEFAULT);
SELECT * FROM test;

INSERT INTO test values(7);
SELECT * FROM test;


-- Napisz zapytanie które wstawi klienta o loginie poprzedniego klienta
-- o najwyższym id z dopiskiem "ALT", ma mieć id większe o 1, tą samą datę
-- urodzenia i dzisiejszą DATE rejestracji.

CREATE temporary TABLE klienci_t(
    nazwa VARCHAR(50),
    id_klienta serial,
    data_urodzenia DATE,
    data_rejstracji DATE
);
INSERT INTO klienci_t values
    ('Login', 1, '2002-01-07', '2023-01-20'),
    ('Login2', 2, '2002-12-28', '2023-01-21');

SELECT * FROM klienci_t;

INSERT INTO klienci_t
SELECT (nazwa || 'ALT'), (id_klienta+1), data_urodzenia, current_date FROM klienci_t 
WHERE id_klienta = (SELECT MAX(id_klienta) FROM klienci_t);

SELECT * FROM klienci_t;



CREATE temporary sequence seq1;

CREATE temporary TABLE nazwa_tabeli(
    nazwa INTEGER PRIMARY KEY DEFAULT nextval('seq1'),
    znak CHAR
);

INSERT INTO nazwa_tabeli values
(DEFAULT, 'a'),
(DEFAULT, 'b'),
(DEFAULT, 'c'); 

SELECT * FROM nazwa_tabeli;


CREATE temporary TABLE nazwa_tabeli(
    nazwa serial PRIMARY KEY,
    znak CHAR
);

INSERT INTO nazwa_tabeli values
(DEFAULT, 'a'),
(DEFAULT, 'b'),
(DEFAULT, 'c');

SELECT * FROM nazwa_tabeli;

1.
SELECT nazwisko, wiek, pobory*12 AS roczne_pobory FROM pracownicy
ORDER BY roczne_pobory DESC, nazwisko;

2.
SELECT nazwisko, imie, dataUrodzenia, coalesce(stanowisko, 'nie ma'), dzial, pobory
WHERE stanowisko IN ('robotnik', 'analityk')
AND pobory > 2000;

3.
SELECT nazwisko, imie FROM pracownicy 
WHERE
pobory > (SELECT pobory form pracownicy WHERE imie = 'Adam' AND nazwisko = 'Kowalik');

4.
UPDATE pracownicy set pobory = pobory*1.1 WHERE stanowisko = 'robotnik';

5.
SELECT stanowisko, AVG(pobory), COUNT(idpracownika) FROM pracownicy
WHERE stanowisko <> 'kierownik';
GROUP BY stanowisko;



CREATE temporary TABLE dzialy(
    iddzialu CHAR(5) PRIMARY KEY,
    nazwa VARCHAR(32) NOT NULL,
    likalizacja VARCHAR(24) NOT NULL,
    kierownik INTEGER NOT NULL
);



CREATE temporary TABLE pracownicy(
    idpracownika serial PRIMARY KEY,
    nazwisko VARCHAR(32) NOT NULL,
    imie VARCHAR(16) NOT NULL,
    dataUrodzenia DATE NOT NULL,
    dzial CHAR(5) NOT NULL,
    stanowisko VARCHAR(24),
    pobory NUMERIC(10,2)
);

ALTER TABLE pracownicy add CONSTRAINT pracownicy_dzial_fk FOREIGN KEY(dzial) REFERENCES dzialy(iddzialu);
ALTER TABLE dzialy add CONSTRAINT dzialy_kierownik_fk FOREIGN KEY(kierownik) REFERENCES pracownicy(idpracownika);

SELECT * FROM pracownicy;
SELECT * FROM dzialy;


-- sprawdzenie rekurencjynych
CREATE temporary TABLE pracownicy(
    id_pracownika serial PRIMARY KEY,
    id_szefa INTEGER,
    imie VARCHAR(20)
);

ALTER TABLE pracownicy add CONSTRAINT pracownicy_id_szefa_fk
	FOREIGN KEY(id_szefa) REFERENCES pracownicy(id_pracownika);




SELECT nazwa, miasto FROM druzyny d
WHERE EXISTS (SELECT 1 FROM punktujace p NATURAL JOIN siatkarki WHERE p.iddruzyny = d.iddruzyny AND  punkty > 8 AND pozycja = 'rozgrywajaca');

SELECT nazwa, miasto FROM druzyny d
WHERE NOT EXISTS (SELECT 1 FROM punktujace p NATURAL JOIN siatkarki WHERE p.iddruzyny = d.iddruzyny AND punkty > 25);

SELECT * FROM druzyny;
SELECT nazwa, miasto FROM druzyny 
--WHERE iddruzyny IN  (SELECT iddruzyny FROM punktujace WHERE punkty > 25);
WHERE iddruzyny = ANY (SELECT iddruzyny FROM punktujace WHERE punkty > 25);

SELECT * FROM punktujace;

SELECT nazwa, miasto FROM druzyny d
WHERE NOT EXISTS (SELECT 1 FROM punktujace p
    WHERE p.iddruzyny = d.iddruzyny AND punkty > 25);

SELECT idmeczu, termin, SUM(punkty)
FROM punktujace NATURAL JOIN mecze
GROUP BY idmeczu, termin
HAVING SUM(punkty) > (SELECT AVG(pkt)::NUMERIC(5,2) FROM
    (SELECT SUM(punkty) AS pkt FROM punktujace GROUP BY idmeczu ) p );


-- obliczenie sumy punktow dla kazdej druzyny w kazdym meczu.
-- jeden rekord TO jeden mecz i konkretna druzyna
-- nastepnie grupujemy te wyniki po nazwie druzyny, więc w kazdej grupie mamy w kazdym rekordzie
-- ilosc punktow jaka zdobyla druzyna w danym meczu. rekordow jest tyle ile rozgrywek rozegrala dana druzyna.
-- nastepnie w kazdej z grup (czyli dla każdej druzyny) średnią, czyli sumujemy wszytkie punkty i dzielimy
-- przez ilosc rekordow, bo tyle bylo mezcy

-- dostajemy srednia ilosc punktow zdobytych przez kazda z druzyn na jeden mecz.
with x AS (
    SELECT idmeczu, iddruzyny, SUM(punkty) AS pkt
    FROM punktujace
    GROUP BY idmeczu, iddruzyny)

SELECT nazwa, AVG(pkt)::NUMERIC(7,2) srednia
FROM x NATURAL JOIN druzyny
GROUP BY nazwa
ORDER BY srednia DESC;

-- with razem z usuwaniem i zwracaniem wartosci


CREATE TEMPORARY TABLE zamowienia_temp AS
SELECT * FROM zamowienia;

CREATE TEMPORARY TABLE historia_tmp AS
SELECT * FROM historia;

SELECT * FROM zamowienia_temp;
SELECT * FROM historia_tmp;


-- SELECT * FROM zamowienia_temp WHERE datarealizacji = '2013-11-02';
WITH x AS (
    DELETE FROM zamowienia
    WHERE datarealizacji = '2013-11-02' 
    RETURNING *
)

INSERT INTO historia
SELECT idzamowienia, idklienta, idkompozycji, cena, datarealizacji FROM x;

INSERT INTO zamowienia FROM x;



-- oke dziala
SELECT * FROM kompozycje;
INSERT INTO kompozycje values('j02', 'nazwa', 'opis', 40.5, 2, 5);


with p AS (UPDATE kompozycje set cena = cena * 1.1 RETURNING *)
SELECT idkompozycji, nazwa, cena FROM p;

-- ==================================================
-- zmiana typu kolumny uzywajac USING(...)
-- ==================================================

-- SELECT * FROM klienci;

CREATE TEMPORARY TABLE klienci_tmp AS
SELECT * FROM klienci;

--SELECT * FROM klienci_tmp;

--SELECT length(nazwa) FROM klienci_tmp;

ALTER TABLE klienci_tmp add column dlugosc_nazwy INTEGER;

UPDATE klienci_tmp set dlugosc_nazwy = length(nazwa);

-- SELECT * FROM klienci_tmp;

-- wywali, bo nie moze autoamtycznie rzutować
-- ALTER TABLE klienci_tmp ALTER column nazwa type INTEGER;

SELECT * FROM klienci_tmp;

-- mowimy w jaki sposob ma zamienic, uzywa tego co jest w USING. TO co jest w
-- USING ma zwracac typ ktory jest zgodny z nowym typem tutaj zapewnie można też
-- wrzucić funkcję jakąś.

ALTER TABLE klienci_tmp ALTER column nazwa
type INTEGER USING(length(nazwa));

SELECT * FROM klienci_tmp;

-- ================================================================
--                  FUNKCJE RÓŻNE
-- ================================================================

CREATE OR REPLACE FUNCTION suma_zamowien(id_klienta_v INTEGER)
RETURNS NUMERIC(7,2) AS
$$
DECLARE
    suma NUMERIC(7,2);
BEGIN
	SELECT SUM(sztuk*cena) INTO suma
    FROM zamowienia NATURAL JOIN artykuly NATURAL JOIN pudelka
	WHERE idklienta = id_klienta_v;
    RETURN suma;
END;
$$ LANGUAGE PLPGSQL;

SELECT suma_zamowien(7);

CREATE OR REPLACE FUNCTION rabat2(id_klienta_v INTEGER)
RETURNS NUMERIC(7,2) AS
$$
DECLARE
	suma NUMERIC(7,2);
	wartosc_rabatu NUMERIC(7,2);
BEGIN
	SELECT suma_zamowien(id_klienta_v) INTO suma;
	wartosc_rabatu = suma * CASE
        WHEN suma < 75 THEN 0.05
	    WHEN suma between 75 AND 110 THEN 0.07
	    ELSE 0.08
    END CASE;
	RETURN wartosc_rabatu;
END;
$$ LANGUAGE PLPGSQL;
SELECT rabat2(7);

CREATE OR REPLACE FUNCTION rabat2(id_klienta_v INTEGER)
RETURNS NUMERIC(7,2) AS
$$
DECLARE
	suma NUMERIC(7,2);
BEGIN
	SELECT suma_zamowien(id_klienta_v) INTO suma;
	RETURN suma * CASE
        WHEN suma < 75 THEN 0.05
	    WHEN suma between 75 AND 110 THEN 0.07
	    ELSE 0.08
    END CASE;
END;
$$ LANGUAGE PLPGSQL;


SELECT rabat2(7);

CREATE OR REPLACE FUNCTION sumaZamowien(_idklienta INTEGER) RETURNS NUMERIC(7,2) AS
$$
DECLARE
	suma NUMERIC(7,2);
BEGIN
	SELECT SUM(cena*sztuk) INTO suma
        FROM zamowienia
        NATURAL JOIN artykuly
        NATURAL JOIN pudelka
        WHERE idklienta = _idklienta;
	RETURN suma;
END;
$$ LANGUAGE PLPGSQL;

SELECT sumaZamowien(7);


CREATE OR REPLACE FUNCTION testowa(cena NUMERIC(7,2)) RETURNS NUMERIC(7,2) AS
$$
BEGIN
	IF cena < 0.0 THEN
        RAISE EXCEPTION 'nieprawidlowa cena %, %', cena, $1; -- ablo $1 - odwołanie do atrybutow
    ELSE RAISE notice 'licze dla %', cena;
    END IF;
	RETURN cena;
END;
$$ LANGUAGE PLPGSQL;

SELECT testowa(4.4);
SELECT testowa(-4.4);



CREATE OR REPLACE FUNCTION nazwa_funkcji(idklienta_ INTEGER) RETURNS NUMERIC(7,2) AS
$$
DECLARE
	suma NUMERIC(7,2);
BEGIN
	IF (idklienta_ NOT IN (SELECT idklienta FROM klienci)) THEN
        RAISE EXCEPTION 'Nie ma takiego kllienta o id= %', idklienta_;
	END IF;
	
    SELECT SUM(sztuk*cena) INTO suma
    FROM zamowienia
    NATURAL JOIN artykuly
    NATURAL JOIN pudelka
    WHERE idklienta = idklienta_;

	RETURN suma;
END;
$$ LANGUAGE PLPGSQL;

-- SELECT nazwa_funkcji(-1);
SELECT nazwa_funkcji(7);

DROP FUNCTION nazwa_funkcji(INTEGER);

/*
DO $$ 
DECLARE 
    func_name TEXT;
BEGIN 
    FOR func_name IN (SELECT proname FROM pg_proc
    WHERE proowner = (SELECT usesysid FROM pg_user WHERE usename = 'nazwa_uzytkownika')) 
    LOOP 
        EXECUTE 'DROP FUNCTION IF EXISTS ' || func_name || ' CASCADE'; 
    END LOOP;  
END $$;
*/

-- between jest domknięty po obu stronach, w tedy decyduje koleność w CASE. 
-- przy dokładniejszych lepiej normalne < i <=
CREATE OR REPLACE FUNCTION nazwa_funkcji(wartosc INTEGER)
RETURNS NUMERIC(7,2) AS
$$
DECLARE
    wynik NUMERIC(7,2) = 5;
BEGIN
	 wynik = CASE
        WHEN wartosc < 75 THEN 1
        WHEN wartosc >= 75 AND wartosc < 110 THEN 2
        WHEN wartosc >= 110 AND wartosc < 150 THEN 3
	    ELSE 4
    END CASE;
    RETURN wynik;
END;
$$ LANGUAGE PLPGSQL;

SELECT nazwa_funkcji(74); -- 1
SELECT nazwa_funkcji(75); -- 2 
SELECT nazwa_funkcji(76); -- 2 
SELECT nazwa_funkcji(109); -- 2 
SELECT nazwa_funkcji(110); -- 3 
SELECT nazwa_funkcji(111); -- 3
SELECT nazwa_funkcji(149); -- 3
SELECT nazwa_funkcji(150); -- 4 
SELECT nazwa_funkcji(151); -- 4

DROP FUNCTION nazwa_funkcji(INTEGER);


-- testowanie typu RECORD, czy git działa odwołanie jak do tabeli 
-- ogolnie też z with x AS () jest problem, bo nie pamieta po kolejnych zapytaniach 
-- chyba.

SELECT *
        FROM zamowienia
        NATURAL JOIN artykuly
        NATURAL JOIN pudelka
        WHERE idklienta = 7 LIMIT 1;

CREATE OR REPLACE FUNCTION nazwa_funkcji(idklienta_ INTEGER)
RETURNS NUMERIC(7,2) AS
$$
DECLARE
	r RECORD;
BEGIN
	SELECT * INTO r
        FROM zamowienia
        NATURAL JOIN artykuly
        NATURAL JOIN pudelka
        WHERE idklienta = idklienta_ LIMIT 1;
	RETURN r.cena;
END;
$$ LANGUAGE PLPGSQL;
SELECT nazwa_funkcji(7);

DROP FUNCTION nazwa_funkcji(INTEGER);


-- ======================================================
--                  PETLE
-- ======================================================

--=========================================
CREATE OR REPLACE FUNCTION nazwa_funkcji(licznik INTEGER)
RETURNS INTEGER AS
$$
DECLARE
	n INTEGER;
BEGIN
    n = 0;
    <<infinite>>
    LOOP
        n = n+1;
        EXIT infinite WHEN n>=licznik;
    END LOOP;
    RETURN n;
END;
$$ LANGUAGE PLPGSQL;
SELECT nazwa_funkcji(8);
SELECT nazwa_funkcji(15);

DROP FUNCTION nazwa_funkcji(INTEGER);



--=========================================
CREATE temporary TABLE test(
    id INTEGER
);

CREATE OR REPLACE FUNCTION nazwa_funkcji() RETURNS void AS
$$
BEGIN
    FOR i IN 0 .. 10 BY 2 
    LOOP
        INSERT INTO test values(i);
    END LOOP;

END;
$$ LANGUAGE PLPGSQL;

SELECT nazwa_funkcji();

SELECT * FROM test;

DROP FUNCTION nazwa_funkcji();


--=========================================
CREATE temporary TABLE test(
    id NUMERIC(7,2)
);

CREATE FUNCTION nazwa_funkcji() RETURNS void AS 
$$
DECLARE
    w RECORD;
BEGIN 
	FOR w IN UPDATE kompozycje set cena = cena * 1.1 RETURNING *
	LOOP
		INSERT INTO test values(w.cena);
	END LOOP;
END;
$$ LANGUAGE PLPGSQL;

SELECT nazwa_funkcji();
SELECT * FROM test;
DROP FUNCTION nazwa_funkcji();

-- mozna TO szybciej zrobic: 
CREATE temporary TABLE test(
id NUMERIC(7,2)
);
with x AS (UPDATE kompozycje set cena = cena * 1.1 RETURNING *)

INSERT INTO test SELECT x.cena FROM x;



--=========================================
CREATE OR REPLACE FUNCTION nazwa_funckji(idklienta_ INTEGER, OUT suma NUMERIC) AS
$$
BEGIN
	SELECT SUM(sztuk*cena) INTO suma
        FROM zamowienia
        NATURAL JOIN artykuly
        NATURAL JOIN pudelka
        WHERE idklienta = idklienta_;
END;
$$ LANGUAGE PLPGSQL;

SELECT nazwa_funckji(7);

DROP FUNCTION nazwa_funckji(INTEGER);


--=========================================
CREATE temporary TABLE test(
    id INTEGER
);

CREATE FUNCTION nazwa_funkcji() RETURNS void AS 
$$
DECLARE 
    x INTEGER = 0;
BEGIN 
    WHILE x < 10
    LOOP
        INSERT INTO test values(x);
        x = x + 1;
    END LOOP;

END;
$$ LANGUAGE PLPGSQL;

SELECT nazwa_funkcji();
SELECT * FROM test;
DROP FUNCTION nazwa_funkcji();

--=========================================
CREATE temporary TABLE test(
    id INTEGER
);

CREATE FUNCTION nazwa_funkcji() RETURNS void AS
$$
DECLARE 
    w RECORD;
BEGIN
	FOR w IN SELECT * FROM klienci
	LOOP
		INSERT INTO test values(w.idklienta);
	END LOOP;
END;
$$ LANGUAGE PLPGSQL;

SELECT nazwa_funkcji();
SELECT * FROM test;
DROP FUNCTION nazwa_funkcji();

--=========================================
CREATE temporary TABLE test(
    id INTEGER
);

CREATE TEMPORARY TABLE klienci_tmp AS
SELECT * FROM klienci;

SELECT * FROM klienci_tmp;

CREATE FUNCTION nazwa_funkcji() RETURNS void AS
$$
DECLARE 
    w RECORD;
BEGIN
	FOR w IN UPDATE klienci_tmp set idklienta = idklienta + 100, nazwa = 'AAAAA' WHERE idklienta < 40 RETURNING *
	LOOP
		INSERT INTO test values(w.idklienta);
	END LOOP;
END;
$$ LANGUAGE PLPGSQL;

SELECT nazwa_funkcji();
SELECT * FROM test;
DROP FUNCTION nazwa_funkcji();

--=========================================
-- z IF trzeba uwazac i zawsze dawać w WHEN cala logike.
CREATE OR REPLACE FUNCTION nazwa_funkcji(x INTEGER, OUT y INTEGER) AS
$$
BEGIN 
    IF x<10 THEN y = 10;
    elseif x<20 THEN y = 20;
    ELSE y = 30;
    END IF;

END;
$$ LANGUAGE PLPGSQL;

SELECT nazwa_funkcji(14);

DROP FUNCTION nazwa_funkcji();

--=========================================
CREATE OR REPLACE FUNCTION nazwa_funkcji(cena NUMERIC, OUT znizka NUMERIC) AS
$$
BEGIN
	znizka = CASE 
	WHEN cena < 20.0 THEN 0.05
	WHEN cena >= 20.0 AND cena < 40.0 THEN 0.10
	ELSE 2.0
	END CASE; 
END;
$$ LANGUAGE PLPGSQL;

SELECT nazwa_funkcji(25.0);

DROP FUNCTION nazwa_funkcji(NUMERIC);


--=========================================
-- polimorficzne
CREATE OR REPLACE FUNCTION nazwa_funkcji(v1 anyelement,
    v2 anyelement, v3 anyelement, OUT wyjscie anyelement) AS
$$
BEGIN
    wyjscie = v1 + v2 + v3;
END;
$$ LANGUAGE PLPGSQL;
SELECT nazwa_funkcji(1, 2, 3);
SELECT nazwa_funkcji(1.0, 2.0, 3.0);
DROP FUNCTION nazwa_funkcji(anyelement, anyelement, anyelement);

--=========================================
CREATE temporary TABLE wyniki(cos INTEGER, cos2 VARCHAR);

CREATE FUNCTION nazwa_funkcji(x INTEGER, y VARCHAR) RETURNS SETOF wyniki AS
$$
BEGIN
	RETURN NEXT (x, y);
END;
$$ LANGUAGE PLPGSQL;

SELECT nazwa_funkcji(1, 'aaa');

DROP FUNCTION nazwa_funkcji(INTEGER, VARCHAR);

--=========================================

CREATE OR REPLACE FUNCTION suma_zamowien(nazwa VARCHAR(10), dni INTEGER) RETURNS NUMERIC(7,2) AS
$$ 
DECLARE
    w1 NUMERIC(7,2) := 0.0; -- historia
    w2 NUMERIC(7,2) := 0.0; -- aktualne
BEGIN
    SELECT COALESCE(SUM(cena), 0.0) INTO w1 FROM zamowienia WHERE idnadawcy = nazwa; 
    SELECT COALESCE(SUM(cena), 0.0) INTO w2 FROM historia WHERE idnadawcy = nazwa AND termin >= current_date - dni; 

    RETURN w1 + w2;
END;
$$ LANGUAGE PLPGSQL;
DROP FUNCTION suma_zamowien(VARCHAR(10), INTEGER);

--=========================================

-- Zwiększa cenę dla każdej kompozycji, jesli cena jest ponizej 50  TO o 5 zl, 
-- jesli pomiedzy 50 a 100 TO o 10,  inaczej o 20p


SELECT * FROM kompozycje;
INSERT INTO kompozycje values
('t00', 'test0', 'opis', 40.0, 1, 2),
('t01', 'test1', 'opis', 45.0, 1, 2),
('t02', 'test2', 'opis', 50.0, 2, 4),
('t03', 'test3', 'opis', 55.0, 3, 6),
('t04', 'test4', 'opis', 60.0, 4, 8),
('t05', 'test5', 'opis', 120.0, 5, 10);

CREATE temporary TABLE kompozycje_temp AS
SELECT * FROM kompozycje; 
SELECT * FROM kompozycje_temp;

ALTER TABLE kompozycje_temp add column stara_cena NUMERIC;

CREATE OR REPLACE FUNCTION podwyzka() RETURNS void AS
$$
DECLARE
	wiazanka RECORD;
    podwyzka kompozycje.cena%type;
BEGIN 
    FOR wiazanka IN SELECT * FROM kompozycje_temp
    LOOP

        IF wiazanka.cena < 50 THEN podwyzka = 5;
        elseif wiazanka.cena >= 50 AND wiazanka.cena < 100 THEN podwyzka = 10;
        ELSE podwyzka = 20;
        END IF;
        
        UPDATE kompozycje_temp set stara_cena = cena, cena = cena + podwyzka
            WHERE wiazanka.idkompozycji = kompozycje_temp.idkompozycji;
    END LOOP;
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM kompozycje_temp;
SELECT podwyzka();
DROP FUNCTION podwyzka();
SELECT * FROM kompozycje_temp;

--=========================================


-- Zwracanie zbioru rekordów (tabelę) przez funkcję
-- Co się tak naprawdę dzieje, (jak dodawać kolejne wartości do finalnego "wyjścia")?

SELECT * FROM kompozycje;

CREATE TEMPORARY TABLE testowa2(
    id INTEGER,
    id2 INTEGER
);

CREATE OR REPLACE FUNCTION nazwa_funkcji() RETURNS SETOF testowa2 AS
$$
BEGIN
    RETURN QUERY SELECT minimum, minimum FROM kompozycje;
    RETURN NEXT (2, 2);
END;
$$ LANGUAGE PLPGSQL;

-- Wywołanie funkcji i wyświetlenie wyników
SELECT nazwa_funkcji();
SELECT * FROM nazwa_funkcji();

-- Usunięcie funkcji
DROP FUNCTION IF EXISTS nazwa_funkcji();

SELECT * FROM kompozycje;

-- lab 10
-- ================================================

 Napisz zapytanie wyświetlające informacje na temat zamówień
 (dataRealizacji, idzamowienia) używając odpowiedniego operatora
 IN/NOT IN/EXISTS/ANY/all, które:

    zostały złożone przez klienta, który ma na imię Antoni,
    zostały złożone przez klientów z mieszkań (zwróć uwagę na pole ulica),
    ★ zostały złożone przez klienta z Krakowa do realizacji w listopadzie 2013 roku.

SELECT dataRealizacji, idzamowienia  FROM zamowienia
WHERE idklienta = ANY (SELECT idklienta FROM klienci WHERE nazwa ~* 'Antoni');

SELECT dataRealizacji, idzamowienia FROM zamowienia
WHERE idklienta = ANY ( SELECT idklienta FROM klienci WHERE ulica ~* '/');

SELECT dataRealizacji, idzamowienia FROM zamowienia
WHERE idzamowienia = ANY ( SELECT idzamowienia FROM zamowienia WHERE dataRealizacji::VARCHAR ~~ '2013-11-__')
AND idklienta = ANY (SELECT idklienta FROM klienci WHERE miejscowosc = 'Kraków');

-- Klienci, ktorzy zlozyli co najmniej 1 zamowienie (wersja z EXISTS):

SELECT * FROM klienci k WHERE EXISTS (SELECT 1 FROM zamowienia z WHERE k.idklienta = z.idklienta);

-- Klienci, ktorzy nie zlozyli zadnych zamowien (wersja z EXISTS):

SELECT * FROM klienci k WHERE NOT EXISTS (SELECT 1 FROM zamowienia z WHERE k.idklienta = z.idklienta);


-- Wszystkie czekoladki z kremem, ktorych koszt jest wyzszy od kosztu
-- dowolnej czekoladki z truskawkami wystepujacej w pudelku 'alls':

SELECT * FROM czekoladki;

SELECT * FROM czekoladki WHERE nadzienie = 'krem'
AND koszt > ANY (SELECT koszt FROM czekoladki
    NATURAL JOIN zawartosc WHERE nadzienie = 'truskawki' AND idpudelka = 'alls');



-- Wszystkie czekoladki z kremem, ktorych koszt jest wyzszy od kosztu
-- wszystkich czekoladek z truskawkami wystepujacych w pudelku 'alls':

SELECT * FROM czekoladki WHERE nadzienie = 'krem'
AND koszt > all (SELECT koszt FROM czekoladki
    NATURAL JOIN zawartosc WHERE nadzienie = 'truskawki' AND idpudelka = 'alls');



-- LAB 11
/*
11.1
Napisz funkcję masaPudelka wyznaczającą masę pudełka jako
SUMę masy czekoladek w nim zawartych.
Funkcja jako argument przyjmuje identyfikator pudełka.
Przetestuj działanie funkcji na podstawie prostej instrukcji SELECT.
*/
-- DROP FUNCTION masaPudelka(CHAR(4));

CREATE OR REPLACE FUNCTION masaPudelka(idpudelka_ CHAR(4), OUT suma NUMERIC(7,2)) AS
$$
BEGIN
    SELECT SUM(masa*sztuk) INTO suma FROM czekoladki NATURAL JOIN zawartosc
    WHERE idpudelka = idpudelka_;
END;
$$ LANGUAGE PLPGSQL;

SELECT masaPudelka('alls');
 
/*
11.2.1
Napisz funkcję zysk obliczającą zysk jaki cukiernia uzyskuje
ze sprzedaży jednego pudełka czekoladek, zakładając, że zysk
ten jest różnicą między ceną pudełka, a kosztem wytworzenia zawartych
w nim czekoladek i kosztem opakowania (0,90 zł dla każdego pudełka).
Funkcja jako argument przyjmuje identyfikator pudełka. Przetestuj działanie
funkcji na podstawie prostej instrukcji SELECT.
*/

CREATE OR REPLACE FUNCTION zysk(idpudelka_ CHAR(4), OUT zysk NUMERIC(7,2)) AS
$$
DECLARE
    koszta NUMERIC(7,2);
BEGIN
    
    SELECT SUM(koszt*sztuk)+0.9 INTO koszta FROM czekoladki
        NATURAL JOIN zawartosc WHERE idpudelka = idpudelka_;
    SELECT cena-koszta INTO zysk FROM pudelka WHERE idpudelka = idpudelka_;

END;
$$ LANGUAGE PLPGSQL;

SELECT zysk('alls');

/*
11.2.2
Napisz instrukcję SELECT obliczającą zysk
jaki cukiernia uzyska ze sprzedaży pudełek zamówionych w wybranym dniu.
*/

SELECT SUM(zysk(idpudelka)*sztuk) FROM zamowienia NATURAL JOIN artykuly WHERE datarealizacji = '2013-10-30';

/*
11.3.1
Napisz funkcję sumaZamowien obliczającą łączną wartość zamówień złożonych przez klienta,
które czekają na realizację (są w tabeli Zamowienia). Funkcja jako argument przyjmuje
identyfikator klienta. Przetestuj działanie funkcji.
*/
DROP FUNCTION sumaZamowien(INTEGER);

CREATE OR REPLACE FUNCTION sumaZamowien(idklienta_ INTEGER, OUT suma NUMERIC(7,2)) AS
$$
DECLARE

BEGIN
    SELECT SUM(sztuk*cena) INTO suma FROM zamowienia
        NATURAL JOIN artykuly
        NATURAL JOIN pudelka
        WHERE idklienta = idklienta_;
END;
$$ LANGUAGE PLPGSQL;

SELECT sumaZamowien(7);

/*
11.3.2
Napisz funkcję rabat obliczającą rabat jaki otrzymuje klient składający zamówienie.
Funkcja jako argument przyjmuje identyfikator klienta.
Rabat wyliczany jest na podstawie wcześniej złożonych zamówień w sposób następujący:

    4 % jeśli wartość zamówień jest z przedziału 101-200 zł;
    7 % jeśli wartość zamówień jest z przedziału 201-400 zł;
    8 % jeśli wartość zamówień jest większa od 400 zł.
*/
DROP FUNCTION rabat(INTEGER);
CREATE OR REPLACE FUNCTION rabat(idklienta_ INTEGER, OUT wartosc_rabatu NUMERIC(7,2)) AS
$$
DECLARE
    suma_zamowien NUMERIC(7,2);
BEGIN
    SELECT sumaZamowien(idklienta_) INTO suma_zamowien;
    wartosc_rabatu = suma_zamowien * CASE
            WHEN suma_zamowien > 100 AND suma_zamowien <= 200 THEN 0.04
            WHEN suma_zamowien > 200 AND suma_zamowien <= 400 THEN 0.07
            WHEN suma_zamowien > 400 THEN 0.08
            ELSE 1.0
        END CASE;
END;
$$ LANGUAGE PLPGSQL;


--SELECT sumaZamowien(7);
SELECT rabat(7);


/*
11.4


Napisz bezargumentową funkcję podwyzka, która dokonuje podwyżki kosztów produkcji czekoladek o:

    3 gr dla czekoladek, których koszt produkcji jest mniejszy od 20 gr;
    4 gr dla czekoladek, których koszt produkcji jest z przedziału 20-29 gr;
    5 gr dla pozostałych.

Funkcja powinna ponadto podnieść cenę pudełek o tyle o ile zmienił się koszt produkcji zawartych w nich czekoladek.

Przed testowaniem działania funkcji wykonaj zapytania, które umieszczą w plikach dane na temat kosztów czekoladek i cen pudełek tak, aby można BYło później sprawdzić poprawność działania funkcji podwyzka. Przetestuj działanie funkcji.

*/ 

CREATE temporary TABLE czekoladki_temp AS
SELECT * FROM czekoladki;

CREATE temporary TABLE pudelka_temp AS
SELECT * FROM pudelka;

SELECT * FROM czekoladki_temp;
SELECT * FROM pudelka_temp;

CREATE OR REPLACE FUNCTION podwyzka() RETURNS void AS
$$
DECLARE
    r RECORD;
    r2 RECORD;
    zmiana NUMERIC(7,2);
    koszt_czekoladki NUMERIC(7,2);
BEGIN
    FOR r IN SELECT * FROM czekoladki_temp
    LOOP
        koszt_czekoladki = r.koszt;
        zmiana = CASE
                WHEN koszt_czekoladki < 0.2 THEN 0.03
                WHEN koszt_czekoladki between 0.20 AND 0.29 THEN 0.04
                ELSE 0.05
            END CASE;

        UPDATE czekoladki_temp set koszt = koszt + zmiana WHERE idczekoladki = r.idczekoladki; 

        FOR r2 IN SELECT * FROM zawartosc z WHERE z.idczekoladki = r.idczekoladki
        LOOP
            UPDATE pudelka_temp set cena = cena + (r2.sztuk*zmiana) WHERE idpudelka = r2.idpudelka;
        END LOOP;

    END LOOP;
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM czekoladki_temp;
SELECT * FROM pudelka_temp ORDER BY idpudelka;

SELECT podwyzka();

SELECT * FROM czekoladki_temp;
SELECT * FROM pudelka_temp ORDER BY idpudelka;

/*
11.6
Napisz funkcję zwracającą informacje o zamówieniach złożonych przez klienta,
którego identyfikator podawany jest jako argument wywołania funkcji.
W/w informacje muszą zawierać: idzamowienia, idpudelka, datarealizacji.
Przetestuj działanie funkcji. Uwaga: Funkcja zwraca więcej niż 1 wiersz!
*/

-- ten sposob jest niebezpieczny, bo nie zawsze dziala, lepiej normalnie RETURNS TABLE(...)
CREATE temporary TABLE zamowienia_info(
    r_idzamowienia INTEGER,
    r_idpudelka CHAR(4),
    r_datarealizacji DATE
);

SELECT * FROM zamowienia_info;

CREATE OR REPLACE FUNCTION info_o_zamowieniach(idklienta_ INTEGER) RETURNS SETOF zamowienia_info AS
$$
DECLARE
    c RECORD;
BEGIN
    RETURN QUERY SELECT idzamowienia, idpudelka, datarealizacji
        FROM zamowienia NATURAL JOIN artykuly WHERE idklienta = idklienta_;

END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM info_o_zamowieniach(7);


CREATE OR REPLACE FUNCTION info_o_zamowieniach(idklienta_ INTEGER)
RETURNS TABLE(
    r_idzamowienia INTEGER,
    r_idpudelka CHAR(4),
    r_datarealizacji DATE
) AS
$$
DECLARE
    c RECORD;
BEGIN
    RETURN QUERY SELECT idzamowienia, idpudelka, datarealizacji
        FROM zamowienia NATURAL JOIN artykuly WHERE idklienta = idklienta_;

END;
$$ LANGUAGE PLPGSQL;


SELECT * FROM info_o_zamowieniach(7);

DROP FUNCTION info_o_zamowieniach(INTEGER);
/*
11.7
 Napisz funkcję rabat obliczającą rabat jaki otrzymuje klient kwiaciarni
 składający zamówienie. Funkcję utwórz w schemacie kwiaciarnia.
 Rabat wyliczany jest na podstawie zamówień bieżących (tabela zamowienia) i
 z ostatnich siedmiu dni (tabela historia) w sposób następujący:

    5 % jeśli wartość zamówień jest większa od 0 lecz nie większa od 100 zł;
    10 % jeśli wartość zamówień jest z przedziału 101-400 zł;
    15 % jeśli wartość zamówień jest z przedziału 401-700 zł;
    20 % jeśli wartość zamówień jest większa od 700 zł.
*/ 

-- nie mam tej calej bazy danych so ffff
SELECT * FROM zamowienia;

CREATE OR REPLACE FUNCTION rabat_kwiaty(idklienta_ INTEGER, OUT wartosc_rabatu NUMERIC(7,2)) AS
$$
DECLARE
    wartosc_zamowien NUMERIC(7,2);
    wartosc_historii NUMERIC(7,2);
BEGIN
    SELECT coalesce(SUM(cena), 0.0) INTO wartosc_zamowien FROM zamowienia WHERE idklienta = idklienta_;
    SELECT coalesce(SUM(cena), 0.0) INTO wartosc_historii FROM historia WHERE idklienta = idklienta_ AND termin >= current_date - 7;

    wartosc_zamowien = wartosc_zamowien + wartosc_historii;

    wartosc_rabatu = wartosc_zamowien * CASE 
    WHEN wartosc_zamowien > 0 AND wartosc_zamowien <= 100 THEN 0.05
    WHEN wartosc_zamowien > 100 AND wartosc_zamowien <= 400 THEN 0.10
    WHEN wartosc_zamowien > 400 AND wartosc_zamowien <= 700 THEN 0.15
    WHEN wartosc_zamowien > 700 THEN 0.20
    ELSE 1.0
    END CASE;
    

END;
$$ LANGUAGE PLPGSQL;

SELECT rabat_kwiaty(1);


INSERT INTO test (id, name) VALUES
(1, 'test1'),
(2, 'test2')
ON CONFLICT DO NOTHING;


copy zamowienia FROM stdin with (NULL '', delimiter '|');
149|55|2013-12-20
\.

-- przyspieszenie tego, odrazu inserta dajemy.
CREATE temporary TABLE test(
id NUMERIC(7,2)
);

CREATE FUNCTION nazwa_funkcji(cena_ NUMERIC(7,2)) RETURNS void AS
$$
DECLARE
w RECORD;
BEGIN

    with x AS (UPDATE kompozycje set cena = cena * 1.1 WHERE cena > cena_ RETURNING *)
    INSERT INTO test SELECT x.cena FROM x;
END;
$$ LANGUAGE PLPGSQL;

SELECT nazwa_funkcji(60.0);
SELECT * FROM test;
DROP FUNCTION nazwa_funkcji(NUMERIC(7,2));



