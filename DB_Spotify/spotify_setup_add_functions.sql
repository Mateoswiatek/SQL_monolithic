BEGIN;
SET search_path TO spotify;
/*
DO $$ 
DECLARE 
    function_name text;
BEGIN
    FOR function_name IN (SELECT routine_name FROM information_schema.routines WHERE routine_schema = 'spotify') LOOP
        EXECUTE 'DROP FUNCTION IF EXISTS ' || function_name || ' CASCADE';
    END LOOP;
END $$;
*/

-- ===============================================================
--                              FUNKCJE
-- ===============================================================

/*
1.
CzasTrwania, która jako parametr
przyjmuję idplaylisty (int) i zwraca czas trwania danej
playlisty
*/
create or replace function czasTrwania(idplaylisty_ integer, out czas integer) as
$$
begin
    select sum(dlugosc) into czas from zawartosc natural join utwory where idplaylisty = idplaylisty_; 
end;
$$ language plpgsql;



/*
2.
Napisz bezargumentową funkcję max_play która zwróci
idplaylisty (int) na której znajduje się najwięcej utworów -
jeśli takich playlist jest więcej to zwróć jeden wynik
*/
create or replace function max_play(out idplaylisty_max integer) as
$$
begin
    select idplaylisty into idplaylisty_max from zawartosc group by idplaylisty order by count(idutworu) desc limit 1;
end;
$$ language plpgsql;



/*
3.
Napisz bezargumentową funkcję min_play która zwróci
idplaylist (TABLE) na których znajduje się najmniej
utworów - playlisty mogą być puste, wtedy przyjmij że jest
na nich 0 utworów
*/
create or replace function min_play() returns table(r_idplaylisty integer, r_ilosc_utworow integer) as
$$
declare
    min integer;
begin
    select coalesce(min(cnt), 0) into min from (select count(idutworu) as cnt from playlisty left join zawartosc using(idplaylisty) group by idplaylisty);

    return query select idplaylisty, min from playlisty left join zawartosc using(idplaylisty) group by idplaylisty having count(idutworu) = min;
end;
$$ language plpgsql;



/*
4.
Napisz funkcje utwory która przyjmuje nazwę playlisty
(VaRCHAR(30)) i zwraca listę utworów (ich nazwy) które
się na niej znajdują
*/
create or replace function utwory_na_playliscie(idplaylisty_ integer) returns table(nazwy_utworow varchar(100)) as
$$
begin
    return query select nazwa from zawartosc natural join utwory where idplaylisty = idplaylisty_;
end;
$$ language plpgsql;



/*
5.
Napisz funkcje playlisty która przyjmuję nazwę utworu
i zwraca liczbę playlist na której dany utwór się znajduje -
jeśli nie znajduje się na żadnej funkcja ma zwrócić 0
*/
create or replace function utwor_na_playlistach(nazwa_utworu varchar(100), out liczba_playlist integer) as
$$
begin
    select count(distinct idplaylisty) into liczba_playlist from utwory natural join zawartosc where nazwa = nazwa_utworu;
end;
$$ language plpgsql;



/*
6.
Napisz funkcje puste_playlisty która zwraca listę
playlist(ich id) na których nie znajdują się żadne utwory
*/
create or replace function puste_playlisty() returns table(idplaylisty_ integer) as
$$
begin
    --return query select idplaylisty from playlisty p where not exists (select 1 from zawartosc z where z.idplaylisty = p.idplaylisty);
    return query select idplaylisty from playlisty p where idplaylisty not in (select idplaylisty from zawartosc);
end;
$$ language plpgsql;



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
    insert into utwory(idutworu, nazwa, idalbumu, dlugosc) values(idutworu_, nazwa_utworu_, idalbumu_, dlugosc_);
    insert into zawartosc(idutworu, idplaylisty) values(idplaylisty_, idutworu_);

    return query select nazwa
        from zawartosc natural join utwory u
        where idplaylisty = idplaylisty_
            and dlugosc >= (select dlugosc from utwory where idutworu = idutworu_);
            -- ew dlugosc >= dlugosc_;
end;
$$ language plpgsql;



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



/*
10.
Napisz funkcje start_od która przyjmuje prefiks i
zwraca dane utworów (idutworu, idalbumu, nazwa,
dlugosc), które się zaczynają od prefiksu
-- jesli po prostu maja zawirac, to zmienic na ~ prefiks
*/
create or replace function start_od(prefiks varchar(100)) returns setof utwory as
$$
begin
    return query select * from utwory where nazwa ~~ (prefiks || '%');
end;
$$ language plpgsql;



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
create or replace function kopiuj_avg(nazwaplaylisty_od varchar(30), nazwaplaylisty_do varchar(30)) returns setof utwory as
$$
declare
    id_playlisty_od integer;
    id_playlisty_do integer;
    sr_czas integer;
begin
    select idplaylisty into id_playlisty_od from playlisty where nazwa = nazwaplaylisty_od;
    select idplaylisty into id_playlisty_do from playlisty where nazwa = nazwaplaylisty_do;
    select coalesce(avg(dlugosc)::integer, 0) into sr_czas from zawartosc natural join utwory where idplaylisty = id_playlisty_do;

    insert into zawartosc(idplaylisty, idutworu)
    select id_playlisty_do, idutworu from utwory
        where
        dlugosc > sr_czas and
        idutworu not in (select idutworu from zawartosc where idplaylisty = id_playlisty_do); -- albo zamist tego: on conflict do nothing;
    
    return query select * from utwory where idutworu in (select idutworu from zawartosc where idplaylisty = id_playlisty_do);
end;
$$ language plpgsql;



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
create or replace function kopiuj_zaczynajace_sie_od(idplaylisty_od integer, nazwa_playlisty_do varchar(30), prefiks varchar(10)) returns setof utwory as
$$
declare
    idplaylisty_do integer;
begin
    select idplaylisty into idplaylisty_do from playlisty where nazwa = nazwa_playlisty_do;

    insert into zawartosc(idplaylisty, idutworu)
    select idplaylisty_do, idutworu from utwory
        where 
            nazwa ~ ( '^' || prefiks) and -- ~~ (prefiks || '%') albo  ~ ( '^' || prefiks) ~ to jest normalny regrex natomiast ^ to kotwica poczatku
            -- mozna by na except zamienic zamiast dwoch oddzielnych. lub on conflict do NOTHING; -- bo i tak musza byc unikatowe
            idutworu in (select idutworu from zawartosc where idplaylisty = idplaylisty_od) and
            idutworu not in (select idutworu from zawartosc where idplaylisty = idplaylisty_do);
    return query select * from utwory where idutworu in (select idutworu from zawartosc where idplaylisty = idplaylisty_do);
end;
$$ language plpgsql;



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
        insert into zawartosc(idplaylisty, idutworu)
        select id_playlisty_var, idutworu from utwory join albumy using(idalbumu)
            where
            idwykonawcy = (select idwykonawcy from wykonawcy where nazwa = nazwa_wykonawcy_) and
            idutworu not in (select idutworu from zawartosc where idplaylisty = id_playlisty_var) and
            data_wydania < (select data_rejestracji from klienci where login = login_klienta_);
    end loop;

    return query select idplaylisty, idutworu, idalbumu, nazwa, dlugosc from zawartosc natural join utwory;
end;
$$ language plpgsql;



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

-- czy maja byc unikatowe nazwy ?? 

*/
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
    -- create temporary table zawartosc
    -- as select * from zawartosc;

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
    -- delete from zawartosc;
    -- insert into zawartosc select * from zawartosc;
end;
$$ language plpgsql;



/*
14.
Napisz funkcję liczba_z_kraju przyjmującą idplaylisty
oraz kraj. Funkcja zwraca liczbę utworów znajdujących
się na playliście które pochodzą z albumów wydanych w
danym kraju
*/ 
create or replace function liczba_z_kraju(idplaylisty_ integer, kraj_ varchar(30), out liczba_utworow integer) as
$$
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



/*
15.
Napisz funkcje
polub_utwory_wykonawcy która przyjmuje
3 argumenty: loginklienta, idwykonawcy,
polub(boolean). Funkcja dodaje polubienia
do wszystkich utworów znajdujących się na
wszystkich playlistach klienta o loginie
loginklienta (jeśli wartość polub jest
ustawiona na True), ktore należą do
albumów wykonawcy o id = idwykonawcy i
nie zostały wcześniej polubione przez
klienta. Funkcja zwraca wszystkie
polubione utwory z playlist klienta (po
operacji polubienia utworów wykonawców)
(idplaylisty, idutworu, idklienta, lubi)


-- czyli mialy wartosc false lub null. 
-- jesli byloby polub = false, no to w tedy wszystkie bysmy ustawili na false
-- polubione, czyli jesli byly na lubi=false, to rowniez sie do tego zalicza.
-- wszystko co nie jest lubi=true to sie zalicza do tego.

i nie zostały wcześniej polubione przez
klienta.
*/

begin;

create or replace function polub_utwory_wykonawcy(loginklienta_ varchar(50), idwykonawcy_ integer, polub boolean)
returns table(
    r_idplaylisty integer,
    r_idutworu integer,
    r_idklienta integer,
    r_lubi boolean
) as
$$
declare
    idklienta_ integer;
begin
    select idklienta into idklienta_ from klienci where login = loginklienta_;

    -- distinct na idutworu, bo moze byc w wielu playlistach, ale 
    -- i tak dla kazdego tylko jeden raz musimy to wykonac, inne sa const
    
    -- tutaj np moglem zrobic join albumy
    -- i dac sam waurnek ale co jest bardziej wydane?

    -- optymalizacja czy bardziej sie oplaca rozbic na dwa:
    -- modyfikacja niepolubionych na polubione  
    -- oraz dodanie zypelnie nowych, - wymaga sprawdzenia tych ktorych nie ma, ewentualnie 
    -- ewentualnie "zapisanie" danych ktore sa wyrzucane z except, bo w tedy to moze byloby szybsze.

    -- czy takie podejscie jak ja zrobilem
    insert into oceny 
    select distinct(idutworu), idklienta_, polub from playlisty
        natural join zawartosc
        join utwory using(idutworu)
        -- join albumy using(idalbumu) --   ALTERNATYWA
        where
            idklienta = idklienta_ and
        -- idwykonawcy = idwykonawcy_ --    ALTERNATYWA
            idalbumu in (select idalbumu from albumy
                where idwykonawcy = idwykonawcy_) -- zamiast tego
    on conflict(idutworu, idklienta) do update set lubi = polub; -- ta co ma byc wstawiane: EXCLUDED.lubi

    return query select idplaylisty, idutworu, idklienta, lubi from klienci
        natural join oceny
        natural join playlisty
        where idklienta = idklienta_;
end;
$$ language plpgsql;




COMMIT;