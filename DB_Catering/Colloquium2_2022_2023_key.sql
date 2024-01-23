############
#
# GRUPA A
#
############

SELECT id_dania
FROM dania
WHERE
    id_dania = ANY(SELECT id_dania FROM wybory WHERE DATE_PART('year', data_dostawy) = 2023)
    AND id_dania != ALL(SELECT id_dania FROM dostepnosc WHERE pora_dnia = 'kolacja')

-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION wybierz_najciezszy_posilek(id_zamowienia int, data_dostawy date, pora_dnia varchar)
RETURNS int AS
$$
DECLARE 
    id_dania int;
BEGIN
    SELECT dost.id_dania INTO id_dania
    FROM
        zamowienia z
        INNER JOIN diety di USING (id_diety)
        INNER JOIN dostepnosc dost USING (id_diety)
        INNER JOIN dania dn USING (id_dania)
    WHERE
        z.id_zamowienia = id_zamowienia
        AND dost.data_dostawy = data_dostawy
        AND dost.pora_dnia = pora_dnia
    ORDER BY dn.gramatura DESC
    LIMIT 1;

    INSERT INTO wybory (id_zamowienia, id_dania, data_dostawy) VALUES (id_zamowienia, id_dania, data_dostawy)
    ON CONFLICT (idkompozycji) DO UPDATE SET id_dania = id_dania;

    RETURN id_dania;
END;
$$ LANGUAGE PLpgSQL;


############
#
# GRUPA B
#
############

SELECT id_dania
FROM dania
WHERE
    id_dania = ANY(SELECT id_dania FROM dostepnosc WHERE pora_dnia = 'kolacja')
    AND id_dania != ALL(SELECT id_dania FROM wybory WHERE DATE_PART('year', data_dostawy) = 2023)

-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION wybierz_najciezszy_posilek(id_zamowienia int, data_dostawy date, pora_dnia varchar)
RETURNS int AS
$$
DECLARE 
    id_dania int;
BEGIN
    SELECT dost.id_dania INTO id_dania
    FROM
        zamowienia z
        INNER JOIN diety di USING (id_diety)
        INNER JOIN dostepnosc dost USING (id_diety)
        INNER JOIN dania dn USING (id_dania)
    WHERE
        z.id_zamowienia = id_zamowienia
        AND dost.data_dostawy = data_dostawy
        AND dost.pora_dnia = pora_dnia
    ORDER BY dn.gramatura DESC
    LIMIT 1;

    INSERT INTO wybory (id_zamowienia, id_dania, data_dostawy) VALUES (id_zamowienia, id_dania, data_dostawy)
    ON CONFLICT (idkompozycji) DO UPDATE SET id_dania = id_dania;

    RETURN id_dania;
END;
$$ LANGUAGE PLpgSQL;
