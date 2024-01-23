BEGIN;

SET search_path TO catering;
SET CONSTRAINTS ALL DEFERRED;

DELETE FROM dania;
DELETE FROM wybory;
DELETE FROM diety;
DELETE FROM dostepnosc;

INSERT INTO dania values
    (1, 'danie1', 1, 100, 'Francja', FALSE, 1.0),
    (2, 'danie2', 2, 200, NULL,      FALSE, 2.0),
    (3, 'danie3', 3, 300, 'Polska',  FALSE, 3.0),
    (4, 'danie4', 4, 400, 'Polska',  FALSE, 4.0);



INSERT INTO wybory values
    (1, 1, '2023-07-19'),
    (1, 1, '2023-07-20'),
    (2, 2, '2024-03-20'),
    (2, 2, '2024-03-21'),
    (3, 3, '2019-02-20'),
    (3, 3, '2019-02-22'),
    (4, 4, '2023-02-20'),
    (4, 4, '2023-02-27');



INSERT INTO diety values
    (1, 'nazwa1'),
    (2, 'nazwa2'),
    (3, 'nazwa3');



INSERT INTO dostepnosc values
    (1, 1, '2023-07-19', 'śniadanie'), -- TF
    (1, 1, '2023-07-20', 'kolacja'),
    (2, 2, '2024-03-20', 'kolacja'), -- TT
    (2, 2, '2024-03-21', 'śniadanie'),
    (3, 3, '2019-02-20', 'obiad'), -- FT
    (3, 3, '2019-02-22', 'śniadanie'),
    (3, 4, '2023-02-20', 'obiad'), -- FF
    (3, 4, '2023-02-27', 'śniadanie');


COMMIT;