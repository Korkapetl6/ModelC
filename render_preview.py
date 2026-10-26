"""Studio renders of the actual water-block STL geometry (no shader displacement)."""
from pathlib import Path
import math
import sys
import bpy
from mathutils import Vector
ROOT=Path(__file__).resolve().parent
GLASS='--glass' in sys.argv
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete(use_global=False)
bpy.ops.wm.stl_import(filepath=str(ROOT/'dist/water-slab-150mm-v2.stl'))
block=bpy.context.object
block.name='Water slab v2 — actual printable STL'
block.scale=(.01,)*3
bpy.ops.object.transform_apply(location=False,rotation=False,scale=True)
# Allow centred or positive-coordinate STL conventions without changing the saved STL.
points=[Vector(p) for p in block.bound_box]
low=Vector(tuple(min(p[i] for p in points) for i in range(3)))
high=Vector(tuple(max(p[i] for p in points) for i in range(3)))
block.location=(-.5*(low.x+high.x),-.5*(low.y+high.y),-low.z)
for polygon in block.data.polygons:polygon.use_smooth=True
block.data.set_sharp_from_angle(angle=math.radians(45))
mat=bpy.data.materials.new('Pale turquoise sculptural gloss' if not GLASS else 'Water-like clear glass — illustrative material')
mat.use_nodes=True
bsdf=mat.node_tree.nodes.get('Principled BSDF')
bsdf.inputs['Base Color'].default_value=(.11,.40,.44,1) if not GLASS else (.82,.96,.98,1)
bsdf.inputs['Roughness'].default_value=.20 if not GLASS else .035
bsdf.inputs['IOR'].default_value=1.45 if not GLASS else 1.333
bsdf.inputs['Transmission Weight'].default_value=0 if not GLASS else 1
bsdf.inputs['Coat Weight'].default_value=.2 if not GLASS else 0
bsdf.inputs['Coat Roughness'].default_value=.12
block.data.materials.append(mat)
bpy.ops.mesh.primitive_plane_add(size=200,location=(0,0,-.003))
plane=bpy.context.object
plane.name='White studio ground'
floor=bpy.data.materials.new('Soft white ground');floor.use_nodes=True
floor.node_tree.nodes['Principled BSDF'].inputs['Base Color'].default_value=(.86,.87,.87,1)
floor.node_tree.nodes['Principled BSDF'].inputs['Roughness'].default_value=.65
plane.data.materials.append(floor)
world=bpy.context.scene.world;world.use_nodes=True
world.node_tree.nodes['Background'].inputs[0].default_value=(.86,.90,.94,1)
world.node_tree.nodes['Background'].inputs[1].default_value=.25

def point_at(obj,point):obj.rotation_euler=(Vector(point)-obj.location).to_track_quat('-Z','Y').to_euler()
def light(name,pos,energy,width,height):
 data=bpy.data.lights.new(name,'AREA');data.energy=energy;data.shape='RECTANGLE';data.size=width;data.size_y=height
 obj=bpy.data.objects.new(name,data);bpy.context.collection.objects.link(obj);obj.location=pos;point_at(obj,(0,0,.10))
light('Broad key',(-2,-1.8,3),110,2.0,2.0)
light('Long strip over waves',(0,2.1,2.8),140,2.8,.22)
light('Side fill',(2.4,-.7,1.1),25,1.1,1.8)
# Dark cards make the low, broad top undulations visible in reflections.
cardmat=bpy.data.materials.new('Dark studio reflection card');cardmat.use_nodes=True
cardmat.node_tree.nodes['Principled BSDF'].inputs['Base Color'].default_value=(.008,.012,.014,1)
cardmat.node_tree.nodes['Principled BSDF'].inputs['Roughness'].default_value=.8
for name,pos,scale in [('Left contrast card',(-2.4,.4,1.1),(1.3,2.0,1)),('Back narrow contrast',(0,2.5,1.6),(2.8,.25,1))]:
 bpy.ops.mesh.primitive_plane_add(size=1,location=pos)
 obj=bpy.context.object;obj.name=name;obj.scale=scale;point_at(obj,(0,0,.12));obj.data.materials.append(cardmat)
 obj.visible_camera=False
camdata=bpy.data.cameras.new('Camera');cam=bpy.data.objects.new('Camera',camdata);bpy.context.collection.objects.link(cam)
cam.location=(2.0,-2.7,3.1);point_at(cam,(0,0,.10));camdata.type='ORTHO';camdata.ortho_scale=2.65
scene=bpy.context.scene;scene.camera=cam;scene.render.engine='CYCLES';scene.cycles.device='CPU';scene.cycles.samples=32 if GLASS else 64
scene.cycles.use_denoising=False;scene.cycles.max_bounces=12;scene.cycles.transmission_bounces=8
scene.render.threads_mode='FIXED';scene.render.threads=4
scene.render.resolution_x=1200;scene.render.resolution_y=1000;scene.render.resolution_percentage=100
scene.render.image_settings.file_format='PNG';scene.render.filepath=str(ROOT/'dist'/('preview-glass-v2.png' if GLASS else 'preview-v2.png'))
scene.view_settings.view_transform='AgX'
if not GLASS:bpy.ops.wm.save_as_mainfile(filepath=str(ROOT/'dist/water-slab-preview-v2.blend'))
bpy.ops.render.render(write_still=True)
