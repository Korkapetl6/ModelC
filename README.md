# Skórka cytryny na płasko — v1

Model wyprostowanej skórki o maksymalnym obrysie **180 × 76 mm**, zgodnie z podanymi wymiarami. Jest to szeroki płat: proporcje są inne niż u wąskiego paska z fotografii referencyjnej. Nie jest zwinięty w spiralę.

- Nieregularne, lekko falujące boki i asymetryczne końce przypominają ręcznie wyciętą skórkę.
- Zewnętrzna warstwa (flavedo): delikatnie nierówna skóra z tysiącami drobnych, płytkich wgłębień gruczołów olejkowych.
- Wewnętrzna warstwa (albedo): bardziej chropowata, gąbczasta powierzchnia z krótkimi, nieregularnymi wypukłościami przypominającymi włókna.
- Grubość nominalna około **4 mm**, lokalnie około **2,44–5,13 mm**. Całkowita wysokość razem z nierównościami obu stron wynosi **5,40 mm**. Dokładne pomiary są w [model-info-v1.json](dist/model-info-v1.json).
- Obie strony mają rzeczywistą rzeźbę w geometrii. Model stanowi jedną zamkniętą bryłę.

## Pobieranie

- [STL — model w milimetrach](dist/lemon-peel-180x76mm-v1.stl)
- [GLB — model z podziałem kolorów na żółtą skórę i biały spód](dist/lemon-peel-180x76mm-v1.glb)
- [Podgląd zewnętrznej strony](dist/preview-yellow.png)
- [Podgląd białej strony](dist/preview-pith.png)
- [ZIP: modele, podglądy i kod źródłowy](dist/lemon-peel-180x76mm-v1-complete.zip)
- [Raport kontroli siatki](dist/validation-v1.json)

STL nie przechowuje kolorów ani miękkości materiału. Biała strona ma nierówny spód — określenie „na płasko” oznacza tutaj brak zwinięcia, nie idealnie gładką dolną płaszczyznę. Model nie był fizycznie drukowany; drobne detale najlepiej ocenić w podglądzie warstw wybranego slicera.

## Odtworzenie

Python 3 i zależności z `requirements.txt`. Blender 4.3 do renderów.

```sh
pip install -r requirements.txt
python build_model.py
python validate_mesh.py
blender -b -t 4 --python render_preview.py
blender -b -t 4 --python render_preview.py -- --pith
python package.py
```

Generator ma stały seed. Nie używa zdjęć jako tekstury ani displacementu w materiale: pory i włóknista faktura są częścią eksportowanej siatki. Wewnętrzny plik `preview-mesh.npz` jest tworzony przez generator do renderowania i nie jest potrzebny do użycia STL/GLB.
