# StepCompass M4L v0.1.6

Odtwarzacz sampla z Simplera z 16-krokowym sekwencerem poleceń.
Dla Ableton Live 11 + Max for Live / Max 8, również macOS Intel.
Bez nagrywania; pobiera sample i jego zakres z poprzedzającego Simplera. Nuty MIDI nie są potrzebne.
Niezależna implementacja inspirowana koncepcją Compass Oliviera Creurera dla norns.
Nie zawiera kodu Compass ani silnika softcut.

## Pierwsze uruchomienie

1. Na ścieżce MIDI umieść **Simpler** i wczytaj do niego sample.
2. Pobierz **StepCompass-M4L-v0.1.6.amxd** i przeciągnij **bezpośrednio za Simpler**, jak Barcode.
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

## Domyślne ustawienia i szanse losowania (v0.1.6)

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

## Rate slope ms (v0.1.6)

Czas dojścia od bieżącej szybkości odtwarzania do nowej: 0–10000 ms, domyślnie 0.
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
