# OctaScenes v0.1

Pobieranie z tej gałęzi:

- [OctaScenes-v0.1.amxd — gotowe urządzenie](https://github.com/Korkapetl6/ModelC/raw/refs/heads/octascenes-v0.1/dist/OctaScenes-v0.1.amxd)
- [OctaScenes-v0.1.zip — urządzenie, instrukcja i źródła](https://github.com/Korkapetl6/ModelC/raw/refs/heads/octascenes-v0.1/dist/OctaScenes-v0.1.zip)
- [Raport weryfikacji](dist/VALIDATION.json) · [SHA256](dist/SHA256SUMS.txt)


Urządzenie Max for Live inspirowane sposobem pracy ze scenami Octatracka.
Docelowo: **Ableton Live 11 Standard 11.3.43 z aktywnym Max for Live (Max 8)**.
Nie używa obiektów `v8` ani funkcji wymagających Live 12 / Max 9.

**Status:** pierwsza wersja do sprawdzenia w Live. Testy logiki, kontrolera w
symulowanym API oraz struktury pliku przeszły. W tym środowisku nie ma Live ani
Max, więc uruchomienie, obsługa panelu, zapis/ponowne otwarcie Setu i zachowanie
konkretnych wtyczek nie zostały jeszcze sprawdzone w aplikacji.

## Co zawiera

- 16 scen, każda z własnymi przypisaniami wybranych parametrów (scene locks).
- Do 32 parametrów z różnych ścieżek, urządzeń, miksera i dostępnych parametrów VST.
- Jedna wspólna baza, zapamiętywana przy włączeniu scen.
- DIRECT: natychmiastowe przywołanie sceny przyciskiem/padem, bez kwantyzacji do taktu.
- MORPH: wybór A/B i crossfader. Parametry skokowe są zaokrąglane do poprawnych wartości.
- EDIT, kasowanie pojedynczego przypisania, kasowanie sceny, kopiowanie/wklejanie scen.
- Przyciski scen i crossfader dostępne do mapowania MIDI; crossfader jest parametrem Live.
- Samodzielny `.amxd` z osadzonym kodem; nie wymaga instalowania bibliotek.
- Przezroczysty tor stereo: urządzenie samo nie dodaje efektów ani nie zmienia audio.

## Instalacja i pierwszy test

1. Przeciągnij **OctaScenes-v0.1.amxd** na ścieżkę audio, grupę, Return lub Master.
   Wystarczy ten jeden plik; pliki źródłowe nie są potrzebne do używania.
2. Zostaw **OFF**. Wybierz pusty slot w **PARAMETER**, kliknij **MAP**, a następnie
   pokrętło w Live. Powtórz dla drugiego parametru. MAP czeka maksymalnie 20 s.
   Jeżeli docelowy parametr był już wybrany przed MAP, kliknij najpierw inny,
   potem docelowy. Wtyczka VST musi udostępniać parametr w Live; w razie potrzeby
   użyj jej przycisku **Configure**.
3. Ustaw zwykłe brzmienie pokrętłami Live. Kliknij **ON** — to zapamiętuje bazę.
4. Wybierz scenę **2**, kliknij **EDIT** i poczekaj na komunikat
   `EDIT Scene 2: turn mapped knobs...`. Zmień jeden z przypisanych parametrów
   w Live. Wyłącz EDIT. Scena zapamięta zmieniony parametr, pozostałe pozostaną bez locka.
5. Zostaw scenę **1** pustą. W trybie **DIRECT** klikaj 1 i 2: scena 1 wraca do bazy,
   scena 2 przywołuje zmianę.
6. Przełącz na **MORPH**, ustaw A=1, B=2 i przesuń crossfader.
7. Sprawdź **OFF** oraz żółty aktywator urządzenia: powinny zwolnić sterowanie.
8. Zapisz Set, zamknij go i otwórz ponownie. Sprawdź mapowanie i obie sceny,
   zanim rozbudujesz bank do 32 parametrów.

**SHOW** próbuje otworzyć urządzenie z wybranym parametrem. Dla parametrów miksera
wyświetla nazwę; otwórz odpowiednią ścieżkę ręcznie. Lista slotów oznacza usunięte
lub niedostępne mapowania jako `[MISSING]`; trzeba je ponownie przypisać przy OFF.

## Zasady scen i bazy

DIRECT przywołuje zapisane wartości wybranej sceny. Każdy przypisany parametr,
którego scena nie określa, otrzymuje wartość bazową. Dzięki temu poprzednia scena
nie zostawia zmian w nowej scenie.

MORPH steruje parametrami zapisanymi w co najmniej jednej z dwóch scen A/B.
Brak locka po jednej stronie oznacza bazę po tej stronie. Gdy parametru nie ma
w żadnej z obu scen, urządzenie zwalnia nad nim kontrolę. Interpolacja odbywa
się w zakresie liczbowym udostępnianym przez Live; nie zgaduje krzywych każdej wtyczki.

W MORPH przyciski 1–16 wybierają scenę do EDIT. Końce crossfadera wybiera się
osobno polami A i B. W DIRECT ruch crossfadera nie zmienia przywołanej sceny.

OFF przywraca wspólną bazę i zwalnia parametry. Gdy parametr ma działającą
automatykę Live, po zwolnieniu sterowania ponownie decyduje automatyka.
Podczas OFF można ustawić nową bazę zwykłymi pokrętłami; kolejny ON ją zapamięta.
Wyłączenie żółtego aktywatora urządzenia zwalnia sterowanie, a ponowne włączenie
wraca do zapisanej pracy scen bez przechwytywania nowej bazy.

## Edycja i MIDI

- **EDIT:** zmieniaj przypisane pokrętła w Live. Rejestrowane są tylko zmiany;
  samo wejście do EDIT nie tworzy 32 locków. Nie rozpoczynaj kręcenia przed
  komunikatem gotowości EDIT (przygotowanie trwa około 0,18 s).
- **CLEAR LOCK:** usuwa wybrany parametr z wybranej sceny.
- **CLEAR SCENE:** usuwa wszystkie locki wybranej sceny.
- **COPY SCENE / PASTE SCENE:** kopiuje locki do wybranej sceny docelowej.
- **MAP / UNMAP:** dostępne przy OFF. Zmiana celu slotu usuwa jego stare locki.
- Tryb mapowania MIDI w Live pozwala przypisać pady do przycisków 1–16 i
  fizyczny crossfader/pokrętło do suwaka. Przyciski działają chwilowo: naciśnięcie
  wywołuje scenę, puszczenie pada jej nie zmienia.

W pierwszej wersji EDIT jest blokowany, jeśli którykolwiek dostępny przypisany
parametr ma automatykę (`automation_state` inne niż 0). Dzięki temu automatyka
nie trafia przypadkiem do sceny. Samo zatrzymanie transportu może nie usunąć
tego stanu: do EDIT użyj parametrów bez automatyki. Można nagrywać automatykę
crossfadera OctaScenes; lepiej nie sterować równocześnie docelowymi parametrami
z innego urządzenia Max for Live lub innego systemu modulacji.

„Natychmiast” w DIRECT oznacza brak celowego czasu przejścia lub czekania na takt.
Pozostają opóźnienia Live, jego kolejki sterowania i konkretnej wtyczki. Twarde
zmiany niektórych efektów mogą być słyszalne. Nie jest to wierna emulacja całego
silnika audio ani wszystkich reguł pierwszeństwa parametrów Octatracka.

## Dla dalszego rozwoju

Źródła są w `src/`, generator patchera i kontenera w `tools/`, testy w `tests/`.
Node.js i Python 3 wystarczają do sprawdzenia logiki i wygenerowania pliku:

```sh
node tests/test-core.js
node tests/test-runtime.js
python3 tools/build.py
python3 tests/test-package.py
```

Patcher używa `live.observer id` z `_persistence: 1` dla identyfikacji mapowanych
parametrów, niezależnie od `live.remote~` przejmującego sterowanie. Sceny i baza
są w ukrytym parametrze `pattr` typu blob powiązanym z `getvalueof/setvalueof` JS.
Źródła wzorców kompatybilności: oficjalne
[Ableton Connection Kit](https://github.com/Ableton/m4l-connection-kit) i
[maxdevtools](https://github.com/Ableton/maxdevtools).

Nie polegamy na zapisanych numerach Live API ani na indeksach ścieżek jako
trwałej tożsamości parametru. Niedostępny lub zmieniony zakres parametru pozostaje
nieaktywny. Nie ma komunikacji sieciowej, odczytu bibliotek sampli ani zmian klipów.
