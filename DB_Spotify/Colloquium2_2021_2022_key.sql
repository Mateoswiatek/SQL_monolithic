############
#
# GRUPA A
#
############

SELECT p.idplaylisty FROM playlisty p
WHERE
    300 < ALL(
        SELECT u.dlugosc
        FROM utwory u INNER JOIN zawartosc z ON u.idutworu = z.idutworu
        WHERE z.idplaylisty = p.idplaylisty
    )
    AND 'Pop' = ANY(
        SELECT a.gatunek
        FROM
            albumy a
            INNER JOIN utwory uu ON a.idalbumu = uu.idalbumu
            INNER JOIN zawartosc zz ON uu.idutworu = zz.idutworu
        WHERE zz.idplaylisty = p.idplaylisty
    )

-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION uzupelnij_playliste(
    in idplaylisty_od INTEGER, in idplaylisty_do INTEGER, polub BOOLEAN
)
RETURNS TABLE(
    t_idutworu INTEGER,
    t_idalbumu INTEGER,
    t_nazwa CHARACTER VARYING(100),
    t_dlugosc INTEGER
) AS
$$
DECLARE owner INTEGER;
DECLARE c RECORD;
BEGIN
    owner := (SELECT idklienta FROM playlisty WHERE idplaylisty = idplaylisty_do);
   
    FOR c IN SELECT z.idutworu
             FROM zawartosc z
             WHERE
                 z.idplaylisty = idplaylisty_od
                 AND NOT EXISTS (
                     SELECT 1 FROM zawartosc zz
                     WHERE
                         zz.idplaylisty = idplaylisty_do
                         AND zz.idutworu = z.idutworu
                 )
    LOOP
    
        INSERT INTO zawartosc VALUES (idplaylisty_do, c.idutworu);
        
        IF polub = TRUE AND NOT EXISTS (
            SELECT * FROM oceny WHERE idutworu = c.idutworu AND idklienta = owner
        ) THEN
            INSERT INTO oceny VALUES (c.idutworu, owner, TRUE);
        END IF;
    
    END LOOP;
    
    RETURN QUERY SELECT DISTINCT u.*
    FROM
        zawartosc z
        INNER JOIN utwory u ON z.idutworu = u.idutworu
    WHERE z.idplaylisty = idplaylisty_do;
END;
$$ LANGUAGE PLpgSQL;

SELECT * FROM uzupelnij_playliste(1, 2, TRUE);

