# ModelC — eksperymentalny firmware NEW15, poprawka R2

**Użyj R2. Poprzednia wersja ModelC-prototype.syx ma potwierdzony błąd stosu.**
R2 oczekuje na sprawdzenie na fizycznym Elektron Model:Cycles.

## Pobieranie

- [ModelC-prototype-r2.syx](firmware/ModelC-prototype-r2.syx)
- [ModelC-prototype-r2.zip](firmware/ModelC-prototype-r2.zip) — rozpakuj plik SYX.
- [Sumy kontrolne SHA256](firmware/SHA256SUMS.txt)
- [Raport testu instrukcji docelowych](firmware/validation-r2-target.json)

Na stronie pliku na GitHubie wybierz „Download raw file”.

## Co poprawiono

Pierwszy prototyp uruchamiał się, ale użytkownik zgłosił wyjątki przy zmianie
maszyny i pokręteł, również przy zatrzymanym sekwencerze. W obsłudze Chord
znaleziono rezerwację 16 zamiast 24 bajtów stosu. Zagnieżdżone przerwanie mogło
nadpisać zapisany wskaźnik bufora. R2 zmienia jeden bajt MAIN OS, poprawiając
tę rezerwację. Pozostałe funkcje i przypisania pokręteł pozostają takie same.

Test instrukcji docelowych w Unicorn 2.1.4 odtwarza uszkodzenie rejestru
w poprzednim obrazie i przechodzi w R2: 170 przypadków, Beads/Rings,
Strum 0/127 i 122 kształty akordów. Przeszły także testy programowe i kontrola
integralności SYX. Emulator nie zastępuje testów panelu, przerwań i CPU na
urządzeniu; nie potwierdzono jeszcze usunięcia zgłoszonego wyjątku na Cycles.

## Pierwszy test na urządzeniu

1. Po wgraniu R2, przy zatrzymanym sekwencerze, kilka razy przełącz Chord
   na następną maszynę i z powrotem.
2. Jeżeli działa, sprawdź pokrętła Chord przy STOP, potem uruchom jedną ścieżkę.
3. Jeżeli wyjątek powróci, zapisz całą linię EXCEPTION i czynność/pokrętło,
   które go wywołało.

Prototyp opiera się na dostarczonym NEW15 i zawiera eksperymentalne Chord
Beads WT / Rings Modal, generator progresji Morph oraz losowy Strum.
Starsze pliki bez „r2” pozostawiono wyłącznie dla identyfikacji poprzedniej wersji.
