Laboratorium 9
Verilog – Przejście dla pieszych
Materiały dydaktyczne przeznaczone są WYŁĄCZNIE dla studentów Wydziału Informatyki i Telekomunikacji Politechniki Poznańskiej
Cele:

zrealizowanie samodzielnej implementacji modułu,
sprawdzenie poprawności działania w symulacji,
synteza na fizyczny układ w laboratorium.
Ćwiczenie przewidziane jest na 2-3 zajęcia laboratoryjne.

Przebieg projektu:

Zaprojektować automat (stany + przejścia pomiędzy stanami). W tym celu ustalić:
sygnały wyjściowe i wejściowe,
elementy wykonawcze (np. mnożarki, sumatory, liczniki, kolejki),
zaprojektować stany automatu oraz ustalić warunki przejścia pomiędzy nimi.
Zaimplementować automat w języku Verilog.
Zweryfikować poprawność działania w symulacji.
Dokonać niezbędnych poprawek automatu oraz ewentualnej redukcji stanów.
Zsyntezować automat na układzie dostępnym w laboratorium oraz sprawdzić poprawność
działania.
Dokonać niezbędnych poprawek i usunąć zauważone błędy.
Uwagi:

Dostępne sygnały w fizycznym układzie opisane są na płytce PCB. Wejściowy/wyjściowy
sygnał z głównego modułu syntezy (TOP.v) powinien być przypisany do nóżki układu w pliku
.lpf. Przykładowe pliki są dostępne w plikach źródłowych.
Dostępne częstotliwości zegarowe to 50MHz oraz 48MHz (PCB_CLK50 – nóżka 105 oraz
PCB_CLK48 – nóżka 5).
Wymagania (proszę wybrać jedną z wersji do finalnej realizacji):

15 punktów
o Sygnalizacja działająca niezależnie od przycisków i czujnika, na zmianę zielone i
czerwone dla pieszych oraz odpowiednie sygnały dla samochodów. Proszę pamiętać,
że sygnalizacja przy zmianie światła z czerwonego na zielone przechodzi przez stan
„czerwony + żółty”, a w odwrotnym kierunku – przez stan „żółty”.
o Czas trwania światła zielonego dla pieszych i dla samochodów to 5 sekund.
2 0 punktów
o Domyślne zielone dla samochodów. Przy naciśnięciu przycisku (konieczny
debouncing) przełącza się na czerwone dla samochodów, zielone dla pieszych trwa 5
sekund, po czym wraca zielone dla samochodów.
3 0 punktów
o Odpowiednie zielone światło ustawia się tylko po tym, gdy naciśnięty zostanie
przycisk (z debouncingiem) lub wykryty zostanie sygnał z czujnika. Sygnalizacja nie
ma stanu „domyślnego”.
Dodatkowe 5 punktów do dowolnego z powyższych:
o Dodanie sygnalizacji dźwiękowej dla pieszych. Sygnalizacja dźwiękowa musi dać się
wyłączyć przez przełączenie przełącznika (żebyśmy nie zwariowali na etapie testów).
Zawartość raportu:

Opis scenariusza,
Schemat blokowy,
Diagram automatu,
Kod modułu,
Użycie zasobów (LUT i FF),
Maksymalna częstotliwość pracy estymowana przez Synplify.
