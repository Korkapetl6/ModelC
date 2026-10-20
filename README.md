# BeadsTable 0.1.0

Prosty instrument VST3 dla macOS Intel (10.15+), oparty na oryginalnym ciągłym oscylatorze wavetable Mutable Instruments Beads. 8 głosów MIDI, 12 banków po 16 fal, płynna pozycja w banku i osobna obwiednia ADSR każdego głosu. Bez przetwarzania granularnego, nagrywania wejścia i efektów Beads. To niezależny projekt, nie oficjalny produkt Mutable Instruments.

## Instalacja w Ableton Live 11

1. Rozpakuj `BeadsTable-0.1.0-macOS-Intel.vst3.zip`.
2. Skopiuj cały pakiet `BeadsTable.vst3` do `~/Library/Audio/Plug-Ins/VST3/` (Finder → Idź → Idź do folderu). Utwórz folder, jeżeli nie istnieje.
3. W Live: Preferences → Plug-Ins → Use VST3 Plug-In System Folders → On, następnie Rescan.
4. Załaduj BeadsTable na ścieżkę MIDI i zagraj nuty.

Wtyczka jest podpisana lokalnie (ad hoc), bez notaryzacji Apple. Jeśli macOS blokuje otwarcie, zezwól na tę wtyczkę w ustawieniach bezpieczeństwa systemu. Nie wyłączaj globalnych zabezpieczeń systemu.

## Parametry

Przeciągaj suwaki pionowo. Wszystkie parametry można automatyzować i zapisywać w projekcie Live.

- **Bank:** 1–12, oryginalne banki Beads.
- **Position:** 0–100%, płynne przejście między falami danego banku.
- **Attack / Decay / Release:** czas w milisekundach.
- **Sustain:** poziom podtrzymania w procentach.
- **Volume:** poziom wyjściowy w dB.

MIDI: velocity, pitch bend ±2 półtony, sustain CC64, All Notes Off CC123 i All Sound Off CC120. Wyjście jest podwójnym mono. Obwiednia jest liniowa. Nowa nuta przy pełnej polifonii przejmuje zwalniany lub najstarszy głos; krótki ogon łagodzi przejście. Zmiana banku i pozycji wykorzystuje wygładzanie z oryginalnego Beads. Nie ma MPE, preset browsera ani dodatkowych efektów.

## Budowanie

Na Macu z Xcode Command Line Tools: `./scripts/build-macos.sh`. Skrypt pobiera przypiętą wersję DPF i tworzy Intel x86_64 VST3 oraz ZIP w `release/`. GitHub Actions wykonuje ten sam build na `macos-15-intel`.

Testy DSP na Linux/macOS: `./scripts/test.sh` (kompilator C++17 i AddressSanitizer/UndefinedBehaviorSanitizer). Obejmują wszystkie banki przy 44,1/48/96 kHz, granice wyjścia, ADSR, zwalnianie nut, sustain, polifonię oraz krótkie komunikaty MIDI. Są to testy silnika; nie zastępują uruchomienia VST3 w Live. Pierwsza wersja wymaga jeszcze testu w docelowym Abletonie.
