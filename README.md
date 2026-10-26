# Water slab v2 — niższa bryła z głębszą taflą wody

Druga wersja modelu inspirowanego zdjęciem. Wymiary: **150 × 150 × 21,667 mm**.
Całkowita wysokość jest dokładnie trzykrotnie mniejsza niż 65 mm w pierwszej wersji.

## Pliki v2

- [STL — water-slab-150mm-v2.stl](dist/water-slab-150mm-v2.stl)
- [Podgląd rzeczywistego kształtu](dist/preview-v2.png)
- [Wizualizacja ze szkłem](dist/preview-glass-v2.png)
- [GLB](dist/water-slab-150mm-v2.glb)
- [ZIP ze źródłami i podglądami](dist/water-slab-150mm-v2-complete.zip)
- [Walidacja](dist/validation-v2.json)

## Zmiana tafli

Górna powierzchnia została wymodelowana od nowa. Zamiast powtarzalnych pasm fal
ma płynne, asymetryczne zagłębienia o różnych długościach i szerokościach,
przechodzące w meandrujące obniżenia i zaokrąglone grzbiety.
Różnica wysokości tafli wynosi **13 mm**, wobec około 8 mm w wersji pierwszej.
Najniższy punkt tafli znajduje się około **8,667 mm ponad płaskim spodem**.
Fale są geometrią STL, nie teksturą czy displacementem w materiale podglądu.

Zachowano zaokrąglone narożniki i płaską podstawę. Jest to pojedyncza, zamknięta
bryła bez pustego wnętrza. Nie wykonano fizycznego wydruku. Importuj w **milimetrach**.
Wypełnienie lub ewentualne wydrążenie dobierz w slicerze.

STL nie zawiera koloru, przezroczystości ani odbić; podgląd szkła jest wizualizacją
materiału i nie gwarantuje takiego wyglądu wydruku. Model jest interpretacją
rzeźbiarską referencji, nie skanem fotografowanego przedmiotu.

## Generowanie

Python 3: `numpy`, `trimesh`, `scipy`; Blender 4.3 do podglądu.

```sh
python build_model.py
python validate_mesh.py --report dist/validation-v2.json
blender -b -t 4 --python render_preview.py
blender -b -t 4 --python render_preview.py -- --glass
python package.py
```

Starsze pliki w `dist/` mają w nazwie `water-block` i dotyczą wyższej wersji v1.
ZIP v2 zawiera tylko aktualną wersję.
