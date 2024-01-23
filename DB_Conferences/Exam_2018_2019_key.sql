####################
#
# Zadanie 1
#
####################

WITH

days AS (
    SELECT
        dr.reservationID,
        SUM(cd.price * (1 - dr.specialDiscount - cd.studentDiscount)) as price
    FROM
        Reservations r1
        INNER JOIN DaysReservations dr ON r1.reservationID = dr.reservationID
        INNER JOIN ConferenceDays cd ON dr.conferenceDayID = cd.conferenceDayID
    WHERE
        cd.conferenceID = 7
        AND r1.isCancelled = false
    GROUP BY dr.reservationID
),

events AS (
    SELECT
        er.reservationID,
        SUM(ce.price * (1 - er.specialDiscount - ce.studentDiscount)) as price
    FROM
        Reservations r2
        INNER JOIN EventReservations er ON r2.reservationID = er.reservationID
        INNER JOIN ConferenceEvents ce ON er.conferenceEventID = ce.conferenceEventID
    WHERE
        ce.conferenceID = 7
        AND r2.isCancelled = false
    GROUP BY er.reservationID
)

SELECT AVG(days.price + COALESCE(events.price, 0)) as sredni_koszt
FROM days LEFT JOIN events ON days.reservationID = events.reservationID


####################
#
# Zadanie 4
#
####################

Sprawdz czy dekompozycja ponizszej relacji na relacje o schematach {A,B,C} i {C,D,E} zachowuje
zaleznosci funkcyjne.

H = {A,B,C,D,E}

F = {{A,C} → B, D → C, {A,D} → C, E → D, E → C, A → C, {A,E} → B, C → B}

H1 = {A,B,C}
H2 = {C,D,E}

Minimalizujemy:

F = {{A,C} → B, D → C, {A,D} → C, E → D, E → C, A → C, {A,E} → B, C → B}

F = {{A,C} → B, D → C, _________, E → D, E → C, A → C, {A,E} → B, C → B}   ze wzgledu na D → C, A → C

F = {_________, D → C, _________, E → D, E → C, A → C, {A,E} → B, C → B}   ze wzgledu na A → C, C → B

F = {_________, D → C, _________, E → D, E → C, A → C, _________, C → B}   ze wzgledu na A → C, C → B
                                                                                    oraz E → C, C → B

F = {_________, D → C, _________, E → D, _____, A → C, _________, C → B}   ze wzgledu na E → D, D → C

Pozostaje:

F = {A → C, C → B, D → C, E → D}

{A}+ = {A,C,B}
{B}+ = {B,C}
{C}+ = {C,B}
{D}+ = {D,C,B}
{E}+ = {E,D,C,B}

Π H1(F) = {A → C, C → B}

Π H2(F) = {D → C, E → D, E → C}

Sprawdzamy czy kazda z zaleznosci F = {A → C, C → B, D → C, E → D}
da się wyprowadzic z Π H1(f) u Π H2(f).

Mozliwe jest wyprowadzenie wszystkich zaleznosci.

Dekompozycja zachowuje zaleznosci funkcyjne.

####################
#
# Zadanie 5
#
####################

Wyznacz klucze relacji i okresl w jakiej jest postaci. Zakladamy, ze jest w 1NF.

H = {A,B,C,D,E,F,G}

F = {{A,C} → B, D → C, {A,D} → C, E → D, E → C, A → C, {A,E} → B, C → B}

Po minimalizacji:

F = {A → C, C → B, D → C, E → D}

{A,E}+ = {A,E,C,B,D}

{A,E,F,G}+ = {A,E,C,B,D,F,G} klucz

kluczowe:    A,E,F,G
niekluczowe: B,C,D

Nie jest w 2NF poniewaz nie kazdy niekluczowy atrybut zalezy funkcyjnie od calego klucza.


