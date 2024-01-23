Diagram przedstawia bazę serwisu streamingowego muzyki. Klienci mogą odtwarzać
utwory muzyczne, wystawiać im oceny i tworzyć playlisty z dowolną zawartością.

W tabeli "wykonawcy" kolumna "data_zakoczenia" wskazuje, czy i kiedy wykonawca
zakończył działalność (nullable).

W tabeli "utwory" długość utworu jest wyrażona w sekundach.

W tabeli "oceny" każda ocena wyrażona jest jako wartość typu boolean: TRUE (lubi)
lub FALSE (nie lubi). Typ boolean po scastowaniu na int zwraca odpowiednio 1 i 0.