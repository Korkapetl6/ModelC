# StepCompass 0.1.0

Sample-only command sequencer, inspired by Compass for monome norns. Independent implementation;
not an official port. No recording, overdub, or external norns hardware required.

**Target: Ableton Live 11, macOS Intel (x86_64), VST3. macOS 10.15 or newer.**
Prototype: automated tests and compilation do not replace testing inside Live.

## Instalacja i pierwsze uruchomienie

1. Rozpakuj `StepCompass-0.1.0-macOS-Intel.vst3.zip`.
2. W Finderze wybierz Idź → Idź do folderu i wpisz `~/Library/Audio/Plug-Ins/VST3/`.
3. Skopiuj tam cały pakiet **StepCompass.vst3**. Jeśli folder nie istnieje, utwórz go.
4. W Live włącz VST3 System Folders w Preferences → Plug-Ins i wykonaj Rescan.
5. Dodaj StepCompass do ścieżki MIDI. Nie wymaga klipu ani nut MIDI.
6. Kliknij **LOAD SAMPLE** i wybierz WAV/AIFF. Na Macu można też przeciągnąć plik z Findera
   na okno wtyczki (przeciąganie z przeglądarki Live zależy od tego, czy host przekazuje ścieżkę pliku).
7. Uruchom transport Live albo przełącz **LIVE PLAY** na **FREE PLAY**.
8. Kliknij krok 3, potem **Position**; krok 7 → **Reverse**; krok 11 → **Loop random**.
   Pozostałe kroki mogą zostać na Hold.

Głośność domyślnie −6 dB; regulacja Output dB. −60 dB wycisza. Bez sampla jest cisza.
Wtyczka jest podpisana ad-hoc, nie ma notaryzacji Apple. Jeśli macOS ją zablokuje,
sprawdź informację w ustawieniach Prywatność i ochrona; nie wyłączaj globalnie Gatekeepera.

## Obsługa

- **Region start / end:** początkowy obszar sampla. Kliknięcie fali przesuwa bliższą granicę;
  wartości można też przeciągać pionowo. Loop random pozostaje w tym obszarze.
- **16 kroków:** kliknij krok, następnie polecenie z palety. Zielona obwódka oznacza krok odtwarzany,
  wypełnienie oznacza krok edytowany. Prawy przycisk czyści krok do Hold.
- **Steps:** liczba aktywnych kroków, 1–16. Pozostałe są przyciemnione i zachowują przypisania.
- **Clock division:** początkowy odstęp kroków: 1, 1/2, 1/4, 1/8, 1/16 uderzenia ćwierćnutowego.
  To tempo poleceń, nie tempo rozciągania sampla. Polecenia Clock mogą je zmieniać podczas grania.
- **RANDOMIZE:** tworzy nową sekwencję z zaznaczonej puli poleceń i ustawia nowy seed.
  Małe pola przy poleceniach włączają/wyłączają je z losowania.
- **Seed:** powtarzalne losowanie pozycji, pętli, szybkości i panoramy. Restart transportu/RESET
  zaczyna przebieg od nowa z tym seedem. Odtworzenie tego samego przebiegu wymaga też tych samych
  ustawień, startu transportu i automatyzacji.
- **RESET:** przywraca cały wybrany obszar, 1x do przodu, środkową panoramę, początkowy zegar i krok 1.
  Nie kasuje sampla ani sekwencji. Host start/seek również restartuje przebieg.
- **Crossfade ms:** 1–100 ms, domyślnie 20 ms. Pętle mają nakładające się końce, a skoki/reverse
  przechodzą między dwiema głowicami. W bardzo krótkich pętlach nakładanie ograniczane jest do 24%
  długości. Kolejne polecenie odtwarzania podczas przejścia czeka na jego koniec; najnowsze zastępuje
  poprzednie oczekujące. Zmiany zegara nie czekają.
- **FREE PLAY:** gra również przy zatrzymanym transporcie (tempo hosta; 120 BPM jeśli niedostępne).
- Parametry i kroki zapisują się w projekcie/presetach oraz obsługują automatyzację hosta.

| Polecenie | Działanie |
|---|---|
| Hold | Zachowaj bieżące odtwarzanie |
| Forward / Reverse | 1x do przodu / 1x do tyłu |
| Rate + / − | Przejdź po tabeli −2, −1, −0.5, 0.5, 1, 2 |
| Rate random | Losuj szybkość z tej tabeli |
| Loop start | Skocz do początku pętli dla bieżącego kierunku |
| Position | Losuj pozycję wewnątrz bieżącej pętli |
| Loop random | Losuj pętlę w wybranym regionie (minimum 40 ms, jeśli region jest dostatecznie długi) |
| Clock + / − | Podwój / podziel przez dwa częstotliwość poleceń |
| Clock fastest / slowest | 16 poleceń / jedno polecenie na uderzenie |
| Step random | Zmień pozycję sekwencera; następny tick wykonuje krok następujący po wylosowanej pozycji |
| Pan left / right | Losuj przesunięcie panoramy w lewo / prawo |

## Sample i ograniczenia

- Jeden plik mono/stereo do 128 MB; PCM WAV/AIFF 8/16/24/32-bit, float WAV 32/64-bit;
  AIFC NONE, sowt, fl32/fl64. 8–384 kHz. Minimum 32 próbki.
- Mono jest kopiowane na oba kanały. Stereo ma wspólne skoki, szybkość i pętlę, aby zachować relację kanałów.
- Zmiana szybkości zmienia wysokość (varispeed). Brak Warp, time-stretch i synchronizacji długości sampla
  do taktu. Liniowa interpolacja; przy dużych zmianach szybkości może pojawić się aliasing.
- Crossfade skraca efektywny obieg pętli o nakładający się fragment. Nie jest to sampler do bezstratnego
  odtwarzania idealnie całych taktów. To świadomy kompromis pierwszej wersji.
- **Projekt przechowuje ścieżkę do pliku, nie kopię audio.** Umieść sample w folderze projektu przed
  załadowaniem. Collect All and Save w Live nie musi kopiować sampli prywatnych VST. Po przeniesieniu
  pliku użyj LOAD SAMPLE, aby wskazać go ponownie.
- Nieudany odczyt wycisza poprzedni sample; UI pokazuje błąd. Nowy plik ładuje się poza callbackiem audio,
  a podmiana ma fade-out/fade-in. Audio nie zwalnia buforów: robi to wątek porządkowy.
- Przejścia ograniczają trzaski wynikające ze skoków odczytu. Nie usuwają trzasków zapisanych w samplu.
- Nie ma oddzielnego obcinania/limitera na wyjściu. Przy dodatnim Output zachowaj zapas na ścieżce Live.

## Budowanie i testy

```
./scripts/bootstrap.sh
./scripts/test.sh
./scripts/build-macos.sh
```

Framework jest przypięty do konkretnego commita. Na macOS potrzebne Xcode Command Line Tools.
GitHub Actions buduje x86_64 na macos-15-intel, uruchamia ASan/UBSan, podpisuje i sprawdza pakiet.
Testy obejmują PCM WAV/AIFF, ucięte pliki, stereo/mono, transport i zegar, deterministyczne losowanie,
przejścia forward/reverse, losową automatyzację i równoległą podmianę sampli.
Ręcznie w Live należy sprawdzić skanowanie, odtwarzanie, GUI/drop, zapis i ponowne otwarcie projektu.

Licencja MIT dla własnego kodu; zależności i inspiracja: THIRD_PARTY.md.
