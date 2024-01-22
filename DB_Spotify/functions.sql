ALTER ROLE matrxteo SET search_path TO kolokwium1;

select * from wykonawcy;
select * from playlisty natural join zawartosc;

/*
Napisz funkcje o nazwie uzupelnij_playliste która
przyjmuje trzy argumenty: idplaylisty_od
(int),idplaylisty_do (int), polub (boolean). Funkcja
skopiuje z playlisty idplaylisty_od do playlisty
idplaylisty_do utwory, które nie występują na tej drugiej.
Jeżeli parametr polub jest równy TRUE to dla
skopiowanych utworów funkcja doda oceny pozytywne
(lubi = TRUE), wystawione przez właściciela drugiej
playlisty, ale tylko jeśli jeszcze nie mają od niego ocen.
Funkcja zwraca tabelę zawierającą wszystkie utwory
(wiersze z tabeli utwory) znajdujące się na playliście
idplaylisty_do po operacji kopiowania.
*/

create temporary table zawartosc_tmp
as select * from zawartosc;

create temporary table oceny_tmp
as select * from oceny;

drop function if exists uzupelnij_playliste(integer, integer, boolean);
create or replace function uzupelnij_playliste(idplaylisty_od integer, idplaylisty_do integer, polub boolean)
returns table (
r_idutworu integer,
r_idalbumu integer,
r_nazwa varchar(100),
r_dlugosc integer
) as
$$
declare
    owner integer;
    r record;
begin
    owner = (select idklienta from playlisty where idplaylisty = idplaylisty_do);
    -- ewentulanie tutaj dac except (te od union, intersect, except) 
    for r in select * from zawartosc_tmp z where idplaylisty = idplaylisty_od and z.idutworu not in (select idutworu from zawartosc_tmp where idplaylisty = idplaylisty_do)
    loop
        insert into zawartosc_tmp values(idplaylisty_do, r.idutworu);
        -- alternatywnie "where r.idutworu not in ()
        if polub and not exists(select 1 from oceny_tmp where idklienta = owner and idutworu = r.idutworu) then
            insert into oceny_tmp values(r.idutworu, owner, TRUE);
        end if;
    end loop;

    return query select idutworu, idalbumu, nazwa, dlugosc from utwory natural join zawartosc_tmp where idplaylisty = idplaylisty_do;
end;
$$ language plpgsql;

select * from zawartosc where idplaylisty = 1;
select * from zawartosc where idplaylisty = 2;
select * from oceny_tmp;
select 'a tera jest funkcja i nowa tabela polubien';
select * from uzupelnij_playliste(1, 2, TRUE);
select * from oceny_tmp;

/*
1.
Napisz funkcje czasTrwania, która jako parametr
przyjmuję idplaylisty (int) i zwraca czas trwania danej
playlisty
*/

drop function if exists czasTrwania(integer);
create or replace function czasTrwania(idplaylisty_ integer, out czas integer) as
$$
declare

begin
    select sum(dlugosc) into czas from zawartosc natural join utwory where idplaylisty = idplaylisty_; 
end;
$$ language plpgsql;

select * from playlisty natural join zawartosc join utwory using(idutworu) where idplaylisty = 1;

select czasTrwania(1);

/*
2.
Napisz bezargumentową funkcję max_play która zwróci
idplaylisty (int) na której znajduje się najwięcej utworów -
jeśli takich playlist jest więcej to zwróć jeden wynik
*/

create or replace function max_play(out idplaylisty_max integer) as
$$
declare

begin
    select idplaylisty into idplaylisty_max from zawartosc group by idplaylisty order by count(idutworu) desc limit 1;
end;
$$ language plpgsql;
select idplaylisty, count(*) from zawartosc group by idplaylisty order by count(*) desc;
select max_play();

/*
3.
Napisz bezargumentową funkcję min_play która zwróci
idplaylist (TABLE) na których znajduje się najmniej
utworów - playlisty mogą być puste, wtedy przyjmij że jest
na nich 0 utworów
*/
drop function min_play();
create or replace function min_play() returns table(r_idplaylisty integer, r_ilosc_utworow integer) as
$$
declare
    min integer;
begin
    select coalesce(min(cnt), 0) into min from (select count(idutworu) as cnt from playlisty left join zawartosc using(idplaylisty) group by idplaylisty);

    return query select idplaylisty, min from playlisty left join zawartosc using(idplaylisty) group by idplaylisty having count(idutworu) = min;
end;
$$ language plpgsql;

select * from playlisty left join zawartosc using(idplaylisty);
select idplaylisty, count(idutworu) from playlisty left join zawartosc using(idplaylisty) group by idplaylisty;

select * from min_play();

/*
4.
Napisz funkcje utwory która przyjmuje nazwę playlisty
(VaRCHAR(30)) i zwraca listę utworów (ich nazwy) które
się na niej znajdują
*/
create or replace function utwory_na_playliscie(idplaylisty_ integer) returns table(nazwy_utworow varchar(100)) as
$$
declare

begin
    return query select nazwa from zawartosc natural join utwory where idplaylisty = idplaylisty_;
end;
$$ language plpgsql;

select * from zawartosc natural join utwory;
select * from utwory_na_playliscie(2);

/*
5.
Napisz funkcje playlisty która przyjmuję nazwę utworu
i zwraca liczbę playlist na której dany utwór się znajduje -
jeśli nie znajduje się na żadnej funkcja ma zwrócić 0
*/


create or replace function utwor_na_playlistach(nazwa_utworu varchar(100), out liczba_playlist integer) as
$$
declare

begin
    select count(distinct idplaylisty) into liczba_playlist from utwory natural join zawartosc where nazwa = nazwa_utworu;
end;
$$ language plpgsql;

select * from utwory left join zawartosc using(idutworu);
select utwor_na_playlistach('Utwor1');
select utwor_na_playlistach('Utwor2');
select utwor_na_playlistach('Utwor6');


/*
6.
Napisz funkcje puste_playlisty która zwraca listę
playlist(ich id) na których nie znajdują się żadne utwory
*/

create or replace function puste_playlisty() returns table(idplaylisty_ integer) as
$$
declare

begin
    --return query select idplaylisty from playlisty p where not exists (select 1 from zawartosc z where z.idplaylisty = p.idplaylisty);
    return query select idplaylisty from playlisty p where idplaylisty not in (select idplaylisty from zawartosc);
end;
$$ language plpgsql;

select * from puste_playlisty();

/*
7.
Napisz funkcje utwory_od_do przyjmującą trzy
argumenty: idplaylisty, czas_od, czas_do zwracającą
wszystkie utwory(ich id i nazwę) na podanej playliście
których czas trwania mieści się w zadanych granicach
*/

create or replace function utwory_od_do(idplaylisty_ integer, czas_od integer, czas_do integer) returns table(r_idutworu integer, r_nazwa varchar(100)) as
$$ 
declare

begin
    return query select idutworu, nazwa from zawartosc natural join utwory where idplaylisty = idplaylisty_ and dlugosc between czas_od and czas_do;
end;
$$ language plpgsql;

select * from utwory left join zawartosc using(idutworu) order by idplaylisty;
select * from utwory_od_do(1, 65, 200);
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
create temporary table zawartosc_tmp
as select * from zawartosc;

create temporary table utwory_tmp
as select * from utwory;

create or replace function dodaj_utwor(
    idutworu_ integer,
    nazwa_utworu_ varchar(50),
    idalbumu_ integer,
    dlugosc_ integer,
    nazwa_playlisty_ varchar(30)
) returns table(r_nazwy_utworow varchar(50)) as
$$
declare
    idplaylisty_ integer;
begin
    select idplaylisty into idplaylisty_ from playlisty where nazwa = nazwa_playlisty_;
    insert into utwory_tmp(idutworu, nazwa, idalbumu, dlugosc) values(idutworu_, nazwa_utworu_, idalbumu_, dlugosc_);
    insert into zawartosc_tmp(idutworu, idplaylisty) values(idplaylisty_, idutworu_);

    return query select nazwa
        from zawartosc_tmp natural join utwory_tmp u
        where idplaylisty = idplaylisty_
            and dlugosc >= (select dlugosc from utwory_tmp where idutworu = idutworu_);
            -- ew dlugosc >= dlugosc_;
end;
$$ language plpgsql;

select * from dodaj_utwor(11, 'aaaaaa', 1, 90, 'MojaPlaylista1');


/*
9.
Napisz funkcje klienci która przyjmuje loginklienta_od,
funkcja zwraca id wszystkich klientów którzy mają na
swoich playlistach co najmniej jeden utwór pokrywający
się z utworami na playliście klienta o loginie
loginklienta_od i którzy dodatkowo urodzili się po tym jak
klient_od się zarejestrował.
*/

create or replace function klienci(loginklienta_od varchar(50)) returns table(r_id_klientow integer) as
$$
declare
    id_dawcy integer;
begin
    select idklienta into id_dawcy from klienci where login = loginklienta_od;

    return query select distinct idklienta from klienci
        natural join playlisty
        natural join zawartosc
        where idutworu in (select idutworu from playlisty natural join zawartosc where idklienta = id_dawcy)
        and data_urodzenia > (select data_urodzenia from klienci where idklienta = id_dawcy);
end;
$$ language plpgsql;

select * from klienci('user6');

/*
10.
Napisz funkcje start_od która przyjmuje prefiks i
zwraca dane utworów (idutworu, idalbumu, nazwa,
dlugosc), które się zaczynają od prefiksu
-- jesli po prostu maja zawirac, to zmienic na ~ prefiks
*/
create or replace function start_od(prefiks varchar(100)) returns setof utwory as
$$
declare

begin
    return query select * from utwory where nazwa ~~ (prefiks || '%');
end;
$$ language plpgsql;

/*
Pomocnicze
select * from utwory;
select * from utwory where nazwa ~~ ('Polskie' || '%');
select * from utwory where nazwa ~ 'or';
*/

select * from start_od('Polskie');
select * from start_od('Utw');

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

create temporary table zawartosc_tmp
as select * from zawartosc;

create or replace function kopiuj_avg(nazwaplaylisty_od varchar(30), nazwaplaylisty_do varchar(30)) returns setof utwory as
$$
declare
    id_playlisty_od integer;
    id_playlisty_do integer;
    sr_czas integer; -- ?? ma byc integer ? numeric(7,2) i w tedy bez rzutowania
begin
    select idplaylisty into id_playlisty_od from playlisty where nazwa = nazwaplaylisty_od;
    select idplaylisty into id_playlisty_do from playlisty where nazwa = nazwaplaylisty_do;
    select coalesce(avg(dlugosc)::integer, 0) into sr_czas from zawartosc_tmp natural join utwory where idplaylisty = id_playlisty_do;

    insert into zawartosc_tmp(idplaylisty, idutworu)
    select id_playlisty_do, idutworu from utwory
        where
        dlugosc > sr_czas and
        idutworu not in (select idutworu from zawartosc_tmp where idplaylisty = id_playlisty_do); -- albo zamist tego: on conflict do nothing;
    
    return query select * from utwory where idutworu in (select idutworu from zawartosc_tmp where idplaylisty = id_playlisty_do);
end;
$$ language plpgsql;

/*
Pomocnicze
select * from playlisty;
select idplaylisty from playlisty where nazwa = 'ImprezaMix';
select idplaylisty from playlisty where nazwa = 'ImprezaMix2';
select avg(dlugosc), avg(dlugosc)::integer from zawartosc natural join utwory where idplaylisty = 7;
*/

select * from kopiuj_avg('Wszystkieee', 'Pusta');
select 'Tera tylko powyzej dlugosci 220';
select * from kopiuj_avg('Wszystkieee', 'Jeden 220dlugosc');

select 'A teraz powyzej 150, bo 220+80/2 = 150, 80 jest bo juz byla';
select * from kopiuj_avg('Wszystkieee', 'Dwa sr 150');

/*
12.
Napisz funkcję kopiuj_zaczynajace_sie_od która
przyjmuje 3 argumenty : idplaylisty_od,
nazwaplaylisty_do, prefiks (varchar(10)). Funkcja kopiuje
wszystkie utowry, których nazwa zaczyna się od prefiks i
które nie występują na playliście_do, z playlisty_od do
playlisty_do.Funkcja zwraca wszystkie utwory na
playliście_do po procesie kopiowania (idutworu, idalbumu,
nazwa, dlugosc)
*/

create temporary table zawartosc_tmp
as select * from zawartosc;

create or replace function kopiuj_zaczynajace_sie_od(idplaylisty_od integer, nazwa_playlisty_do varchar(30), prefiks varchar(10)) returns setof utwory as
$$
declare
    idplaylisty_do integer;
begin
    select idplaylisty into idplaylisty_do from playlisty where nazwa = nazwa_playlisty_do;

    insert into zawartosc_tmp(idplaylisty, idutworu)
    select idplaylisty_do, idutworu from utwory
        where 
            nazwa ~ ( '^' || prefiks) and -- ~~ (prefiks || '%') albo  ~ ( '^' || prefiks) ~ to jest normalny regrex natomiast ^ to kotwica poczatku
            -- mozna by na except zamienic zamiast dwoch oddzielnych. lub on conflict do NOTHING; -- bo i tak musza byc unikatowe
            idutworu in (select idutworu from zawartosc_tmp where idplaylisty = idplaylisty_od) and
            idutworu not in (select idutworu from zawartosc_tmp where idplaylisty = idplaylisty_do);
    return query select * from utwory where idutworu in (select idutworu from zawartosc_tmp where idplaylisty = idplaylisty_do);
end;
$$ language plpgsql;

/*
select * from zawartosc z natural join playlisty p right join utwory using(idutworu); 

create temporary table zawartosc_tmp
as select * from zawartosc;
select 1, idutworu from utwory
        where 
            nazwa  ~ ( '^' || 'Polsk') and -- ~ ( '^' || prefiks) ~ to jest normalny regrex natomiast ^ to kotwica poczatku
            -- mozna by na except zamienic zamiast dwoch oddzielnych. lub on conflict do NOTHING; -- bo i tak musza byc unikatowe
            idutworu in (select idutworu from zawartosc_tmp where idplaylisty = 7) and
            idutworu not in (select idutworu from zawartosc_tmp where idplaylisty = 2);
*/
select * from kopiuj_zaczynajace_sie_od(7, 'MojaPlaylista2', 'Polsk');


/*
13.1
Napisz funkcje dodaj_utwory_wykonawcy1 która
przyjmuje 2 argumenty: nazwa_wykonawcy,
login_klienta. Funkcja dodaje do każdej playlisty
nazleżącej do klienta o loginie login_klienta utwory
wytępujące na albumach wykonawcy nazwa_wykonawcy -
o ile wcześniej nie znajdują się już na jego playliście.
Album z którego pochodzą utwory musi być dodatkowo
wydany przed datą rejestracji klienta. Funkcja zwraca
idplaylist oraz wszystkie utwory na playlistach klienta po
dodaniu do nich utworów (idutworu, idalbumu, nazwa,
dlugosc).
*/


create temporary table zawartosc_tmp
as select * from zawartosc;

create or replace function dodaj_utwory_wykonawcy1(nazwa_wykonawcy_ varchar(100), login_klienta_ varchar(50)) 
returns table(
    r_idplaylisty integer,
    r_idutworu_ integer,
    r_idalbumu_ integer,
    r_nazwa_utworu_ varchar(100),
    r_dlugosc_ integer
) as
$$
declare
    id_playlisty_var integer;
begin
    for id_playlisty_var in select idplaylisty from playlisty where idklienta = (select idklienta from klienci where login = login_klienta_)
    loop
        insert into zawartosc_tmp(idplaylisty, idutworu)
        select id_playlisty_var, idutworu from utwory join albumy using(idalbumu)
            where
            idwykonawcy = (select idwykonawcy from wykonawcy where nazwa = nazwa_wykonawcy_) and
            idutworu not in (select idutworu from zawartosc_tmp where idplaylisty = id_playlisty_var) and
            data_wydania < (select data_rejestracji from klienci where login = login_klienta_);
    end loop;

    return query select idplaylisty, idutworu, idalbumu, nazwa, dlugosc from zawartosc_tmp natural join utwory;
end;
$$ language plpgsql;

select * from wykonawcy join albumy using(idwykonawcy);
select * from klienci natural join playlisty;
-- (3, 'Album3', 'Hip-Hop', '2005-10-12'),
-- album 3 wykonawca 3 
-- na pewno nie sa na pustej.
-- data wydania albumu jest 1910 rok, user 6 zarejstrowal sie 1990 roku wiec sie zgadza
-- update albumy set data_wydania = '1910-01-07' where idalbumu = 3;
select 'przed funkcja: ';
select idplaylisty, idutworu, idalbumu, u.nazwa dlugosc from playlisty natural join zawartosc
    join utwory u using(idutworu) join albumy using(idalbumu)
    order by idalbumu;

select 'po funkcji: ';
select * from dodaj_utwory_wykonawcy1('Artysta3', 'user6')
order by r_idalbumu_;








-- tu niby poprawna ???
create temporary table zawartosc_tmp
as select * from zawartosc;

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
$$ LANGUAGE PLpgSQL;


select * from dodaj_utwory_wykonawcy11('Artysta3', 'user6')
order by r_idalbumu;






create temporary table zawartosc_tmp
as select * from zawartosc;

create or replace function func(
	f_nazwa varchar(30),
	f_login varchar(50)
	)
returns table(
	t_idplaylisty integer,
	t_idutworu integer,
	t_idalbumu integer,
	t_nazwa varchar(100),
	t_dlugosc integer
	) as
$$
declare
v_data date;
v_utw record;

begin
v_data := (select data_rejestracji from klienci where login = f_login);

for v_utw in(
	select idutworu
	from wykonawcy w
	join albumy a using(idwykonawcy)
	join utwory u using(idalbumu)
	where w.nazwa = f_nazwa
	and a.data_wydania < v_data
	)
loop
insert into zawartosc_tmp
select v_utw.idutworu, idplaylisty
from playlisty
where idklienta = (select idklienta from klienci where login = f_login)
on conflict do nothing; --  (idutworu, idplaylisty)
end loop;

return query
select idplaylisty, idutworu, idalbumu, u.nazwa, dlugosc
from utwory u
join zawartosc_tmp using(idutworu)
join playlisty using(idplaylisty)
where idklienta = (select idklienta from klienci where login = f_login);
end;
$$
language plpgsql;
select * from func('Artysta3', 'user6');



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

create or replace function dodaj_utwory_wykonawcy2(
    idwykonawcy_ integer,
    idklienta_ integer,
    prefiks varchar(10))
returns setof utwory as
$$
declare -- mozna tez zrobic petla na palylistach, to jest lepsze podejscie jesli jest wiecej playlist niz utworow.
-- bo to co jest w forze w selectcie to tylko raz wykonujemy, wiec lepiej dac tam najbardziej skkomplikowne operajce / zapytanie.
    idutworu_var integer;
begin

-- kopia zapasowa:
    create temporary table zawartosc_tmp
    as select * from zawartosc;

    for idutworu_var in select idutworu from utwory u join albumy using(idalbumu)
        where 
        u.nazwa ~('^' || prefiks) and
        idwykonawcy = idwykonawcy_
    loop -- dla kazdego utworu dodajemy go do playlisty, uzywamy on
        insert into zawartosc(idplaylisty, idutworu)
        select idplaylisty, idutworu_var from playlisty
            where idklienta = idklienta_
            -- ewentualnie zamiast tego, trzeba by robic joina z zawartoscia i tam sprawdzac tylu (p byloby aliasem dla playlisty)
            -- and idutworu_var not in (select idutworu from zawartosc z where z.idplaylisty = p.idklaylisty)
            on conflict do NOTHING;
    end loop;

-- distinct czy maja byc unikatowe nazwy ??
    -- return query select distinct u.idutworu, u.idalbumu, u.nazwa, u.dlugosc -- TAK
    return query select u.idutworu, u.idalbumu, u.nazwa, u.dlugosc -- NIE
    from utwory u natural join zawartosc join playlisty using(idplaylisty)
    where idklienta = idklienta_; 

-- sprzatanie:
    delete from zawartosc;
    insert into zawartosc select * from zawartosc_tmp;
end;
$$ language plpgsql;

select * from dodaj_utwory_wykonawcy2(3, 6, 'Polskie');

/*
14.
Napisz funkcję liczba_z_kraju przyjmującą idplaylisty
oraz kraj. Funkcja zwraca liczbę utworów znajdujących
się na playliście które pochodzą z albumów wydanych w
danym kraju
*/ 

create or replace function liczba_z_kraju(idplaylisty_ integer, kraj_ varchar(30), out liczba_utworow integer) as
$$
declare

begin
    select count(*) into liczba_utworow from zawartosc
        natural join utwory
        join albumy using(idalbumu)
        join wykonawcy using(idwykonawcy)
        where
            idplaylisty = idplaylisty_ and
            kraj = kraj_;
end;
$$ language plpgsql;

-- cala zawartosc playlisty
select * from wykonawcy
    join albumy using(idwykonawcy)
    join utwory using(idalbumu)
    join zawartosc using(idutworu)
    where idplaylisty = 7;

-- idplaylisty bedzie taki sam ale tak orientacyjnie aby wiedziec,
-- tu i tak to na sztywno ustawiamy
select idplaylisty, kraj, count(*) as ilosc_utworow from wykonawcy
    join albumy using(idwykonawcy)
    join utwory using(idalbumu)
    join zawartosc using(idutworu)
    where idplaylisty = 7
    group by kraj, idplaylisty
    order by ilosc_utworow desc;


select liczba_z_kraju(7, 'Polska');