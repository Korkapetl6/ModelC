#!/usr/bin/env python3
"""Independent binary STL checks. Requires numpy and trimesh."""
import argparse
import hashlib
import json
import struct
from pathlib import Path

import numpy as np
import trimesh
from scipy.interpolate import LinearNDInterpolator
from scipy.ndimage import label
from scipy.signal import find_peaks


def validate(path: Path):
    blob = path.read_bytes()
    assert len(blob) >= 84, 'File too short for binary STL'
    face_count = struct.unpack_from('<I', blob, 80)[0]
    assert len(blob) == 84 + face_count * 50, 'Binary STL byte length does not match triangle count'
    records = np.frombuffer(blob, dtype=np.dtype([
        ('normal', '<f4', (3,)), ('vertices', '<f4', (3, 3)), ('attribute', '<u2')
    ]), offset=84, count=face_count)
    triangles = records['vertices'].astype(np.float64)
    assert np.isfinite(triangles).all(), 'Non-finite vertex coordinate'
    assert face_count > 0, 'Empty mesh'
    vertices, inverse = np.unique(triangles.reshape(-1, 3), axis=0, return_inverse=True)
    faces = inverse.reshape(-1, 3)
    mesh = trimesh.Trimesh(vertices=vertices, faces=faces, process=False)
    edge_faces = np.bincount(mesh.edges_unique_inverse)
    winding = bool(mesh.is_winding_consistent)
    watertight = bool(mesh.is_watertight)
    component_count = len(mesh.split(only_watertight=False))
    extents = mesh.extents
    areas = mesh.area_faces
    report = {
        'path': str(path.resolve()),
        'sha256': hashlib.sha256(blob).hexdigest(),
        'format': 'binary STL',
        'file_bytes': len(blob),
        'vertices': int(len(vertices)),
        'triangles': int(face_count),
        'dimensions_mm': extents.tolist(),
        'bounds_mm': mesh.bounds.tolist(),
        'surface_area_mm2': float(mesh.area),
        'signed_volume_mm3': float(mesh.volume),
        'watertight': watertight,
        'consistent_winding': winding,
        'connected_components': component_count,
        'boundary_edges': int(np.count_nonzero(edge_faces == 1)),
        'nonmanifold_edges': int(np.count_nonzero(edge_faces > 2)),
        'degenerate_triangles': int(np.count_nonzero(areas <= 0)),
        'tiny_nonzero_triangles_below_1e_12_mm2': int(np.count_nonzero((areas > 0) & (areas <= 1e-12))),
        'minimum_triangle_area_mm2': float(areas.min()),
        'euler_number': int(mesh.euler_number),
        'self_intersections_checked': False,
    }
    # The model must form a closed block on an exactly planar printing base.
    minimum_z = float(mesh.bounds[0, 2])
    base_vertex_mask = np.abs(vertices[:, 2]) <= 1e-6
    base_faces = np.all(base_vertex_mask[faces], axis=1)
    base_area = float(areas[base_faces].sum())
    bottom_normals = mesh.face_normals[base_faces]
    base_patch = mesh.submesh([np.flatnonzero(base_faces)], append=True, repair=False)
    base_component_count = len(base_patch.split(only_watertight=False))
    report['base_connected_components'] = base_component_count
    # Ignore side walls: upward-facing triangles characterize the wave surface.
    top_faces = mesh.face_normals[:, 2] > .01
    top_vertices = vertices[np.unique(faces[top_faces])]
    top_relief = float(np.ptp(top_vertices[:, 2])) if len(top_vertices) else 0.0
    interior_top_vertices = top_vertices[
        (np.abs(top_vertices[:, 0]) < 70) &
        (np.abs(top_vertices[:, 1]) < 70)
    ]
    interior_relief = float(np.ptp(interior_top_vertices[:, 2])) if len(interior_top_vertices) else 0.0
    report['interior_top_relief_mm'] = interior_relief
    report['interior_top_min_z_mm'] = float(interior_top_vertices[:, 2].min()) if len(interior_top_vertices) else None
    report['interior_top_max_z_mm'] = float(interior_top_vertices[:, 2].max()) if len(interior_top_vertices) else None
    report['interior_top_vertex_count'] = int(len(interior_top_vertices))
    expected_base_area = 144 ** 2 - (4 - np.pi) * 15 ** 2
    report['expected_base_area_mm2'] = float(expected_base_area)
    report['base_area_mm2'] = base_area
    report['base_triangles'] = int(np.count_nonzero(base_faces))
    report['top_surface_relief_mm'] = top_relief
    # Independent descriptive measurements: interpolate the actual top triangles' vertices,
    # excluding the curved outer rim; do not inspect or reuse generator height functions.
    if len(top_vertices):
        xy, unique_index = np.unique(top_vertices[:, :2], axis=0, return_index=True)
        interpolator = LinearNDInterpolator(xy, top_vertices[unique_index, 2])
        axis = np.linspace(-65., 65., 261)
        xx, yy = np.meshgrid(axis, axis)
        zz = interpolator(xx, yy)
        valid = np.isfinite(zz)
        bands = {}
        for percentile in (25, 35, 45):
            threshold = float(np.nanpercentile(zz, percentile))
            components, count = label(valid & (zz < threshold))
            spans = []
            for component in range(1, count + 1):
                rows, cols = np.nonzero(components == component)
                if len(rows) < 50:
                    continue
                x_span = float(axis[cols.max()] - axis[cols.min()])
                y_span = float(axis[rows.max()] - axis[rows.min()])
                spans.append({'x_span_mm': x_span, 'y_span_mm': y_span,
                              'projected_area_mm2': float(len(rows) * .25)})
            bands[str(percentile)] = {'threshold_z_mm': threshold,
                                     'components': sorted(spans, key=lambda x: -x['x_span_mm'])}
        sections = []
        for x_value in (-60, -30, 0, 30, 60):
            column = int(np.argmin(np.abs(axis - x_value)))
            profile = zz[:, column]
            minima, props = find_peaks(-profile, prominence=.7, distance=12)
            sections.append({'x_mm': float(axis[column]),
                             'trough_y_mm': axis[minima].tolist(),
                             'trough_prominence_mm': props['prominences'].tolist()})
        report['top_long_trough_measurements'] = {
            'sample_region_xy_mm': [-65, 65], 'grid_spacing_mm': .5,
            'low_height_connected_bands_by_percentile': bands,
            'y_section_minima': sections,
            'interpretation': 'Descriptive mesh-derived metrics, not a photo similarity test.'}

    checks = {
        'watertight': watertight,
        'winding_consistent': winding,
        'single_component': component_count == 1,
        'each_edge_has_two_faces': bool(np.all(edge_faces == 2)),
        'positive_volume': bool(mesh.volume > 0),
        'no_degenerate_triangles': bool(np.all(areas > 0)),
        'width_150mm': bool(abs(float(extents[0]) - 150) <= 1e-4),
        'depth_150mm': bool(abs(float(extents[1]) - 150) <= 1e-4),
        'height_65_over_3_mm': bool(abs(float(extents[2]) - 65 / 3) <= .001),
        'base_at_z_zero': abs(minimum_z) <= 1e-6,
        'base_matches_rounded_footprint': bool(abs(base_area - expected_base_area) < 5),
        'base_is_one_connected_patch': base_component_count == 1,
        'base_faces_point_down': bool(len(bottom_normals) and np.all(bottom_normals[:, 2] < -.999999)),
        'top_is_nonflat': top_relief > .5,
        'interior_top_relief_above_10mm': interior_relief > 10,
        'nonzero_thickness': bool(float(extents.min()) > .1),
    }
    report['checks'] = checks
    report['passed'] = all(checks.values())
    return report


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('path', nargs='?', type=Path,
                        default=Path(__file__).parent / 'dist/water-slab-150mm-v4.stl')
    parser.add_argument('--report', type=Path)
    args = parser.parse_args()
    result = validate(args.path)
    output = json.dumps(result, indent=2)
    print(output)
    if args.report:
        args.report.write_text(output + '\n')
    raise SystemExit(0 if result['passed'] else 1)
