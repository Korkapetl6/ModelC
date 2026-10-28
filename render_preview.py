"""Render the actual peel mesh. Colour only; no texture or displacement.

blender -b -t 4 --python render_preview.py
blender -b -t 4 --python render_preview.py -- --pith
blender -b -t 4 --python render_preview.py -- --closeup
"""
from pathlib import Path
import math
import sys
import bpy
import numpy as np
from mathutils import Vector

ROOT = Path(__file__).resolve().parent
PITH = '--pith' in sys.argv
CLOSEUP = '--closeup' in sys.argv
DRAFT = '--draft' in sys.argv
DATA = ROOT / 'dist' / 'preview-mesh.npz'

bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete(use_global=False)

def material(name, colour, roughness, coat=0):
    mat = bpy.data.materials.new(name)
    mat.use_nodes = True
    shader = mat.node_tree.nodes.get('Principled BSDF')
    shader.inputs['Base Color'].default_value = (*colour, 1)
    shader.inputs['Roughness'].default_value = roughness
    shader.inputs['IOR'].default_value = 1.45
    shader.inputs['Coat Weight'].default_value = coat
    shader.inputs['Coat Roughness'].default_value = .22
    return mat

yellow = material('Lemon yellow outer skin', (.85, .58, .001), .34, .1)
pith = material('Ivory pith inner face', (.88, .85, .72), .82)

if DATA.exists():
    data = np.load(DATA)
    verts = data['vertices'].astype(np.float32) * .01
    faces = data['faces'].astype(np.int32)
    ids = data['material_ids'].astype(np.int32)
    mesh = bpy.data.meshes.new('Actual peel geometry')
    mesh.from_pydata(verts.tolist(), [], faces.tolist())
    mesh.update()
    obj = bpy.data.objects.new('Lemon peel 180 x 76 mm', mesh)
    bpy.context.collection.objects.link(obj)
    mesh.materials.append(yellow)
    mesh.materials.append(pith)
    mesh.polygons.foreach_set('material_index', ids)
else:
    bpy.ops.wm.stl_import(filepath=str(ROOT / 'dist' / 'lemon-peel-180x76mm-v1.stl'))
    obj = bpy.context.object
    obj.name = 'Lemon peel 180 x 76 mm'
    obj.scale = (.01,) * 3
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    obj.data.materials.append(yellow)
    obj.data.materials.append(pith)
    for face in obj.data.polygons:
        face.material_index = 0 if face.normal.z > .4 else 1

for face in obj.data.polygons:
    face.use_smooth = True
obj.data.set_sharp_from_angle(angle=math.radians(55))
if PITH:
    obj.rotation_euler.x = math.pi
bpy.context.view_layer.update()
points = [obj.matrix_world @ Vector(p) for p in obj.bound_box]
low = Vector(tuple(min(p[i] for p in points) for i in range(3)))
high = Vector(tuple(max(p[i] for p in points) for i in range(3)))
obj.location += Vector((-.5 * (low.x + high.x), -.5 * (low.y + high.y), -low.z + .001))

bpy.ops.mesh.primitive_plane_add(size=200, location=(0, 0, -.001))
floor = bpy.context.object
floor.name = 'Neutral studio ground'
floor.data.materials.append(material('Neutral soft grey', (.64, .66, .67), .8))

def aim(o, target):
    o.rotation_euler = (Vector(target) - o.location).to_track_quat('-Z', 'Y').to_euler()

def light(name, position, power, width, height, target=(0, 0, 0)):
    data = bpy.data.lights.new(name, 'AREA')
    data.energy = power
    data.shape = 'RECTANGLE'
    data.size = width
    data.size_y = height
    o = bpy.data.objects.new(name, data)
    bpy.context.collection.objects.link(o)
    o.location = position
    aim(o, target)

light('Low broad key revealing real surface', (-1.6, -.9, 1.1), 60, 1.1, 1.6)
light('Soft upper fill', (.7, 1.4, 2.6), 25, 2.6, 2.6)
light('Narrow rim', (1.7, .6, .85), 20, .5, 1.5)

world = bpy.context.scene.world
world.use_nodes = True
world.node_tree.nodes['Background'].inputs[0].default_value = (.86, .89, .93, 1)
world.node_tree.nodes['Background'].inputs[1].default_value = .2

cam_data = bpy.data.cameras.new('Camera')
cam = bpy.data.objects.new('Camera', cam_data)
bpy.context.collection.objects.link(cam)
cam.location = (.12, -1.5, 3.7)
target = (0, 0, .02)
if CLOSEUP:
    target = (.25, -.04, .02)
    cam.location = (.4, -.7, 1.65)
aim(cam, target)
cam_data.type = 'ORTHO'
cam_data.ortho_scale = .68 if CLOSEUP else 2.12

scene = bpy.context.scene
scene.camera = cam
scene.render.engine = 'CYCLES'
scene.cycles.device = 'CPU'
scene.cycles.samples = 12 if DRAFT else 64
scene.cycles.use_denoising = False
scene.cycles.max_bounces = 8
scene.render.threads_mode = 'FIXED'
scene.render.threads = 4
scene.render.resolution_x = 1600
scene.render.resolution_y = 900
scene.render.resolution_percentage = 50 if DRAFT else 100
scene.render.image_settings.file_format = 'PNG'
label = 'pith' if PITH else 'yellow'
if CLOSEUP:
    label += '-detail'
if DRAFT:
    label += '-draft'
scene.render.filepath = str(ROOT / 'dist' / f'preview-{label}.png')
scene.view_settings.view_transform = 'Standard'
scene.view_settings.look = 'None'
scene.view_settings.exposure = -.55
bpy.ops.render.render(write_still=True)
