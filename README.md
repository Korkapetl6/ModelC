# Cząstka mandarynki bez błonki — model STL

Model proceduralny inspirowany referencją fotograficzną: pojedyncza cząstka z wypukłymi,
podłużnymi woreczkami soku na obu stronach i krawędziach. To przybliżenie rzeźbiarskie,
nie skan 3D ani dokładna rekonstrukcja ze zdjęcia.

- **STL:** [mandarin-segment-60mm.stl](dist/mandarin-segment-60mm.stl)
- **Podgląd rzeczywistej siatki:** [preview.png](dist/preview.png)
- **GLB:** [mandarin-segment-60mm.glb](dist/mandarin-segment-60mm.glb)
- **Weryfikacja:** [validation.json](dist/validation.json)

## Wymiary i druk

Importuj STL w **milimetrach**. Szerokość wynosi 60 mm; dokładne pozostałe wymiary
podaje `dist/model-info.json`. Woreczki są połączone z wewnętrznym rdzeniem w jedną
szczelną bryłę, a nie osobnymi luźnymi częściami. STL nie zawiera kolorów ani
przezroczystości. Pomarańczowy materiał na podglądzie służy jedynie prezentacji.

Model nie ma płaskiego spodu. Dobierz orientację i podpory w slicerze do drukarki.
Do wyraźnego oddania drobnego reliefu lepiej nadaje się druk żywiczny. Model nie był
fizycznie drukowany. Jedna zamknięta siatka nie gwarantuje wydruku bez podpór.

## Generowanie

Python 3 z `numpy`, `scipy`, `scikit-image`, `trimesh`:

```sh
python build_model.py
python validate_mesh.py --report dist/validation.json
blender -b -t 4 --python render_preview.py
```

Generator używa powtarzalnego ziarna i pola objętościowego, aby połączyć kapsułki
z rdzeniem bez nakładających się osobnych skorup. Parametry można zmienić w
`build_model.py`. Walidator sprawdza m.in. szczelność, zgodność orientacji ścian,
spójność, dodatnią objętość i wymiary.
