"""150 mm rounded glass/water block: explicit manifold surface, millimetres."""
from pathlib import Path
import json
import numpy as np
import trimesh
ROOT=Path(__file__).resolve().parent
N=257
HALF=73.0
CORNER=4.0
LIP=2.0
HEIGHT=65.0/3.0
RELIEF=13.0
FOOT=1.2

def rounded_grid(x,y,half,radius):
    ax,ay=np.abs(x),np.abs(y)
    u=np.maximum(0,ax-(half-radius))/radius
    v=np.maximum(0,ay-(half-radius))/radius
    corner=(u>0)&(v>0)
    factor=np.maximum(u,v)/np.maximum(1e-12,np.sqrt(u*u+v*v))
    return np.where(corner,np.sign(x)*(half-radius+u*factor*radius),x),np.where(corner,np.sign(y)*(half-radius+v*factor*radius),y)

def raw_water(x,y):
    # Smoothly warped coordinates avoid repeated parallel crests and circular dimples.
    u=x+6.0*np.sin(y/29.0)+3.0*np.sin((x+y)/47.0)
    v=y+7.0*np.sin(x/36.0)-3.0*np.cos((x-2*y)/63.0)
    h=.8*np.sin(.045*u+.025*v)+.45*np.sin(-.018*u+.060*v)
    # Broad asymmetric depressions join into wandering troughs and rounded saddles.
    pools=[(-35,-30,22,15,.40,3.5),(26,-10,27,14,-.60,4.2),
           (-7,40,29,16,.20,3.7),(60,53,22,12,-.90,2.5),
           (-65,20,20,30,.35,2.6)]
    for cx,cy,rx,ry,angle,depth in pools:
        dx=u-cx;dy=v-cy
        a=np.cos(angle)*dx+np.sin(angle)*dy
        b=-np.sin(angle)*dx+np.cos(angle)*dy
        # Different axial exponents stay smooth while avoiding a repeated oval stamp.
        h-=depth*np.exp(-((a/rx)**2+.85*(b/ry)**2))
    h-=1.15*np.exp(-((v+13*np.sin(u/40.0)+12)/15.0)**2)
    h+=1.30*np.exp(-((u+12)**2/900+(v+10)**2/600))
    h+=.85*np.exp(-((u-43)**2/1000+(v-30)**2/750))
    return h

# Fixed normalization on the full top so edge derivative samples use the same amplitude.
ref=np.linspace(-HALF,HALF,N)
refx,refy=np.meshgrid(ref,ref)
refx,refy=rounded_grid(refx,refy,HALF,CORNER)
reference=raw_water(refx,refy)
RAW_RANGE=float(np.ptp(reference));RAW_MAX=float(reference.max())
def water(x,y):
    return RELIEF*(raw_water(x,y)-RAW_MAX)/RAW_RANGE

g=np.linspace(-HALF,HALF,N)
x,y=np.meshgrid(g,g)
x,y=rounded_grid(x,y,HALF,CORNER)
z=water(x,y)
z+=HEIGHT-float(z.max())
vertices=list(np.stack([x,y,z],axis=-1).reshape(-1,3))
faces=[]
for j in range(N-1):
    for i in range(N-1):
        a=j*N+i;faces.extend([(a,a+1,a+N+1),(a,a+N+1,a+N)])
# Counter-clockwise ring around top perimeter (indices refer to top grid).
ring=list(range(N))+[j*N+N-1 for j in range(1,N)]+[(N-1)*N+i for i in range(N-2,-1,-1)]+[j*N for j in range(N-2,0,-1)]
xy=np.asarray(vertices)[ring,:2];topz=np.asarray(vertices)[ring,2]
centres=np.clip(xy,-HALF+CORNER,HALF-CORNER)
normal=xy-centres;normal/=np.linalg.norm(normal,axis=1)[:,None]
eps=.01
slope=(water(*(xy+normal*eps).T)-water(*(xy-normal*eps).T))/(2*eps)

def add_ring(points):
    global ring
    ids=list(range(len(vertices),len(vertices)+len(points)));vertices.extend(points)
    for i in range(len(ring)):
        j=(i+1)%len(ring)
        faces.extend([(ring[i],ids[i],ids[j]),(ring[i],ids[j],ring[j])])
    ring=ids

# Rounded top lip, tangential to the actual water height field at its inner edge.
for theta in np.linspace(0,np.pi/2,17)[1:]:
    rxy=xy+normal*(LIP*np.sin(theta))
    rz=topz+slope*LIP*np.sin(theta)-LIP*(1-np.cos(theta))
    add_ring(np.column_stack([rxy,rz]))
outer=xy+normal*LIP
# Straight, smooth walls; an eased bottom edge meets a genuinely planar base.
add_ring(np.column_stack([outer,np.full(len(outer),FOOT)]))
for theta in np.linspace(0,np.pi/2,13)[1:]:
    rxy=outer-normal*(FOOT*(1-np.cos(theta)))
    rz=np.full(len(outer),FOOT*(1-np.sin(theta)))
    add_ring(np.column_stack([rxy,rz]))
centre=len(vertices);vertices.append([0,0,0])
for i in range(len(ring)):faces.append((centre,ring[(i+1)%len(ring)],ring[i]))
mesh=trimesh.Trimesh(np.asarray(vertices),np.asarray(faces),process=True)
# Include possible lip crest in precise overall height while retaining the flat base.
height_scale=HEIGHT/mesh.bounds[1,2]
mesh.vertices[:,2]*=height_scale
mesh.vertices=mesh.vertices.astype(np.float32).astype(np.float64)
mesh.fix_normals()
assert mesh.is_watertight and mesh.is_winding_consistent and mesh.volume>0
assert np.allclose(mesh.extents,[150,150,HEIGHT],atol=.0001)
assert len(mesh.split())==1
out=ROOT/'dist';out.mkdir(exist_ok=True)
mesh.export(out/'water-slab-150mm-v2.stl')
mesh.export(out/'water-slab-150mm-v2.glb')
info={'dimensions_mm':mesh.extents.tolist(),'triangles':len(mesh.faces),'volume_mm3':float(mesh.volume),'top_relief_mm':float(np.ptp(z)*height_scale),'top_lip_radius_mm':LIP,'vertical_corner_radius_mm':CORNER+LIP,'bottom_fillet_mm':FOOT,'watertight':bool(mesh.is_watertight),'components':1,'grid_resolution':N,'minimum_top_height_mm':float(z.min()*height_scale),'units':'mm'}
(out/'model-info-v2.json').write_text(json.dumps(info,indent=2)+'\n')
print(json.dumps(info))
