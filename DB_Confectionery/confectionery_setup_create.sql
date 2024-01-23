BEGIN;
DROP SCHEMA IF EXISTS confectionery CASCADE;
CREATE SCHEMA confectionery;
SET search_path TO confectionery;
SET CONSTRAINTS ALL DEFERRED;

DROP TABLE IF EXISTS zawartosc;
DROP TABLE IF EXISTS artykuly;
DROP TABLE IF EXISTS zamowienia;
DROP TABLE IF EXISTS klienci;
DROP TABLE IF EXISTS pudelka;
DROP TABLE IF EXISTS czekoladki;


create table czekoladki (
  idczekoladki char(3) primary key,
  nazwa        varchar(30) not null,
  czekolada    varchar(15),
  orzechy      varchar(15),
  nadzienie    varchar(15),
  opis         varchar(100) not null,
  koszt        numeric(7,2) not null,
  masa         integer not null
);

create table pudelka (
  idpudelka char(4) primary key,
  nazwa     varchar(40) not null,
  opis      varchar(150),
  cena      numeric(7,2) not null,
  stan      integer not null
);

create table zawartosc (
  idpudelka    char(4) not null references pudelka,
  idczekoladki char(3) not null references czekoladki,
  sztuk        integer not null,
  primary key (idpudelka, idczekoladki)
);

create table klienci (
  idklienta   integer primary key,
  nazwa       varchar(130) not null,
  ulica       varchar(30) not null,
  miejscowosc varchar(15) not null,
  kod         char(6) not null,
  telefon     varchar(20) not null
);

create table zamowienia (
  idzamowienia   integer primary key,
  idklienta      integer not null references klienci,
  datarealizacji date not null
);

create table artykuly (
  idzamowienia integer not null references zamowienia,
  idpudelka    char(4) not null references pudelka,
  sztuk        integer not null,
  primary key (idzamowienia, idpudelka)
);



COMMIT;