-- Napisz zapytanie SQL które wyświetla idwykonawcy którego utwory lubi użytkownik jim. Usuń duplikaty
-- Write an SQL QUERY that displays the artist ID of whose songs user jim likes. Remove duplicates
SELECT DISTINCT idwykonawcy
    FROM klienci nautral
    JOIN oceny
    JOIN utwory USING(idutworu)
    JOIN albumy USING(idalbumu)
    WHERE
        lubi = TRUE
        AND login = 'jim';


-- Napisz zapytanie SQL które wyswietla nazwę utworu i ile razy dany utwor zostal polubiony(Jest TRUE w "lubi" ) i posortuje wedlug wartosci polubien malejaco 
-- Write an SQL QUERY that displays the name of the song AND how many times the song has been liked (It IS TRUE IN "likes") AND sort BY the value of likes IN descending ORDER
SELECT nazwa, COUNT(lubi) AS suma
    FROM utwory
    LEFT JOIN oceny USING(idutworu)
    WHERE lubi = TRUE
    GROUP BY nazwa, idutworu
    ORDER BY suma;

-- OR

SELECT nazwa, coalesce(SUM(lubi::INT), 0) AS suma
    FROM utwory
    LEFT JOIN oceny USING(idutworu)
    GROUP BY idutworu
    ORDER BY suma;


-- Napisz zapytanie SQL, które wyświetla nazwy wykonawców którzy mają albumy z ostatnich 2 lat. usuń duplikaty
-- Write an SQL QUERY that displays the names of artists who have albums FROM the last 2 years. remove duplicates
SELECT DISTINCT w.nazwa
    FROM wykonawcy w
    JOIN albumy USING(idwykonawcy)
    WHERE data_wydania > current_date - INTERVAL '2 years';


-- Napisz zapytanie SQL, które wyświetla loginy klientów, którzy mają w playlistach utwory o dlugosci mniejszej niż 300 i z albumów nie starszych niż 2 lata. 
-- Write an SQL QUERY that displays the logins of customers who have songs IN their playlists that are less than 300 long AND FROM albums that are less than 2 years OLD.
SELECT DISTINCT login
    FROM klienci
    JOIN playlisty  USING(idklienta)
    NATURAL JOIN zawartosc
    JOIN utwory     USING(idutworu)
    JOIN albumy     USING(idalbumu)
    WHERE
        dlugosc < 300
        data_wydania > current_date - INTERVAL '2 years';


-- Napisz zapytanie SQL które policzy wszystkie utwory z playlist użytkowników. Ma wyświetlać login klienta i liczę utworów zapisanych w playlistach.
-- Write an SQL QUERY that will COUNT all songs FROM users' playlists. It IS supposed TO display the client's login AND the number of songs saved IN playlists.
SELECT login, COUNT(DISTINCT idutworu)
    FROM klienci
    LEFT JOIN playlisty USING(idklienta)
    JOIN zawartosc      USING(idplaylisty)
    GROUP BY login
    ORDER BY login;


--Napisz zapytanie które wyswietli nazwe wykonawcow i ile polubien oni zdobyli, jak wykonawca nie zdobyl polubień TO wtedy 0.
--Write a QUERY that will display the name of the artists AND how many likes they got, IF the artist did NOT get ANY likes, THEN 0.
SELECT w.nazwa, coalesce(SUM(lubi::INT), 0)
    FROM oceny
    NATURAL JOIN utwory
    JOIN albumy      USING (idalbumu)
    JOIN wykonawcy w USING (idwykonawcy)
    GROUP BY w.nazwa; 


-- Napisz zapytanie które wstawi klienta o loginie poprzedniego klienta o najwyższym id z dopiskiem "ALT", ma mieć id większe o 1, tą samą datę urodzenia i dzisiejszą DATE rejestracji.
-- Write a QUERY that will INSERT a client with the login of the previous client with the highest id with the note "ALT",
-- it should have an id greater than 1, the same DATE of birth AND today's registration DATE.
INSERT INTO klienci
    SELECT idklienta + 1, login || 'ALT', current_date, data_urodzenia
    FROM klienci
    WHERE idklienta = (SELECT MAX(idklienta) FROM klienci);


-- Wyświetl wszystkie utwory o długości powyżej średniej długości utworów w bazie.
-- Display all songs with a length above the average length of songs IN the database.
SELECT *
    FROM kolokwium1.utwory
    WHERE dlugosc > (SELECT AVG(dlugosc) FROM kolokwium1.utwory);


-- Znajdź najdłuższy utwór w bazie danych.
-- Find the longest song IN the database.
SELECT *
    FROM kolokwium1.utwory
    WHERE dlugosc = (SELECT MAX(dlugosc) FROM kolokwium1.utwory);
-- OR
SELECT *
    FROM utwory
    ORDER BY dlugosc DESC LIMIT 1;


-- Wybierz wszystkie utwory / ocenione przez danego klienta jako "lubię". O podanym id oraz ogólnie (tutaj tylko liczbę), każdy numer id i liczba polubionych utworów.
-- SELECT all songs / rated BY a given customer AS "likes". About the given id AND IN general (here only the number), each id number AND the number of liked songs.
SELECT *
    FROM kolokwium1.oceny
    WHERE
        idklienta = 3
        AND lubi = TRUE;
-- OR
SELECT idklienta, COUNT(idutworu)
    FROM oceny
    WHERE lubi = TRUE
    GROUP BY idklienta;


-- Znajdź wszystkich artystów o debiucie od 2015 roku.
-- Find all debuting artists since 2015.
SELECT *
    FROM wykonawcy
    WHERE data_debiutu >= '2015-01-01';
-- OR
SELECT *
    FROM wykonawcy
    WHERE date_part('year', data_debiutu) >= 2015;


-- Policz, ile utworów znajduje się w każdym albumie
-- COUNT how many songs are IN each album
SELECT idalbumu, COUNT(idutworu)
    FROM albumy jon utwory USING(idalbumu)
    GROUP BY idalbumu;


-- Policz, ile utworów znajduje się w każdej playliście. (bo może BYć playlista bez zawartości, dlatego jest LEFT JOIN)
-- COUNT how many songs are IN each playlist. (because there can be a playlist without content, that's why it's LEFT JOIN)
SELECT idplaylisty, COUNT(*) AS liczba_utworow
    FROM playlisty
    LEFT JOIN zawartosc
    GROUP BY idplaylisty;


-- Znajdź klientów, którzy nie ocenili żadnego utworu.
-- Find customers who have NOT rated ANY songs.
(SELECT idklienta FROM klienci)
EXCEPT
(SELECT idklienta FROM oceny);
-- OR
SELECT *
    FROM kolokwium1.klienci
    WHERE idklienta NOT IN (SELECT DISTINCT idklienta FROM kolokwium1.oceny);


-- Wybierz wszystkie albumy wydane w danym roku. 
-- SELECT all albums released IN a given year.
SELECT *
    FROM albumy
    WHERE date_part('year', data_wydania) = 2015;


-- Znajdź najpopularniejszy gatunek muzyczny (najwięcej albumów).
-- Find the most popular music genre (most albums).
SELECT gatunek, COUNT(*) AS ilosc
    FROM albumy
    GROUP BY albumy
    ORDER BY ilosc DESC
    LIMIT 1;


-- Policz, ile utworów jest w każdej playliste danego klienta. 
-- COUNT how many songs are IN each customer's playlist.
SELECT idklienta, idplaylisty, COUNT(*) AS iloscUtworow
    FROM klienci
    NATURAL JOIN playlisty
    LEFT JOIN zawartosc USING(idplaylisty);
    GROUP BY idklienta, idplaylisty;


-- Znajdź wszystkich wykonawców, których debiut miał miejsce przed rokiem 1990.
-- Find all artists who debuted before 1990.
SELECT *
    FROM wykonwacy
    WHERE date_part('year', data_debiutu) < 1990;


-- Policz, ile albumów zostało wydanych przez każdego wykonawcę.
--COUNT how many albums were released BY each artist.
SELECT idwykonawcy, COUNT(idalbumu) AS liczba_albumow
    FROM wykonawcy
    LEFT JOIN albumy USING(idwykonawcy)
    GROUP BY idwykonwacy;


-- Dla każdego utworu, liczbę playlist w których występuje.
-- FOR each song, the number of playlists it appears IN.
SELECT idutworu, COUNT(*)
    FROM zawartosc
    GROUP BY idutworu;


-- Znajdź średnią ocenę danego utworu.
-- Find the average rating of a given song.
SELECT nazwa, COALESCE(AVG(lubi::INT), 0.5) 
    FROM utwory
    LEFT JOIN oceny USING(idutworu)
    GROUP BY idutworu, nazwa;
--OR, tu moze byc problem z tymi ktore nie maja oceny. there may be a problem with those who don't have a rating
SELECT nazwa, (SELECT COALESCE(AVG(lubi::INT), 0.5) FROM oceny o WHERE o.idutworu = u.idutworu)
    FROM utwory u;


--Zlicz ile albumów zostało wydanych w każdym z roków.
--COUNT how many albums were released IN each year.
SELECT date_part('year', data_wydania) AS rok, COUNT(*)
    FROM albumy
    GROUP BY rok;




-- =======================================================================
-- =======================================================================
-- =======================================================================
-- =======================================================================
-- =======================================================================
-- =======================================================================
--                               KOLOS 2
-- =======================================================================
-- =======================================================================
-- =======================================================================
-- =======================================================================
-- =======================================================================
-- =======================================================================


/*
Napisz zapytania SQL tworzące w bazie tabele albumy i wykonawcy
(patrz: załączony schemat).
Zadbaj o utworzenie właściwych kluczy głównych i kluczy obcych
(mogą BYć częścią zapytań CREATE lub
stanowić odrębne zapytania typu ALTER).


Dodatkowo nałóż ograniczenia na kolumny, aby login klienta
miał co najmniej 5 znaków oraz gatunek albumu mógł przyjmować
tylko jedną z wartości: ’Rock’, ’Pop’,
’Metal’
*/


CREATE TABLE albumy(
    idalbumu serial PRIMARY KEY, -- serial robi TO za mnie, ale alternatywnie CREATE sequence seq1, i tutaj INTEGER PRIMARY KEY DEFAULT nextval('seq1');
    idwykonawcy INTEGER NOT NULL,
    nazwa VARCHAR(50) NOT NULL,
    gatunek VARCHAR(20) NOT NULL,
    data_wydania DATE NOT NULL
);

CREATE TABLE wykonawcy(
    idwykonawcy serial PRIMARY KEY,
    nazwa VARCHAR(100) NOT NULL,
    kraj VARCHAR(30) NOT NULL,
    data_debiutu DATE NOT NULL,
    data_zakonczenia DATE
);

ALTER TABLE albumy add CONSTRAINT albumy_idwykonawcy_fk FOREIGN KEY(idwykonawcy) REFERENCES wykonawcy;


ALTER TABLE klienci add CONSTRAINT min_login CHECK(length(login) >= 5);
ALTER TABLE albumy add CONSTRAINT dozwolony_gatunek CHECK(gatunek IN ('Rock', 'Pop', 'Metal'));

/*
Korzystając z operatorów all oraz ANY (obu)
napisz zapytanie SQL pobierające z bazy ID wszystkich
playlist, dla których wszystkie znajdujące się na
nich utwory są dłuższe niż 300 sekund oraz co najmniej
jeden z ich utworów należy do gatunku ’Pop’
*/

SELECT idplaylisty FROM playlisty p
    WHERE
    300 < all (SELECT dlugosc FROM utwory
        NATURAL JOIN z.zawartosc
        WHERE z.idplaylisty = p.idplaylisty) AND
    'Pop' = ANY (SELECT gatunek FROM zawartosc
        NATURAL JOIN utwory JOIN albumy USING(idalbumu)
        WHERE z.idalbumu = p.idalbumu);


/*
Napisz funkcję o nazwie uzupelnij_playliste, która przyjmuje
trzy argumenty: idplaylisty_od (INT), idplaylisty_do (INT),
polub (BOOLEAN). Funkcja skopiuje z playlisty idplaylisty_od
do playlisty idplaylisty_do utwory, które nie występują na tej drugiej.
Jeżeli parametr polub jest równy TRUE TO dla skopiowanych
utworów funkcja doda oceny pozytywne (lubi = TRUE),
wystawione przez właściciela drugiej playlisty, ale
tylko jeśli jeszcze nie mają od niego ocen.
Funkcja zwraca tabelę zawierającą wszystkie utwory (wiersze
z tabeli utwory) znajdujące się na playliście idplaylisty_do
po operacji kopiowania
*/
BEGIN;
CREATE OR REPLACE FUNCTION uzupelnij_playliste(idplaylisty_od INTEGER, idplaylisty_do INTEGER, polub BOOLEAN)
RETURNS SETOF utwory AS
$$
DECLARE
    v_idutworu INTEGER;
    idklienta_do INTEGER;
BEGIN
    SELECT idklienta INTO idklienta_do FROM playlisty WHERE idplaylisty = idplaylisty_do;
-- petla zawierajaca tylko utwory ktore sa na playliscie od i nie ma na playliscie do
    FOR v_idutworu IN SELECT idutworu FROM zawartosc
        WHERE idplaylisty = idplaylisty_od AND
        idutworu NOT IN (SELECT idutworu FROM zawartosc WHERE idplaylisty = idplaylisty_do)
    LOOP
        INSERT INTO zawartosc values(idplaylisty_do, v_idutworu);

        -- jesli jest flaga i utworu nie ma w zbiorze utworow z ocena klienta_do
        IF polub AND v_idutworu NOT IN (SELECT idutworu FROM oceny WHERE idklienta = idklienta_do) THEN
            INSERT INTO oceny(idutworu, idklienta, lubi) values(v_idutworu, idklienta_do, TRUE);
        END IF;
    END LOOP;

    RETURN QUERY SELECT idutworu, idalbumu, nazwa, dlugosc FROM zawartosc NATURAL JOIN utwory WHERE idplaylisty = idplaylisty_do;
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM zawartosc WHERE idplaylisty = 1;
SELECT * FROM zawartosc WHERE idplaylisty = 2;
SELECT 'a tera jest funkcja i nowa tabela polubien';
SELECT * FROM uzupelnij_playliste(1, 2, TRUE);
SELECT * FROM oceny;

rollback;


/*
Napisz zapytania SQL tworzące w bazie tabele klienci i playlist
(patrz: załączony schemat).
Zadbaj o utworzenie właściwych kluczy głównych i kluczy obcych
(mogą BYć częścią zapytań CREATE
lub stanowić odrębne zapytania typu ALTER). Dodatkowo nałóż
ograniczenia na kolumny, aby nazwa
playlisty miała co najmniej 5 znaków oraz kraj wykonawcy mógł
przyjmować tylko jedną z wartości:
’Polska’, ’Niemcy’, ’Hiszpania’.
*/

CREATE TABLE klienci(
    idklienta serial PRIMARY KEY,
    login VARCHAR(50) NOT NULL,
    data_rejestracji DATE NOT NULL,
    data_urodzenia DATE NOT NULL
);

CREATE TABLE palylisty(
    idplaylisty serial PRIMARY KEY,
    idklienta INTEGER NOT NULL FOREIGN KEY REFERENCES klienci,
    nazwa VARCHAR(30) NOT NULL
);

ALTER TABLE playlisty add CONSTRAINT palylisty_idklienta_fk FOREIGN KEY(idklienta) REFERENCES klienci;

ALTER TABLE palylisty add CONSTRAINT min_dlogosc CHECK(length(nazwa) >= 5);

ALTER TABLE wykonawcy add CONSTRAINT dozwolony_kraj CHECK(kraj IN ('Polska', 'Niemcy', 'Hiszpania'));



/*
Korzystając z operatora ANY napisz zapytanie SQL pobierające
z bazy ID wszystkich playlist, dla
których co najmniej jeden ze znajdujących się na nich utworów
jest dłuższy niż 300 sekund oraz wszystkie
ich utwory należą do gatunku ’Pop’
*/

SELECT idplaylisty FROM playlisty p WHERE
    300 < ANY (SELECT dlugosc FROM zawartosc z
        NATURAL JOIN utwory WHERE z.idplaylisty = p.idplaylisty) AND
    'Pop' = all (SELECT gatunek FROM zawartosc z
        NATURAL JOIN utwory JOIN albumy USING(idablumu)
        WHERE z.idplaylisty = p.idplaylisty);



/*
Napisz funkcję o nazwie uzupelnij_playliste, która przyjmuje trzy argumenty:
idplaylisty_od (INT),
idplaylisty_do (INT), polub (BOOLEAN). Funkcja skopiuje z playlisty
idplaylisty_od do playlisty idplaylisty_do
utwory, które nie występują na tej drugiej. Jeżeli parametr polub jest
równy TRUE TO dla skopiowanych
utworów funkcja doda oceny pozytywne (lubi = TRUE), wystawione przez
właściciela drugiej playlisty, ale
tylko jeśli jeszcze nie mają od niego ocen. Funkcja zwraca tabelę
zawierającą wszystkie utwory (wiersze
z tabeli utwory) znajdujące się na playliście idplaylisty_do po
operacji kopiowania.
*/

CREATE FUNCTION uzupelnij_playliste(idplaylisty_od INTEGER, idplaylisty_do INTEGER, polub BOOLEAN)
RETURNS SETOF utwory AS
$$
DECLARE
    idklienta_do INTEGER;
    v_idutworu INTEGER;
BEGIN
    SELECT idklienta INTO idklienta_do FROM playlisty WHERE idplaylisty = idplaylisty_do;
    
    -- petla po idutworow z playlisty idplaylisty_od takie ktorych nie ma na playliscie idplaylisty_do
    FOR v_idutworu IN SELECT idutworu FROM zawartosc
        WHERE idplaylisty = idplaylisty_od AND
        idutworu NOT IN (SELECT idutworu FROM zawartosc WHERE playlisty = idplaylisty_do)
    LOOP


    END LOOP;  

END;
$$ LANGUAGE PLPGSQL;
