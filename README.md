# Water block — pofalowana tafla, 150 mm

Model STL inspirowany bryłą ze zdjęcia: niski blok o kwadratowej podstawie,
z gładkimi ścianami, zaokrąglonymi krawędziami i falującą powierzchnią wody na górze.
To model proceduralny o podobnym charakterze, nie skan ani dokładna rekonstrukcja fotografii.

## Pliki

- [STL — water-block-150mm.stl](dist/water-block-150mm.stl)
- [Podgląd rzeczywistej geometrii](dist/preview.png)
- [Podgląd z materiałem szkła](dist/preview-glass.png)
- [GLB](dist/water-block-150mm.glb)
- [Walidacja](dist/validation.json)

## Wymiary

**150 × 150 × 65 mm.** Importuj STL w milimetrach. Wysokość 65 mm obejmuje najwyższy
punkt fal. Różnica wysokości fal wynosi około 8 mm. Pionowe narożniki mają promień
6 mm, górna krawędź 2 mm, dolna 1,2 mm. Podstawa jest płaska; maksymalna szerokość
150 mm wypada na ścianach powyżej dolnego zaokrąglenia.

Fale stanowią rzeczywistą geometrię siatki, nie teksturę ani efekt materiału.
Przezroczystość, zielonkawy kolor i refleksy ze zdjęcia nie są zapisywane w STL.
Wizualizacja ze szkłem służy prezentacji; nie gwarantuje takiego wyglądu wydruku.

Model jest zamkniętą pojedynczą bryłą bez pustego wnętrza. Wypełnienie, ewentualne
wydrążenie i parametry druku dobiera się w slicerze. Nie przeprowadzono fizycznego
wydruku. Geometria ma płaską podstawę i nie zawiera osobnych luźnych elementów.

## Odtwarzanie

Python 3: `numpy`, `trimesh`, `scipy`; Blender 4.3 do podglądu.

```sh
python build_model.py
python validate_mesh.py --report dist/validation.json
blender -b -t 4 --python render_preview.py
blender -b -t 4 --python render_preview.py -- --glass
```

Topologia powstaje bezpośrednio z regularnej siatki powierzchni i połączonych pierścieni
boków. Nie wymaga składania przecinających się skorup. `build_model.py` zawiera jawne
parametry wymiarów, fal, zaokrągleń i rozdzielczości.
