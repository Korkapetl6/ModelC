# StepCompass M4L v0.1.0

Samodzielny odtwarzacz sampla z 16-krokowym sekwencerem poleceń.
Dla Ableton Live 11 + Max for Live / Max 8, również macOS Intel.
Bez nagrywania; nie wymaga Simplera ani nut MIDI.
Niezależna implementacja inspirowana koncepcją Compass Oliviera Creurera dla norns.
Nie zawiera kodu Compass ani silnika softcut.

## Pierwsze uruchomienie

1. Pobierz **StepCompass-M4L-v0.1.0.amxd** i przeciągnij do Live na pustą **ścieżkę audio**.
   To Max Audio Effect, który generuje własny dźwięk. Przychodzące audio nie jest przepuszczane.
2. Kliknij **LOAD SAMPLE**, wybierz WAV/AIFF.
3. Poczekaj na nazwę pliku i `sample ready`.
4. Włącz transport Abletona lub przełącz **LIVE PLAY** na **FREE PLAY**.
5. Zmień polecenia w listach kroków 1–16. Aktualny krok świeci na wyświetlaczu po lewej;
   numer i szybkość są też podane w wierszu statusu.

Plik AMXD zawiera wszystkie potrzebne skrypty. ZIP zawiera także źródła i README.
Do instalacji nie jest potrzebny Max Standalone ani kompilator.

## Sterowanie

- **ON / OFF:** wycisza/włącza odtwarzanie.
- **LIVE PLAY / FREE PLAY:** transport Live lub granie także przy zatrzymanym transporcie.
- **RESET:** początek regionu, normalny kierunek i szybkość, środek panoramy, początkowy zegar i seed.
  Nie kasuje sampla ani poleceń.
- **RANDOMIZE:** nowa sekwencja z podświetlonych poleceń w sekcji RANDOM POOL.
- **Start % / End %:** region sampla. Loop random wybiera pętle wewnątrz tego regionu.
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
- Wczytywany jest cały plik do RAM. Brak opcji nagrywania, automatycznego importu z Simplera i edycji waveform myszą.
- **Live Set przechowuje ścieżkę do sampla, nie kopię jego audio.** Trzymaj plik w folderze projektu;
  po przeniesieniu użyj LOAD SAMPLE. Nie zakładaj, że Collect All and Save skopiuje ten zewnętrzny plik.
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
