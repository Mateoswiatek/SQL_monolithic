
/*
15.
Napisz funkcje
polub_utwory_wykonawcy która przyjmuje
3 argumenty: loginklienta, idwykonawcy,
polub(BOOLEAN). Funkcja dodaje polubienia
do wszystkich utworów znajdujących się na
wszystkich playlistach klienta o loginie
loginklienta (jeśli wartość polub jest
ustawiona na TRUE), ktore należą do
albumów wykonawcy o id = idwykonawcy i
nie zostały wcześniej polubione przez
klienta. Funkcja zwraca wszystkie
polubione utwory z playlist klienta (po
operacji polubienia utworów wykonawców)
(idplaylisty, idutworu, idklienta, lubi)


-- czyli mialy wartosc FALSE lub NULL. 
-- jesli byloby polub = FALSE, no TO w tedy wszystkie bysmy ustawili na FALSE
-- polubione, czyli jesli byly na lubi=FALSE, TO rowniez sie do tego zalicza.
-- wszystko co nie jest lubi=TRUE TO sie zalicza do tego.

i nie zostały wcześniej polubione przez
klienta.
*/

BEGIN;

CREATE OR REPLACE FUNCTION polub_utwory_wykonawcy(loginklienta_ VARCHAR(50), idwykonawcy_ INTEGER, polub BOOLEAN)
RETURNS TABLE(
    r_idplaylisty INTEGER,
    r_idutworu INTEGER,
    r_idklienta INTEGER,
    r_lubi BOOLEAN
) AS
$$
DECLARE
    idklienta_ INTEGER;
BEGIN
    SELECT idklienta INTO idklienta_ FROM klienci WHERE login = loginklienta_;

    -- distinct na idutworu, bo moze byc w wielu playlistach, ale 
    -- i tak dla kazdego tylko jeden raz musimy TO wykonac, inne sa const
    
    -- tutaj np moglem zrobic JOIN albumy
    -- i dac sam waurnek ale co jest bardziej wydane?

    -- optymalizacja czy bardziej sie oplaca rozbic na dwa:
    -- modyfikacja niepolubionych na polubione  
    -- oraz dodanie zypelnie nowych, - wymaga sprawdzenia tych ktorych nie ma, ewentualnie 
    -- ewentualnie "zapisanie" danych ktore sa wyrzucane z EXCEPT, bo w tedy TO moze byloby szybsze.

    -- czy takie podejscie jak ja zrobilem
    INSERT INTO oceny 
    SELECT distinct(idutworu), idklienta_, polub FROM playlisty
        NATURAL JOIN zawartosc
        JOIN utwory USING(idutworu)
        -- JOIN albumy USING(idalbumu) --   ALTERNATYWA
        WHERE
            idklienta = idklienta_ AND
        -- idwykonawcy = idwykonawcy_ --    ALTERNATYWA
            idalbumu IN (SELECT idalbumu FROM albumy
                WHERE idwykonawcy = idwykonawcy_) -- zamiast tego
    ON conflict(idutworu, idklienta) do UPDATE set lubi = polub; -- ta co ma byc wstawiane: EXCLUDED.lubi

    RETURN QUERY SELECT idplaylisty, idutworu, idklienta, lubi FROM klienci
        NATURAL JOIN oceny
        NATURAL JOIN playlisty
        WHERE idklienta = idklienta_;
END;
$$ LANGUAGE PLPGSQL;






