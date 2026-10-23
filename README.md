# StepCompass M4L v0.1.11

Wersja 0.1.7 poprawia kolejność fizycznych wejść podpatcha odtwarzania,
która w 0.1.6 mogła powodować ciszę. Zachowuje poprawiony slope i pole czasu z ±10 ms.

Odtwarzacz sampla z Simplera z 16-krokowym sekwencerem poleceń.
Dla Ableton Live 11 + Max for Live / Max 8, również macOS Intel.
Bez nagrywania; pobiera sample i jego zakres z poprzedzającego Simplera. Nuty MIDI nie są potrzebne.
Niezależna implementacja inspirowana koncepcją Compass Oliviera Creurera dla norns.
Nie zawiera kodu Compass ani silnika softcut.

## Pierwsze uruchomienie

1. Na ścieżce MIDI umieść **Simpler** i wczytaj do niego sample.
2. Pobierz **StepCompass-M4L-v0.1.11.amxd** i przeciągnij **bezpośrednio za Simpler**, jak Barcode.
   W racku oba urządzenia muszą znajdować się w tym samym łańcuchu.
3. Ustaw początek i koniec sampla w Simplerze. StepCompass automatycznie pobierze ten zakres.
4. Poczekaj, aż status pokaże nazwę pliku i zakres, np. `Simpler 1.00–4.00 s | ready`.
5. Domyślnie **FREE PLAY** jest włączone — sample zagra też przy zatrzymanym transporcie. Przełącz na LIVE PLAY, aby podążać za start/stop Live.
6. Zmień polecenia w listach kroków 1–16. Aktualny krok świeci na wyświetlaczu po lewej.

Zmiany sampla i markerów są wykrywane co 0,5 sekundy. **RELOAD** ponawia pobranie ręcznie.
StepCompass wybiera najbliższy poprzedzający Simpler w tym samym łańcuchu. Brak Simplera,
pusty sample lub usunięcie źródła wycisza StepCompass. Nie odtwarza wtedy starej kopii.
Przychodzące audio Simplera nie jest przepuszczane — słyszysz odtwarzanie StepCompass.

Plik AMXD zawiera wszystkie potrzebne skrypty. ZIP zawiera także źródła i README.
Do instalacji nie jest potrzebny Max Standalone ani kompilator.

## Sterowanie

- **ON / OFF:** wycisza/włącza odtwarzanie.
- **LIVE PLAY / FREE PLAY:** transport Live lub granie także przy zatrzymanym transporcie.
- **RESET:** początek regionu, normalny kierunek i szybkość, pełną głośność kroku, początkowy zegar i seed.
  Nie kasuje sampla ani poleceń.
- **RANDOMIZE:** nowa sekwencja z dokładną liczbą Holdów wyznaczoną przez HOLD %, a pozostałe komendy według COMMAND WEIGHTS.
- **Start % / End %:** dodatkowy region wewnątrz zakresu pobranego z Simplera. 0–100% oznacza cały zaznaczony w Simplerze zakres. Loop random pozostaje wewnątrz tego regionu.
- **Fade ms:** wygładzenie zmian i końców pętli (1–100 ms, domyślnie 20).
- **Out dB:** głośność, domyślnie −6 dB; −60 oznacza pełną ciszę.
- **Steps:** liczba aktywnych kroków 1–16.
- **Clock 0–4:** 0 = 1 polecenie na ćwierćnutę; 1 = 2; 2 = 4; 3 = 8; 4 = 16.
- **Seed:** stan początkowy losowania. RESET pozwala powtórzyć losowania przy tych samych ustawieniach.

| Polecenie | Działanie |
|---|---|
| Hold | Nic nie zmieniaj |
| Forward / Reverse | Do przodu / do tyłu, bez zmiany szybkości |
| Rate + / − | Kolejna / poprzednia szybkość z 0.5, 1, 2, bez zmiany kierunku |
| Rate random | Losuj 0.5, 1 lub 2, bez zmiany kierunku |
| Loop start | Początek bieżącej pętli w danym kierunku |
| Position | Losowa pozycja w pętli |
| Loop random | Nowa pętla wewnątrz regionu; minimum 40 ms, o ile region tyle ma |
| Clock + / − | Podwój / podziel przez dwa częstotliwość poleceń |
| Clock fastest / slowest | 16 / 1 polecenie na ćwierćnutę |
| Step random | Losowa pozycja sekwencera; następny tick przechodzi do następnego kroku |
| Fade out | W ciągu jednego kroku: pełna głośność → cisza |
| Fade in | W ciągu jednego kroku: cisza → pełna głośność |

FADE OUT i FADE IN zastępują PAN L/PAN R (także w puli losowania). Fade działa tylko na
przypisany krok. Następny krok, nawet Hold, wraca do pełnej głośności ustawionej pokrętłem
Out dB, chyba że sam ma Fade In/Out. Kolejne kroki z fade zaczynają własną obwiednię od nowa.
Długość fade wynika z aktualnego tempa i zegara kroków; nie z pokrętła **Fade ms**, które
nadal służy do wygładzania pętli i skoków sampla. Przy nagłym powrocie głośności zastosowano
krótkie wygładzenie 64 próbek (około 1,5 ms przy 44,1 kHz), aby ograniczyć kliknięcia.
W zapisanych sekwencjach stare polecenia Pan left/right stają się Fade out/in.

## Domyślne ustawienia i szanse losowania (v0.1.11)

Sekwencja początkowa jest zapisana bezpośrednio, jak na przesłanym zrzucie:

1. Forward, Fade out, Clock +, Reverse, Step random, Fade out, Hold, Clock −
2. Clock +, Fade out, Clock −, Fade in, Clock −, Fade out, Forward, Clock −

ON i FREE PLAY są włączone; region 0–100%, Fade ms 20, Out −6 dB, 16 kroków,
Clock 2 (4 polecenia na ćwierćnutę). Seed pozostaje 1234 — nie służy do odtworzenia
ręcznie zmienionej sekwencji ze zrzutu. Wzór kroków nie zależy od seeda przy ładowaniu.

**HOLD %** ustala liczbę Holdów po RANDOMIZE, a nie wagę losowania. Domyślnie 25%.
Liczba Holdów = zaokrąglenie `aktywne Steps × HOLD % / 100` do najbliższej liczby całkowitej
(połówki w górę). Obok widać wynik, np. `NEXT 4/16` (dla następnego RANDOMIZE).

- 0% → zero Holdów; 25% → 4 z 16; 50% → 8 z 16; 100% → same Holdy.
- Dla 8 aktywnych kroków 25% daje dokładnie 2 Holdy.
- RANDOMIZE rozmieszcza tę liczbę losowo w aktywnych krokach. Nie zmienia nieaktywnych kroków.
- **COMMAND WEIGHTS** to względne wagi 0–100 pozostałych 15 komend, bez znaku procenta.
  0 wyklucza komendę; 100 i 50 dają pierwszej dwa razy większą szansę na pozostałych miejscach.
- Domyślnie Rate +, Rate −, Clock fastest i Clock slowest mają wagę 0; pozostałe 100.
- Jeśli wszystkie wagi komend są zerowe i potrzebne są kroki inne niż Hold, RANDOMIZE
  pokazuje komunikat i nic nie zmienia. Przy HOLD 100% może wygenerować same Holdy bez innych wag.
- HOLD % i wagi działają dopiero po RANDOMIZE; nie zmieniają automatycznie ręcznie ustawionej sekwencji.
- Domyślny wzór kroków ze zrzutu zostaje zachowany. HOLD 25% zastosuje się po pierwszym RANDOMIZE.

Ustawienia zapisują się z projektem i obsługują automatyzację. Starsze zapisane wagi komend są
zachowywane (dawne przełączniki 0/1 zamieniają się na 0/100); stara waga Hold nie jest już używana.
Przy odczycie starego stanu HOLD % zaczyna od 25%, bez zmieniania zapisanych kroków.

## Rate slope ms (v0.1.11)

Czas dojścia od bieżącej szybkości odtwarzania do nowej: 0–10000 ms, domyślnie 50 ms.
0 oznacza zmianę natychmiastową; 200 ms krótki ślizg; 1000 ms rozpędzanie/hamowanie taśmy.
Działa dla Rate +/− i Rate random. Zmiana szybkości zmienia też pitch.
Przejście jest liniowe w szybkości, nie w półtonach.

Sygnał szybkości tworzy natywny `line~` na wątku DSP, wspólny dla obu głowic stereo.
Kolejne polecenie retargetuje go od aktualnej wartości — bez skoku do poprzedniego celu,
bez restartu pozycji sampla i bez czekania na crossfade pozycji/pętli. Hold, Fade In/Out,
Position i Loop nie przerywają rozpoczętego ślizgu. Powtórzenie tego samego celu nie wydłuża go.

Slope nigdy nie przechodzi przez zero ani nie odwraca sampla. Forward/Reverse zmieniają
tylko kierunek przez crossfade (Fade ms), zachowując szybkość i trwający ślizg. RESET ustawia cel 1x z aktualnym slope.
Załadowanie nowego sampla ustawia 1x natychmiast, gdy wyjście jest wyciszone.
Zmiana samego pokrętła slope obowiązuje od następnego nowego celu; nie restartuje istniejącej rampy.
Czas wpisujesz w zwykłe pole całkowite (kliknij, wpisz liczbę, Enter). Przyciski −10/+10
zmieniają go o 10 ms. Pole zapisuje się w projekcie przez CompassData; nie jest
odrębnym parametrem automatyzacji Live. Stare stany otrzymują 0 ms.
Status pokazuje szybkość odczytaną z DSP oraz cel podczas przejścia.

## Ważne różnice i ograniczenia prototypu

- Audio odtwarzają natywne obiekty MSP `groove~`, po jednej parze stereo na głowicę.
  Przy skoku pozycji lub zmianie pętli następuje crossfade między dwiema głowicami.
  Szybkość zmienia wspólny sygnał Rate slope; każda głowica ma osobny kierunek.
  Przy samym zawijaniu pętli zastosowano krótkie wyciszenie obu końców, a nie nakładanie ich
  jak w silniku VST. Może to być słyszalne jako pulsowanie przy krótkiej pętli; zmniejsz Fade ms.
- Zegar odczytuje czas Live przez Live API w zadaniu co 10 ms. To nie jest zegar audio sample-accurate.
  Przy obciążeniu interfejsu/CPU polecenia mogą się opóźniać. Odtwarzanie audio trwa na wątku DSP.
- Następna zmiana pozycji/pętli czeka na zakończenie crossfade; przy wielu zmianach oczekuje najnowsza.
  Polecenia szybkości zmieniają cel Rate slope od razu.
- Podmiana sampla czeka na zakończenie fade-out, żeby nie zmieniać bufora pod głośno grającą głowicą.
- Brak Warp/time-stretch. Zmiana szybkości zmienia wysokość dźwięku.
- Mono jest kierowane na oba kanały; stereo ma wspólne skoki i pętlę.
- Wczytywany jest zakres **Sample.start_marker → Sample.end_marker**, w jednostkach próbek pliku,
  przeliczonych na milisekundy według jego częstotliwości próbkowania. To granice sampla,
  a nie oddzielna pętla wewnątrz trybu Classic ani aktualny slice.
- Kopia audio trafia do RAM. Nie ma limitu 60 sekund znanego z wcześniejszego Barcode.
- Pobierany jest surowy plik: Warp, transpose, obwiednia, filtr i efekty Simplera nie są kopiowane.
- Zapis projektu zachowuje sekwencję i parametry. Po otwarciu StepCompass ponownie odnajduje Simpler;
  nie zapisuje identyfikatorów Live API ani niezależnej ścieżki do sampla. Zapisuj sample z projektem
  przez funkcje zarządzania plikami Live/Simplera.
- Przy dodatnim Out dB można przesterować dalszy tor Live. Nie ma ukrytego ogranicznika.
- Zweryfikowano algorytm, kontener i połączenia; środowisko budowania nie ma Max ani Live.
  Rzeczywiste odtwarzanie, GUI i ponowne otwarcie Setu wymagają sprawdzenia w Live.

## Źródła / budowa

```
python3 tools/build.py
node tests/test.js
python3 tests/package.py
python3 tools/package.py
```

Wymagane Python 3 i Node.js, bez dodatkowych bibliotek. Skrypty urządzenia używają ES5 dla starszego `js` w Max 8.
Kontener AMXD oparto na formacie maxdevtools; nie oznacza to walidacji urządzenia przez Max.
Własny kod MIT. Pomocnicze generowanie patchera i kontenera pochodzi z wcześniejszych projektów
Barcode/OctaScenes w tym repozytorium. Brak zewnętrznych obiektów MSP i płatnych bibliotek.

## 10 gotowych presetów (0.1.8)

Pod podglądem sampla po lewej wybierz preset i kliknij LOAD PRESET. Sam wybór nazwy nic nie zmienia.
LOAD zastępuje 16 komend, ustawia 16 kroków, bazowy clock (preset 1: 4/beat, pozostałe: 1/beat), seed i slope;
restartuje sekwencję. Zachowuje sample, zakres, głośność, Fade ms, HOLD % i wagi RANDOMIZE.
Wzór po załadowaniu można edytować; zapis Setu zachowuje jego aktualne kroki.
Nazwa w menu wskazuje wybór do załadowania, nie identyfikuje edytowanego wzoru.
RANDOMIZE nadal używa wag; nie zachowuje dokładnych proporcji presetu.

W pierwszych dwóch presetach są trzy pary Reverse → Forward. Po każdym Reverse
następny krok przywraca kierunek do przodu. Preset 1 ma Hold na kroku 3 zamiast Clock +, zgodnie z przesłanym ustawieniem.
Rate +/− przesuwa cel o oktawę względem poprzedniej szybkości (0.5, 1, 2), z ograniczeniem
na końcach zakresu. Para Rate +, Rate − daje 1→2→1, nie 1→2→0.5.
Step random może pomijać lub powtarzać komendy, w tym Forward: liczby oznaczają obsadę
16 pól, nie gwarantowaną liczbę zdarzeń przy każdym obiegu.

| Preset | Charakter | Slope ms |
|---|---|---|
| 01 Soft drift | 3 pary Reverse/Forward, 1 Rate +, 1 Rate −, 1 Clock +, 2 Clock −, 1 Hold, 2 Fade out, 2 Fade in | 50 |
| 02 Small detours | 3 pary Reverse/Forward, 1 Rate +, 1 Rate −, 2 Clock +, 2 Clock −, 2 Step random, 1 Fade out, 1 Fade in | 50 |
| 03 Position drift | Dodaje skoki pozycji | 50 |
| 04 Loop wander | Dodaje losową pętlę oraz Loop start | 50 |
| 05 Broken motion | Więcej skoków, mniej odpoczynku | 50 |
| 06 Tape turns | Zmiany kierunku i losowy pitch | 50 |
| 07 Loop shuffle | Gęstsze zmiany pętli | 50 |
| 08 Clock fracture | Clock slowest i pauza Hold | 50 |
| 09 Jump cuts | Częstsze skoki pozycji i kroków | 50 |
| 10 Full scatter | Dużo skoków i zmian szybkości, z pauzami Hold | 50 |

W 0.1.11 presety 2–10 startują przy Clock 0 (1 krok/beat); Clock fastest zastąpiono Hold.
Clock + nadal może stopniowo przyspieszyć sekwencję, zwłaszcza przy Step random.
Preset 1 zachowuje Clock 2 i seed 12340 ze zrzutu ekranu. Slope wszędzie: 50 ms.

## Osobna wersja No Fades

`dist/no-fades/StepCompass-M4L-NoFades-v0.1.11.amxd` nie ma komend Fade in/out
w menu, presetach ani losowaniu. Wszystkie takie kroki zastępuje Hold.
Pozostaje techniczne wygładzanie skoków i końców pętli (Fade ms), chroniące przed klikami.
Slope nadal wynosi 50 ms. Wersja standardowa pozostaje dostępna.
Budowanie wariantu: `python3 tools/build.py --no-fades`.

## Osobna wersja Safe (0.1.12)

Plik: `dist/safe/StepCompass-M4L-Safe-v0.1.12.amxd`. Budowa: `python3 tools/build.py --safe`.
Wariant No Fades z ograniczeniem czasu rozpędzenia. Pełny zakres Clock (do 16/beat)
i Rate (0.5–2x) pozostaje dostępny. Po 4 beatach od wyjścia poza 1/beat lub 1x
następuje powrót do 1/beat i 1x, z zachowaniem kierunku i slope.
Następne 2 beaty to RECOVER: komendy Clock i Rate działają jak Hold.
Reverse/Forward i skoki pozycji nadal działają. Timer liczy wykonany czas muzyczny,
nie indeks kroku; Step random i kolejne przyspieszenia go nie przedłużają.
Okno liczy się także przy spowolnieniu i po wcześniejszym ręcznym powrocie do 1x.
Wszystkie presety startują przy 1/beat, slope 50 ms. RESET rozpoczyna nowe okno.
Przy 120 BPM: do 2 sekund efektu, następnie 1 sekunda regeneracji.
Powrót pitcha trwa ustawiony slope; wysoki slope wydłuża słyszalne hamowanie.

## Safe / No Fades / No Repeat (0.1.13)

Plik: `dist/no-repeat/StepCompass-M4L-Safe-NoRepeat-v0.1.13.amxd`.
Budowa: `python3 tools/build.py --no-repeat`.
Wariant zachowuje Safe (do 4 beatów zmian szybkości, potem 2 beaty odpoczynku),
No Fades i domyślny slope 50 ms.

Wybrany zakres audio dzielony jest na 16 równych stref. Na każdym wykonanym kroku
porównuje się jego początek z początkiem poprzedniego kroku, także dla Hold.
Jeśli oba leżą w tej samej strefie, następny start trafia do środka jednej z pozostałych
15 stref. Inaczej odtwarzanie trwa naturalnie. Przy wykroczeniu poza bieżącą pętlę
pętla zostaje przeniesiona z zachowaniem długości. Kierunek, rate i zakres źródła zostają.
Powtórzenia pętli wewnątrz kroku nie są blokowane. RESET/nowy preset czyści historię.

To porównywanie miejsc pliku, nie analiza podobieństwa brzmienia. Powtórzone nagranie
w różnych strefach może nadal brzmieć tak samo; różne początki nie gwarantują
całkowicie rozłącznych odcinków audio. Dla długich sampli i krótkich kroków wariant
może wywoływać częste skoki. Pozycja pochodzi ze snapshotów DSP co 10 ms;
przy przeciążeniu lub krokach krótszych od crossfade mogą występować opóźnienia
i pomijanie oczekujących przejść, jak w pozostałych wersjach.
