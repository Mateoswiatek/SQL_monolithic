DROP SCHEMA IF EXISTS spotify CASCADE;
CREATE SCHEMA spotify;

create table spotify.albumy(
    idalbumu serial primary key,
    idwykonawcy integer not null,
    nazwa varchar(50) not null,
    gatuenk varchar(50) not null,
    data_wydania date not null
);

create table spotify.wykonawcy(
    idwykonawcy serial primary key,
    nazwa varchar(100) not null,
    kraj varchar(30) not null,
    data_debiutu date not null,
    data_zakonczenia date
);

create table spotify.utwory(
    idutworu serial primary key,
    idalbumu integer not null,
    nazwa varchar(100) not null,
    dlugosc integer not null
);

create table spotify.oceny(
    idutworu integer not null,
    idklienta integer not null,
    lubi boolean not null
);

create table spotify.klienci(
    idklienta serial primary key,
    login varchar(50) not null,
    data_rejestracji date not null,
    data_urodzenia date not null
);

create table spotify.playlisty(
    idplaylisty integer primary key,
    idklienta integer not null,
    nazwa varchar(30)
);

create table spotify.zawartosc(
    idplaylisty integer not null,
    idutworu integer not null
);

alter table spotify.albumy
    add constraint albumy_idwykonawcy_fk foreign key(idwykonawcy) references spotify.wykonawcy(idwykonawcy) on update cascade;


alter table spotify.utwory
    add constraint utwory_idalbumu_fk foreign key(idalbumu) references spotify.albumy(idalbumu) on update cascade;


alter table spotify.oceny
    add constraint oceny_pk primary key(idutworu, idklienta),
    add constraint oceny_idutworu_fk foreign key(idutworu) references spotify.utwory(idutworu) on update cascade,
    add constraint oceny_idklienta_kf foreign key(idklienta) references spotify.klienci(idklienta) on update cascade on delete cascade;

alter table spotify.playlisty
    add constraint playlisty_idklienta_fk foreign key(idklienta) references spotify.klienci(idklienta) on update cascade on delete cascade;

alter table spotify.zawartosc
    add constraint zawartosc_pk primary key(idplaylisty, idutworu),
    add constraint zawartosc_idplaylisty_fk foreign key(idplaylisty) references spotify.playlisty(idplaylisty) on update cascade on delete cascade,
    add constraint zawartosc_idutworu_fk foreign key(idutworu) references spotify.utwory(idutworu) on update cascade on delete cascade;




