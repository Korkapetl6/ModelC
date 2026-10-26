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
HEIGHT=65.0
FOOT=1.2

def rounded_grid(x,y,half,radius):
    ax,ay=np.abs(x),np.abs(y)
    u=np.maximum(0,ax-(half-radius))/radius
    v=np.maximum(0,ay-(half-radius))/radius
    corner=(u>0)&(v>0)
    factor=np.maximum(u,v)/np.maximum(1e-12,np.sqrt(u*u+v*v))
    return np.where(corner,np.sign(x)*(half-radius+u*factor*radius),x),np.where(corner,np.sign(y)*(half-radius+v*factor*radius),y)

def water(x,y):
    # Warped long crests, varied wavelengths, no concentric/radial ripple stamp.
    p=(.78*x+.62*y)/50.0
    q=(-.62*x+.78*y)/76.0
    return (2.30*np.sin(2*np.pi*p+.65*np.sin(2*np.pi*q))
        +1.05*np.sin(2*np.pi*(.28*x-.96*y)/83+.5)
        +.50*np.cos(2*np.pi*(.94*x+.34*y)/34+.8*np.sin(y/44))
        +.80*np.exp(-((x+22)**2/1700+(y-17)**2/1000))
        -.60*np.exp(-((x-41)**2/1100+(y+29)**2/1300)))

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
mesh.vertices[:,2]*=HEIGHT/mesh.bounds[1,2]
mesh.vertices=mesh.vertices.astype(np.float32).astype(np.float64)
mesh.fix_normals()
assert mesh.is_watertight and mesh.is_winding_consistent and mesh.volume>0
assert np.allclose(mesh.extents,[150,150,65],atol=.0001)
assert len(mesh.split())==1
out=ROOT/'dist';out.mkdir(exist_ok=True)
mesh.export(out/'water-block-150mm.stl')
mesh.export(out/'water-block-150mm.glb')
info={'dimensions_mm':mesh.extents.tolist(),'triangles':len(mesh.faces),'volume_mm3':float(mesh.volume),'top_relief_mm':float(np.ptp(z)),'top_lip_radius_mm':LIP,'vertical_corner_radius_mm':CORNER+LIP,'bottom_fillet_mm':FOOT,'watertight':bool(mesh.is_watertight),'components':1,'grid_resolution':N,'units':'mm'}
(out/'model-info.json').write_text(json.dumps(info,indent=2)+'\n')
print(json.dumps(info))
