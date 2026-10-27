# Water slab v3 — gęstsza tafla i mocniej zaokrąglone krawędzie

Model ma **150 × 150 × 21,667 mm**. Zachowuje wysokość trzykrotnie mniejszą niż
pierwsza bryła oraz płaski spód. W tej wersji dodano trzy zagłębienia między
istniejącymi: tafla ma osiem wyraźnych obniżeń zamiast pięciu.

## Pliki v3

- [STL — water-slab-150mm-v3.stl](dist/water-slab-150mm-v3.stl)
- [Podgląd rzeczywistego kształtu](dist/preview-v3.png)
- [Wizualizacja ze szkłem](dist/preview-glass-v3.png)
- [GLB](dist/water-slab-150mm-v3.glb)
- [ZIP ze źródłami i podglądami](dist/water-slab-150mm-v3-complete.zip)
- [Walidacja siatki](dist/validation-v3.json)

## Zmiany względem v2

| Cecha | v2 | v3 |
|---|---:|---:|
| Zagłębienia | 5 | 8 |
| Zaokrąglenie górnej krawędzi | 2 mm | 3,5 mm |
| Promień pionowych narożników | 6 mm | 10 mm |
| Zaokrąglenie przy spodzie | 1,2 mm | 2 mm |

Nowe zagłębienia są mniejsze i asymetryczne, z płynnymi przejściami do istniejących
fal. Różnica wysokości tafli nadal wynosi **13 mm**, a jej najniższy punkt jest około
**8,667 mm nad spodem**. Nie dodano drobnej faktury ani shaderowego displacementu:
cała tafla i zaokrąglenia stanowią rzeczywistą geometrię STL.

STL jest pojedynczą zamkniętą bryłą bez pustego wnętrza. Importuj w **milimetrach**.
Nie wykonano fizycznego wydruku. Wypełnienie/wydrążenie dobierz w slicerze.

Kolor, przezroczystość i odbicia z podglądu szkła nie są zapisane w STL i nie
stanowią obietnicy wyglądu wydruku. To rzeźbiarska interpretacja referencji.

## Generowanie

Python 3: `numpy`, `trimesh`, `scipy`; Blender 4.3 do podglądu.

```sh
python build_model.py
python validate_mesh.py --report dist/validation-v3.json
blender -b -t 4 --python render_preview.py
blender -b -t 4 --python render_preview.py -- --glass
python package.py
```

Starsze pliki w `dist/` zachowano. ZIP v3 zawiera tylko bieżącą wersję.
