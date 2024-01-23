SET search_path TO spotify;

SELECT * FROM wykonawcy;
SELECT * FROM playlisty NATURAL JOIN zawartosc;

/*
Napisz funkcje o nazwie uzupelnij_playliste która
przyjmuje trzy argumenty: idplaylisty_od
(INT),idplaylisty_do (INT), polub (BOOLEAN). Funkcja
skopiuje z playlisty idplaylisty_od do playlisty
idplaylisty_do utwory, które nie występują na tej drugiej.
Jeżeli parametr polub jest równy TRUE TO dla
skopiowanych utworów funkcja doda oceny pozytywne
(lubi = TRUE), wystawione przez właściciela drugiej
playlisty, ale tylko jeśli jeszcze nie mają od niego ocen.
Funkcja zwraca tabelę zawierającą wszystkie utwory
(wiersze z tabeli utwory) znajdujące się na playliście
idplaylisty_do po operacji kopiowania.
*/

CREATE temporary TABLE zawartosc_tmp
AS SELECT * FROM zawartosc;

CREATE temporary TABLE oceny_tmp
AS SELECT * FROM oceny;

DROP FUNCTION IF EXISTS uzupelnij_playliste(INTEGER, INTEGER, BOOLEAN);
CREATE OR REPLACE FUNCTION uzupelnij_playliste(idplaylisty_od INTEGER, idplaylisty_do INTEGER, polub BOOLEAN)
RETURNS TABLE (
r_idutworu INTEGER,
r_idalbumu INTEGER,
r_nazwa VARCHAR(100),
r_dlugosc INTEGER
) AS
$$
DECLARE
    owner INTEGER;
    r RECORD;
BEGIN
    owner = (SELECT idklienta FROM playlisty WHERE idplaylisty = idplaylisty_do);
    -- ewentulanie tutaj dac EXCEPT (te od UNION, INTERSECT, EXCEPT) 
    FOR r IN SELECT * FROM zawartosc_tmp z WHERE idplaylisty = idplaylisty_od AND z.idutworu NOT IN (SELECT idutworu FROM zawartosc_tmp WHERE idplaylisty = idplaylisty_do)
    LOOP
        INSERT INTO zawartosc_tmp values(idplaylisty_do, r.idutworu);
        -- alternatywnie "WHERE r.idutworu NOT IN ()
        IF polub AND NOT EXISTS(SELECT 1 FROM oceny_tmp WHERE idklienta = owner AND idutworu = r.idutworu) THEN
            INSERT INTO oceny_tmp values(r.idutworu, owner, TRUE);
        END IF;
    END LOOP;

    RETURN QUERY SELECT idutworu, idalbumu, nazwa, dlugosc FROM utwory NATURAL JOIN zawartosc_tmp WHERE idplaylisty = idplaylisty_do;
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM zawartosc WHERE idplaylisty = 1;
SELECT * FROM zawartosc WHERE idplaylisty = 2;
SELECT * FROM oceny_tmp;
SELECT 'a tera jest funkcja i nowa tabela polubien';
SELECT * FROM uzupelnij_playliste(1, 2, TRUE);
SELECT * FROM oceny_tmp;

/*
1.
Napisz funkcje czasTrwania, która jako parametr
przyjmuję idplaylisty (INT) i zwraca czas trwania danej
playlisty
*/

DROP FUNCTION IF EXISTS czasTrwania(INTEGER);
CREATE OR REPLACE FUNCTION czasTrwania(idplaylisty_ INTEGER, OUT czas INTEGER) AS
$$
DECLARE

BEGIN
    SELECT SUM(dlugosc) INTO czas FROM zawartosc NATURAL JOIN utwory WHERE idplaylisty = idplaylisty_; 
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM playlisty NATURAL JOIN zawartosc JOIN utwory USING(idutworu) WHERE idplaylisty = 1;

SELECT czasTrwania(1);

/*
2.
Napisz bezargumentową funkcję max_play która zwróci
idplaylisty (INT) na której znajduje się najwięcej utworów -
jeśli takich playlist jest więcej TO zwróć jeden wynik
*/

CREATE OR REPLACE FUNCTION max_play(OUT idplaylisty_max INTEGER) AS
$$
DECLARE

BEGIN
    SELECT idplaylisty INTO idplaylisty_max FROM zawartosc GROUP BY idplaylisty ORDER BY COUNT(idutworu) DESC LIMIT 1;
END;
$$ LANGUAGE PLPGSQL;
SELECT idplaylisty, COUNT(*) FROM zawartosc GROUP BY idplaylisty ORDER BY COUNT(*) DESC;
SELECT max_play();

/*
3.
Napisz bezargumentową funkcję min_play która zwróci
idplaylist (TABLE) na których znajduje się najmniej
utworów - playlisty mogą BYć puste, wtedy przyjmij że jest
na nich 0 utworów
*/
DROP FUNCTION min_play();
CREATE OR REPLACE FUNCTION min_play() RETURNS TABLE(r_idplaylisty INTEGER, r_ilosc_utworow INTEGER) AS
$$
DECLARE
    MIN INTEGER;
BEGIN
    SELECT coalesce(MIN(cnt), 0) INTO MIN FROM (SELECT COUNT(idutworu) AS cnt FROM playlisty LEFT JOIN zawartosc USING(idplaylisty) GROUP BY idplaylisty);

    RETURN QUERY SELECT idplaylisty, MIN FROM playlisty LEFT JOIN zawartosc USING(idplaylisty) GROUP BY idplaylisty HAVING COUNT(idutworu) = MIN;
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM playlisty LEFT JOIN zawartosc USING(idplaylisty);
SELECT idplaylisty, COUNT(idutworu) FROM playlisty LEFT JOIN zawartosc USING(idplaylisty) GROUP BY idplaylisty;

SELECT * FROM min_play();

/*
4.
Napisz funkcje utwory która przyjmuje nazwę playlisty
(VARCHAR(30)) i zwraca listę utworów (ich nazwy) które
się na niej znajdują
*/
CREATE OR REPLACE FUNCTION utwory_na_playliscie(idplaylisty_ INTEGER) RETURNS TABLE(nazwy_utworow VARCHAR(100)) AS
$$
DECLARE

BEGIN
    RETURN QUERY SELECT nazwa FROM zawartosc NATURAL JOIN utwory WHERE idplaylisty = idplaylisty_;
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM zawartosc NATURAL JOIN utwory;
SELECT * FROM utwory_na_playliscie(2);

/*
5.
Napisz funkcje playlisty która przyjmuję nazwę utworu
i zwraca liczbę playlist na której dany utwór się znajduje -
jeśli nie znajduje się na żadnej funkcja ma zwrócić 0
*/


CREATE OR REPLACE FUNCTION utwor_na_playlistach(nazwa_utworu VARCHAR(100), OUT liczba_playlist INTEGER) AS
$$
DECLARE

BEGIN
    SELECT COUNT(distinct idplaylisty) INTO liczba_playlist FROM utwory NATURAL JOIN zawartosc WHERE nazwa = nazwa_utworu;
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM utwory LEFT JOIN zawartosc USING(idutworu);
SELECT utwor_na_playlistach('Utwor1');
SELECT utwor_na_playlistach('Utwor2');
SELECT utwor_na_playlistach('Utwor6');


/*
6.
Napisz funkcje puste_playlisty która zwraca listę
playlist(ich id) na których nie znajdują się żadne utwory
*/

CREATE OR REPLACE FUNCTION puste_playlisty() RETURNS TABLE(idplaylisty_ INTEGER) AS
$$
DECLARE

BEGIN
    --RETURN QUERY SELECT idplaylisty FROM playlisty p WHERE NOT EXISTS (SELECT 1 FROM zawartosc z WHERE z.idplaylisty = p.idplaylisty);
    RETURN QUERY SELECT idplaylisty FROM playlisty p WHERE idplaylisty NOT IN (SELECT idplaylisty FROM zawartosc);
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM puste_playlisty();

/*
7.
Napisz funkcje utwory_od_do przyjmującą trzy
argumenty: idplaylisty, czas_od, czas_do zwracającą
wszystkie utwory(ich id i nazwę) na podanej playliście
których czas trwania mieści się w zadanych granicach
*/

CREATE OR REPLACE FUNCTION utwory_od_do(idplaylisty_ INTEGER, czas_od INTEGER, czas_do INTEGER) RETURNS TABLE(r_idutworu INTEGER, r_nazwa VARCHAR(100)) AS
$$ 
DECLARE

BEGIN
    RETURN QUERY SELECT idutworu, nazwa FROM zawartosc NATURAL JOIN utwory WHERE idplaylisty = idplaylisty_ AND dlugosc between czas_od AND czas_do;
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM utwory LEFT JOIN zawartosc USING(idutworu) ORDER BY idplaylisty;
SELECT * FROM utwory_od_do(1, 65, 200);
/*
zgadza sie
1, utwor1
8, utwr7
6, utwr 6
*/ 

/*
8.
Napisz funkcje dodaj_utwor, która przyjmuje
argumenty: idutworu, nazwę utworu, idalbumu, dlugosc
utworu oraz nazwę playlisty na której znajdzie się nowo
dodany utwór. Dodaje do utworow przekazany utwór jak i do playlisty.
Funkcja zwraca wszystkie utwory(ich
nazwy) na zaktualizowanej playliście, których długość jest
co najmniej równa długości nowo dodanego utworu.
*/
CREATE temporary TABLE zawartosc_tmp
AS SELECT * FROM zawartosc;

CREATE temporary TABLE utwory_tmp
AS SELECT * FROM utwory;

CREATE OR REPLACE FUNCTION dodaj_utwor(
    idutworu_ INTEGER,
    nazwa_utworu_ VARCHAR(50),
    idalbumu_ INTEGER,
    dlugosc_ INTEGER,
    nazwa_playlisty_ VARCHAR(30)
) RETURNS TABLE(r_nazwy_utworow VARCHAR(50)) AS
$$
DECLARE
    idplaylisty_ INTEGER;
BEGIN
    SELECT idplaylisty INTO idplaylisty_ FROM playlisty WHERE nazwa = nazwa_playlisty_;
    INSERT INTO utwory_tmp(idutworu, nazwa, idalbumu, dlugosc) values(idutworu_, nazwa_utworu_, idalbumu_, dlugosc_);
    INSERT INTO zawartosc_tmp(idutworu, idplaylisty) values(idplaylisty_, idutworu_);

    RETURN QUERY SELECT nazwa
        FROM zawartosc_tmp NATURAL JOIN utwory_tmp u
        WHERE idplaylisty = idplaylisty_
            AND dlugosc >= (SELECT dlugosc FROM utwory_tmp WHERE idutworu = idutworu_);
            -- ew dlugosc >= dlugosc_;
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM dodaj_utwor(11, 'aaaaaa', 1, 90, 'MojaPlaylista1');


/*
9.
Napisz funkcje klienci która przyjmuje loginklienta_od,
funkcja zwraca id wszystkich klientów którzy mają na
swoich playlistach co najmniej jeden utwór pokrywający
się z utworami na playliście klienta o loginie
loginklienta_od i którzy dodatkowo urodzili się po tym jak
klient_od się zarejestrował.
*/

CREATE OR REPLACE FUNCTION klienci(loginklienta_od VARCHAR(50)) RETURNS TABLE(r_id_klientow INTEGER) AS
$$
DECLARE
    id_dawcy INTEGER;
BEGIN
    SELECT idklienta INTO id_dawcy FROM klienci WHERE login = loginklienta_od;

    RETURN QUERY SELECT distinct idklienta FROM klienci
        NATURAL JOIN playlisty
        NATURAL JOIN zawartosc
        WHERE idutworu IN (SELECT idutworu FROM playlisty NATURAL JOIN zawartosc WHERE idklienta = id_dawcy)
        AND data_urodzenia > (SELECT data_urodzenia FROM klienci WHERE idklienta = id_dawcy);
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM klienci('user6');

/*
10.
Napisz funkcje start_od która przyjmuje prefiks i
zwraca dane utworów (idutworu, idalbumu, nazwa,
dlugosc), które się zaczynają od prefiksu
-- jesli po prostu maja zawirac, TO zmienic na ~ prefiks
*/
CREATE OR REPLACE FUNCTION start_od(prefiks VARCHAR(100)) RETURNS SETOF utwory AS
$$
DECLARE

BEGIN
    RETURN QUERY SELECT * FROM utwory WHERE nazwa ~~ (prefiks || '%');
END;
$$ LANGUAGE PLPGSQL;

/*
Pomocnicze
SELECT * FROM utwory;
SELECT * FROM utwory WHERE nazwa ~~ ('Polskie' || '%');
SELECT * FROM utwory WHERE nazwa ~ 'OR';
*/

SELECT * FROM start_od('Polskie');
SELECT * FROM start_od('Utw');

/*
11.
Napisz funkcje kopiuj_avg która przyjmuje dwa
argumenty : nazwaplaylisty_od, nazwaplaylisty_do, która
skopiuje wszystkie utwory które nie występują na
playliście_do, z playlisty_od do playlisty_do, jeśli czas ich
trwania jest większy niż średni czas trwania utworów
(INTEGER) na playliście_do, Funkcja zwraca wszystkie
utwory na playliście_do po procesie kopiowania (idutworu,
idalbumu, nazwa, dlugosc)
*/

CREATE temporary TABLE zawartosc_tmp
AS SELECT * FROM zawartosc;

CREATE OR REPLACE FUNCTION kopiuj_avg(nazwaplaylisty_od VARCHAR(30), nazwaplaylisty_do VARCHAR(30)) RETURNS SETOF utwory AS
$$
DECLARE
    id_playlisty_od INTEGER;
    id_playlisty_do INTEGER;
    sr_czas INTEGER; -- ?? ma byc INTEGER ? NUMERIC(7,2) i w tedy bez rzutowania
BEGIN
    SELECT idplaylisty INTO id_playlisty_od FROM playlisty WHERE nazwa = nazwaplaylisty_od;
    SELECT idplaylisty INTO id_playlisty_do FROM playlisty WHERE nazwa = nazwaplaylisty_do;
    SELECT coalesce(AVG(dlugosc)::INTEGER, 0) INTO sr_czas FROM zawartosc_tmp NATURAL JOIN utwory WHERE idplaylisty = id_playlisty_do;

    INSERT INTO zawartosc_tmp(idplaylisty, idutworu)
    SELECT id_playlisty_do, idutworu FROM utwory
        WHERE
        dlugosc > sr_czas AND
        idutworu NOT IN (SELECT idutworu FROM zawartosc_tmp WHERE idplaylisty = id_playlisty_do); -- albo zamist tego: ON conflict do nothing;
    
    RETURN QUERY SELECT * FROM utwory WHERE idutworu IN (SELECT idutworu FROM zawartosc_tmp WHERE idplaylisty = id_playlisty_do);
END;
$$ LANGUAGE PLPGSQL;

/*
Pomocnicze
SELECT * FROM playlisty;
SELECT idplaylisty FROM playlisty WHERE nazwa = 'ImprezaMix';
SELECT idplaylisty FROM playlisty WHERE nazwa = 'ImprezaMix2';
SELECT AVG(dlugosc), AVG(dlugosc)::INTEGER FROM zawartosc NATURAL JOIN utwory WHERE idplaylisty = 7;
*/

SELECT * FROM kopiuj_avg('Wszystkieee', 'Pusta');
SELECT 'Tera tylko powyzej dlugosci 220';
SELECT * FROM kopiuj_avg('Wszystkieee', 'Jeden 220dlugosc');

SELECT 'A teraz powyzej 150, bo 220+80/2 = 150, 80 jest bo juz byla';
SELECT * FROM kopiuj_avg('Wszystkieee', 'Dwa sr 150');

/*
12.
Napisz funkcję kopiuj_zaczynajace_sie_od która
przyjmuje 3 argumenty : idplaylisty_od,
nazwaplaylisty_do, prefiks (VARCHAR(10)). Funkcja kopiuje
wszystkie utowry, których nazwa zaczyna się od prefiks i
które nie występują na playliście_do, z playlisty_od do
playlisty_do.Funkcja zwraca wszystkie utwory na
playliście_do po procesie kopiowania (idutworu, idalbumu,
nazwa, dlugosc)
*/

CREATE temporary TABLE zawartosc_tmp
AS SELECT * FROM zawartosc;

CREATE OR REPLACE FUNCTION kopiuj_zaczynajace_sie_od(idplaylisty_od INTEGER, nazwa_playlisty_do VARCHAR(30), prefiks VARCHAR(10)) RETURNS SETOF utwory AS
$$
DECLARE
    idplaylisty_do INTEGER;
BEGIN
    SELECT idplaylisty INTO idplaylisty_do FROM playlisty WHERE nazwa = nazwa_playlisty_do;

    INSERT INTO zawartosc_tmp(idplaylisty, idutworu)
    SELECT idplaylisty_do, idutworu FROM utwory
        WHERE 
            nazwa ~ ( '^' || prefiks) AND -- ~~ (prefiks || '%') albo  ~ ( '^' || prefiks) ~ TO jest normalny regrex natomiast ^ TO kotwica poczatku
            -- mozna BY na EXCEPT zamienic zamiast dwoch oddzielnych. lub ON conflict do NOTHING; -- bo i tak musza byc unikatowe
            idutworu IN (SELECT idutworu FROM zawartosc_tmp WHERE idplaylisty = idplaylisty_od) AND
            idutworu NOT IN (SELECT idutworu FROM zawartosc_tmp WHERE idplaylisty = idplaylisty_do);
    RETURN QUERY SELECT * FROM utwory WHERE idutworu IN (SELECT idutworu FROM zawartosc_tmp WHERE idplaylisty = idplaylisty_do);
END;
$$ LANGUAGE PLPGSQL;

/*
SELECT * FROM zawartosc z NATURAL JOIN playlisty p RIGHT JOIN utwory USING(idutworu); 

CREATE temporary TABLE zawartosc_tmp
AS SELECT * FROM zawartosc;
SELECT 1, idutworu FROM utwory
        WHERE 
            nazwa  ~ ( '^' || 'Polsk') AND -- ~ ( '^' || prefiks) ~ TO jest normalny regrex natomiast ^ TO kotwica poczatku
            -- mozna BY na EXCEPT zamienic zamiast dwoch oddzielnych. lub ON conflict do NOTHING; -- bo i tak musza byc unikatowe
            idutworu IN (SELECT idutworu FROM zawartosc_tmp WHERE idplaylisty = 7) AND
            idutworu NOT IN (SELECT idutworu FROM zawartosc_tmp WHERE idplaylisty = 2);
*/
SELECT * FROM kopiuj_zaczynajace_sie_od(7, 'MojaPlaylista2', 'Polsk');


/*
13.1
Napisz funkcje dodaj_utwory_wykonawcy1 która
przyjmuje 2 argumenty: nazwa_wykonawcy,
login_klienta. Funkcja dodaje do każdej playlisty
nazleżącej do klienta o loginie login_klienta utwory
wytępujące na albumach wykonawcy nazwa_wykonawcy -
o ile wcześniej nie znajdują się już na jego playliście.
Album z którego pochodzą utwory musi BYć dodatkowo
wydany przed datą rejestracji klienta. Funkcja zwraca
idplaylist oraz wszystkie utwory na playlistach klienta po
dodaniu do nich utworów (idutworu, idalbumu, nazwa,
dlugosc).
*/


CREATE temporary TABLE zawartosc_tmp
AS SELECT * FROM zawartosc;

CREATE OR REPLACE FUNCTION dodaj_utwory_wykonawcy1(nazwa_wykonawcy_ VARCHAR(100), login_klienta_ VARCHAR(50)) 
RETURNS TABLE(
    r_idplaylisty INTEGER,
    r_idutworu_ INTEGER,
    r_idalbumu_ INTEGER,
    r_nazwa_utworu_ VARCHAR(100),
    r_dlugosc_ INTEGER
) AS
$$
DECLARE
    id_playlisty_var INTEGER;
BEGIN
    FOR id_playlisty_var IN SELECT idplaylisty FROM playlisty WHERE idklienta = (SELECT idklienta FROM klienci WHERE login = login_klienta_)
    LOOP
        INSERT INTO zawartosc_tmp(idplaylisty, idutworu)
        SELECT id_playlisty_var, idutworu FROM utwory JOIN albumy USING(idalbumu)
            WHERE
            idwykonawcy = (SELECT idwykonawcy FROM wykonawcy WHERE nazwa = nazwa_wykonawcy_) AND
            idutworu NOT IN (SELECT idutworu FROM zawartosc_tmp WHERE idplaylisty = id_playlisty_var) AND
            data_wydania < (SELECT data_rejestracji FROM klienci WHERE login = login_klienta_);
    END LOOP;

    RETURN QUERY SELECT idplaylisty, idutworu, idalbumu, nazwa, dlugosc FROM zawartosc_tmp NATURAL JOIN utwory;
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM wykonawcy JOIN albumy USING(idwykonawcy);
SELECT * FROM klienci NATURAL JOIN playlisty;
-- (3, 'Album3', 'Hip-Hop', '2005-10-12'),
-- album 3 wykonawca 3 
-- na pewno nie sa na pustej.
-- data wydania albumu jest 1910 rok, user 6 zarejstrowal sie 1990 roku wiec sie zgadza
-- UPDATE albumy set data_wydania = '1910-01-07' WHERE idalbumu = 3;
SELECT 'przed funkcja: ';
SELECT idplaylisty, idutworu, idalbumu, u.nazwa dlugosc FROM playlisty NATURAL JOIN zawartosc
    JOIN utwory u USING(idutworu) JOIN albumy USING(idalbumu)
    ORDER BY idalbumu;

SELECT 'po funkcji: ';
SELECT * FROM dodaj_utwory_wykonawcy1('Artysta3', 'user6')
ORDER BY r_idalbumu_;








-- tu niby poprawna ???
CREATE temporary TABLE zawartosc_tmp
AS SELECT * FROM zawartosc;

CREATE OR REPLACE FUNCTION dodaj_utwory_wykonawcy11(IN nazwa_wykonawcy
VARCHAR(100), IN login_klienta VARCHAR(50))
RETURNS TABLE(
r_idplaylisty INTEGER,
r_idutworu INTEGER,
r_idalbumu INTEGER,
r_nazwa VARCHAR(100),
r_dlugosc INTEGER
) AS
$$
DECLARE id_k INTEGER;
DECLARE id_w INTEGER;
DECLARE c1 RECORD;
DECLARE c2 RECORD;
BEGIN
id_k := (SELECT idklienta FROM klienci WHERE login = login_klienta);
id_w := (SELECT idwykonawcy FROM wykonawcy WHERE nazwa = nazwa_wykonawcy);
FOR c1 IN SELECT DISTINCT idplaylisty
FROM playlisty p
WHERE p.idklienta = id_k
LOOP
FOR c2 IN SELECT u.idutworu
FROM utwory u
JOIN albumy a USING(idalbumu)
WHERE a.idwykonawcy = id_w
AND NOT EXISTS(SELECT 1 FROM zawartosc_tmp zz WHERE zz.idplaylisty =
c1.idplaylisty AND u.idutworu = zz.idutworu)
AND a.data_wydania < (SELECT data_rejestracji FROM klienci WHERE idklienta
= id_k)
LOOP
INSERT INTO zawartosc_tmp VALUES(c1.idplaylisty, c2.idutworu);
END LOOP;
END LOOP;
RETURN QUERY
SELECT p.idplaylisty, u.idutworu, u.idalbumu, u.nazwa, u.dlugosc
FROM utwory u
JOIN zawartosc_tmp z USING(idutworu)
JOIN playlisty p USING(idplaylisty)
WHERE idklienta = id_k;
END;
$$ LANGUAGE PLPGSQL;


SELECT * FROM dodaj_utwory_wykonawcy11('Artysta3', 'user6')
ORDER BY r_idalbumu;






CREATE temporary TABLE zawartosc_tmp
AS SELECT * FROM zawartosc;

CREATE OR REPLACE FUNCTION func(
	f_nazwa VARCHAR(30),
	f_login VARCHAR(50)
	)
RETURNS TABLE(
	t_idplaylisty INTEGER,
	t_idutworu INTEGER,
	t_idalbumu INTEGER,
	t_nazwa VARCHAR(100),
	t_dlugosc INTEGER
	) AS
$$
DECLARE
v_data DATE;
v_utw RECORD;

BEGIN
v_data := (SELECT data_rejestracji FROM klienci WHERE login = f_login);

FOR v_utw IN(
	SELECT idutworu
	FROM wykonawcy w
	JOIN albumy a USING(idwykonawcy)
	JOIN utwory u USING(idalbumu)
	WHERE w.nazwa = f_nazwa
	AND a.data_wydania < v_data
	)
LOOP
INSERT INTO zawartosc_tmp
SELECT v_utw.idutworu, idplaylisty
FROM playlisty
WHERE idklienta = (SELECT idklienta FROM klienci WHERE login = f_login)
ON conflict do nothing; --  (idutworu, idplaylisty)
END LOOP;

RETURN QUERY
SELECT idplaylisty, idutworu, idalbumu, u.nazwa, dlugosc
FROM utwory u
JOIN zawartosc_tmp USING(idutworu)
JOIN playlisty USING(idplaylisty)
WHERE idklienta = (SELECT idklienta FROM klienci WHERE login = f_login);
END;
$$
LANGUAGE PLPGSQL;
SELECT * FROM func('Artysta3', 'user6');



/*
13.2
Napisz funkcje dodaj_utwory_wykonawcy2 która
przyjmuje 3 argumenty: idwykonawcy, idklienta,
prefiks(VARCHAR(10)). Funkcja dodaje do każdej
playlisty nazleżącej do klienta o id = idklienta, utwory
zaczynające się od prefiks wytępujące na albumach
wykonawcy o id idwykonawcy - o ile wcześniej nie
znajdują się już na jego playliście.Funkcja zwraca
wszystkie utwory na playlistach klienta po dodaniu do nich
utworów (idutworu, idalbumu, nazwa, dlugosc).
*/

-- czy maja byc unikatowe nazwy ?? 

CREATE OR REPLACE FUNCTION dodaj_utwory_wykonawcy2(
    idwykonawcy_ INTEGER,
    idklienta_ INTEGER,
    prefiks VARCHAR(10))
RETURNS SETOF utwory AS
$$
DECLARE -- mozna tez zrobic petla na palylistach, TO jest lepsze podejscie jesli jest wiecej playlist niz utworow.
-- bo TO co jest w forze w selectcie TO tylko raz wykonujemy, wiec lepiej dac tam najbardziej skkomplikowne operajce / zapytanie.
    idutworu_var INTEGER;
BEGIN

-- kopia zapasowa:
    CREATE temporary TABLE zawartosc_tmp
    AS SELECT * FROM zawartosc;

    FOR idutworu_var IN SELECT idutworu FROM utwory u JOIN albumy USING(idalbumu)
        WHERE 
        u.nazwa ~('^' || prefiks) AND
        idwykonawcy = idwykonawcy_
    LOOP -- dla kazdego utworu dodajemy go do playlisty, uzywamy ON
        INSERT INTO zawartosc(idplaylisty, idutworu)
        SELECT idplaylisty, idutworu_var FROM playlisty
            WHERE idklienta = idklienta_
            -- ewentualnie zamiast tego, trzeba BY robic joina z zawartoscia i tam sprawdzac tylu (p byloby aliasem dla playlisty)
            -- AND idutworu_var NOT IN (SELECT idutworu FROM zawartosc z WHERE z.idplaylisty = p.idklaylisty)
            ON conflict do NOTHING;
    END LOOP;

-- distinct czy maja byc unikatowe nazwy ??
    -- RETURN QUERY SELECT distinct u.idutworu, u.idalbumu, u.nazwa, u.dlugosc -- TAK
    RETURN QUERY SELECT u.idutworu, u.idalbumu, u.nazwa, u.dlugosc -- NIE
    FROM utwory u NATURAL JOIN zawartosc JOIN playlisty USING(idplaylisty)
    WHERE idklienta = idklienta_; 

-- sprzatanie:
    DELETE FROM zawartosc;
    INSERT INTO zawartosc SELECT * FROM zawartosc_tmp;
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM dodaj_utwory_wykonawcy2(3, 6, 'Polskie');

/*
14.
Napisz funkcję liczba_z_kraju przyjmującą idplaylisty
oraz kraj. Funkcja zwraca liczbę utworów znajdujących
się na playliście które pochodzą z albumów wydanych w
danym kraju
*/ 

CREATE OR REPLACE FUNCTION liczba_z_kraju(idplaylisty_ INTEGER, kraj_ VARCHAR(30), OUT liczba_utworow INTEGER) AS
$$
DECLARE

BEGIN
    SELECT COUNT(*) INTO liczba_utworow FROM zawartosc
        NATURAL JOIN utwory
        JOIN albumy USING(idalbumu)
        JOIN wykonawcy USING(idwykonawcy)
        WHERE
            idplaylisty = idplaylisty_ AND
            kraj = kraj_;
END;
$$ LANGUAGE PLPGSQL;

-- cala zawartosc playlisty
SELECT * FROM wykonawcy
    JOIN albumy USING(idwykonawcy)
    JOIN utwory USING(idalbumu)
    JOIN zawartosc USING(idutworu)
    WHERE idplaylisty = 7;

-- idplaylisty bedzie taki sam ale tak orientacyjnie aby wiedziec,
-- tu i tak TO na sztywno ustawiamy
SELECT idplaylisty, kraj, COUNT(*) AS ilosc_utworow FROM wykonawcy
    JOIN albumy USING(idwykonawcy)
    JOIN utwory USING(idalbumu)
    JOIN zawartosc USING(idutworu)
    WHERE idplaylisty = 7
    GROUP BY kraj, idplaylisty
    ORDER BY ilosc_utworow DESC;

SELECT liczba_z_kraju(7, 'Polska');


/*
15.
Napisz funkcje
polub_utwory_wykonawcy która przyjmuje
3 argumenty: loginklienta, idwykonawcy,
polub(BOOLEAN). Funkcja dodaje polubienia
do wszystkich utworów znajdujących się na
wszystkich playlistach klienta o loginie
loginklienta (jeśli wartość polub jest
ustawiona na TRUE), ktore należą do
albumów wykonawcy o id = idwykonawcy i
nie zostały wcześniej polubione przez
klienta. Funkcja zwraca wszystkie
polubione utwory z playlist klienta (po
operacji polubienia utworów wykonawców)
(idplaylisty, idutworu, idklienta, lubi)


-- czyli mialy wartosc FALSE lub NULL. 
-- jesli byloby polub = FALSE, no TO w tedy wszystkie bysmy ustawili na FALSE
-- polubione, czyli jesli byly na lubi=FALSE, TO rowniez sie do tego zalicza.
-- wszystko co nie jest lubi=TRUE TO sie zalicza do tego.

i nie zostały wcześniej polubione przez
klienta.
*/

BEGIN;

CREATE OR REPLACE FUNCTION polub_utwory_wykonawcy(loginklienta_ VARCHAR(50), idwykonawcy_ INTEGER, polub BOOLEAN)
RETURNS TABLE(
    r_idplaylisty INTEGER,
    r_idutworu INTEGER,
    r_idklienta INTEGER,
    r_lubi BOOLEAN
) AS
$$
DECLARE
    idklienta_ INTEGER;
BEGIN

-- dodanie kopi zapasowej
    CREATE temporary TABLE oceny_tmp
    AS SELECT * FROM oceny;

    SELECT idklienta INTO idklienta_ FROM klienci WHERE login = loginklienta_;

    -- distinct na idutworu, bo moze byc w wielu playlistach, ale 
    -- i tak dla kazdego tylko jeden raz musimy TO wykonac, inne sa const
    
    -- tutaj np moglem zrobic JOIN albumy
    -- i dac sam waurnek ale co jest bardziej wydane?

    -- optymalizacja czy bardziej sie oplaca rozbic na dwa:
    -- modyfikacja niepolubionych na polubione  
    -- oraz dodanie zypelnie nowych, - wymaga sprawdzenia tych ktorych nie ma, ewentualnie 
    -- ewentualnie "zapisanie" danych ktore sa wyrzucane z EXCEPT, bo w tedy TO moze byloby szybsze.

    -- czy takie podejscie jak ja zrobilem
    INSERT INTO oceny 
    SELECT distinct(idutworu), idklienta_, polub FROM playlisty
        NATURAL JOIN zawartosc
        JOIN utwory USING(idutworu)
        -- JOIN albumy USING(idalbumu) --   ALTERNATYWA
        WHERE
            idklienta = idklienta_ AND
        -- idwykonawcy = idwykonawcy_ --    ALTERNATYWA
            idalbumu IN (SELECT idalbumu FROM albumy
                WHERE idwykonawcy = idwykonawcy_) -- zamiast tego
    ON conflict(idutworu, idklienta) do UPDATE set lubi = polub; -- ta co ma byc wstawiane: EXCLUDED.lubi
-- dajemy ktore kolumny sa odpwoeidzalne za konflikt

    RETURN QUERY SELECT idplaylisty, idutworu, idklienta, lubi FROM klienci
        NATURAL JOIN oceny
        NATURAL JOIN playlisty
        WHERE idklienta = idklienta_;

    
-- sprzatanie:
    DELETE FROM oceny;
    INSERT INTO oceny SELECT * FROM oceny_tmp;

END;
$$ LANGUAGE PLPGSQL;

/*
SELECT * FROM oceny NATURAL JOIN utwory WHERE idklienta = 1;
SELECT * FROM albumy WHERE idalbumu = 1;
*/

SELECT * FROM oceny NATURAL JOIN utwory WHERE idklienta = 1;
SELECT * FROM polub_utwory_wykonawcy('user1', 1, TRUE);

-- do testu aby sprawdzic, czy nie ma zdublowanych wartosci,
-- chcąc sprawdzić, trzeba usunac z funkji "sprzątanie" 
-- ale tu nizej trzeba odkomendowac.

-- SELECT * FROM oceny WHERE idklienta = 1;
-- DELETE FROM oceny;
-- INSERT INTO oceny SELECT * FROM oceny_tmp;

SELECT * FROM oceny NATURAL JOIN utwory WHERE idklienta = 1;

rollback;


/*
INNE INNYM RAZEM XD
*/


/*
