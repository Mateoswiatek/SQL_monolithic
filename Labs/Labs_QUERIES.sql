SET search_path TO siatkowka, kwiaciarnia, public;

// Problem, bo zamiast w kwiaciarni mam wszystko w publicu.
ALTER ROLE matrxteo SET search_path TO siatkowka, kwiaciarnia, public, testowe; 

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
alter table kwiaciarnia.zamowienia add constraint zamowienia_idodbiorcy_fkey foreign key (idodbiorcy)
references odbiorcy;
alter table kwiaciarnia.zamowienia add constraint zamowienia_idkompozycji_fkey foreign key (idkompozycji)
references odbiorcy;

alter table kwiaciarnia.zapotrzebowanie add constraint zapotrzebowanie_idkompozycji_fkey foreign key (idkompozycji)
references kompozycje;


9.2
copy kwiaciarnia.kleinci from stdin with (delimiter ';', null 'BRAK DANYCH');
copy kwiaciarnia.kompozycje from stdin with (delimiter ';', null 'BRAK DANYCH');
copy kwiaciarnia.odbiorcy from stdin with (delimiter ';', null 'BRAK DANYCH'); -- ?? tu coś z serialem trzeba dorobic
copy kwiaciarnia.zamowienia from stdin with (delimiter ';', null 'BRAK DANYCH');
copy kwiaciarnia.historia from stdin with (delimiter ';', null 'BRAK DANYCH');







10.1
-- bierzemy unikatowe nazwy pudełek, w których znajdują się czekoladki które są jedymi z trzech najdroższych.
-- zwraca 3 rekordy, które są zamieniane na "listę"

-- bierzemy nazwę czekoladki której koszt jest największy - nazwa najdroższej czekoladki.

-- nazwę czekokladek oraz idppudełka w któym wstępuje dla trzech najdroższych czekoladek.

-- nazwa oraz koszt dla wszystkich czekoladek, trzecia kolumna to maksymalna cena.


-- natural joiny się gubiły, bo było więcej kolumn. 


10.2
select * from zamowienia join klienci using(idklienta);

select dataRealizacji, idzamowienia
from zamowienia
join klienci using(idklienta)
where nazwa ~~* '%antoni%';

select * from zamowienia join klienci using(idklienta)
where ulica ~~ '%/%';


select dataRealizacji, idzamowienia from zamowienia join klienci using(idklienta)
where miejscowosc = 'Kraków'
and dataRealizacji::varchar ~~ '2013-11-__';

10.3.1
select * from zamowienia join klienci using(idklienta);
select nazwa, ulica, miejscowosc, dataRealizacji from zamowienia 
join klienci using(idklienta)
where dataRealizacji = '2013-11-12';

10.3.2
select nazwa, ulica, miejscowosc, dataRealizacji from zamowienia 
join klienci using(idklienta)
where date_part('year', dataRealizacji) = 2013
and date_part('month', dataRealizacji) = 11;

10.3.3
select * from zamowienia 
join klienci using(idklienta)
where idzamowienia in (
select idzamowienia from artykuly
join pudelka using(idpudelka) where nazwa in ('Kremowa fantazja', 'Kolekcja jesienna'));

10.3.4
-- nazwa, ulica, miejscowosc, dataRealizacji
select * from zamowienia 
join klienci using(idklienta)
where idzamowienia in (
    select idzamowienia from artykuly
    where idpudelka in (select idpudelka from pudelka where nazwa in ('Kremowa fantazja', 'Kolekcja jesienna'))
    and sztuk > 1);

10.3.5
select * from zamowienia join klienci using(idklienta) where idzamowienia in (
    select idzamowienia from artykuly
    join zawartosc using(idpudelka)
    join czekoladki using(idczekoladki)
    where orzechy = 'migdały');

10.3.6
select * from klienci where idklienta in (select idklienta from zamowienia);
-- z exists
SELECT k.* FROM klienci k WHERE EXISTS (SELECT z.* FROM zamowienia z WHERE z.idklienta = k.idklienta);

10.3.7
select * from klienci where idklienta not in (select idklienta from zamowienia);
-- z exists
SELECT k.* FROM klienci k WHERE NOT EXISTS (SELECT z.* FROM zamowienia z WHERE z.idklienta = k.idklienta)


10.4
10.4.1
select p.nazwa, p.opis, p.cena from pudelka p
join zawartosc using(idpudelka)
join czekoladki using(idczekoladki)
where idczekoladki = 'd09';

10.4.2
select p.nazwa, p.opis, p.cena from pudelka p
join zawartosc using(idpudelka)
join czekoladki c using(idczekoladki)
where c.nazwa = 'Gorzka truskawkowa';

10.4.3
select p.nazwa, p.opis, p.cena from pudelka p
join zawartosc using(idpudelka)
join czekoladki c using(idczekoladki)
where c.nazwa in (select nazwa from czekoladki where nazwa ~~ 'S%');



11.1
/*
create function masaPudelka(idpudelka char(4)) returns numeric(7,2) as 
$$
declare
    summasa numeric(7,2) := 0;
    w record;
begin
    for w in select idczekoladki, sztuk from zawartosc z where z.idpudelka = idpudelka
    loop
        summasa := summasa + w.sztuk * (select masa from czekoladki c where c.idczekoladki = w.idczekoladki);
    end loop;
    return summasa;
end;
$$
language plpgsql
*/

CREATE OR REPLACE FUNCTION masaPudelka2(in arg1 CHARACTER(4))
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
$$ LANGUAGE PLpgSQL;

SELECT masaPudelka2('alls');


11.2
create or replace function zysk(in _idpudelka char(4))
returns numeric(7, 2) as
$$
declare 
    naszKoszt numeric(7,2);
begin
    select sum(c.koszt * z.sztuk) into naszKoszt
    from zawartosc z join czekoladki c using(idczekoladki)
    where z.idpudelka = _idpudelka;

    return (select cena from pudelka where idpudelka = _idpudelka) - naszKoszt - 0.90;
    
end;
$$ language PLpgSQL;

select zysk('alls');

select SUM(zysk(idpudelka)*sztuk) from zamowienia join artykuly using(idzamowienia)
where datarealizacji = '2013-10-30';

/* 
select *
    from zawartosc z join czekoladki c using(idczekoladki)
    where z.idpudelka = 'alls';

(select  cena from pudelka where idpudelka = 'alls'); 
*/

11.3.1

create or replace function sumaZamowien(in idklienta_ integer)
returns numeric(7,2) as
$$
declare
    sumaZamowien_ numeric(7,2);
begin
    select SUM(sztuk * cena) into sumaZamowien_
        from zamowienia
        join artykuly using(idzamowienia)
        join pudelka using(idpudelka)
        where idklienta = idklienta_;

    return sumaZamowien_;
end;
$$ language plpgsql;

select sumaZamowien(7);

-- select sztuk, cena from zamowienia join artykuly using(idzamowienia) join pudelka using(idpudelka) where idklienta = 7;

/*
-- klient co ma najwiecej zamowien,
-- id4 => 6
-- id2 => 4 
-- id3 => 3
-- id7 => 2
-- id8 => 1
select idklienta, count(*) from zamowienia group by idklienta
order by count(*) desc; 
*/

11.3.2

create or replace function rabat(in idklienta_ integer)
returns numeric(7,2) as
$$
declare
    _wartosc numeric(7,2);
    -- rabat_pr numeric(7,2);
begin
    select sumaZamowien(idklienta_) into _wartosc;
    -- return _wartosc * rabat_pr; - rabat to bylo to case.
    return _wartosc * case -- obliczanie rabatu w procentach
            when _wartosc between 101 and 200 then 0.04
            when _wartosc between 201 and 400 then 0.07
            else 0.08
        end case;
end;
$$ language PLpgSQL;


-- niby powinno dzialc ale chyba jednak nie
create or replace function rabat(in idklienta_ integer)
returns numeric(7,2) as
$$
declare
    _wartosc numeric(7,2);
    -- rabat_pr numeric(7,2);
begin
    select sumaZamowien(idklienta_) into _wartosc;
    -- return _wartosc * rabat_pr; - rabat to bylo to case.
    return _wartosc * case _wartosc -- obliczanie rabatu w procentach
            when between 101 and 200 then 0.04
            when between 201 and 400 then 0.07
            else 0.08
        end case;
end;
$$ language PLpgSQL;


select sumaZamowien(7);
select rabat(7);

11.4.1
create or replace function podwyzka() returns integer as
$$
declare
    w record;
    _podwyzka numeric(7,2)
begin
    for w in select * from czekoladki
    loop
        case
            when w.koszt < 20 then w.koszt := w.koszt +
    end loop;
    
end;
$$ language plpgsql;




-- OSTATNIE LABY
-- nie będzie triggerow, 
-- nie bedzie sprowadzania do postaci normalnej.

-- z algebry zależności będzie


-- http://20.123.196.72:9001/p/AGH-MP-LAB12-a
-- LAB12 a

F. zwracac musi abstrakcyjny typ trigger

Trigger moze sie odpalić przed lub po akcji

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
    stary_id int,
    dane TEXT,
    czas TIMESTAMP
);


Cel: trigger, który przy update tabeli WAZNE przepisze dane do tabeli ZAPAS i doda znacznik czasowy.



CREATE OR REPLACE FUNCTION on_update_wazne()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO zapas(stary_id,dane,  czas)
    VALUES (OLD.id, OLD.dane, CURRENT_TIMESTAMP);
    RETURN OLD; 
END;
$$ LANGUAGE plpgsql;



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
$$ LANGUAGE plpgsql;


CREATE TRIGGER wazneAfterDelete
AFTER DELETE ON wazne
FOR EACH ROW
EXECUTE FUNCTION on_delete_wazne();

select * from wazne;
update wazne set dane='poprawione' where id<3;

drop trigger wazneAfterUpdate on wazne;
drop function on_update_wazne;
drop function on_delete_wazne;Welcome to Etherpad!

CREATE OR REPLACE FUNCTION on_update_wazne()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO zapas(stary_id,dane,  czas)
    VALUES (OLD.id, OLD.dane, CURRENT_TIMESTAMP);
    RETURN OLD; 
END;
$$ LANGUAGE plpgsql;



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
$$ LANGUAGE plpgsql;


CREATE TRIGGER wazneAfterDelete
AFTER DELETE ON wazne
FOR EACH ROW
EXECUTE FUNCTION on_delete_wazne();

select * from wazne;
update wazne set dane='poprawione' where id<3;

drop trigger wazneAfterUpdate on wazne;
drop function on_update_wazne;
drop function on_delete_wazne;Welcome to Etherpad!


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
    stary_id int,
    dane TEXT,
    czas TIMESTAMP,
    akcja varchar(20)
);

Cel: Trigger ma przepisywać do 'zapas' dane z 'wazne' oraz  komentarz co się działo  ('zmieniony', 'skasowany')
Cel: Można następnie stworzyc jeden trigger implementujący obywdie wersje w jednym bloku kodu.




CREATE OR REPLACE FUNCTION on_update_wazne()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO zapas(stary_id,dane,  czas,akcja)
    VALUES (OLD.id, OLD.dane, CURRENT_TIMESTAMP,'wstawiony');
    RETURN OLD; 
END;
$$ LANGUAGE plpgsql;

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
$$ LANGUAGE plpgsql;

drop trigger wazneAfterDelete on wazne

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

alter table nowa_tabela add column 
liczba integer;
alter table nowa_tabela add column 
liczba2 integer default 2;

alter table nowa_tabela alter column liczba2 add check(liczba < 18);
alter table nowa_tabela alter column liczba2 set not null;
insert into nowa_tabela values('ola', default, null, null);
alter table nowa_tabela alter column liczba2 drop not null;
insert into nowa_tabela values('ola', default, null, null);

delete from nowa_tabela where liczba2 is null;

insert into nowa_tabela values('ola', default, 20, null);



insert into nowa_tabela values('ola', default, 20, null);

select * from nowa_tabela;
update nowa_tabela set liczba = 20;
-- Sprawdź nazwę ograniczenia CHECK
select constraint_name from information_schema.check_constraints
where constraint_name ~ 'pelnoletni';

alter table nowa_tabela add constraint pelnoletni check(liczba > 18);
alter table nowa_tabela drop constraint pelnoletni;
alter table nowa_tabela alter column liczba set not null;


create table maz(
    id integer primary key,
    idzony integer
);
create table zona(
    id integer primary key,
    idmeza integer
);
alter table maz 
    add foreign key(idzony) references zona;

alter table zona add constraint zona_idmeza_fkey
    foreign key(idmeza) references maz;

alter table zona drop constraint foreign key(idmeza);

drop table maz ;

SELECT constraint_name
FROM information_schema.table_constraints
WHERE table_name = 'zona' AND constraint_type = 'FOREIGN KEY';

alter table zona drop constraint zona_idmeza_fkey1;


create table dzialy(
    iddzialu    char(5)     primary key,
    nazwa       varchar(32) not null,
    lokalizacja varchar(23) not null,
    kierownik   integer     not null
);

create table pracownicy(
    idpracownika    integer     primary key,
    nazwisko        varchar(32) not null,
    imie            varchar(16) not null,
    dataUrodzenia   date        not null,
    dzial           char(5)     not null,
    stanowisko      varchar(24),
    pobory          numeric(7,2)
);

alter table dzialy add constraint dzial_fk
    foreign key(kierownik) references pracownicy(idpracownika) on update cascade deferrable;
alter table pracownicy add constraint pracownicy_fk
    foreign key(dzial) references dzialy(iddzialu) on update cascade deferrable;


select * from dzialy;
select * from pracownicy;

create schema testowe;
ALTER ROLE matrxteo SET search_path TO testowe; 
create table test(
    index serial primary key
);
-- Sprawdź, czy tabela istnieje w danym schemacie
SELECT table_name, table_schema
FROM information_schema.tables where table_name = 'test';

select * from test;
drop table test;
SELECT table_name, table_schema
FROM information_schema.tables where table_name = 'test';


create table klienci(
    idklienta varchar(10) primary key,
    haslo varchar(10) not null,
    nazwa varchar(40) not null,
    miasto varchar(40) not null,
    kod char(6) not null,
    adres varchar(40) not null,
    email varchar(40),
    telefon varchar(16) not null,
    fax varchar(16),
    nip char(13),
    regon char(9)
);

create table kompozycje(
    idkompozycji char(5) primary key,
    nazwa varchar(40) not null,
    opic varchar(100),
    cena numeric(7,2),
    minimm integer,
    stan integer
);

create table odbiorcy(
    idodbiorcy serial primary key,
    nazwa varchar(40) not null,
    miasto varchar(40) not null,
    kod char(6) not null,
    adres varchar(40) not null
);

create table zapotrzebowanie(
    idkompozycji char(5) primary key,
    data date
);

create table historia(
    idzamowienia integer primary key,
    idklienta varchar(10),
    idkompozycji char(5),
    cena numeric(7,2),
    termin date
);

create table zamowienia(
    idzamowienia integer primary key,
    idklienta varchar(10) not null,
    idodbiorcy integer not null,
    idkompozycji char(5) not null,
    termin date not null,
    cen numeric(7,2),
    zaplacone boolean default false,
    uwagi varchar(200)
);

alter table historia add constraint historia_fk foreign key(idzamowienia) references zamowienia(idzamowienia);
alter table zapotrzebowanie add constraint zapotrzebowanie_fk foreign key(idkompozycji) references kompozycje(idkompozycji);


alter table klienci add constraint min_dl_hasla check(length(haslo) >= 4);
alter table kompozycje add constraint min_cena check(cena >= 40.00);

alter table zamowienia
    add constraint zamowienia_klient_fk     foreign key(idklienta)    references klienci(idklienta),
    add constraint zamowienia_odbiorca_fk   foreign key(idodbiorcy)   references odbiorcy(idodbiorcy),
    add constraint zamowienia_kompozycja_fk foreign key(idkompozycji) references kompozycje(idkompozycji);


SELECT constraint_name, constraint_type, table_name
FROM information_schema.table_constraints
WHERE table_name = 'zamowienia';

--gdy dodawany jest zamowienie, sprawdzamy czy mamy tyle na stanie,
--jesli tak to apceptuejmy, odejmujemy od stanu tyle ile zeszlo, jesli
--spadnie ponizej normy minimum to dajemy do zapotrzebowania 2*minium? i tyle

-- dorobic

create table diety(
    id_diety serial primary key,
    nazwa varchar(150) not null,
    gluten boolean not null,
    laktoza boolean not null,
    wege boolean not null,
    keto boolean not null,
    opakowania_eko boolean not null,
    cena_dzien numeric(5,2) not null
);

create table dania (
    id_dania serial primary key,
    nazwa varchar(255) not null,
    gramatura integer not null,
    kalorycznosc integer not null,
    kuchnia varchar(100),
    wymaga_podgrzania boolean not null,
    koszt_produkcji numeric(5,2)
);

create table dostepnosc(
    id_diety integer not null,
    id_dania integer not null,
    data_dostawy date not null,
    pora_dnia varchar(100) not null
);

create table wybory(
    id_zamowienia integer not null, -- aby potem zamienic constraint na alter table
    id_dania integer not null,
    data_dostawy date not null,
    constraint wybory_pk primary key(id_zamowienia, id_dania, data_dostawy)
);


alter table dostepnosc
	add constraint dostepnosc_pk primary key(id_diety, id_dania, data_dostawy),
	add constraint dostepnosc_iddiety_fk foreign key(id_diety) references diety(id_diety),
	add constraint dostepnosc_iddania_fk foreign key(id_dania) references dania(id_dania),
    add constraint pora_dnia_c check(pora_dnia in ('śniadanie', 'drugie śniadanie', 'obiad', 'podwieczorek', 'kolacja')); -- ewentualnie enum, lepiej tabele słownikowe

alter table dania
	add constraint dlugsoc_nazwy_dania_c check(length(nazwa) >= 5);

-- alter table dania drop constraint pora_dnia_c;
insert into dania values(1, 'danie1', 20, 300, 'Polska', false, 20.5);
select * from dania;

alter table diety add column nazwa varchar(100);
insert into diety values(1, 'nazwa');
-- delete from diety where id_diety = 1;

insert into dostepnosc values(1, 1, '2024-01-20', 'śniadanie');

select * from diety;
select * from dania;
select * from dostepnosc;

insert into dostepnosc values(1, 1, '2024-01-20', 'śniadaniee'); -- git dziala ograniczenie

-- ===========================================================
-- TEST zad 4b
-- Korzystając z operatorów any oraz all (obu) napisz zapytanie SQL pobierające z bazy ID wszystkich
-- dań, które co najmniej raz były dostępne na kolację, a które jednocześnie ani razu nie zostały wybrane w
-- roku 2023. Nie używaj złączeń JOIN.
-- ===========================================================

select * from dostepnosc;
delete from dostepnosc;

insert into dania values
    (1, 'danie1', 1, 100, 'Francja', false, 1.0)
    (2, 'danie2', 2, 200, null,      false, 2.0);
    (3, 'danie3', 3, 300, 'Polska',  false, 3.0),
    (4, 'danie4', 4, 400, 'Polska',  false, 4.0);

select * from dania;

insert into wybory values
    (1, 1, '2023-07-19'),
    (1, 1, '2023-07-20'),
    (2, 2, '2024-03-20'),
    (2, 2, '2024-03-21'),
    (3, 3, '2019-02-20'),
    (3, 3, '2019-02-22'),
    (4, 4, '2023-02-20'),
    (4, 4, '2023-02-27');

select * from wybory;

insert into diety values
    (1, 'nazwa1'),
    (2, 'nazwa2'),
    (3, 'nazwa3');


select * from dostepnosc;

-- TF
insert into dostepnosc values(1, 1, '2023-07-19', 'śniadanie');
insert into dostepnosc values(1, 1, '2023-07-20', 'kolacja');
-- TT
insert into dostepnosc values(2, 2, '2024-03-20', 'kolacja');
insert into dostepnosc values(2, 2, '2024-03-21', 'śniadanie');
-- FT
insert into dostepnosc values(3, 3, '2019-02-20', 'obiad');
insert into dostepnosc values(3, 3, '2019-02-22', 'śniadanie');
-- FF
insert into dostepnosc values(3, 4, '2023-02-20', 'obiad');
insert into dostepnosc values(3, 4, '2023-02-27', 'śniadanie');

-- Pierwszy warunek
select id_dania from dostepnosc
where
pora_dnia = 'kolacja';

-- X F: -> te ktore niespelniaja drugiego warunku:
select id_dania from wybory where date_part('year', data_dostawy) = 2023;

-- Razem -> tylkok index 2 powinien byc poprawny.

-- ZAD4

select id_dania from dostepnosc
where
pora_dnia = 'kolacja'
and id_dania  != all (select id_dania from wybory where date_part('year', data_dostawy) = 2023);

create temporary table test(
    id serial
);
insert into test values
    (default),
    (default),
    (default),
    (default);
select * from test;

insert into test values(7);
select * from test;


-- Napisz zapytanie które wstawi klienta o loginie poprzedniego klienta
-- o najwyższym id z dopiskiem "ALT", ma mieć id większe o 1, tą samą datę
-- urodzenia i dzisiejszą date rejestracji.

create temporary table klienci_t(
    nazwa varchar(50),
    id_klienta serial,
    data_urodzenia date,
    data_rejstracji date
);
insert into klienci_t values
    ('Login', 1, '2002-01-07', '2023-01-20'),
    ('Login2', 2, '2002-12-28', '2023-01-21');

select * from klienci_t;

insert into klienci_t
select (nazwa || 'ALT'), (id_klienta+1), data_urodzenia, current_date from klienci_t 
where id_klienta = (select max(id_klienta) from klienci_t);

select * from klienci_t;



create temporary sequence seq1;

create temporary table nazwa_tabeli(
    nazwa integer primary key default nextval('seq1'),
    znak char
);

insert into nazwa_tabeli values
(default, 'a'),
(default, 'b'),
(default, 'c'); 

select * from nazwa_tabeli;


create temporary table nazwa_tabeli(
    nazwa serial primary key,
    znak char
);

insert into nazwa_tabeli values
(default, 'a'),
(default, 'b'),
(default, 'c');

select * from nazwa_tabeli;

1.
select nazwisko, wiek, pobory*12 as roczne_pobory from pracownicy
order by roczne_pobory desc, nazwisko;

2.
select nazwisko, imie, dataUrodzenia, coalesce(stanowisko, 'nie ma'), dzial, pobory
where stanowisko in ('robotnik', 'analityk')
and pobory > 2000;

3.
select nazwisko, imie from pracownicy 
where
pobory > (select pobory form pracownicy where imie = 'Adam' and nazwisko = 'Kowalik');

4.
update pracownicy set pobory = pobory*1.1 where stanowisko = 'robotnik';

5.
select stanowisko, avg(pobory), count(idpracownika) from pracownicy
where stanowisko <> 'kierownik';
group by stanowisko;



create temporary table dzialy(
    iddzialu char(5) primary key,
    nazwa varchar(32) not null,
    likalizacja varchar(24) not null,
    kierownik integer not null
);



create temporary table pracownicy(
    idpracownika serial primary key,
    nazwisko varchar(32) not null,
    imie varchar(16) not null,
    dataUrodzenia date not null,
    dzial char(5) not null,
    stanowisko varchar(24),
    pobory numeric(10,2)
);

alter table pracownicy add constraint pracownicy_dzial_fk foreign key(dzial) references dzialy(iddzialu);
alter table dzialy add constraint dzialy_kierownik_fk foreign key(kierownik) references pracownicy(idpracownika);

select * from pracownicy;
select * from dzialy;


-- sprawdzenie rekurencjynych
create temporary table pracownicy(
    id_pracownika serial primary key,
    id_szefa integer,
    imie varchar(20)
);

alter table pracownicy add constraint pracownicy_id_szefa_fk
	foreign key(id_szefa) references pracownicy(id_pracownika);




select nazwa, miasto from druzyny d
where exists (select 1 from punktujace p natural join siatkarki where p.iddruzyny = d.iddruzyny and  punkty > 8 and pozycja = 'rozgrywajaca');

select nazwa, miasto from druzyny d
where not exists (select 1 from punktujace p natural join siatkarki where p.iddruzyny = d.iddruzyny and punkty > 25);

select * from druzyny;
select nazwa, miasto from druzyny 
--where iddruzyny in  (select iddruzyny from punktujace where punkty > 25);
where iddruzyny = any (select iddruzyny from punktujace where punkty > 25);

select * from punktujace;

select nazwa, miasto from druzyny d
where not exists (select 1 from punktujace p
    where p.iddruzyny = d.iddruzyny and punkty > 25);

select idmeczu, termin, sum(punkty)
from punktujace natural join mecze
group by idmeczu, termin
having sum(punkty) > (select avg(pkt)::numeric(5,2) from
    (select sum(punkty) as pkt from punktujace group by idmeczu ) p );


-- obliczenie sumy punktow dla kazdej druzyny w kazdym meczu.
-- jeden rekord to jeden mecz i konkretna druzyna
-- nastepnie grupujemy te wyniki po nazwie druzyny, więc w kazdej grupie mamy w kazdym rekordzie
-- ilosc punktow jaka zdobyla druzyna w danym meczu. rekordow jest tyle ile rozgrywek rozegrala dana druzyna.
-- nastepnie w kazdej z grup (czyli dla każdej druzyny) średnią, czyli sumujemy wszytkie punkty i dzielimy
-- przez ilosc rekordow, bo tyle bylo mezcy

-- dostajemy srednia ilosc punktow zdobytych przez kazda z druzyn na jeden mecz.
with x as (
    select idmeczu, iddruzyny, sum(punkty) as pkt
    from punktujace
    group by idmeczu, iddruzyny)

select nazwa, avg(pkt)::numeric(7,2) srednia
from x natural join druzyny
group by nazwa
order by srednia desc;

-- with razem z usuwaniem i zwracaniem wartosci


CREATE TEMPORARY TABLE zamowienia_temp AS
SELECT * FROM zamowienia;

CREATE TEMPORARY TABLE historia_tmp AS
SELECT * FROM historia;

select * from zamowienia_temp;
select * from historia_tmp;


-- select * from zamowienia_temp where datarealizacji = '2013-11-02';
WITH x AS (
    DELETE FROM zamowienia
    WHERE datarealizacji = '2013-11-02' 
    RETURNING *
)

insert into historia
select idzamowienia, idklienta, idkompozycji, cena, datarealizacji from x;

insert into zamowienia from x;



-- oke dziala
select * from kompozycje;
insert into kompozycje values('j02', 'nazwa', 'opis', 40.5, 2, 5);


with p as (update kompozycje set cena = cena * 1.1 returning *)
select idkompozycji, nazwa, cena from p;

-- ==================================================
-- zmiana typu kolumny uzywajac using(...)
-- ==================================================

-- select * from klienci;

CREATE TEMPORARY TABLE klienci_tmp AS
SELECT * FROM klienci;

--select * from klienci_tmp;

--select length(nazwa) from klienci_tmp;

alter table klienci_tmp add column dlugosc_nazwy integer;

update klienci_tmp set dlugosc_nazwy = length(nazwa);

-- select * from klienci_tmp;

-- wywali, bo nie moze autoamtycznie rzutować
-- alter table klienci_tmp alter column nazwa type integer;

select * from klienci_tmp;

-- mowimy w jaki sposob ma zamienic, uzywa tego co jest w using. to co jest w
-- using ma zwracac typ ktory jest zgodny z nowym typem tutaj zapewnie można też
-- wrzucić funkcję jakąś.

alter table klienci_tmp alter column nazwa
type integer using(length(nazwa));

select * from klienci_tmp;

-- ================================================================
--                  FUNKCJE RÓŻNE
-- ================================================================

create or replace function suma_zamowien(id_klienta_v integer)
returns numeric(7,2) as
$$
declare
    suma numeric(7,2);
begin
	select sum(sztuk*cena) into suma
    from zamowienia natural join artykuly natural join pudelka
	where idklienta = id_klienta_v;
    return suma;
end;
$$ language plpgsql;

select suma_zamowien(7);

create or replace function rabat2(id_klienta_v integer)
returns numeric(7,2) as
$$
declare
	suma numeric(7,2);
	wartosc_rabatu numeric(7,2);
begin
	select suma_zamowien(id_klienta_v) into suma;
	wartosc_rabatu = suma * case
        when suma < 75 then 0.05
	    when suma between 75 and 110 then 0.07
	    else 0.08
    end case;
	return wartosc_rabatu;
end;
$$ language plpgsql;
select rabat2(7);

create or replace function rabat2(id_klienta_v integer)
returns numeric(7,2) as
$$
declare
	suma numeric(7,2);
begin
	select suma_zamowien(id_klienta_v) into suma;
	return suma * case
        when suma < 75 then 0.05
	    when suma between 75 and 110 then 0.07
	    else 0.08
    end case;
end;
$$ language plpgsql;


select rabat2(7);

create or replace function sumaZamowien(_idklienta integer) returns numeric(7,2) as
$$
declare
	suma numeric(7,2);
begin
	select sum(cena*sztuk) into suma
        from zamowienia
        natural join artykuly
        natural join pudelka
        where idklienta = _idklienta;
	return suma;
end;
$$ language plpgsql;

select sumaZamowien(7);


create or replace function testowa(cena numeric(7,2)) returns numeric(7,2) as
$$
begin
	if cena < 0.0 then
        raise exception 'nieprawidlowa cena %, %', cena, $1; -- ablo $1 - odwołanie do atrybutow
    else raise notice 'licze dla %', cena;
    end if;
	return cena;
end;
$$ language plpgsql;

select testowa(4.4);
select testowa(-4.4);



create or replace function nazwa_funkcji(idklienta_ integer) returns numeric(7,2) as
$$
declare
	suma numeric(7,2);
begin
	if (idklienta_ not in (select idklienta from klienci)) then
        raise exception 'Nie ma takiego kllienta o id= %', idklienta_;
	end if;
	
    select sum(sztuk*cena) into suma
    from zamowienia
    natural join artykuly
    natural join pudelka
    where idklienta = idklienta_;

	return suma;
end;
$$ language plpgsql;

-- select nazwa_funkcji(-1);
select nazwa_funkcji(7);

drop function nazwa_funkcji(integer);

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

-- between jest domknięty po obu stronach, w tedy decyduje koleność w case. 
-- przy dokładniejszych lepiej normalne < i <=
create or replace function nazwa_funkcji(wartosc integer)
returns numeric(7,2) as
$$
declare
    wynik numeric(7,2) = 5;
begin
	 wynik = case
        when wartosc < 75 then 1
        when wartosc >= 75 and wartosc < 110 then 2
        when wartosc >= 110 and wartosc < 150 then 3
	    else 4
    end case;
    return wynik;
end;
$$ language plpgsql;

select nazwa_funkcji(74); -- 1
select nazwa_funkcji(75); -- 2 
select nazwa_funkcji(76); -- 2 
select nazwa_funkcji(109); -- 2 
select nazwa_funkcji(110); -- 3 
select nazwa_funkcji(111); -- 3
select nazwa_funkcji(149); -- 3
select nazwa_funkcji(150); -- 4 
select nazwa_funkcji(151); -- 4

drop function nazwa_funkcji(integer);


-- testowanie typu record, czy git działa odwołanie jak do tabeli 
-- ogolnie też z with x as () jest problem, bo nie pamieta po kolejnych zapytaniach 
-- chyba.

select *
        from zamowienia
        natural join artykuly
        natural join pudelka
        where idklienta = 7 limit 1;

create or replace function nazwa_funkcji(idklienta_ integer)
returns numeric(7,2) as
$$
declare
	r record;
begin
	select * into r
        from zamowienia
        natural join artykuly
        natural join pudelka
        where idklienta = idklienta_ limit 1;
	return r.cena;
end;
$$ language plpgsql;
select nazwa_funkcji(7);

drop function nazwa_funkcji(integer);


-- ======================================================
--                  PETLE
-- ======================================================

--=========================================
create or replace function nazwa_funkcji(licznik integer)
returns integer as
$$
declare
	n integer;
begin
    n = 0;
    <<infinite>>
    loop
        n = n+1;
        exit infinite when n>=licznik;
    end loop;
    return n;
end;
$$ language plpgsql;
select nazwa_funkcji(8);
select nazwa_funkcji(15);

drop function nazwa_funkcji(integer);



--=========================================
create temporary table test(
    id integer
);

create or replace function nazwa_funkcji() returns void as
$$
begin
    for i in 0 .. 10 by 2 
    loop
        insert into test values(i);
    end loop;

end;
$$ language plpgsql;

select nazwa_funkcji();

select * from test;

drop function nazwa_funkcji();


--=========================================
create temporary table test(
    id numeric(7,2)
);

create function nazwa_funkcji() returns void as 
$$
declare
    w record;
begin 
	for w in update kompozycje set cena = cena * 1.1 returning *
	loop
		insert into test values(w.cena);
	end loop;
end;
$$ language plpgsql;

select nazwa_funkcji();
select * from test;
drop function nazwa_funkcji();


--=========================================
create or replace function nazwa_funckji(idklienta_ integer, out suma numeric) as
$$
begin
	select sum(sztuk*cena) into suma
        from zamowienia
        natural join artykuly
        natural join pudelka
        where idklienta = idklienta_;
end;
$$ language plpgsql;

select nazwa_funckji(7);

drop function nazwa_funckji(integer);


--=========================================
create temporary table test(
    id integer
);

create function nazwa_funkcji() returns void as 
$$
declare 
    x integer = 0;
begin 
    while x < 10
    loop
        insert into test values(x);
        x = x + 1;
    end loop;

end;
$$ language plpgsql;

select nazwa_funkcji();
select * from test;
drop function nazwa_funkcji();

--=========================================
create temporary table test(
    id integer
);

create function nazwa_funkcji() returns void as
$$
declare 
    w record;
begin
	for w in select * from klienci
	loop
		insert into test values(w.idklienta);
	end loop;
end;
$$ language plpgsql;

select nazwa_funkcji();
select * from test;
drop function nazwa_funkcji();

--=========================================
create temporary table test(
    id integer
);

CREATE TEMPORARY TABLE klienci_tmp AS
SELECT * FROM klienci;

create function nazwa_funkcji() returns void as
$$
declare 
    w record;
begin
	for w in update klienci_tmp set idklienta = idklienta + 100 where idklienta < 40 returning *
	loop
		insert into test values(w.idklienta);
	end loop;
end;
$$ language plpgsql;

select nazwa_funkcji();
select * from test;
drop function nazwa_funkcji();

--=========================================
-- z if trzeba uwazac i zawsze dawać w when cala logike.
create or replace function nazwa_funkcji(x integer, out y integer) as
$$
begin 
    if x<10 then y = 10;
    elseif x<20 then y = 20;
    else y = 30;
    end if;

end;
$$ language plpgsql;

select nazwa_funkcji(14);

drop function nazwa_funkcji();

--=========================================
create or replace function nazwa_funkcji(cena numeric, out znizka numeric) as
$$
begin
	znizka = case 
	when cena < 20.0 then 0.05
	when cena >= 20.0 and cena < 40.0 then 0.10
	else 2.0
	end case; 
end;
$$ language plpgsql;

select nazwa_funkcji(25.0);

drop function nazwa_funkcji(numeric);


--=========================================
-- polimorficzne
create or replace function nazwa_funkcji(v1 anyelement,
    v2 anyelement, v3 anyelement, out wyjscie anyelement) as
$$
begin
    wyjscie = v1 + v2 + v3;
end;
$$ language plpgsql;
select nazwa_funkcji(1, 2, 3);
select nazwa_funkcji(1.0, 2.0, 3.0);
drop function nazwa_funkcji(anyelement, anyelement, anyelement);

--=========================================
create temporary table wyniki(cos integer, cos2 varchar);

create function nazwa_funkcji(x integer, y varchar) returns setof wyniki as
$$
begin
	return next (x, y);
end;
$$ language plpgsql;

select nazwa_funkcji(1, 'aaa');

drop function nazwa_funkcji(integer, varchar);

--=========================================

CREATE OR REPLACE FUNCTION suma_zamowien(nazwa varchar(10), dni integer) RETURNS numeric(7,2) AS
$$ 
DECLARE
    w1 numeric(7,2) := 0.0; -- historia
    w2 numeric(7,2) := 0.0; -- aktualne
BEGIN
    SELECT COALESCE(SUM(cena), 0.0) INTO w1 FROM zamowienia WHERE idnadawcy = nazwa; 
    SELECT COALESCE(SUM(cena), 0.0) INTO w2 FROM historia WHERE idnadawcy = nazwa AND termin >= current_date - dni; 

    RETURN w1 + w2;
END;
$$ LANGUAGE plpgsql;
drop function suma_zamowien(varchar(10), integer);

--=========================================

-- Zwiększa cenę dla każdej kompozycji, jesli cena jest ponizej 50  to o 5 zl, 
-- jesli pomiedzy 50 a 100 to o 10,  inaczej o 20p


select * from kompozycje;
insert into kompozycje values
('t00', 'test0', 'opis', 40.0, 1, 2),
('t01', 'test1', 'opis', 45.0, 1, 2),
('t02', 'test2', 'opis', 50.0, 2, 4),
('t03', 'test3', 'opis', 55.0, 3, 6),
('t04', 'test4', 'opis', 60.0, 4, 8),
('t05', 'test5', 'opis', 120.0, 5, 10);

create temporary table kompozycje_temp as
select * from kompozycje; 
select * from kompozycje_temp;

alter table kompozycje_temp add column stara_cena numeric;

create or replace function podwyzka() returns void as
$$
declare
	wiazanka record;
    podwyzka kompozycje.cena%type;
begin 
    for wiazanka in select * from kompozycje_temp
    loop

        if wiazanka.cena < 50 then podwyzka = 5;
        elseif wiazanka.cena >= 50 and wiazanka.cena < 100 then podwyzka = 10;
        else podwyzka = 20;
        end if;
        
        update kompozycje_temp set stara_cena = cena, cena = cena + podwyzka
            where wiazanka.idkompozycji = kompozycje_temp.idkompozycji;
    end loop;
end;
$$ language plpgsql;

select * from kompozycje_temp;
select podwyzka();
drop function podwyzka();
select * from kompozycje_temp;

--=========================================


-- Zwracanie zbioru rekordów (tabelę) przez funkcję
-- Co się tak naprawdę dzieje, (jak dodawać kolejne wartości do finalnego "wyjścia")?

select * from kompozycje;

CREATE TEMPORARY TABLE testowa2(
    id INTEGER,
    id2 integer
);

CREATE OR REPLACE FUNCTION nazwa_funkcji() RETURNS SETOF testowa2 AS
$$
BEGIN
    RETURN QUERY SELECT minimum, minimum FROM kompozycje;
    RETURN NEXT (2, 2);
END;
$$ LANGUAGE plpgsql;

-- Wywołanie funkcji i wyświetlenie wyników
select nazwa_funkcji();
SELECT * from nazwa_funkcji();

-- Usunięcie funkcji
DROP FUNCTION IF EXISTS nazwa_funkcji();

SELECT * FROM kompozycje;

-- lab 10
-- ================================================

 Napisz zapytanie wyświetlające informacje na temat zamówień
 (dataRealizacji, idzamowienia) używając odpowiedniego operatora
 in/not in/exists/any/all, które:

    zostały złożone przez klienta, który ma na imię Antoni,
    zostały złożone przez klientów z mieszkań (zwróć uwagę na pole ulica),
    ★ zostały złożone przez klienta z Krakowa do realizacji w listopadzie 2013 roku.

select dataRealizacji, idzamowienia  from zamowienia
where idklienta = any (select idklienta from klienci where nazwa ~* 'Antoni');

select dataRealizacji, idzamowienia from zamowienia
where idklienta = any ( select idklienta from klienci where ulica ~* '/');

select dataRealizacji, idzamowienia from zamowienia
where idzamowienia = any ( select idzamowienia from zamowienia where dataRealizacji::varchar ~~ '2013-11-__')
and idklienta = any (select idklienta from klienci where miejscowosc = 'Kraków');

-- Klienci, ktorzy zlozyli co najmniej 1 zamowienie (wersja z EXISTS):

select * from klienci k where exists (select 1 from zamowienia z where k.idklienta = z.idklienta);

-- Klienci, ktorzy nie zlozyli zadnych zamowien (wersja z EXISTS):

select * from klienci k where not exists (select 1 from zamowienia z where k.idklienta = z.idklienta);


-- Wszystkie czekoladki z kremem, ktorych koszt jest wyzszy od kosztu
-- dowolnej czekoladki z truskawkami wystepujacej w pudelku 'alls':

select * from czekoladki;

select * from czekoladki where nadzienie = 'krem'
and koszt > any (select koszt from czekoladki
    natural join zawartosc where nadzienie = 'truskawki' and idpudelka = 'alls');



-- Wszystkie czekoladki z kremem, ktorych koszt jest wyzszy od kosztu
-- wszystkich czekoladek z truskawkami wystepujacych w pudelku 'alls':

select * from czekoladki where nadzienie = 'krem'
and koszt > all (select koszt from czekoladki
    natural join zawartosc where nadzienie = 'truskawki' and idpudelka = 'alls');



-- LAB 11
/*
11.1
Napisz funkcję masaPudelka wyznaczającą masę pudełka jako
sumę masy czekoladek w nim zawartych.
Funkcja jako argument przyjmuje identyfikator pudełka.
Przetestuj działanie funkcji na podstawie prostej instrukcji select.
*/
-- drop function masaPudelka(char(4));

create or replace function masaPudelka(idpudelka_ char(4), out suma numeric(7,2)) as
$$
begin
    select sum(masa*sztuk) into suma from czekoladki natural join zawartosc
    where idpudelka = idpudelka_;
end;
$$ language plpgsql;

SELECT masaPudelka('alls');
 
/*
11.2.1
Napisz funkcję zysk obliczającą zysk jaki cukiernia uzyskuje
ze sprzedaży jednego pudełka czekoladek, zakładając, że zysk
ten jest różnicą między ceną pudełka, a kosztem wytworzenia zawartych
w nim czekoladek i kosztem opakowania (0,90 zł dla każdego pudełka).
Funkcja jako argument przyjmuje identyfikator pudełka. Przetestuj działanie
funkcji na podstawie prostej instrukcji select.
*/

create or replace function zysk(_idpudelka char(4), out zysk numeric(7,2)) as
$$
declare
    koszta numeric(7,2);
begin
    
    select sum(koszt*sztuk)+0.9 into koszta from czekoladki
        natural join zawartosc where idpudelka = _idpudelka;
    select cena-koszta into zysk from pudelka where idpudelka = _idpudelka;

end;
$$ language plpgsql;

select zysk('alls');

/*
11.2.2
Napisz instrukcję select obliczającą zysk
jaki cukiernia uzyska ze sprzedaży pudełek zamówionych w wybranym dniu.
*/

select sum(zysk(idpudelka)*sztuk) from zamowienia natural join artykuly where datarealizacji = '2013-10-30';

/*
11.3.1
Napisz funkcję sumaZamowien obliczającą łączną wartość zamówień złożonych przez klienta,
które czekają na realizację (są w tabeli Zamowienia). Funkcja jako argument przyjmuje
identyfikator klienta. Przetestuj działanie funkcji.
*/
drop function sumaZamowien(integer);

create or replace function sumaZamowien(idklienta_ integer, out suma numeric(7,2)) as
$$
declare

begin
    select sum(sztuk*cena) into suma from zamowienia
        natural join artykuly
        natural join pudelka
        where idklienta = idklienta_;
end;
$$ language plpgsql;

select sumaZamowien(7);

/*
11.3.2
Napisz funkcję rabat obliczającą rabat jaki otrzymuje klient składający zamówienie.
Funkcja jako argument przyjmuje identyfikator klienta.
Rabat wyliczany jest na podstawie wcześniej złożonych zamówień w sposób następujący:

    4 % jeśli wartość zamówień jest z przedziału 101-200 zł;
    7 % jeśli wartość zamówień jest z przedziału 201-400 zł;
    8 % jeśli wartość zamówień jest większa od 400 zł.
*/
drop function rabat(integer);
create or replace function rabat(idklienta_ integer, out wartosc_rabatu numeric(7,2)) as
$$
declare
    suma_zamowien numeric(7,2);
begin
    select sumaZamowien(idklienta_) into suma_zamowien;
    wartosc_rabatu = suma_zamowien * case
            when suma_zamowien > 100 and suma_zamowien <= 200 then 0.04
            when suma_zamowien > 200 and suma_zamowien <= 400 then 0.07
            when suma_zamowien > 400 then 0.08
            else 1.0
        end case;
end;
$$ language plpgsql;


--select sumaZamowien(7);
select rabat(7);


/*
11.4


Napisz bezargumentową funkcję podwyzka, która dokonuje podwyżki kosztów produkcji czekoladek o:

    3 gr dla czekoladek, których koszt produkcji jest mniejszy od 20 gr;
    4 gr dla czekoladek, których koszt produkcji jest z przedziału 20-29 gr;
    5 gr dla pozostałych.

Funkcja powinna ponadto podnieść cenę pudełek o tyle o ile zmienił się koszt produkcji zawartych w nich czekoladek.

Przed testowaniem działania funkcji wykonaj zapytania, które umieszczą w plikach dane na temat kosztów czekoladek i cen pudełek tak, aby można było później sprawdzić poprawność działania funkcji podwyzka. Przetestuj działanie funkcji.

*/ 

create temporary table czekoladki_temp as
select * from czekoladki;

create temporary table pudelka_temp as
select * from pudelka;

select * from czekoladki_temp;
select * from pudelka_temp;

create or replace function podwyzka() returns void as
$$
declare
    r record;
    r2 record;
    zmiana numeric(7,2);
    koszt_czekoladki numeric(7,2);
begin
    for r in select * from czekoladki_temp
    loop
        koszt_czekoladki = r.koszt;
        zmiana = case
                when koszt_czekoladki < 0.2 then 0.03
                when koszt_czekoladki between 0.20 and 0.29 then 0.04
                else 0.05
            end case;

        update czekoladki_temp set koszt = koszt + zmiana where idczekoladki = r.idczekoladki; 

        for r2 in select * from zawartosc z where z.idczekoladki = r.idczekoladki
        loop
            update pudelka_temp set cena = cena + (r2.sztuk*zmiana) where idpudelka = r2.idpudelka;
        end loop;

    end loop;
end;
$$ language plpgsql;

select * from czekoladki_temp;
select * from pudelka_temp order by idpudelka;

select podwyzka();

select * from czekoladki_temp;
select * from pudelka_temp order by idpudelka;

/*
11.6
Napisz funkcję zwracającą informacje o zamówieniach złożonych przez klienta,
którego identyfikator podawany jest jako argument wywołania funkcji.
W/w informacje muszą zawierać: idzamowienia, idpudelka, datarealizacji.
Przetestuj działanie funkcji. Uwaga: Funkcja zwraca więcej niż 1 wiersz!
*/

-- ten sposob jest niebezpieczny, bo nie zawsze dziala, lepiej normalnie returns table(...)
create temporary table zamowienia_info(
    r_idzamowienia integer,
    r_idpudelka char(4),
    r_datarealizacji date
);

select * from zamowienia_info;

create or replace function info_o_zamowieniach(idklienta_ integer) returns setof zamowienia_info as
$$
declare
    c record;
begin
    return query select idzamowienia, idpudelka, datarealizacji
        from zamowienia natural join artykuly where idklienta = idklienta_;

end;
$$ language plpgsql;

select * from info_o_zamowieniach(7);


create or replace function info_o_zamowieniach(idklienta_ integer)
returns table(
    r_idzamowienia integer,
    r_idpudelka char(4),
    r_datarealizacji date
) as
$$
declare
    c record;
begin
    return query select idzamowienia, idpudelka, datarealizacji
        from zamowienia natural join artykuly where idklienta = idklienta_;

end;
$$ language plpgsql;


select * from info_o_zamowieniach(7);

drop function info_o_zamowieniach(integer);
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
select * from zamowienia;

create or replace function rabat_kwiaty(idklienta_ integer, out wartosc_rabatu numeric(7,2)) as
$$
declare
    wartosc_zamowien numeric(7,2);
    wartosc_historii numeric(7,2);
begin
    select coalesce(sum(cena), 0.0) into wartosc_zamowien from zamowienia where idklienta = idklienta_;
    select coalesce(sum(cena), 0.0) into wartosc_historii from historia where idklienta = idklienta_ and termin >= current_date - 7;

    wartosc_zamowien = wartosc_zamowien + wartosc_historii;

    wartosc_rabatu = wartosc_zamowien * case 
    when wartosc_zamowien > 0 and wartosc_zamowien <= 100 then 0.05
    when wartosc_zamowien > 100 and wartosc_zamowien <= 400 then 0.10
    when wartosc_zamowien > 400 and wartosc_zamowien <= 700 then 0.15
    when wartosc_zamowien > 700 then 0.20
    else 1.0
    end case;
    

end;
$$ language plpgsql;

select rabat_kwiaty(1);