# Water slab v4 — długie fale i miękkie obrzeże

Wymiary **150 × 150 × 21,667 mm**. Płaski spód, pojedyncza zamknięta bryła.
Ta wersja zastępuje punktowe zagłębienia v3 pięcioma długimi, płynnie wijącymi się
obniżeniami przechodzącymi przez większość powierzchni.

## Pliki v4

- [STL](dist/water-slab-150mm-v4.stl)
- [Podgląd rzeczywistego kształtu](dist/preview-v4.png)
- [Podgląd z materiałem szkła](dist/preview-glass-v4.png)
- [GLB](dist/water-slab-150mm-v4.glb)
- [ZIP ze źródłami i podglądami](dist/water-slab-150mm-v4-complete.zip)
- [Walidacja i pomiary ciągłości fal](dist/validation-v4.json)

## Kształt tafli

Nie ma osobnych okrągłych dołków. Każde z pięciu zagłębień przebiega wzdłuż formy,
ze zmienną szerokością i wyraźnym meandrem; miejscami zagłębienia łączą się.
Ostatnie kilka milimetrów przechodzi łagodnie w mocniej zaokrąglone obrzeże.
Pomiar siatki wykazał główne ciągłe obniżone obszary o rozpiętości w osi X
około **123–129 mm** (przy progu wysokości 13,78 mm).

Relief nadal wynosi **13 mm**. Najniższa część tafli znajduje się około **8,667 mm**
nad spodem. Górne obrzeże ma zaokrąglenie **5,5 mm** (wcześniej 3,5), pionowe
narożniki **18 mm** (wcześniej 10), a dolna krawędź **3 mm** (wcześniej 2).

Wszystkie fale i zaokrąglenia są rzeczywistą geometrią STL. Nie dodano tekstury
ani shaderowego displacementu. Wizualizacja szkła ilustruje tylko materiał:
STL nie zawiera przezroczystości, koloru ani odbić.

Importuj w **milimetrach**. Model nie był fizycznie drukowany. Wypełnienie lub
wydrążenie dobierz w slicerze; plik opisuje pełną zewnętrzną bryłę.

## Generowanie

Python 3: `numpy`, `trimesh`, `scipy`; Blender 4.3 do podglądu.

```sh
python build_model.py
python validate_mesh.py --report dist/validation-v4.json
blender -b -t 4 --python render_preview.py
blender -b -t 4 --python render_preview.py -- --glass
python package.py
```

Starsze pliki w `dist/` pozostają dostępne. ZIP v4 zawiera tylko bieżącą wersję.
