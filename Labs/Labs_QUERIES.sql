SET search_path TO siatkowka, kwiaciarnia, public;

// Problem, bo zamiast w kwiaciarni mam wszystko w publicu.
ALTER ROLE matrxteo SET search_path TO siatkowka, kwiaciarnia, public; 

SELECT * from mecze;
SELECT * from czekoladki;
SELECT * from czekoladki;

SELECT k.nazwa FROM klienci k;

select *
from siatkowka.druzyny;

select nazwa, miasto, nazwisko, imie, numer
from siatkowka.druzyny join siatkarki on nazwisko > 'K' and miasto < 'M';

select nazwa, miasto, nazwisko, imie, numer
from siatkowka.druzyny join siatkowka.siatkarki
on nazwisko like '%k%' or nazwa like '%k%';

select nazwisko, imie, nazwa
from siatkowka.siatkarki join siatkowka.druzyny using(iddruzyny)
where pozycja = 'rozgrywająca';

select numer, iddruzySny, nazwisko, imie, punkty
from siatkowka.siatkarki join siatkowka.punktujace using(numer, iddruzyny);

select nazwisko, imie, punkty
from siatkowka.siatkarki natural join siatkowka.punktujace;

nazwisko, imie, termin, punkty
select *
from siatkowka.siatkarki natural join siatkowka.punktujace natural join siatkowka.mecze
order by termin;

select d1.nazwa, d2.nazwa, termin
from siatkowka.druzyny d1 join siatkowka.mecze on d1.iddruzyny = gospodarze
join siatkowka.druzyny d2 on d2.iddruzyny = goscie;

select imie, nazwisko, idmeczu
from siatkowka.siatkarki left join siatkowka.punktujace using(numer, iddruzyny);


select count(*) from siatkowka.siatkarki;

select count(*) from siatkowka.siatkarki natural join siatkowka.punktujace
where iddruzyny = 'musz' and idmeczu = 1;

SELECT avg(punkty) from siatkowka.punktujace;
SELECT max(punkty) from siatkowka.punktujace;
SELECT min(punkty) from siatkowka.punktujace;

SELECT min(punkty) as minimum, max(punkty) as maksimum from siatkowka.punktujace;


select min(gospodarze[1]) as "I set", min(gospodarze[2]) as "II set",
min(gospodarze[3]) as "III set", min(gospodarze[4]) as "IV set",
min(gospodarze[5]) as "V set"
from siatkowka.statystyki;


select nazwisko, imie, avg(punkty), count(distinct punkty)
from punktujace natural join siatkarki
where iddruzyny = 'musz'
group by nazwisko, imie;

select nazwisko, imie,
(select max(punkty) from punktujace
where punktujace.numer = siatkarki.numer
and punktujace.iddruzyny = siatkarki.iddruzyny) as maksimum
from siatkarki order by 3 desc

select nazwisko, imie, punkty,
(select max(punkty)
from punktujace
where punktujace.numer = siatkarki.numer
and punktujace.iddruzyny = siatkarki.iddruzyny) as maksimum
from siatkarki natural join punktujace order by 1;

select nazwisko, imie, sum(punkty), nazwa
from siatkarki natural join druzyny natural join punktujace
group by nazwisko, imie, nazwa
having sum(punkty) > 200
order by sum(punkty) desc;

select nazwisko, imie, sum(punkty)
from siatkarki natural join punktujace
group by nazwisko, imie
having count(*) > 10
order by sum(punkty) desc;



Zad 3.3
select distinct miejscowosc from klienci;
select nazwa, telefon from klienci where telefon similar to '% __';
select nazwa, telefon from klienci where telefon similar to '% ___';



LABY 4:
4.2
select * from klienci k JOIN zamowienia z on z.idklienta=k.idklienta where k.nazwa LIKE '%Antoni';
select * from klienci k JOIN zamowienia z on z.idklienta=k.idklienta where k.ulica LIKE '%/%';
select * from klienci k JOIN zamowienia z on z.idklienta=k.idklienta where k.miejscowosc='Kraków' and date_part('month', z.datarealizacji) = 11 and date_part('year', z.datarealizacji) = 2013;

4.3.1
select k.idklienta, k.nazwa, k.ulica, k.miejscowosc, z.datarealizacji from klienci k JOIN zamowienia z on z.idklienta=k.idklienta where z.datarealizacji >= current_date - interval '5 year';
albo:
select k.idklienta, k.nazwa, k.ulica, k.miejscowosc, z.datarealizacji from klienci k JOIN zamowienia z on z.idklienta=k.idklienta where z.datarealizacji >= date '2013-11-30' - interval '5 year';


4.3.2
select k.idklienta, k.nazwa, k.ulica, k.miejscowosc, z.datarealizacji, p.nazwa from klienci k JOIN zamowienia z on z.idklienta=k.idklienta JOIN artykuly a on a.idzamowienia=z.idzamowienia JOIN pudelka p on a.idpudelka=p.idpudelka where p.nazwa in ('Kremowa fantazja', 'Kolekcja jesienna');
albo: 
select k.idklienta, k.nazwa, k.ulica, k.miejscowosc, z.datarealizacji, a.idpudelka from klienci k JOIN zamowienia z on z.idklienta=k.idklienta JOIN artykuly a on a.idzamowienia=z.idzamowienia where a.idpudelka in ('fudg', 'autu');

4.3.3
select k.idklienta, z.idklienta, k.nazwa, k.ulica, k.miejscowosc from zamowienia z JOIN klienci k on z.idklienta=k.idklienta;

4.3.4 ~
select k.idklienta, z.idklienta, k.nazwa, k.ulica, k.miejscowosc from zamowienia z LEFT JOIN klienci k on z.idklienta=k.idklienta;
4.3.5
select * from zamowienia z JOIN klienci k on z.idklienta=k.idklienta where date_part('year', z.datarealizacji) = 2013 and date_part('month', z.datarealizacji) = 11;
4.3.6
select * from klienci k NATURAL JOIN zamowienia z NATURAL JOIN artykuly where (idpudelka in ('fudg', 'autu') and sztuk > 1);


select distinct k.nazwa, k.ulica, k.miejscowosc, c.orzechy  from klienci k NATURAL JOIN zamowienia z NATURAL JOIN artykuly JOIN zawartosc using(idpudelka) JOIN czekoladki c using(idczekoladki) where czekoladki like 'migda_y';


LABY5
5.1.1
SELECT * from czekoladki;

SELECT count(*) from czekoladki;
5.1.2
SELECT count(nadzienie) from czekoladki;

SELECT count(*) from czekoladki
where nadzienie is not null;

5.1.3
select idpudelka, sztuk from zawartosc
order by sztuk desc limit 1;
5.1.4
select distinct idpudelka, (select sum(sztuk) from zawartosc z where z.idpudelka = zawartosc.idpudelka) from zawartosc
order by sum;

select idpudelka, sum(sztuk) from zawartosc
group by idpudelka
order by sum;

5.2.1
select idpudelka, sum(masa) from zawartosc natural join czekoladki
group by idpudelka;
5.2.2
select idpudelka, sum(masa) from zawartosc natural join czekoladki
group by idpudelka
order by sum desc limit 1;
5.2.3
select avg(masa) from zawartosc natural join czekoladki;
5.2.4
select idpudelka, avg(masa)/sum(sztuk) from zawartosc natural join czekoladki
group by idpudelka;

5.3.1
select datarealizacji, count(*) as ilosczamowien from zamowienia
group by datarealizacji
order by datarealizacji;
5.3.2
select count(*) from zamowienia;
5.3.3
-- select * from zamowienia natural join artykuly natural join pudelka;
-- select idzamowienia, sztuk*cena as wartosc from zamowienia natural join artykuly natural join pudelka;
select sum(sztuk*cena) from zamowienia natural join artykuly natural join pudelka;
5.3.4
select * from klienci natural join zamowienia natural join artykuly join pudelka using(idpudelka)
order by idklienta;

select idklienta, idzamowienia, (select sum(sztuk*cena) as wartosc from artykuly a natural join pudelka
where a.idzamowienia = idzamowienia) as wartosc from klienci left join zamowienia using(idklienta)
--group by idklienta
order by idklienta;

select sum(sztuk*cena) as wartosc from artykuly a natural join pudelka
where a.idzamowienia = 1
group by idzamowienia;

--select idzamowienia, sztuk, cena from artykuly a natural join pudelka
--order by idzamowienia;

5.4.1
select * from zawartosc
order by idczekoladki, sztuk;

select idczekoladki, count(*) as ilosc from zawartosc
group by idczekoladki
order by ilosc desc limit 1;

select idczekoladki from zawartosc
group by idczekoladki
order by count(*) desc limit 1;

5.4.2
select * from zawartosc natural join czekoladki
where orzechy is null;

select idpudelka, count(*) from zawartosc
group by idpudelka
order by count(*) desc;

select idpudelka, count(*) from zawartosc natural join czekoladki
where orzechy is null
group by idpudelka
order by count(*) desc;

select idpudelka from zawartosc natural join czekoladki
where orzechy is null
group by idpudelka
order by count(*) desc limit 1;

5.4.3
-- b01 nie jest w zadnym pudelku
select * from czekoladki left join zawartosc using(idczekoladki);


6.1.1
select * from czekoladki where idczekoladki = 'W98';
Insert into czekoladki values('W98', 'Biały kieł', 'biała', 'laskowe', 'marcepan', 'Rozpływające się w rękach i kieszeniach', 0.45, 20);

6.1.2
select * from klienci;
INSERT INTO klienci values
    (90, 'Matusiak Edward', 'Kropiwnickiego 6/3', 'Leningrad', '31-471', '031 423 45 38'),
    (91, 'Matusiak Alina', 'Kropiwnickiego 6/3', 'Leningrad', '31-471', '031 423 45 38'),
    (92, 'Kimono Franek', 'Karateków 8', 'Mistrz', '30-029', '501 498 324');
select * from klienci where idklienta >89;

6.1.3
select * from klienci where 
Insert INTO klienci values(93, 'Matusiak Iza',
    (SELECT ulica from klienci where idklienta = 90),
    (SELECT miejscowosc from klienci where idklienta = 90),
    (SELECT kod from klienci where idklienta = 90),
    (SELECT telefon from klienci where idklienta = 90));
SELECT * from klienci where nazwa LIKE '%Matusiak%';

select * from klienci where idklienta >89;
delete from klienci where idklienta = 93;
select * from klienci where idklienta >89;
insert into klienci(idklienta, nazwa, ulica, miejscowosc, kod, telefon)
select 93, 'Matusiak Alina', ulica, miejscowosc, kod, telefon
from klienci 
where idklienta = 90;
select * from klienci where idklienta >89;

6.2
select * from czekoladki;
INSERT INTO czekoladki values
    ('X91', 'Nieznana Nieznajoma', null, null, null, 'Niewidzialna czekoladka wspomagajaca odchudzanie.', 0.26, 0),
    ('M98', 'Mleczny Raj', 'Mleczna', null, null, 'Aksamitna mleczna czekolada w ksztalcie butelki z mlekiem.', 0.26, 36);
select * from czekoladki where idczekoladki in('X91', 'M98');

6.3
DELETE from czekoladki where idczekoladki in('X91', 'M98');

INSERT INTO czekoladki(idczekoladki, nazwa, czekolada, opis, koszt, masa)
values
    ('X91', 'Nieznana Nieznajoma', null, 'Niewidzialna czekoladka wspomagajaca odchudzanie.', 0.26, 0),
    ('M98', 'Mleczny Raj', 'Mleczna', 'Aksamitna mleczna czekolada w ksztalcie butelki z mlekiem.', 0.26, 36);
select * from czekoladki where idczekoladki in('X91', 'M98');


6.4.1
select * from klienci where idklienta > 89;
update klienci set nazwa = 'Nowak Iza' 
where idklienta = 93;

6.4.2
select * from czekoladki where idczekoladki in('W98', 'M98', 'X91');
update czekoladki set koszt = koszt*0.9
where idczekoladki in('W98', 'M98', 'X91');
select * from czekoladki where idczekoladki in('W98', 'M98', 'X91');

6.4.3
select * from czekoladki where idczekoladki in('W98', 'X91');
update czekoladki set koszt = (select koszt from czekoladki where idczekoladki = 'W98')
where idczekoladki = 'X91';
select * from czekoladki where idczekoladki in('W98', 'X91');

6.4.4
select * from klienci where miejscowosc LIKE '%grad%';
update klienci set miejscowosc = 'Piotrograd'
where miejscowosc LIKE '%eningrad%';
select * from klienci where miejscowosc LIKE '%grad%';

6.4.5
select substr(idczekoladki, 2,2)::numeric from czekoladki;
select * from czekoladki where substr(idczekoladki, 2,2)::numeric > 90;
update czekoladki set koszt = koszt + 0.15
where substr(idczekoladki, 2,2)::numeric > 90;
select * from czekoladki where substr(idczekoladki, 2,2)::numeric > 90;

6.5.1
select * from klienci where nazwa LIKE '%Matusiak%';
delete from klienci where nazwa LIKE '%Matusiak%';
select * from klienci where nazwa LIKE '%Matusiak%';

6.5.2
select * from klienci where idklienta > 91;
delete from klienci where idklienta > 91;
select * from klienci where idklienta > 91;

6.5.3
select * from czekoladki where koszt >=0.45 or masa >= 36 or masa = 0;
delete from czekoladki where koszt >=0.45 or masa >= 36 or masa = 0;

6.6
select * from pudelka;
id1 = 'new1';
id2 = 'new2';

insert into pudelka values
    ('new1', 'nazwa1', 'opis1', 100, 149),
    ('new2', 'nazwa2', 'opis2', 200, 249);

select * from zawartosc
order by idczekoladki;

delete from zawartosc where idpudelka in('new1', 'new2');
select * from zawartosc where idpudelka in('new1', 'new2');

insert into zawartosc values
    ('new1', 'b02', 5),
    ('new1', 'b03', 6),
    ('new1', 'b04', 1),
    ('new1', 'm05', 2),

    ('new1', 'd01', 3),
    ('new1', 'd02', 4),
    ('new1', 'd03', 5),
    ('new1', 'd04', 6);
select * from zawartosc where idpudelka in('new1', 'new2');

6.7 

??? 

select * from zawartosc where idpudelka in('new1', 'new2')
COPY TO /;






codeshare - stronka do wrzucania kodu (udostępniania).

dodać dane jakie ma jakiś inny rekord. (wyciągamy kolejne dane). można pozapytaniami, ale można inaczej

insert into klienci(.....)
select 93, 'Matusiak Alina', ulica, miejscowosc, kod, telefon
from klienci 
wehere idkleinta = 90;



select gospodarze[2:3] from statystyki limit 5;
select distinct on (czekolada, koszt) * from czekoladki;


select (substr('B', 1, 1) = 'B')::int;
select ('Basadas' LIKE 'B%')::int;



insert into pudelka values
    ('xxx', 'nazwa1', null, 100, 149);

select * from pudelka where idpudelka = 'xxx';
select count(*) from pudelka;
select count(opis) from pudelka;




select age(current_date, '2002-01-07');

select * from siatkarki
where nazwisko ~ '^[A-C]';


select date '2001-10-01' - date '2001-09-28';



2.6.1
select idCzekoladki, nazwa, masa, koszt from czekoladki
where masa between 15 and 24 or koszt between 0.15 and 0.24;

2.6.2
select idCzekoladki, nazwa, masa, koszt from czekoladki
where
    (masa between 15 and 24 and koszt between 0.15 and 0.24)
    or
    (masa between 25 and 35 and koszt between 0.25 and 0.35);

2.6.4
select idCzekoladki, nazwa, masa, koszt from czekoladki
where (masa between 25 and 35 and koszt not between 0.25 and 0.35);

2.6.5
select idCzekoladki, nazwa, masa, koszt from czekoladki
where (masa between 25 and 35
and koszt not between 0.15 and 0.24
and koszt not between 0.25 and 0.35);

3.1.1
select idZamowienia, dataRealizacji from zamowienia
where dataRealizacji BETWEEN '2013-11-12' and '2013-11-20';
3.1.2
select idZamowienia, dataRealizacji from zamowienia
where
    dataRealizacji BETWEEN '2013-12-01' and '2013-12-06'
 or dataRealizacji BETWEEN '2013-12-15' and '2013-12-20';

3.1.3
select idZamowienia, dataRealizacji from zamowienia
where
dataRealizacji BETWEEN '2013-12-01' and '2013-12-31';

SELECT idzamowienia, datarealizacji
FROM zamowienia
WHERE datarealizacji::varchar LIKE '2013-12-__';

3.1.4
select idZamowienia, dataRealizacji from zamowienia
where
date_part('year', dataRealizacji) = 2013
and DATE_PART('month', dataRealizacji) = 11;

select idZamowienia, dataRealizacji from zamowienia
where dataRealizacji::varchar like '2013-11-__';



3.1.5
SELECT idzamowienia, datarealizacji
FROM zamowienia
WHERE
date_part('year', datarealizacji) = 2013
AND
date_part('month', datarealizacji) IN (11, 12);

3.1.6
select idZamowienia, dataRealizacji
from zamowienia
where date_part('day', dataRealizacji) in (17, 18, 19);

select idZamowienia, dataRealizacji
from zamowienia
where date_part('day', dataRealizacji) between 17 and 19;


3.1.7
select idZamowienia, dataRealizacji
from zamowienia
where date_part('week', dataRealizacji) in (46, 47);

3.2.1
select idCzekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where nazwa like 'S%';

3.2.4
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE nazwa ~ '^(A|B|C)'

select idCzekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where substr(nazwa, 1, 1) in ('A', 'B', 'C');

3.2.5
select idCzekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where lower(nazwa) like '%orzech%';

SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE nazwa ILIKE '%orzech%'

3.2.6
select idCzekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where nazwa like 'S%m%';


3.2.7
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE nazwa ~* '(^| )maliny|truskawki'

select idCzekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where nazwa like '%maliny%' or nazwa like '%truskawki%';

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
WHERE nazwa not like '% %';

3.3.1
SELECT distinct miejscowosc
FROM klienci
where miejscowosc like '% %';

3.3.2
SELECT nazwa, telefon
FROM klienci
where telefon like '% __';

SELECT nazwa, telefon
FROM klienci
WHERE telefon LIKE '___ ___ __ __'

SELECT nazwa, telefon
FROM klienci
WHERE telefon ~ '^[0-9]{3} [0-9]{3} [0-9]{2} [0-9]{2}$'

3.3.3
SELECT nazwa, telefon
FROM klienci
where telefon like '% ___';

SELECT nazwa, telefon
FROM klienci
WHERE telefon LIKE '___ ___ ___'

SELECT nazwa, telefon
FROM klienci
WHERE telefon ~ '^[0-9]{3} [0-9]{3} [0-9]{3}$'

3.4.1
(SELECT idCzekoladki, nazwa, masa, koszt
FROM czekoladki
where masa between 15 and 24)
union
(SELECT idCzekoladki, nazwa, masa, koszt
FROM czekoladki
where koszt between 0.15 and 0.24);

3.4.2
(SELECT idCzekoladki, nazwa, masa, koszt
FROM czekoladki
where masa between 25 and 35)
INTERSECT
(SELECT idCzekoladki, nazwa, masa, koszt
FROM czekoladki
where koszt not between 0.25 and 0.35);

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
where masa between 15 and 24)
INTERSECT
(SELECT idCzekoladki, nazwa, masa, koszt
FROM czekoladki
where koszt between 0.15 and 0.24)

3.4.5
(SELECT idCzekoladki, nazwa, masa, koszt
FROM czekoladki
where masa between 25 and 35)
EXCEPT
(SELECT idCzekoladki, nazwa, masa, koszt
FROM czekoladki
where koszt between 0.15 and 0.24)
EXCEPT
(SELECT idCzekoladki, nazwa, masa, koszt
FROM czekoladki
where koszt between 0.29 and 0.35)



9.1

CREATE SCHEMA kwiaciarnia;

create table kwiaciarnia.klienci (
    idklienta varchar(10) not null,
    haslo   varchar(10) not null,
    nazwa   varchar(40) not null,
    miasto  varchar(40) not null,
    kod     char(6)     not null,
    adres   varchar(40) not null,
    email   varchar(40) not null,
    telefon varchar(16) not null,
    fax     varchar(16),
    nip     char(13),
    region  char(9),
    constraint haslo_min check (length((haslo)::text) > 4)
);

create table kwiaciarnia.zamowienia (
    idzamowienia    int         not null,
    idkleinta       varchar(10) not null,
    idodbiorcy      int         not null,
    idkompozycji    char(5)     not null,
    termin          date        not null,
    cena            numeric(7, 2) not null,
    zaplacone       boolean,
    uwagi           varchar(200)
);

create table kwiaciarnia.odbiorcy (
    idodbiorcy  int         not null,
    nazwa       varchar(40) not null,
    miasto      varchar(40) not null,
    kod         char(6)     not null,
    adres       varchar(40) not null
);


create sequence odbiorcy_idodbiorcy_seq
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1;

create table kwiaciarnia.kompozycje (
    idkompozycji char(5) not null,
    nazwa   varchar(40) not null,
    opis    varchar(100),
    cena    numeric(7, 2),
    minimum int,
    stan    int
    constraint cena_min check (cena >= 40.00)
);

create table kwiaciarnia.zapotrzebowanie (
    idkompozycji    char(5),
    data            date
);

create table kwiaciarnia.historia (
    idzamowienia    int , not null,
    idklienta       char(10),
    idkompozycji    char(5),
    cena            numeric(10, 2),
    termin          date
);

alter table only kwiaciarnia.odbiorcy alter column idodbiorcy set default
nextval('kwiaciarnia.odbiorcy_idodbiorcy_seq'::regclass) -- ??? 


alter table kwiaciarnia.klienci
    add constraint klienci_pkey primary key (idklienta);

alter table kwiaciarnia.zamowienia
    add constraint zamowienia_pkey primary key (idzamowienia);


alter table kwiaciarnia.historia
    add constraint historia_pkey primary key (idzamowienia);

alter table kwiaciarnia.kompozycje
    add constraint kompozycje_pkey primary key (idkompozycji);

alter table kwiaciarnia.odbiorcy
    add constraint odbiorcy_pkey primary key (idodbiorcy);

alter table kwiacairnia.zapotrzebowanie
    add constraint zapotrzebowanie_pkey primary key (idkompozycji);


alter table kwiaciarnia.zamowienia add constraint zamowienia_idklienta_fkey foreign key (idklienta)
references klienci;
alter table zamowienia add constraint zamowienia_idodbiorcy_fkey foreign key (idodbiorcy)
references odbiorcy;
alter table zamowienia add constraint zamowienia_idkompozycji_fkey foreign key (idkompozycji)
references odbiorcy;

alter table zapotrzebowanie add constraint zapotrzebowanie_idkompozycji_fkey foregin key (idkompozycji)
references kompozycje;


9.2
copy kwiaciarnia.kleinci from stdin with (delimiter ';', null 'BRAK DANYCH');
copy kwiaciarnia.kompozycje from stdin with (delimiter ';', null 'BRAK DANYCH');
copy kwiaciarnia.odbiorcy from stdin with (delimiter ';', null 'BRAK DANYCH'); -- ?? tu coś z serialem trzeba dorobic
copy kwiaciarnia.zamowienia from stdin with (delimiter ';', null 'BRAK DANYCH');
copy kwiaciarnia.historia from stdin with (delimiter ';', null 'BRAK DANYCH');










