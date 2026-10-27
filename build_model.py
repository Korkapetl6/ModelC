"""150 mm rounded glass/water block: explicit manifold surface, millimetres."""
from pathlib import Path
import json
import numpy as np
import trimesh
ROOT=Path(__file__).resolve().parent
N=257
HALF=69.5
CORNER=12.5
LIP=5.5
HEIGHT=65.0/3.0
RELIEF=13.0
FOOT=3.0

def rounded_grid(x,y,half,radius):
    ax,ay=np.abs(x),np.abs(y)
    u=np.maximum(0,ax-(half-radius))/radius
    v=np.maximum(0,ay-(half-radius))/radius
    corner=(u>0)&(v>0)
    factor=np.maximum(u,v)/np.maximum(1e-12,np.sqrt(u*u+v*v))
    return np.where(corner,np.sign(x)*(half-radius+u*factor*radius),x),np.where(corner,np.sign(y)*(half-radius+v*factor*radius),y)

def raw_water(x,y):
    # Five continuous flowing troughs: no localized pools or circular depressions.
    # Each channel runs across almost the full width, with gently varying width/curvature.
    flow=13.0*np.sin(x/32.0)+7.0*np.sin(x/60.0+.7)
    h=.18*np.sin(x/75.0)+.12*np.sin(y/65.0)
    for centre,width,depth,phase in [(-48,8.5,3.3,.2),(-24,9.3,3.8,.7),
                                   (0,10.5,4.0,1.2),(25,9.0,3.7,1.8),
                                   (49,8.5,3.1,2.3)]:
        path=centre+flow*(1-.60*(abs(centre)/55.0)**1.2)+6.0*np.sin(x/24.0+phase)
        w=width*(1+.35*np.sin(x/27.0+phase))
        strength=depth*(1+.15*np.sin(x/43.0+phase))
        h-=strength*np.exp(-((y-path)/w)**2)
    # Ease only the final few millimetres into the larger rolled edge.
    # This prevents a deep wave trough intersecting the bottom fillet at the perimeter.
    qx=np.abs(x)-(HALF-CORNER);qy=np.abs(y)-(HALF-CORNER)
    signed=np.sqrt(np.maximum(qx,0)**2+np.maximum(qy,0)**2)+np.minimum(np.maximum(qx,qy),0)-CORNER
    distance=np.maximum(0,-signed)
    blend=1-np.exp(-(distance/4.8)**2)
    return -.80*(1-blend)+h*blend

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
assert np.min(rz)>FOOT+.5, 'Top and bottom fillets intersect'
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
mesh.export(out/'water-slab-150mm-v4.stl')
mesh.export(out/'water-slab-150mm-v4.glb')
info={'dimensions_mm':mesh.extents.tolist(),'triangles':len(mesh.faces),'volume_mm3':float(mesh.volume),'top_relief_mm':float(np.ptp(z)*height_scale),'top_lip_radius_mm':LIP,'vertical_corner_radius_mm':CORNER+LIP,'bottom_fillet_mm':FOOT,'watertight':bool(mesh.is_watertight),'components':1,'grid_resolution':N,'minimum_top_height_mm':float(z.min()*height_scale),'continuous_troughs':5,'units':'mm'}
(out/'model-info-v4.json').write_text(json.dumps(info,indent=2)+'\n')
print(json.dumps(info))
