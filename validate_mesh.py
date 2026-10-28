"""Independent checks on the exported STL, in millimetres.

Geometric validity is tested directly from the STL. Texture and thickness
measurements are descriptive approximations, not fabrication certification.
"""
from pathlib import Path
import argparse
import hashlib
import json
import struct

import numpy as np
import trimesh
from scipy.ndimage import gaussian_filter
from scipy.spatial import cKDTree


ROOT = Path(__file__).resolve().parent


def surface_measurements(mesh):
    """Sample the central region, avoiding the irregular cut edge.

    Nearest projected triangle centres give a mesh-derived approximation,
    without any dependency on the generator's procedural fields.
    """
    centres = mesh.triangles_center
    normals = mesh.face_normals
    xs = np.arange(-60.0, 60.01, 0.5)
    ys = np.arange(-22.0, 22.01, 0.5)
    xx, yy = np.meshgrid(xs, ys)
    query = np.column_stack((xx.ravel(), yy.ravel()))
    fields = {}
    diagnostics = {}
    for name, selection in (
        ('yellow_top', normals[:, 2] > 0.5),
        ('pith_bottom', normals[:, 2] < -0.5),
    ):
        samples = centres[selection]
        if not len(samples):
            return {'available': False, 'reason': f'No {name} faces'}
        distance, nearest = cKDTree(samples[:, :2]).query(query)
        field = samples[nearest, 2].reshape(xx.shape)
        fields[name] = field
        highpass = field - gaussian_filter(field, sigma=2.0)
        diagnostics[name] = {
            'sampled_z_range_mm': [float(field.min()), float(field.max())],
            'rms_relief_below_approx_1mm_scale_mm': float(np.std(highpass)),
            'max_projected_distance_to_triangle_centre_mm': float(distance.max()),
        }
    thickness = fields['yellow_top'] - fields['pith_bottom']
    diagnostics['approx_local_thickness_mm'] = {
        'min': float(thickness.min()),
        'median': float(np.median(thickness)),
        'max': float(thickness.max()),
    }
    diagnostics['sample_region_mm'] = {'x': [-60, 60], 'y': [-22, 22]}
    diagnostics['sample_spacing_mm'] = 0.5
    diagnostics['method'] = (
        'Nearest projected triangle centres on upward/downward faces; '
        'descriptive estimates within the central region, not an exact '
        'global minimum wall-thickness or self-intersection test.'
    )
    return diagnostics


def validate(path):
    data = path.read_bytes()
    mesh = trimesh.load_mesh(path, process=True)
    incidence = np.bincount(mesh.edges_unique_inverse)
    components = len(trimesh.graph.connected_components(
        mesh.face_adjacency, nodes=np.arange(len(mesh.faces)), engine='scipy'))
    finite = bool(np.all(np.isfinite(mesh.vertices)))
    areas = mesh.area_faces
    dims = mesh.extents
    binary = len(data) >= 84 and len(data) == 84 + 50 * struct.unpack_from('<I', data, 80)[0]
    checks = {
        'finite_coordinates': finite,
        'binary_stl_size_valid': binary,
        'watertight': bool(mesh.is_watertight),
        'consistent_winding': bool(mesh.is_winding_consistent),
        'single_component': components == 1,
        'each_edge_has_two_faces': bool(np.all(incidence == 2)),
        'positive_volume': bool(mesh.volume > 0),
        'no_degenerate_triangles': bool(np.all(areas > 1e-12)),
        'length_180_mm': bool(np.isclose(dims[0], 180, atol=0.01)),
        'width_76_mm': bool(np.isclose(dims[1], 76, atol=0.01)),
        'low_flat_form_under_10_mm': bool(0 < dims[2] < 10),
        'lowest_point_at_z_zero': bool(abs(mesh.bounds[0, 2]) < 0.01),
    }
    return {
        'path': str(path),
        'sha256': hashlib.sha256(data).hexdigest(),
        'file_bytes': len(data),
        'format': 'binary STL' if binary else 'other STL',
        'units_assumed': 'mm',
        'vertices': len(mesh.vertices),
        'triangles': len(mesh.faces),
        'dimensions_mm': dims.tolist(),
        'bounds_mm': mesh.bounds.tolist(),
        'surface_area_mm2': float(mesh.area),
        'signed_volume_mm3': float(mesh.volume),
        'watertight': bool(mesh.is_watertight),
        'consistent_winding': bool(mesh.is_winding_consistent),
        'connected_components': components,
        'boundary_edges': int(np.count_nonzero(incidence == 1)),
        'nonmanifold_edges': int(np.count_nonzero(incidence > 2)),
        'degenerate_triangles': int(np.count_nonzero(areas <= 1e-12)),
        'minimum_triangle_area_mm2': float(areas.min()),
        'euler_number': int(mesh.euler_number),
        'self_intersections_checked': False,
        'surface_measurements': surface_measurements(mesh),
        'checks': checks,
        'passed': all(checks.values()),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('stl', nargs='?', type=Path,
                        default=ROOT / 'dist/lemon-peel-180x76mm-v1.stl')
    parser.add_argument('--report', type=Path,
                        default=ROOT / 'dist/validation-v1.json')
    args = parser.parse_args()
    report = validate(args.stl)
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({key: report[key] for key in (
        'passed', 'dimensions_mm', 'triangles', 'signed_volume_mm3',
        'connected_components', 'sha256')}, indent=2))
    if not report['passed']:
        raise SystemExit('Failed checks: ' + ', '.join(
            name for name, passed in report['checks'].items() if not passed))


if __name__ == '__main__':
    main()
