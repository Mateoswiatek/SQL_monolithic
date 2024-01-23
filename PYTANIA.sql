
/*
15.
Napisz funkcje
polub_utwory_wykonawcy która przyjmuje
3 argumenty: loginklienta, idwykonawcy,
polub(boolean). Funkcja dodaje polubienia
do wszystkich utworów znajdujących się na
wszystkich playlistach klienta o loginie
loginklienta (jeśli wartość polub jest
ustawiona na True), ktore należą do
albumów wykonawcy o id = idwykonawcy i
nie zostały wcześniej polubione przez
klienta. Funkcja zwraca wszystkie
polubione utwory z playlist klienta (po
operacji polubienia utworów wykonawców)
(idplaylisty, idutworu, idklienta, lubi)


-- czyli mialy wartosc false lub null. 
-- jesli byloby polub = false, no to w tedy wszystkie bysmy ustawili na false
-- polubione, czyli jesli byly na lubi=false, to rowniez sie do tego zalicza.
-- wszystko co nie jest lubi=true to sie zalicza do tego.

i nie zostały wcześniej polubione przez
klienta.
*/

begin;

create or replace function polub_utwory_wykonawcy(loginklienta_ varchar(50), idwykonawcy_ integer, polub boolean)
returns table(
    r_idplaylisty integer,
    r_idutworu integer,
    r_idklienta integer,
    r_lubi boolean
) as
$$
declare
    idklienta_ integer;
begin
    select idklienta into idklienta_ from klienci where login = loginklienta_;

    -- distinct na idutworu, bo moze byc w wielu playlistach, ale 
    -- i tak dla kazdego tylko jeden raz musimy to wykonac, inne sa const
    
    -- tutaj np moglem zrobic join albumy
    -- i dac sam waurnek ale co jest bardziej wydane?

    -- optymalizacja czy bardziej sie oplaca rozbic na dwa:
    -- modyfikacja niepolubionych na polubione  
    -- oraz dodanie zypelnie nowych, - wymaga sprawdzenia tych ktorych nie ma, ewentualnie 
    -- ewentualnie "zapisanie" danych ktore sa wyrzucane z except, bo w tedy to moze byloby szybsze.

    -- czy takie podejscie jak ja zrobilem
    insert into oceny 
    select distinct(idutworu), idklienta_, polub from playlisty
        natural join zawartosc
        join utwory using(idutworu)
        -- join albumy using(idalbumu) --   ALTERNATYWA
        where
            idklienta = idklienta_ and
        -- idwykonawcy = idwykonawcy_ --    ALTERNATYWA
            idalbumu in (select idalbumu from albumy
                where idwykonawcy = idwykonawcy_) -- zamiast tego
    on conflict(idutworu, idklienta) do update set lubi = polub; -- ta co ma byc wstawiane: EXCLUDED.lubi

    return query select idplaylisty, idutworu, idklienta, lubi from klienci
        natural join oceny
        natural join playlisty
        where idklienta = idklienta_;
end;
$$ language plpgsql;






