#!/usr/bin/env python3
"""Independent binary STL checks. Requires numpy and trimesh."""
import argparse
import hashlib
import json
import struct
from pathlib import Path

import numpy as np
import trimesh


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
    checks = {
        'watertight': watertight,
        'winding_consistent': winding,
        'single_component': component_count == 1,
        'each_edge_has_two_faces': bool(np.all(edge_faces == 2)),
        'positive_volume': bool(mesh.volume > 0),
        'no_degenerate_triangles': bool(np.all(areas > 0)),
        'width_about_60mm': bool(abs(float(extents.max()) - 60) <= .6),
        'nonzero_thickness': bool(float(extents.min()) > .1),
    }
    report['checks'] = checks
    report['passed'] = all(checks.values())
    return report


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('path', nargs='?', type=Path,
                        default=Path(__file__).parent / 'dist/mandarin-segment-60mm.stl')
    parser.add_argument('--report', type=Path)
    args = parser.parse_args()
    result = validate(args.path)
    output = json.dumps(result, indent=2)
    print(output)
    if args.report:
        args.report.write_text(output + '\n')
    raise SystemExit(0 if result['passed'] else 1)
