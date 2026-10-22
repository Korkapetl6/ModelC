# StepCompass M4L v0.1.1

Odtwarzacz sampla z Simplera z 16-krokowym sekwencerem poleceń.
Dla Ableton Live 11 + Max for Live / Max 8, również macOS Intel.
Bez nagrywania; pobiera sample i jego zakres z poprzedzającego Simplera. Nuty MIDI nie są potrzebne.
Niezależna implementacja inspirowana koncepcją Compass Oliviera Creurera dla norns.
Nie zawiera kodu Compass ani silnika softcut.

## Pierwsze uruchomienie

1. Na ścieżce MIDI umieść **Simpler** i wczytaj do niego sample.
2. Pobierz **StepCompass-M4L-v0.1.1.amxd** i przeciągnij **bezpośrednio za Simpler**, jak Barcode.
   W racku oba urządzenia muszą znajdować się w tym samym łańcuchu.
3. Ustaw początek i koniec sampla w Simplerze. StepCompass automatycznie pobierze ten zakres.
4. Poczekaj, aż status pokaże nazwę pliku i zakres, np. `Simpler 1.00–4.00 s | ready`.
5. Włącz transport Abletona lub przełącz **LIVE PLAY** na **FREE PLAY**.
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
- **RESET:** początek regionu, normalny kierunek i szybkość, środek panoramy, początkowy zegar i seed.
  Nie kasuje sampla ani poleceń.
- **RANDOMIZE:** nowa sekwencja z podświetlonych poleceń w sekcji RANDOM POOL.
- **Start % / End %:** dodatkowy region wewnątrz zakresu pobranego z Simplera. 0–100% oznacza cały zaznaczony w Simplerze zakres. Loop random pozostaje wewnątrz tego regionu.
- **Fade ms:** wygładzenie zmian i końców pętli (1–100 ms, domyślnie 20).
- **Out dB:** głośność, domyślnie −6 dB; −60 oznacza pełną ciszę.
- **Steps:** liczba aktywnych kroków 1–16.
- **Clock 0–4:** 0 = 1 polecenie na ćwierćnutę; 1 = 2; 2 = 4; 3 = 8; 4 = 16.
- **Seed:** stan początkowy losowania. RESET pozwala powtórzyć losowania przy tych samych ustawieniach.

| Polecenie | Działanie |
|---|---|
| Hold | Nic nie zmieniaj |
| Forward / Reverse | 1x do przodu / do tyłu |
| Rate + / − | Kolejna / poprzednia szybkość z −2, −1, −0.5, 0.5, 1, 2 |
| Rate random | Losuj szybkość z tabeli |
| Loop start | Początek bieżącej pętli w danym kierunku |
| Position | Losowa pozycja w pętli |
| Loop random | Nowa pętla wewnątrz regionu; minimum 40 ms, o ile region tyle ma |
| Clock + / − | Podwój / podziel przez dwa częstotliwość poleceń |
| Clock fastest / slowest | 16 / 1 polecenie na ćwierćnutę |
| Step random | Losowa pozycja sekwencera; następny tick przechodzi do następnego kroku |
| Pan left / right | Losowe przesunięcie panoramy |

## Ważne różnice i ograniczenia prototypu

- Audio odtwarzają natywne obiekty MSP `groove~`, po jednej parze stereo na głowicę.
  Przy skoku lub zmianie kierunku następuje crossfade między dwiema głowicami.
  Przy samym zawijaniu pętli zastosowano krótkie wyciszenie obu końców, a nie nakładanie ich
  jak w silniku VST. Może to być słyszalne jako pulsowanie przy krótkiej pętli; zmniejsz Fade ms.
- Zegar odczytuje czas Live przez Live API w zadaniu co 10 ms. To nie jest zegar audio sample-accurate.
  Przy obciążeniu interfejsu/CPU polecenia mogą się opóźniać. Odtwarzanie audio trwa na wątku DSP.
- Następna zmiana czeka na zakończenie crossfade; przy wielu zmianach oczekuje najnowsza.
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
