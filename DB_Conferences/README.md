Uwagi dotyczące konwencji przyjętych na schemacie:

    Połączenie między tabelami jest zaczepione tak, aby łączyć klucz obcy z kluczem głównym.
    Krotność przy połączeniu (1 lub n) jest umieszczana zawsze nad linią reprezentująca połączenie.

OPIS: Baza danych zawiera informacje o odczytach poziomu wody w punktach pomiarowych ulokowanych na polskich rzekach.

Relacja punkty_pomiarowe zawiera informacje o punktach pomiarowych zlokalizowanych na rzekach. Atrybut id_punktu jest unikatowym identyfikatorem punktu pomiarowego w skali kraju. Atrybut nr_porządkowy wskazuje, który to jest punkt pomiarowy na danej rzece (licząc od źródła), np punkt pomiarowy o identyfikatorze 107 jest 3 punktem pomiarowym na Sanie. Atrybuty dlugosc_geogr i szer_geogr wskazują położenie punktu pomiarowego, a atrybuty stan_ostrzegawczy i stan_alarmowy zdefiniowane dla tego punktu odpowiednio stany ostrzegawczy i alarmowy. Dane w tej tabeli w zasadzie nie ulegają zmianie (chyba, że zostanie zamontowany nowy punkt pomiarowy).

Tabela pomiary zawiera informacje od odczytach poziomu wody. Poziom wody podajemy w centymetrach. Odczyty mogą być wykonywane nawet kilka razy na dobę, stąd użyty typ timestamp. Każdy pomiar wody w danym punkcie pomiarowym skutkuje dodaniem nowego rekordu do tabeli pomiary.

Jeżeli po wykonaniu pomiaru stwierdzamy, że dla nowo dodanego rekordu pomiary.poziom_wody >= punkty_pomiarowe.stan_ostrzegawczy (oczywiście dla odpowiedniego punktu pomiarowego), to dodawany jest nowy rekord do tabeli ostrzezenia. W tym dodawanym rekordzie:

ostrzezenia.czas_ostrzezenia = pomiary.czas_pomiaru

ostrzezenia.przekroczony_stan_ostrz = pomiary.poziom_wody - punkty_pomiarowe.stan_ostrzegawczy

Jeżeli nie jest przekroczony stan alarmowy, to atrybut przekroczony_stan_alarm ma wartość NULL. Jeżeli stan alarmowy jest przekroczony, to:

ostrzezenia.przekroczony_stan_alarm = pomiary.poziom_wody - punkty_pomiarowe.stan_alarmowy

Atrybut zmiana_poziomu wskazuje o ile setnych (procent) zmienił się poziom wody względem wcześniejszego pomiaru (czyli bierzemy pod uwagę ostatni (ten nowy) i przedostatni pomiar). Nie ma znaczenia, czy ten przedostatni pomiar skutkował wpisaniem rekordu do tabeli ostrzezenia czy nie. 