BEGIN;

SET search_path TO spotify;
SET CONSTRAINTS ALL DEFERRED;

DELETE FROM wykonawcy;
DELETE FROM albumy;
DELETE FROM utwory;
DELETE FROM zawartosc;
DELETE FROM playlisty;
DELETE FROM klienci;
DELETE FROM oceny;


INSERT INTO spotify.wykonawcy (nazwa, kraj, data_debiutu, data_zakonczenia) VALUES
('Artysta1', 'Polska', '2000-01-01', NULL),
('Artysta2', 'USA', '1995-05-10', '2010-12-31'),
('Artysta3', 'Włochy', '2008-03-20', NULL),
('Artysta4', 'Francja', '2012-08-05', NULL),
('Artysta5', 'Niemcy', '1990-11-15', '2005-06-20');

INSERT INTO spotify.albumy (idwykonawcy, nazwa, gatunek, data_wydania) VALUES
(1, 'Album1', 'Rock', '2021-02-15'),
(2, 'Album2', 'Pop', '2018-06-30'),
(3, 'Album3', 'Hip-Hop', '1910-01-07'),
(4, 'Album4', 'Rock', '2010-03-25'),
(5, 'Album5', 'Pop', '2014-09-08');

INSERT INTO spotify.utwory (idalbumu, nazwa, dlugosc) VALUES
(1, 'Utwor1', 180),
(1, 'Utwor2', 210),
(2, 'Utwor3', 160),
(3, 'Utwor4', 220),
(3, 'Utwor5', 190),
(3, 'Utwor6', 80),
(3, 'Utwor6', 60),
(3, 'Utwor7', 70),
(3, 'Utwor8', 300),
(3, 'Utwor9', 400),
(3, 'Polskie Tango', 220);

INSERT INTO spotify.klienci (login, data_rejestracji, data_urodzenia) VALUES
('user1', '2022-01-01', '1990-05-20'),
('user2', '2021-12-15', '1985-11-10'),
('user3', '2023-02-28', '2000-08-05'),
('user4', '2020-06-10', '1992-03-15'),
('user5', '2022-09-18', '1988-12-01'),
('user6', '1990-09-18', '1900-12-01');

INSERT INTO spotify.playlisty (idklienta, nazwa) VALUES
(1, 'MojaPlaylista1'),
(1, 'MojaPlaylista2'),
(2, 'Faworyty'),
(2, 'Ulubione'),
(3, 'ImprezaMix'),
(3, 'ImprezaMix2'),
(6, 'Wszystkieee'),
(6, 'Pusta'),
(6, 'Jeden 220dlugosc'),
(6, 'Dwa sr 150'),
(6, 'PustaDwa');

INSERT INTO spotify.zawartosc (idplaylisty, idutworu) VALUES
(1, 1),
(1, 2),
(1, 8),
(1, 6),
(1, 7),
(2, 3),
(3, 4),
(4, 5),
(7, 1),
(7, 2),
(7, 3),
(7, 4),
(7, 5),
(7, 6),
(7, 7),
(7, 8),
(7, 9),
(7, 10),
(7, 11),
(9, 4), -- dodanie do tego jednego 220
(10, 4), -- dodanie do tej z dwoma o sredniej 150
(10, 6);

INSERT INTO spotify.oceny (idutworu, idklienta, lubi) VALUES
(1, 1, true),
(2, 1, false),
(3, 2, true),
(4, 3, true),
(5, 4, false);

COMMIT;