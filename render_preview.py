"""Render the actual printable STL mesh, not an AI illustration."""
from pathlib import Path
import bpy
from mathutils import Vector
ROOT=Path(__file__).resolve().parent
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete(use_global=False)
bpy.ops.wm.stl_import(filepath=str(ROOT/'dist/mandarin-segment-60mm.stl'))
fruit=bpy.context.object
fruit.name='Peeled mandarin segment — actual STL'
# The mesh is in millimetres. A convenient 0.01 scale keeps numeric scene scales moderate.
fruit.scale=(.01,)*3
bpy.ops.object.transform_apply(location=False,rotation=False,scale=True)
for polygon in fruit.data.polygons:polygon.use_smooth=True
mat=bpy.data.materials.new('Mandarin orange — preview material only')
mat.use_nodes=True
bsdf=mat.node_tree.nodes.get('Principled BSDF')
bsdf.inputs['Base Color'].default_value=(.72,.12,.004,1)
bsdf.inputs['Roughness'].default_value=.32
bsdf.inputs['IOR'].default_value=1.4
bsdf.inputs['Subsurface Weight'].default_value=0
fruit.data.materials.append(mat)
bpy.ops.mesh.primitive_plane_add(size=200,location=(0,0,-.002))
plane=bpy.context.object
floor=bpy.data.materials.new('Warm white ground')
floor.diffuse_color=(.88,.88,.86,1)
floor.use_nodes=True
floor.node_tree.nodes['Principled BSDF'].inputs['Base Color'].default_value=(.88,.88,.86,1)
floor.node_tree.nodes['Principled BSDF'].inputs['Roughness'].default_value=.7
plane.data.materials.append(floor)
world=bpy.context.scene.world
world.use_nodes=True
world.node_tree.nodes['Background'].inputs[0].default_value=(.9,.92,.95,1)
world.node_tree.nodes['Background'].inputs[1].default_value=.35

def light(name,position,energy,size):
 data=bpy.data.lights.new(name,'AREA');data.energy=energy;data.shape='DISK';data.size=size
 obj=bpy.data.objects.new(name,data);bpy.context.collection.objects.link(obj);obj.location=position
 obj.rotation_euler=(Vector((0,0,.12))-obj.location).to_track_quat('-Z','Y').to_euler()
light('Large softbox',(-.65,-.65,.9),18,.55)
light('Gentle fill',(.7,-.25,.45),4,.45)
light('Rim',(.25,.55,.7),10,.4)
camdata=bpy.data.cameras.new('Camera');cam=bpy.data.objects.new('Camera',camdata)
bpy.context.collection.objects.link(cam)
cam.location=(.42,-1.2,.55)
cam.rotation_euler=(Vector((0,0,.115))-cam.location).to_track_quat('-Z','Y').to_euler()
camdata.type='ORTHO';camdata.ortho_scale=.78
scene=bpy.context.scene;scene.camera=cam
scene.render.engine='CYCLES';scene.cycles.device='CPU';scene.cycles.samples=32
scene.cycles.use_denoising=False
scene.render.threads_mode='FIXED';scene.render.threads=4
scene.render.resolution_x=1200;scene.render.resolution_y=900;scene.render.resolution_percentage=100
scene.render.image_settings.file_format='PNG';scene.render.filepath=str(ROOT/'dist/preview.png')
scene.view_settings.view_transform='AgX'
bpy.ops.wm.save_as_mainfile(filepath=str(ROOT/'dist/mandarin-preview.blend'))
bpy.ops.render.render(write_still=True)
