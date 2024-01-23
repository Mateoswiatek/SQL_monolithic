-- BY Mateusz Świątek
-- lab 9

CREATE temporary TABLE dzialy(
    iddzialu CHAR(5) PRIMARY KEY,
    nazwa VARCHAR(32) NOT NULL,
    likalizacja VARCHAR(24) NOT NULL,
    kierownik INTEGER NOT NULL
);



CREATE temporary TABLE pracownicy(
    idpracownika serial PRIMARY KEY,
    nazwisko VARCHAR(32) NOT NULL,
    imie VARCHAR(16) NOT NULL,
    dataUrodzenia DATE NOT NULL,
    dzial CHAR(5) NOT NULL,
    stanowisko VARCHAR(24),
    pobory NUMERIC(10,2)
);

ALTER TABLE pracownicy
    add CONSTRAINT pracownicy_dzial_fk FOREIGN KEY(dzial) REFERENCES dzialy(iddzialu) ON UPDATE cascade;
ALTER TABLE dzialy
add CONSTRAINT dzialy_kierownik_fk FOREIGN KEY(kierownik) REFERENCES pracownicy(idpracownika) ON UPDATE cascade;

SELECT * FROM pracownicy;
SELECT * FROM dzialy;