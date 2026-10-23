"""Source transforms for the separately packaged No Fades edition."""
import json,re

def transform(name,source):
    if name=='core.js':
        source=re.sub(r'this.steps=(\[[^;]+\]);',lambda m:'this.steps='+json.dumps([0 if x>=14 else x for x in json.loads(m[1])])+';',source,count=1)
        source=re.sub(r'Compass.presets=(\[.*\]);',lambda m:'Compass.presets='+json.dumps([{**p,'steps':[0 if x>=14 else x for x in p['steps']]} for p in json.loads(m[1])])+';',source)
        source=source.replace('case 14:return {fade:14};case 15:return {fade:15};','case 14:case 15:return null;')
        source=source.replace('for(i=1;i<16;i++){var w=','for(i=1;i<14;i++){var w=').replace('for(j=1;j<16;j++){if(weights[j]<=0)','for(j=1;j<14;j++){if(weights[j]<=0)')
        a=source.index('Compass.prototype.fadeValue=');b=source.index('\n',a)
        source=source[:a]+'Compass.prototype.fadeValue=function(){return 1;};'+source[b:]
        source=source.replace('this.pool=[0,100,100,0,0,100,100,100,100,100,100,0,0,100,100,100]','this.pool=[0,100,100,0,0,100,100,100,100,100,100,0,0,100,0,0]')
    elif name=='compass.js':
        source=source.replace("if(i>0)ui('pool'+i", "if(i>0&&i<14)ui('pool'+i")
        source=source.replace('core.steps[clip(i,0,15)|0]=clip(x,0,15)|0','core.steps[clip(i,0,15)|0]=Number(x)>=14?0:clip(x,0,13)|0')
        source=source.replace('core.steps[i]=clip(s.steps[i],0,15)|0','core.steps[i]=Number(s.steps[i])>=14?0:clip(s.steps[i],0,13)|0')
        source=source.replace('core.pool[0]=0;', 'core.pool[0]=0;core.pool[14]=0;core.pool[15]=0;')
    return source
