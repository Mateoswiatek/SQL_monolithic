Diagram przedstawia bazę cateringu dietetycznego z wyborem dań.

Klienci składają zamówienia na diety.

Każda dieta oferuje (tabela dostępność) w każdym dniu 25 dań, po 5 na każdą porę dnia: śniadanie, drugie śniadanie, obiad, podwieczorek i kolację. Klient wybiera z nich 5 dań, po jednym na każdą porę dnia. Jeżeli klient nie wybierze dań to zostaną one losowo wybrane w dniu dostawy.

Zamówienie jest realizowane w dni, które wskazują kolumny dostawy_od oraz dostawy_do. Tylko na te dni klient wybiera dania.

Warto przed kolokwium przypomnieć sobie informacje o typie boolean, który przyjmuje wartości TRUE/FALSE:
https://www.postgresql.org/docs/current/datatype-boolean.html
Na przykład: Dieta bezglutenowa w kolumnie gluten będzie mieć wartość FALSE. Dieta bezlaktozowa w kolumnie laktoza będzie mieć wartość FALSE. Jeżeli w ramach diety jedzenie dostarczane jest w opakowaniach ekologicznych to kolumna opakowania_eko będzie mieć wartość TRUE.

Każda dieta ma podany koszt jednego dnia (kolumna cena_dzien), wyrażony w złotówkach. Na przykład: jeśli zamówienie obejmuje 5 dni to jego wartość wyniesie 5 x cena_dzień.

Każde danie ma podany koszt produkcji (kolumna koszt_produkcji), wyrażony w złotówkach. Dodatkowo ma podaną gramaturę (w gramach) oraz kalorczyność (w kcal). Każde danie może mieć przypisany (ale nie musi) rodzaj kuchni (kolumna kuchnia), np. polska, włoska, amerykańska. Dania wymagające podgrzania będą mieć wartość TRUE w kolumnie wymaga_podgrzania.

