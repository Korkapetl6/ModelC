"""Screen-only adaptation of Mark Eats' Molly the Poly redraw/update, GPLv3.
Source: github.com/markwheeler/molly_the_poly commit 76cd4dc86f043546e3525c58e09eba688696172c.
No MIDI input; Pad selected. Initial phases and velocities chosen for a seamless loop.
Pillow approximates norns screen rasterization and font.
"""
import math
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
OUT=Path(__file__).resolve().parent
S=4
N=900
font=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',8*S)
frames=[]
phases=[4.4,1.2,3.1]
turns=[3,2,4]
palette=[v for i in range(256) for v in (i,i,i)]
for f in range(N):
 im=Image.new('L',(128*S,64*S),0);d=ImageDraw.Draw(im)
 def circle(x,y,r,level,width=None):
  b=((x-r)*S,(y-r)*S,(x+r)*S,(y+r)*S)
  if width is None:d.ellipse(b,fill=level*17)
  else:d.ellipse(b,outline=level*17,width=max(1,round(width*S)))
 for i,r in enumerate([13.5,21.5,29.5]):
  a=phases[i]+math.tau*turns[i]*f/N
  x,y=64+r*math.cos(a),32+r*math.sin(a)
  if i==1:
   circle(64,32,r,5,.7);circle(x,y,5.5,15,.7)
   level=15
  else:
   segments=round(math.tau*r/6)
   for seg in range(segments):
    start=seg*360/segments
    d.arc(((64-r)*S,(32-r)*S,(64+r)*S,(32+r)*S),start,start+180/segments,fill=3*17,width=S)
   level=4
  circle(x,y,2.8,level)
 circle(64,32,5,15)
 d.text((3*S,58*S),'Pad',font=font,fill=255,anchor='ls')
 # Approximate the antialiased 128x64 monochrome norns screen, then enlarge pixels.
 im=im.resize((128,64),Image.Resampling.LANCZOS).resize((512,256),Image.Resampling.NEAREST)
 p=im.convert('P');p.putpalette(palette);frames.append(p)
frames[0].save(OUT/'Molly-the-Poly-screen.gif',save_all=True,append_images=frames[1:],duration=[60,70,70]*(N//3),loop=0,optimize=False,disposal=1)
frames[0].convert('RGB').save(OUT/'preview.png')
with Image.open(OUT/'Molly-the-Poly-screen.gif') as check:
 assert check.n_frames==N
 assert check.size==(512,256)
 total=0
 for i in range(check.n_frames):check.seek(i);total+=check.info['duration']
 assert total==60000
print('Verified: 900 frames, 512x256, 60-second seamless loop;', (OUT/'Molly-the-Poly-screen.gif').stat().st_size,'bytes')
