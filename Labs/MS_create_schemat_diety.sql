-- By Mateusz Świątek
-- lab 4

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

-- usuwanie ograniczen
alter table dostepnosc
	drop constraint dostepnosc_pk,
	drop constraint dostepnosc_iddiety_fk,
	drop constraint dostepnosc_iddania_fk,
    drop constraint pora_dnia_c;

alter table dania
	drop constraint dlugsoc_nazwy_dania_c;

-- usuwanie zawartosci
-- delete from diety; delete from dania; delete from dostepnosc; delete from wybory;

-- dodawanie ograniczen
alter table dostepnosc
	add constraint dostepnosc_pk primary key(id_diety, id_dania, data_dostawy),
	add constraint dostepnosc_iddiety_fk foreign key(id_diety) references diety(id_diety),
	add constraint dostepnosc_iddania_fk foreign key(id_dania) references dania(id_dania),
    add constraint pora_dnia_c check(pora_dnia in ('śniadanie', 'drugie śniadanie', 'obiad', 'podwieczorek', 'kolacja')); -- ewentualnie enum, lepiej tabele słownikowe

alter table dania
	add constraint dlugsoc_nazwy_dania_c check(length(nazwa) >= 5);

select * from diety;
select * from dania;
select * from dostepnosc;
select * from wybory;

-- insert into dostepnosc values(1, 1, '2024-01-20', 'śniadaniee'); -- git dziala ograniczenie

-- ===========================================================
-- TEST zad 4b
-- Korzystając z operatorów any oraz all (obu) napisz zapytanie SQL pobierające z bazy ID wszystkich
-- dań, które co najmniej raz były dostępne na kolację, a które jednocześnie ani razu nie zostały wybrane w
-- roku 2023. Nie używaj złączeń JOIN.
-- ===========================================================

insert into dania values
    (1, 'danie1', 1, 100, 'Francja', false, 1.0),
    (2, 'danie2', 2, 200, null,      false, 2.0),
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

select * from diety;

insert into dostepnosc values
    (1, 1, '2023-07-19', 'śniadanie'), -- TF
    (1, 1, '2023-07-20', 'kolacja'),
    (2, 2, '2024-03-20', 'kolacja'), -- TT
    (2, 2, '2024-03-21', 'śniadanie'),
    (3, 3, '2019-02-20', 'obiad'), -- FT
    (3, 3, '2019-02-22', 'śniadanie'),
    (3, 4, '2023-02-20', 'obiad'), -- FF
    (3, 4, '2023-02-27', 'śniadanie');

select * from dostepnosc;

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