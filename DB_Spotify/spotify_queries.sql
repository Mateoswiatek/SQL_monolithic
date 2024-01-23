-- Napisz zapytanie SQL które wyświetla idwykonawcy którego utwory lubi użytkownik jim. Usuń duplikaty
-- Write an SQL query that displays the artist ID of whose songs user jim likes. Remove duplicates
SELECT DISTINCT idwykonawcy
    FROM klienci nautral
    JOIN oceny
    JOIN utwory USING(idutworu)
    JOIN albumy USING(idalbumu)
    WHERE
        lubi = TRUE
        AND login = 'jim';


-- Napisz zapytanie SQL które wyswietla nazwę utworu i ile razy dany utwor zostal polubiony(Jest TRUE w "lubi" ) i posortuje wedlug wartosci polubien malejaco 
-- Write an SQL query that displays the name of the song AND how many times the song has been liked (It is TRUE in "likes") AND sort BY the value of likes in descending ORDER
SELECT nazwa, count(lubi) AS suma
    FROM utwory
    LEFT JOIN oceny USING(idutworu)
    WHERE lubi = TRUE
    GROUP BY nazwa, idutworu
    ORDER BY suma;

-- OR

SELECT nazwa, coalesce(sum(lubi::int), 0) AS suma
    FROM utwory
    LEFT JOIN oceny USING(idutworu)
    GROUP BY idutworu
    ORDER BY suma;


-- Napisz zapytanie SQL, które wyświetla nazwy wykonawców którzy mają albumy z ostatnich 2 lat. usuń duplikaty
-- Write an SQL query that displays the names of artists who have albums FROM the last 2 years. remove duplicates
SELECT DISTINCT w.nazwa
    FROM wykonawcy w
    JOIN albumy USING(idwykonawcy)
    WHERE data_wydania > current_date - interval '2 years';


-- Napisz zapytanie SQL, które wyświetla loginy klientów, którzy mają w playlistach utwory o dlugosci mniejszej niż 300 i z albumów nie starszych niż 2 lata. 
-- Write an SQL query that displays the logins of customers who have songs in their playlists that are less than 300 long AND FROM albums that are less than 2 years old.
SELECT DISTINCT login
    FROM klienci
    JOIN playlisty  USING(idklienta)
    NATURAL JOIN zawartosc
    JOIN utwory     USING(idutworu)
    JOIN albumy     USING(idalbumu)
    WHERE
        dlugosc < 300
        data_wydania > current_date - interval '2 years';


-- Napisz zapytanie SQL które policzy wszystkie utwory z playlist użytkowników. Ma wyświetlać login klienta i liczę utworów zapisanych w playlistach.
-- Write an SQL query that will count all songs FROM users' playlists. It is supposed to display the client's login AND the number of songs saved in playlists.
SELECT login, count(DISTINCT idutworu)
    FROM klienci
    LEFT JOIN playlisty USING(idklienta)
    JOIN zawartosc      USING(idplaylisty)
    GROUP BY login
    ORDER BY login;


--Napisz zapytanie które wyswietli nazwe wykonawcow i ile polubien oni zdobyli, jak wykonawca nie zdobyl polubień to wtedy 0.
--Write a query that will display the name of the artists AND how many likes they got, if the artist did not get any likes, then 0.
SELECT w.nazwa, coalesce(sum(lubi::int), 0)
    FROM oceny
    NATURAL JOIN utwory
    JOIN albumy      USING (idalbumu)
    JOIN wykonawcy w USING (idwykonawcy)
    GROUP BY w.nazwa; 


-- Napisz zapytanie które wstawi klienta o loginie poprzedniego klienta o najwyższym id z dopiskiem "ALT", ma mieć id większe o 1, tą samą datę urodzenia i dzisiejszą date rejestracji.
-- Write a query that will INSERT a client with the login of the previous client with the highest id with the note "ALT",
-- it should have an id greater than 1, the same date of birth AND today's registration date.
INSERT INTO klienci
    SELECT idklienta + 1, login || 'ALT', current_date, data_urodzenia
    FROM klienci
    WHERE idklienta = (SELECT max(idklienta) FROM klienci);


-- Wyświetl wszystkie utwory o długości powyżej średniej długości utworów w bazie.
-- Display all songs with a length above the average length of songs in the database.
SELECT *
    FROM kolokwium1.utwory
    WHERE dlugosc > (SELECT AVG(dlugosc) FROM kolokwium1.utwory);


-- Znajdź najdłuższy utwór w bazie danych.
-- Find the longest song in the database.
SELECT *
    FROM kolokwium1.utwory
    WHERE dlugosc = (SELECT MAX(dlugosc) FROM kolokwium1.utwory);
-- OR
SELECT *
    FROM utwory
    ORDER BY dlugosc DESC LIMIT 1;


-- Wybierz wszystkie utwory / ocenione przez danego klienta jako "lubię". O podanym id oraz ogólnie (tutaj tylko liczbę), każdy numer id i liczba polubionych utworów.
-- Select all songs / rated BY a given customer AS "likes". About the given id AND in general (here only the number), each id number AND the number of liked songs.
SELECT *
    FROM kolokwium1.oceny
    WHERE
        idklienta = 3
        AND lubi = TRUE;
-- OR
SELECT idklienta, count(idutworu)
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
-- Count how many songs are in each album
SELECT idalbumu, count(idutworu)
    FROM albumy jon utwory USING(idalbumu)
    GROUP BY idalbumu;


-- Policz, ile utworów znajduje się w każdej playliście. (bo może być playlista bez zawartości, dlatego jest LEFT JOIN)
-- Count how many songs are in each playlist. (because there can be a playlist without content, that's why it's LEFT JOIN)
SELECT idplaylisty, count(*) AS liczba_utworow
    FROM playlisty
    LEFT JOIN zawartosc
    GROUP BY idplaylisty;


-- Znajdź klientów, którzy nie ocenili żadnego utworu.
-- Find customers who have not rated any songs.
(SELECT idklienta FROM klienci)
except
(SELECT idklienta FROM oceny);
-- OR
SELECT *
    FROM kolokwium1.klienci
    WHERE idklienta NOT IN (SELECT DISTINCT idklienta FROM kolokwium1.oceny);


-- Wybierz wszystkie albumy wydane w danym roku. 
-- Select all albums released in a given year.
SELECT *
    FROM albumy
    WHERE date_part('year', data_wydania) = 2015;


-- Znajdź najpopularniejszy gatunek muzyczny (najwięcej albumów).
-- Find the most popular music genre (most albums).
SELECT gatunek, count(*) AS ilosc
    FROM albumy
    GROUP BY albumy
    ORDER BY ilosc DESC
    LIMIT 1;


-- Policz, ile utworów jest w każdej playliste danego klienta. 
-- Count how many songs are in each customer's playlist.
SELECT idklienta, idplaylisty, count(*) AS iloscUtworow
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
--Count how many albums were released BY each artist.
SELECT idwykonawcy, count(idalbumu) AS liczba_albumow
    FROM wykonawcy
    LEFT JOIN albumy USING(idwykonawcy)
    GROUP BY idwykonwacy;


-- Dla każdego utworu, liczbę playlist w których występuje.
-- For each song, the number of playlists it appears in.
SELECT idutworu, count(*)
    FROM zawartosc
    GROUP BY idutworu;


-- Znajdź średnią ocenę danego utworu.
-- Find the average rating of a given song.
SELECT nazwa, COALESCE(avg(lubi::int), 0.5) 
    FROM utwory
    LEFT JOIN oceny USING(idutworu)
    GROUP BY idutworu, nazwa;
--OR, tu moze byc problem z tymi ktore nie maja oceny. there may be a problem with those who don't have a rating
SELECT nazwa, (SELECT COALESCE(avg(lubi::int), 0.5) FROM oceny o WHERE o.idutworu = u.idutworu)
    FROM utwory u;


--Zlicz ile albumów zostało wydanych w każdym z roków.
--Count how many albums were released in each year.
SELECT date_part('year', data_wydania) AS rok, count(*)
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
(mogą być częścią zapytań CREATE lub
stanowić odrębne zapytania typu ALTER).


Dodatkowo nałóż ograniczenia na kolumny, aby login klienta
miał co najmniej 5 znaków oraz gatunek albumu mógł przyjmować
tylko jedną z wartości: ’Rock’, ’Pop’,
’Metal’
*/


create table albumy(
    idalbumu serial primary key, -- serial robi to za mnie, ale alternatywnie create sequence seq1, i tutaj integer primary key default nextval('seq1');
    idwykonawcy integer not null,
    nazwa varchar(50) not null,
    gatunek varchar(20) not null,
    data_wydania date not null
);

create table wykonawcy(
    idwykonawcy serial primary key,
    nazwa varchar(100) not null,
    kraj varchar(30) not null,
    data_debiutu date not null,
    data_zakonczenia date
);

alter table albumy add constraint albumy_idwykonawcy_fk foreign key(idwykonawcy) references wykonawcy;


alter table klienci add constraint min_login check(length(login) >= 5);
alter table albumy add constraint dozwolony_gatunek check(gatunek in ('Rock', 'Pop', 'Metal'));

/*
Korzystając z operatorów all oraz any (obu)
napisz zapytanie SQL pobierające z bazy ID wszystkich
playlist, dla których wszystkie znajdujące się na
nich utwory są dłuższe niż 300 sekund oraz co najmniej
jeden z ich utworów należy do gatunku ’Pop’
*/

select idplaylisty from playlisty p
    where
    300 < all (select dlugosc from utwory
        natural join z.zawartosc
        where z.idplaylisty = p.idplaylisty) and
    'Pop' = any (select gatunek from zawartosc
        natural join utwory join albumy using(idalbumu)
        where z.idalbumu = p.idalbumu);


/*
Napisz funkcję o nazwie uzupelnij_playliste, która przyjmuje
trzy argumenty: idplaylisty_od (int), idplaylisty_do (int),
polub (boolean). Funkcja skopiuje z playlisty idplaylisty_od
do playlisty idplaylisty_do utwory, które nie występują na tej drugiej.
Jeżeli parametr polub jest równy TRUE to dla skopiowanych
utworów funkcja doda oceny pozytywne (lubi = TRUE),
wystawione przez właściciela drugiej playlisty, ale
tylko jeśli jeszcze nie mają od niego ocen.
Funkcja zwraca tabelę zawierającą wszystkie utwory (wiersze
z tabeli utwory) znajdujące się na playliście idplaylisty_do
po operacji kopiowania
*/
begin;
create or replace function uzupelnij_playliste(idplaylisty_od integer, idplaylisty_do integer, polub boolean)
returns setof utwory as
$$
declare
    v_idutworu integer;
    idklienta_do integer;
begin
    select idklienta into idklienta_do from playlisty where idplaylisty = idplaylisty_do;
-- petla zawierajaca tylko utwory ktore sa na playliscie od i nie ma na playliscie do
    for v_idutworu in select idutworu from zawartosc
        where idplaylisty = idplaylisty_od and
        idutworu not in (select idutworu from zawartosc where idplaylisty = idplaylisty_do)
    loop
        insert into zawartosc values(idplaylisty_do, v_idutworu);

        -- jesli jest flaga i utworu nie ma w zbiorze utworow z ocena klienta_do
        if polub and v_idutworu not in (select idutworu from oceny where idklienta = idklienta_do) then
            insert into oceny(idutworu, idklienta, lubi) values(v_idutworu, idklienta_do, TRUE);
        end if;
    end loop;

    return query select idutworu, idalbumu, nazwa, dlugosc from zawartosc natural join utwory where idplaylisty = idplaylisty_do;
end;
$$ language plpgsql;

select * from zawartosc where idplaylisty = 1;
select * from zawartosc where idplaylisty = 2;
select 'a tera jest funkcja i nowa tabela polubien';
select * from uzupelnij_playliste(1, 2, TRUE);
select * from oceny;

rollback;


/*
Napisz zapytania SQL tworzące w bazie tabele klienci i playlist
(patrz: załączony schemat).
Zadbaj o utworzenie właściwych kluczy głównych i kluczy obcych
(mogą być częścią zapytań CREATE
lub stanowić odrębne zapytania typu ALTER). Dodatkowo nałóż
ograniczenia na kolumny, aby nazwa
playlisty miała co najmniej 5 znaków oraz kraj wykonawcy mógł
przyjmować tylko jedną z wartości:
’Polska’, ’Niemcy’, ’Hiszpania’.
*/

create table klienci(
    idklienta serial primary key,
    login varchar(50) not null,
    data_rejestracji date not null,
    data_urodzenia date not null
);

create table palylisty(
    idplaylisty serial primary key,
    idklienta integer not null foreign key references klienci,
    nazwa varchar(30) not null
);

alter table playlisty add constraint palylisty_idklienta_fk foreign key(idklienta) references klienci;

alter table palylisty add constraint min_dlogosc check(length(nazwa) >= 5);

alter table wykonawcy add constraint dozwolony_kraj check(kraj in ('Polska', 'Niemcy', 'Hiszpania'));



/*
Korzystając z operatora any napisz zapytanie SQL pobierające
z bazy ID wszystkich playlist, dla
których co najmniej jeden ze znajdujących się na nich utworów
jest dłuższy niż 300 sekund oraz wszystkie
ich utwory należą do gatunku ’Pop’
*/

select idplaylisty from playlisty p where
    300 < any (select dlugosc from zawartosc z
        natural join utwory where z.idplaylisty = p.idplaylisty) and
    'Pop' = all (select gatunek from zawartosc z
        natural join utwory join albumy using(idablumu)
        where z.idplaylisty = p.idplaylisty);



/*
Napisz funkcję o nazwie uzupelnij_playliste, która przyjmuje trzy argumenty:
idplaylisty_od (int),
idplaylisty_do (int), polub (boolean). Funkcja skopiuje z playlisty
idplaylisty_od do playlisty idplaylisty_do
utwory, które nie występują na tej drugiej. Jeżeli parametr polub jest
równy TRUE to dla skopiowanych
utworów funkcja doda oceny pozytywne (lubi = TRUE), wystawione przez
właściciela drugiej playlisty, ale
tylko jeśli jeszcze nie mają od niego ocen. Funkcja zwraca tabelę
zawierającą wszystkie utwory (wiersze
z tabeli utwory) znajdujące się na playliście idplaylisty_do po
operacji kopiowania.
*/

create function uzupelnij_playliste(idplaylisty_od integer, idplaylisty_do integer, polub boolean)
returns setof utwory as
$$
declare
    idklienta_do integer;
    v_idutworu integer;
begin
    select idklienta into idklienta_do from playlisty where idplaylisty = idplaylisty_do;
    
    -- petla po idutworow z playlisty idplaylisty_od takie ktorych nie ma na playliscie idplaylisty_do
    for v_idutworu in select idutworu from zawartosc
        where idplaylisty = idplaylisty_od and
        idutworu not in (select idutworu from zawartosc where playlisty = idplaylisty_do)
    loop


    end loop;  

end;
$$ language plpgsql;
