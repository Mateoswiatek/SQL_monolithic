-- By Mateusz Świątek
-- lab 9

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

alter table pracownicy
    add constraint pracownicy_dzial_fk foreign key(dzial) references dzialy(iddzialu) on update cascade;
alter table dzialy
add constraint dzialy_kierownik_fk foreign key(kierownik) references pracownicy(idpracownika) on update cascade;

select * from pracownicy;
select * from dzialy;