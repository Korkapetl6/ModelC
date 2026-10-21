# Barcode for Simpler v0.1.3

Urządzenie Max for Live dla Ableton Live 11 / Max 8, oparte na **[barcode v0.12.0 autorstwa Zachary'ego Scholla](https://github.com/schollz/barcode)**. Sześć głosów odtwarza sample z najbliższego poprzedzającego Simplera. 36 LFO zmienia poziom, panoramę, prędkość, kierunek oraz początek i koniec pętli. **Bez nagrywania.**

- [Pobierz gotowy AMXD](https://github.com/Korkapetl6/ModelC/raw/refs/heads/barcode-m4l/dist/Barcode-for-Simpler-v0.1.3.amxd)
- [Pobierz ZIP: urządzenie, patcher, źródła i README](https://github.com/Korkapetl6/ModelC/raw/refs/heads/barcode-m4l/dist/Barcode-for-Simpler-v0.1.3-complete.zip)

**Status: prototyp do testu w Live.** Testy logiki i kontrolera z symulowanym Live API oraz walidacja struktury AMXD przeszły. Nie uruchamiano urządzenia w Max/Live: dźwięk, odczyt przez `buffer~`, działanie panelu i rzeczywiste odtworzenie Setu wymagają sprawdzenia w aplikacji. Nie jest to potwierdzona emulacja softcut 1:1.

## Poprawka 0.1.3 — poziom wyjścia i sześć pokręteł głosów

Użytkownik potwierdził działający dźwięk w 0.1.2, ale poziom był zbyt niski. Usunięto stały mnożnik 0,25 oraz startowe 0,7: wyjście domyślnie ma teraz **0 dB / gain 1**, około 15,1 dB więcej niż w poprzedniej wersji. Pole **Output dB** ma zakres od −60 dB (wyciszenie) do +12 dB. Poprawiono także formatowanie wartości ułamkowych w pozostałych polach.

Po prawej dodano **Voice 1–6**, sześć osobnych pokręteł poziomu. 0% wycisza głos, 100% zachowuje jego poziom wynikający z oryginalnego Barcode, 200% mnoży go przez dwa (+6 dB). To dodatkowe mnożniki za modulacją Level; nie zmieniają biasu, faz ani okresów LFO. Reagują z niezależnym wygładzeniem 30 ms, również przy FROZEN. Można je mapować MIDI, automatyzować i zapisywać w Secie jako parametry Live. Reset voices nie resetuje tych pokręteł.

Wstaw nową wersję zamiast poprzedniej. Jeśli za Barcode dodano wcześniej Utility z dodatnim Gain, wyzeruj ten dodatkowy boost przed odsłuchem. Ogranicznik ±0,98 nadal działa; duże sumy głosów mogą się przesterować — wtedy zmniejsz Output dB. Panel jest szerszy, aby wszystkie sześć pokręteł było widocznych równocześnie.

Testy obejmują domyślne gain 1, przeliczanie dB, mute, niezależność sześciu pokręteł od LFO, połączenia DSP i zapis parametrów w strukturze patchera. Nowy panel wymaga jeszcze sprawdzenia w rzeczywistym Live/Max.

## Poprawka 0.1.2 — usunięcie nieobsługiwanego obiektu wyjściowego

Zrzut z 0.1.1 potwierdził aktywny DSP, gotowy sample i sygnał z głosów (−15,4 dB), ale ciszę na wyjściu. W poprzednim generatorze użyto błędnie `expr~ tanh($v1)` — `expr~` nie jest standardowym obiektem Max/MSP. W obu kanałach zastąpiono go natywnym `clip~ -0.98 0.98`. To ograniczenie twarde, a nie poprzednio zamierzone łagodne nasycenie.

Dolny wiersz mierzy teraz sygnał z głosów, za filtrem i na wyjściu oraz pokazuje żądane wzmocnienie Gain. W FREE PLAY opis źródła również odświeża się od razu. Test struktury odrzuca użycie `expr~` i sprawdza połączenia wyjściowe obu kanałów. Odsłuch wersji 0.1.2 nadal wymaga testu w Live.

## Poprawka 0.1.1 — uruchamianie głosów i diagnostyka

W 0.1.0 użytkownik potwierdził poprawne odczytanie sampla i działanie pasków LFO, ale nie było dźwięku także przy FREE PLAY. W 0.1.1 każdy odtwarzacz otrzymuje jawne `set <nazwa bufora>` z nadrzędnego patchera oraz `startloop` po odczycie i przy rozpoczęciu odtwarzania. FREE PLAY aktualizuje odtwarzacze od razu. Nie opieramy przypisania głosów wyłącznie na rozwinięciu `#0` w zagnieżdżonych patcherach.

Dolny wiersz pokazuje **DSP**, **Active**, **Sample**, **Voices**, **Filter**, **Gain** i **Output**. Mierniki obserwują lewy kanał przed filtrem i po wyjściowym ograniczniku. Paski pokazują modulację, a nie obecność sygnału audio.

Podmień poprzednie urządzenie na nowy plik, pozostawiając Simpler. Kliknij FREE PLAY. Jeśli nadal jest cisza, zrzut dolnego wiersza pozwoli rozróżnić wyłączony DSP, nieaktywny efekt i brak sygnału z głosów. Nie potwierdzono jeszcze odsłuchu tej poprawki w Live.

## Pierwsze uruchomienie

1. Utwórz ścieżkę MIDI i wstaw **Simpler**.
2. Wczytaj do niego zwykły plik WAV lub AIFF z dysku.
3. Przeciągnij **Barcode-for-Simpler-v0.1.3.amxd bezpośrednio ZA Simpler**, jako efekt audio w tym samym łańcuchu.
4. Poczekaj na nazwę sampla w górnym wierszu. Domyślnie aktywne są **ON** i **LIVE PLAY**.
5. Uruchom transport Live. Barcode zapętli sample bez potrzeby grania nut MIDI. Dla odsłuchu przy zatrzymanym transporcie przełącz **LIVE PLAY → FREE PLAY**.
6. Podmień sample w Simplerze — Barcode wykryje zmianę automatycznie, zwykle w ciągu około sekundy. **Reload** wymusza ponowny odczyt.

Nie wyłączaj całego urządzenia Simpler; nie musisz uruchamiać go nutami. Gdy Barcode jest ON, wejściowy dźwięk Simplera jest wyciszony i słychać wyłącznie Barcode. **OFF** zwalnia odtwarzanie Barcode i przepuszcza zwykły sygnał ze ścieżki. Żółty aktywator Live korzysta również z normalnego mechanizmu bypass.

W Instrument Rack wstaw oba urządzenia wewnątrz **tej samej chain**. Wyszukiwanie nie przechodzi przez wnętrze racków ani między ścieżkami.

## Obsługa

- **LFO RUN / FROZEN** — pauza 36 modulacji; odtwarzanie audio trwa dalej.
- **FORWARD / REVERSE** — możliwość ruchu wstecz; REVERSE zezwala LFO na zmianę kierunku, nie wymusza stale ruchu wstecz.
- **LFO SEC / LFO BEATS** — okresy LFO w sekundach albo przeskalowane aktualnym tempem Live. Zachowano wzór z oryginalnego Barcode, łącznie z przeskalowaniem fazy.
- **LIVE PLAY / FREE PLAY** — odtwarzanie zależne od transportu albo swobodne. Sterowanie transportem odświeża się co 250 ms; nie jest to kwantyzowane uruchamianie pętli na granicy taktu.
- **VOICE 1–6** — wybór głosu do edycji.
- Lista **Level / Pan / Rate / Direction / Loop start / Loop end** — wybór modulowanego parametru.
- **Bias** — przesunięcie wyniku modulacji. Dla Rate przesuwa indeks prędkości; Start/End używają ułamka długości sampla.
- **LFO period** — okres wybranego LFO; 0 wyłącza jego oscylację, zgodnie ze stałą wartością z oryginalnego skryptu.
- **Output dB** — poziom końcowy w decybelach, domyślnie 0 dB; −60 dB wycisza wyjście.
- **Voice 1–6** — sześć pokręteł poziomu głosów 0–200%, domyślnie 100%.
- **Filter Hz / Resonance** — wspólny filtr dolnoprzepustowy stereo.
- **Rate / Pan / Level slew s** — wygładzanie zmian w sekundach, 0,01–30 s.
- **Reset voices** — usuwa własne biasy/okresy i inicjalizuje nowy zestaw faz oraz okresów LFO.

Pola liczbowe zmienia się przeciąganiem w pionie lub wpisywaniem wartości. Ustawienia globalne są parametrami Live; biasy i okresy LFO wybranego głosu są zapisywane w ukrytym `pattr`, ale nie mają osobnych ścieżek automatyki. Sześć pokręteł poziomu głosów ma osobną automatykę i zapis jako parametry Live. Kopia urządzenia ma własny bufor audio i stan.

## Co zachowano i co zmieniono

Zachowano sześć głosów, wzory modulacji, dyskretne prędkości **1/8, 1/4, 1/2, 1, 2, 4**, inicjalne poziomy/panoramy/prędkości, losowe fazy i okresy, aktualizację LFO co 250 ms oraz oryginalny reset licznika LFO po 60 sekundach. Paski odtwarzają układ ekranu Barcode; jasna grupa wskazuje edytowany głos.

Oryginalne dwa bufory zastępuje **jeden sample wskazany przez Simpler**. Ścieżka pliku, sample rate i znaczniki pochodzą z Live API; urządzenie nie zmienia ustawień Simplera. Odczytywany jest fragment między Start/End, maksymalnie pierwsze 60 sekund tego fragmentu. Mono jest powielane na oba kanały, stereo zachowuje dwa kanały z modulacją panoramy/balansu.

Audio jest odtwarzane przez sześć natywnych `groove~` z interpolacją pętli. Filtr to biquad low-pass, a wyjście ma ograniczenie amplitudy przez natywne `clip~` do ±0,98. Nie używamy silnika softcut ani kompresora norns, więc pętle, zmiany kierunku, filtr i nasycenie mogą brzmieć inaczej. Granice pętli są ograniczone do rzeczywistego sampla; nie kopiujemy jednosekundowego zapasu oryginalnego bufora.

Nie są kopiowane Warp, transpozycja, obwiednia, filtr, slicing ani modulacje Simplera. Prędkość jest taśmowa: szybsze odtwarzanie podnosi wysokość. Wtyczka nie reaguje nutami na wysokość dźwięku; to generator pętli, jak Barcode na norns.

Nie ma recordingu, wejściowego resamplingu, undo nagrania ani sieciowego udostępniania. Chronione pliki z niektórych Packs i formaty niedostępne dla Max `buffer~` mogą się nie wczytać — wtedy użyj zwykłego WAV/AIFF. Oryginalny plik sampla pozostaje w swoim miejscu; przechowuj go razem z projektem Live. Zapis Setu zachowuje parametry i konfigurację LFO; po ponownym odczycie sampla jego faza odtwarzania i licznik czasu są inicjalizowane od nowa.

## Gdy nie ma dźwięku

Sprawdź nazwę sampla w górnym wierszu, **ON**, aktywny silnik audio Live i **FREE PLAY**. Po błędzie pliku urządzenie wycisza własne głosy; wybierz zwykły WAV w Simplerze i naciśnij **Reload**. Jeżeli komunikat każe umieścić urządzenie za Simplerem, sprawdź ich kolejność i przynależność do tej samej chain. Starego sampla nie odtwarzamy po odłączeniu źródła.

## Źródła i weryfikacja

- `src/barcode-core.js`: logika 36 LFO i stanu.
- `src/barcode.js`: integracja z Simplerem i sterowanie Max/MSP.
- `src/barcode-display.js`: ekran z paskami.
- `tools/`: generator patchera i kontenera AMXD.
- `tests/`: testy Node.js oraz struktury urządzenia w Pythonie.
- `dist/Barcode-for-Simpler.maxpat` i trzy pliki JS: edytowalny patcher; pozostaw je razem.
- `upstream/`: niezmieniony skrypt Barcode, README i licencja autora. Ten skrypt Lua nie jest wykonywany przez urządzenie.

Budowanie i testy: **`make test`** (Python 3 i Node.js). AMXD zawiera wszystkie trzy pliki JS i nie wymaga instalowania bibliotek. Testy uruchomione bez Maxa nie weryfikują wykonania obiektów DSP ani renderowania panelu.

Oryginalny Barcode: commit `8287bfec137f1bdb7b06090d0ef0b1b6c2245fa7`. Dostępność `Sample.file_path`, `sample_rate`, `length`, `start_marker` i `end_marker` potwierdzono w wykazie `_MxDCore/LomTypes.py` Live 11; sam dostęp przez Max należy jeszcze sprawdzić w aplikacji.

Adaptacja 2026-10-21. Licencja MIT, copyright oryginału Zachary Scholl — zachowane w `LICENSE`. To niezależna adaptacja, nie oficjalny produkt autora Barcode, Abletona ani monome.
