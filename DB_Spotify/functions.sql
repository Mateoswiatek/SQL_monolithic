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

delete from zawartosc;
INSERT INTO kolokwium1.zawartosc (idplaylisty, idutworu) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 1),
(3, 4),
(4, 5);

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
    for r in select * from zawartosc z where idplaylisty = idplaylisty_od and z.idutworu not in (select idutworu from zawartosc where idplaylisty = idplaylisty_do)
    loop
        insert into zawartosc values(idplaylisty_do, r.idutworu);
        if polub and not exists(select 1 from oceny where idklienta = owner and idutworu = r.idutworu) then
            insert into oceny values(r.idutworu, owner, TRUE);
        end if;
    end loop;

    return query select idutworu, idalbumu, nazwa, dlugosc from utwory natural join zawartosc where idplaylisty = idplaylisty_do;
end;
$$ language plpgsql;

select * from uzupelnij_playliste(1, 2, TRUE);

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

*/

-- latwe ez