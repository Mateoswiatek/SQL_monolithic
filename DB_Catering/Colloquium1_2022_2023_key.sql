############
#
# GRUPA A
#
############

SELECT nazwa, FLOOR(gramatura / 10) as gramatura
FROM dania
WHERE kalorycznosc BETWEEN 300 AND 500
ORDER BY nazwa ASC, gramatura DESC

-------------------------------------------------------------------------------

SELECT id_diety FROM diety WHERE gluten = FALSE
INTERSECT
SELECT id_diety FROM zamowienia WHERE DATE_PART('month', data_zlozenia) = 12

-------------------------------------------------------------------------------

SELECT dn.nazwa
FROM
    zamowienia zam
    JOIN diety di USING (id_diety)
    JOIN dostepnosc dost ON (
        dost.id_diety = di.id_diety
        AND dost.data_dostawy BETWEEN zam.dostawy_od AND zam.dostawy_do
        AND dost.pora_dnia = 'śniadanie'
    )
    JOIN dania dn USING (id_dania)
    LEFT JOIN wybory wyb ON (
        wyb.id_zamowienia = zam.id_zamowienia
        AND wyb.id_dania = dost.id_dania
    )
WHERE
    zam.id_zamowienia = 20
    AND dn.kalorycznosc > 800
    AND wyb.id_zamowienia IS NULL

-------------------------------------------------------------------------------

WITH wartosc_zamowien AS (
    SELECT SUM(cena_dzien) AS wartosc
    FROM zamowienia zam JOIN diety di USING (id_diety)
    WHERE '2022-12-01'::date BETWEEN zam.dostawy_od AND zam.dostawy_do
),
koszt_dan AS (
    SELECT SUM(koszt_produkcji) AS koszt
    FROM
        wybory wyb
        JOIN dania dn USING (id_dania)
    WHERE wyb.data_dostawy = '2022-12-01'
)
SELECT COALESCE(w.wartosc - k.koszt, 0) AS zysk
FROM wartosc_zamowien w CROSS JOIN koszt_dan k

-------------------------------------------------------------------------------

INSERT INTO wybory (id_zamowienia, id_dania, data_dostawy)
SELECT zam.id_zamowienia, dn.id_dania, dost.data_dostawy
FROM
    zamowienia zam
    JOIN dostepnosc dost USING (id_diety)
    JOIN dania dn USING (id_dania)
WHERE
    zam.id_zamowienia = 20
    AND dost.data_dostawy = '2022-12-01'
    AND dost.pora_dnia = 'śniadanie'
ORDER BY dn.kalorycznosc ASC
LIMIT 1


############
#
# GRUPA B
#
############

SELECT nazwa, CEIL(gramatura / 10) as gramatura
FROM dania
WHERE wymaga_podgrzania = FALSE
ORDER BY nazwa DESC, kalorycznosc ASC

-------------------------------------------------------------------------------

SELECT id_diety FROM diety WHERE laktoza = FALSE
EXCEPT
SELECT id_diety FROM zamowienia WHERE DATE_PART('month', data_zlozenia) = 12

-------------------------------------------------------------------------------

SELECT dn.nazwa
FROM
    zamowienia zam
    JOIN diety di USING (id_diety)
    JOIN dostepnosc dost ON (
        dost.id_diety = di.id_diety
        AND dost.data_dostawy BETWEEN zam.dostawy_od AND zam.dostawy_do
        AND dost.pora_dnia = 'obiad'
    )
    JOIN dania dn USING (id_dania)
    LEFT JOIN wybory wyb ON (
        wyb.id_zamowienia = zam.id_zamowienia
        AND wyb.id_dania = dost.id_dania
    )
WHERE
    zam.id_zamowienia = 20
    AND dn.gramatura > 600
    AND wyb.id_zamowienia IS NULL

-------------------------------------------------------------------------------

WITH wartosc_zamowien AS (
    SELECT SUM(cena_dzien) AS wartosc
    FROM zamowienia zam JOIN diety di USING (id_diety)
    WHERE '2022-12-01'::date BETWEEN zam.dostawy_od AND zam.dostawy_do
),
koszt_dan AS (
    SELECT SUM(koszt_produkcji) AS koszt
    FROM
        wybory wyb
        JOIN dania dn USING (id_dania)
    WHERE wyb.data_dostawy = '2022-12-01'
)
SELECT COALESCE(w.wartosc - k.koszt, 0) AS zysk
FROM wartosc_zamowien w CROSS JOIN koszt_dan k

-------------------------------------------------------------------------------

UPDATE wybory
SET 
    id_dania = (
        SELECT dn.id_dania
        FROM
            zamowienia zam
            JOIN dostepnosc dost USING (id_diety)
            JOIN dania dn USING (id_dania)
        WHERE
            zam.id_zamowienia = 20
            AND dost.data_dostawy = '2022-12-01'
            AND dost.pora_dnia = 'obiad'
        ORDER BY dn.gramatura DESC
        LIMIT 1
    )
WHERE id_zamowienia = 20 AND data_dostawy = '2022-12-01'
