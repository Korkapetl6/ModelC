"""Procedural membrane-free mandarin segment. Units: millimetres."""
from pathlib import Path
import json
import numpy as np
from scipy.ndimage import gaussian_filter
from skimage.measure import marching_cubes
import trimesh
ROOT=Path(__file__).resolve().parent
rng=np.random.default_rng(8173)
R,H=28.4,24.0
pitch=.14
axes=[np.arange(-32,32+pitch,pitch,dtype=np.float32),np.arange(-10,10+pitch,pitch,dtype=np.float32),np.arange(-4,29+pitch,pitch,dtype=np.float32)]
x,y,z=np.meshgrid(*axes,indexing='ij',sparse=True)
def shape(x,z):
 u=x/R
 top=2.25*np.maximum(0,1-u*u)+.32*np.sin(x*.32)
 bottom=H*np.sqrt(np.maximum(0,1-u*u))
 s=np.clip((z-top)/np.maximum(.001,bottom-top),0,1)
 thick=5.65*np.maximum(0,1-u*u)**.4*np.maximum(0,np.sin(np.pi*s))**.68
 return top,bottom,thick
zt,zb,thick=shape(x,z)
field=np.minimum(np.minimum(z-zt,zb-z),thick-np.abs(y))
field=np.minimum(field, R-np.abs(x)).astype(np.float32)
# Capsules embedded in the flesh, distributed on both faces with irregular lengths and angles.
caps=[]
for side in [-1,1]:
 for row,z0 in enumerate(np.arange(2.0,24,2.8)):
  for col,x0 in enumerate(np.arange(-27.3,28,1.65)):
   cx=x0+rng.uniform(-.32,.32)+(row%2)*.7
   cz=z0+rng.uniform(-.65,.65)
   top,bot,depth=shape(cx,cz)
   if cz<top+.6 or cz>bot-.65 or depth<.5:continue
   cy=side*(depth-.35)
   angle=-.52*cx/R+rng.uniform(-.20,.20)
   # Spindle axis is mostly vertical, fanning toward the tapered ends.
   major=rng.uniform(1.7,3.35)
   minor=rng.uniform(.70,.98)
   outward=rng.uniform(.85,1.2)
   caps.append((cx,cy,cz,minor,outward,major,angle))
# Small irregular sacs cover the narrow upper and lower ridges as well.
for cx in np.arange(-27.3,27.4,1.35):
 top,bot,_=shape(cx,8)
 for cz in [top+.55,bot-.65]:
  caps.append((cx+rng.uniform(-.18,.18),rng.uniform(-.25,.25),cz,rng.uniform(.65,.85),rng.uniform(.9,1.3),rng.uniform(1.1,1.7),-.6*cx/R))
for cx,cy,cz,rx,ry,rz,ang in caps:
 # Rotated tapered ellipsoid. Restrict work to each capsule's bounding box.
 extent=np.array([abs(np.cos(ang))*rx+abs(np.sin(ang))*rz,ry,abs(np.sin(ang))*rx+abs(np.cos(ang))*rz])+pitch*2
 centre=np.array([cx,cy,cz]);bounds=[]
 for i in range(3):
  lo=max(0,int(np.searchsorted(axes[i],centre[i]-extent[i])-1));hi=min(len(axes[i]),int(np.searchsorted(axes[i],centre[i]+extent[i])+1));bounds.append(slice(lo,hi))
 sl=tuple(bounds)
 xx=axes[0][sl[0]][:,None,None]-cx;yy=axes[1][sl[1]][None,:,None]-cy;zz=axes[2][sl[2]][None,None,:]-cz
 aa=np.cos(ang)*xx-np.sin(ang)*zz;bb=np.sin(ang)*xx+np.cos(ang)*zz
 taper=1-.17*np.clip(bb/rz,-1,1)
 q=(aa/(rx*taper))**2+(yy/(ry*taper))**2+(bb/rz)**2
 local=(1-np.sqrt(q))*min(rx,ry)
 np.maximum(field[sl],local,out=field[sl])
field=gaussian_filter(field,.42)
v,f,_,_=marching_cubes(field,level=0,spacing=(pitch,)*3,allow_degenerate=False)
v+=np.array([a[0] for a in axes])
mesh=trimesh.Trimesh(v,f,process=True)
parts=mesh.split(only_watertight=False)
mesh=max(parts,key=lambda p:p.volume if p.volume>0 else abs(p.volume))
mesh.fix_normals()
# Flip vertical modelling axis so the convex lower edge rests at z=0.
mesh.vertices[:,2]*=-1
mesh.invert()
mesh.fix_normals()
mesh.apply_scale(60/mesh.extents[0])
mesh.apply_translation([-mesh.bounds[:,0].mean(),-mesh.bounds[:,1].mean(),-mesh.bounds[0,2]])
# Quantize exactly as binary STL, then weld submicron slivers while preserving topology.
mesh.vertices=mesh.vertices.astype(np.float32).astype(np.float64)
mesh.merge_vertices(digits_vertex=5)
mesh.update_faces(mesh.nondegenerate_faces())
mesh.update_faces(mesh.unique_faces())
mesh.remove_unreferenced_vertices()
# Preserve full-resolution topology; no potentially destructive decimation.

mesh.fix_normals()

assert mesh.is_watertight and mesh.is_winding_consistent and mesh.volume>0
out=ROOT/'dist';out.mkdir(exist_ok=True)
mesh.export(out/'mandarin-segment-60mm.stl')
mesh.export(out/'mandarin-segment-60mm.glb')
report={'dimensions_mm':mesh.extents.tolist(),'capsules':len(caps),'triangles':len(mesh.faces),'volume_mm3':mesh.volume,'watertight':bool(mesh.is_watertight),'connected_components':len(mesh.split()),'voxel_mm':pitch,'seed':8173}
(out/'model-info.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report),flush=True)
