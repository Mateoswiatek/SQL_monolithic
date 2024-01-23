/*
10.
Napisz funkcje start_od która przyjmuje prefiks i
zwraca dane utworów (idutworu, idalbumu, nazwa,
dlugosc), które się zaczynają od prefiksu
-- jesli po prostu maja zawirac, to zmienic na ~ prefiks
*/
create or replace function start_od(prefiks varchar(100)) returns setof utwory as
$$
begin
    return query select * from utwory where nazwa ~~ (prefiks || '%');
end;
$$ language plpgsql;



