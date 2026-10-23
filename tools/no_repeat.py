from pathlib import Path

def transform_no_repeat(name,source):
    if name=='core.js':
        source+='\n'+(Path(__file__).resolve().parents[1]/'src/no_repeat_core.js').read_text()
    elif name=='compass.js':
        source=source.replace('h=core.advance();', 'h=core.advance(stepCursor());')
        source=source.replace('function configure(i,h){', 'function configure(i,h){phase[i]=clip((h.pos-h.lo)/(h.hi-h.lo),0,1);')
        source+='''\nfunction stepCursor(){
 if(queued&&queued.seek)return queued.pos;
 if(lastConfig)return lastConfig.lo+phase[activeHead]*(lastConfig.hi-lastConfig.lo);
 return core.lo;
}\n'''
    return source
