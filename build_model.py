"""A flattened lemon peel: actual pores and fibrous albedo in a closed STL (mm)."""
from pathlib import Path
import hashlib,json
import numpy as np
from scipy.ndimage import gaussian_filter
from scipy.spatial import cKDTree
import trimesh
ROOT=Path(__file__).resolve().parent
DIST=ROOT/'dist'; DIST.mkdir(exist_ok=True)
rng=np.random.default_rng(20261028)
NX,NY=721,305
u,v=np.meshgrid(np.linspace(-1,1,NX),np.linspace(-1,1,NY))
x,y=90*u,38*v
# A rounded hand-cut rectangle, then asymmetrical edge undulations.
r=5.2
cx=np.clip((np.abs(x)-(90-r))/r,0,1)
cy=np.clip((np.abs(y)-(38-r))/r,0,1)
x=np.sign(x)*(np.abs(x)-r*cx+r*cx*np.sqrt(1-cy*cy/2))
y=np.sign(y)*(np.abs(y)-r*cy+r*cy*np.sqrt(1-cx*cx/2))
y*=.945+.038*np.sin(x/24+.7)+.022*np.sin(x/11+1.1)
y+=1.0*np.sin(x/34)+.6*np.sin(x/9+.3)
# A hand-peeled edge has nonperiodic small chips, not a scalloped knife pattern.
edge_rng=np.random.default_rng(91028)
def edge_noise(count,sigma,amplitude):
    a=gaussian_filter(edge_rng.normal(size=count),sigma,mode='reflect')
    return amplitude*a/max(a.std(),1e-8)
upper=edge_noise(NX,6,.28)+edge_noise(NX,1.6,.055)
lower=edge_noise(NX,7,.30)+edge_noise(NX,1.8,.050)
y+=(np.abs(v)**8)*((1+v)/2*upper[None,:]+(1-v)/2*lower[None,:])
left=edge_noise(NY,7,.34)+edge_noise(NY,2,.06)
right=edge_noise(NY,5,.29)+edge_noise(NY,2,.05)
x+=(np.abs(u)**8)*(1.25*np.sin(y/13+.8)+.065*y+((1+u)/2*right[:,None]+(1-u)/2*left[:,None]))
# Exact requested maximum extents, with a handmade nonrectangular silhouette.
x=(x-(x.max()+x.min())/2)*180/np.ptp(x)
y=(y-(y.max()+y.min())/2)*76/np.ptp(y)
xy=np.column_stack((x.ravel(),y.ravel()))
tree=cKDTree(xy)
spacing=.25

def noise(mm,amp):
    a=gaussian_filter(rng.normal(size=x.shape),mm/spacing,mode='reflect')
    return amp*a/max(a.std(),1e-8)

# Yellow flavedo: nearly smooth skin with thousands of shallow oil-gland pits.
zt=4.0+.12*np.sin(x/27)*np.cos(y/22)+noise(4,.045)+noise(.38,.024)
pits=[]; bins={}; cell=.72
for _ in range(20000):
    j=int(rng.integers(3,NY-3)); i=int(rng.integers(3,NX-3))
    p=xy[j*NX+i]+rng.uniform(-.12,.12,2)
    key=tuple(np.floor(p/cell).astype(int))
    neighbours=[q for a in range(key[0]-1,key[0]+2) for b in range(key[1]-1,key[1]+2) for q in bins.get((a,b),[])]
    if any(np.sum((p-q)**2)<.72**2 for q in neighbours):continue
    bins.setdefault(key,[]).append(p)
    pits.append(p)
    if len(pits)==4400:break
flat=zt.ravel()
for p in pits:
    radius=rng.uniform(.38,.85); aspect=rng.uniform(.80,1.16); angle=rng.uniform(0,np.pi)
    idx=np.asarray(tree.query_ball_point(p,radius*2.5),dtype=int)
    d=xy[idx]-p
    a=d[:,0]*np.cos(angle)+d[:,1]*np.sin(angle)
    b=-d[:,0]*np.sin(angle)+d[:,1]*np.cos(angle)
    rr=(a/radius)**2+(b/(radius*aspect))**2
    flat[idx]-=rng.uniform(.13,.40)*np.exp(-2*rr)
    flat[idx]+=.015*np.exp(-((np.sqrt(rr)-1.18)/.30)**2)
# White albedo: rough, multiscale, with short soft torn fibres.
zb=noise(5,.16)+noise(1.35,.14)+noise(.38,.105)+noise(.16,.035)
flat=zb.ravel()
for _ in range(1700):
    p=xy[int(rng.integers(len(xy)))]
    length=rng.uniform(.7,2.4); width=rng.uniform(.20,.44); angle=rng.normal(.0,.9)
    idx=np.asarray(tree.query_ball_point(p,length*2.0),dtype=int)
    d=xy[idx]-p
    a=d[:,0]*np.cos(angle)+d[:,1]*np.sin(angle)
    b=-d[:,0]*np.sin(angle)+d[:,1]*np.cos(angle)
    # Slightly ragged fibrous ridge instead of a smooth regular bump pattern.
    profile=np.exp(-2*(a/length)**2-2*(b/width)**2)
    profile*=.80+.20*np.cos(a*7+angle)
    flat[idx]-=rng.uniform(.14,.42)*profile
# Roll the surfaces gently into the irregular cut edge.
ed=np.minimum((1-np.abs(u))*90,(1-np.abs(v))*38)
zt-=.25*np.exp(-ed/.55)
zb+=.19*np.exp(-ed/.65)
local_thickness=zt-zb
assert local_thickness.min()>2.2, float(local_thickness.min())
n=NX*NY
verts=[np.column_stack((xy,zt.ravel())),np.column_stack((xy,zb.ravel()))]
a=np.arange(n).reshape(NY,NX)[:-1,:-1].ravel()
faces_top=np.vstack((np.column_stack((a,a+1,a+NX+1)),np.column_stack((a,a+NX+1,a+NX))))
faces_bottom=(faces_top[:,::-1]+n)
faces=[faces_top,faces_bottom]
labels=[np.zeros(len(faces_top),np.uint8),np.ones(len(faces_bottom),np.uint8)]
# Continuous perimeter counterclockwise; closed sides, smoothly bulged cut face.
ids=np.arange(n).reshape(NY,NX)
boundary=np.concatenate((ids[0,:],ids[1:,-1],ids[-1,-2::-1],ids[-2:0:-1,0]))
p=xy[boundary]; tangent=np.roll(p,-1,axis=0)-np.roll(p,1,axis=0)
normal=np.column_stack((tangent[:,1],-tangent[:,0]));normal/=np.linalg.norm(normal,axis=1)[:,None]
prev=boundary;count=2*n;B=len(boundary)
for k in range(1,10):
    t=k/10
    ring_xy=p+normal*(.16*np.sin(np.pi*t))
    z=(1-t)*zt.ravel()[boundary]+t*zb.ravel()[boundary]
    verts.append(np.column_stack((ring_xy,z)))
    curr=np.arange(count,count+B);count+=B
    faces.append(np.vstack((np.column_stack((prev,np.roll(prev,-1),curr)),np.column_stack((np.roll(prev,-1),np.roll(curr,-1),curr)))))
    labels.append(np.full(2*B,0 if t<=.1 else 1,np.uint8));prev=curr
curr=boundary+n
faces.append(np.vstack((np.column_stack((prev,np.roll(prev,-1),curr)),np.column_stack((np.roll(prev,-1),np.roll(curr,-1),curr)))))
labels.append(np.ones(2*B,np.uint8))
vertices=np.vstack(verts);faces=np.vstack(faces);material_ids=np.concatenate(labels)
# Account for the soft side bulge and place the lowest pith point on z=0.
for axis,extent in [(0,180),(1,76)]:
    vertices[:,axis]-=(vertices[:,axis].max()+vertices[:,axis].min())/2
    vertices[:,axis]*=extent/np.ptp(vertices[:,axis])
vertices[:,2]-=vertices[:,2].min()
vertices=vertices.astype(np.float32)
mesh=trimesh.Trimesh(vertices=vertices,faces=faces,process=False)
# The side strips have opposite winding to the top; orient them outward.
mesh.faces[len(faces_top)+len(faces_bottom):]=mesh.faces[len(faces_top)+len(faces_bottom):,::-1]
assert mesh.is_watertight and mesh.is_winding_consistent and mesh.volume>0
assert len(mesh.split(only_watertight=False))==1
assert np.allclose(mesh.extents[:2],[180,76],atol=.0001)
file=DIST/'lemon-peel-180x76mm-v1.stl'
mesh.export(file)
# Preview data keeps real geometry and distinguishes yellow skin from white pith.
np.savez_compressed(DIST/'preview-mesh.npz',vertices=mesh.vertices,faces=mesh.faces,material_ids=material_ids)
colors=np.where(material_ids[:,None]==0,np.array([249,198,15,255]),np.array([242,231,193,255])).astype(np.uint8)
mesh.visual.face_colors=colors
mesh.export(DIST/'lemon-peel-180x76mm-v1.glb')
info={
 'units':'mm','dimensions_mm':mesh.extents.tolist(),'nominal_thickness_mm':4,
 'minimum_local_thickness_mm':float(local_thickness.min()),'maximum_local_thickness_mm':float(local_thickness.max()),
 'yellow_oil_gland_pits':len(pits),'pith_fibre_features':1700,'triangles':len(mesh.faces),
 'vertices':len(mesh.vertices),'volume_mm3':float(mesh.volume),'watertight':bool(mesh.is_watertight),
 'components':1,'texture_is_geometry':True,'curled':False,'seed':20261028,
 'sha256':hashlib.sha256(file.read_bytes()).hexdigest()}
(DIST/'model-info-v1.json').write_text(json.dumps(info,indent=2)+'\n')
print(json.dumps(info,indent=2))
