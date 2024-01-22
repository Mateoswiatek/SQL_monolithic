DROP SCHEMA IF EXISTS Spotify CASCADE;
CREATE SCHEMA Spotify;

create table Spotify.albumy(
    idalbumu serial primary key,
    idwykonawcy integer not null,
    nazwa varchar(50) not null,
    gatuenk varchar(50) not null,
    data_wydania date not null
);

create table Spotify.wykonawcy(
    idwykonawcy serial primary key,
    nazwa varchar(100) not null,
    kraj varchar(30) not null,
    data_debiutu date not null,
    data_zakonczenia date
);

create table Spotify.utwory(
    idutworu serial primary key,
    idalbumu integer not null,
    nazwa varchar(100) not null,
    dlugosc integer not null
);

create table Spotify.oceny(
    idutworu integer not null,
    idklienta integer not null,
    lubi boolean not null
);

create table Spotify.klienci(
    idklienta serial primary key,
    login varchar(50) not null,
    data_rejestracji date not null,
    data_urodzenia date not null
);

create table Spotify.playlisty(
    idplaylisty integer primary key,
    idklienta integer not null,
    nazwa varchar(30)
);

create table Spotify.zawartosc(
    idplaylisty integer not null,
    idutworu integer not null
);

alter table Spotify.albumy
    add constraint albumy_idwykonawcy_fk foreign key(idwykonawcy) references Spotify.wykonawcy(idwykonawcy) on update cascade;


alter table Spotify.utwory
    add constraint utwory_idalbumu_fk foreign key(idalbumu) references Spotify.albumy(idalbumu) on update cascade;


alter table Spotify.oceny
    add constraint oceny_pk primary key(idutworu, idklienta),
    add constraint oceny_idutworu_fk foreign key(idutworu) references Spotify.utwory(idutworu) on update cascade,
    add constraint oceny_idklienta_kf foreign key(idklienta) references Spotify.klienci(idklienta) on update cascade on delete cascade;

alter table Spotify.playlisty
    add constraint playlisty_idklienta_fk foreign key(idklienta) references Spotify.klienci(idklienta) on update cascade on delete cascade;

alter table Spotify.zawartosc
    add constraint zawartosc_pk primary key(idplaylisty, idutworu),
    add constraint zawartosc_idplaylisty_fk foreign key(idplaylisty) references Spotify.playlisty(idplaylisty) on update cascade on delete cascade,
    add constraint zawartosc_idutworu_fk foreign key(idutworu) references Spotify.utwory(idutworu) on update cascade on delete cascade;




