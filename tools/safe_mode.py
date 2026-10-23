"""Build the time-limited No Fades variant without changing the standard editions."""
import json,re
from pathlib import Path

def transform_safe(name,source):
    if name=='core.js':
        source=source.replace('this.baseDivision=4;','this.baseDivision=1;')
        source=re.sub(r'"clock":\s*2', '"clock":0',source)
        source+='\n'+(Path(__file__).resolve().parents[1]/'src/safe_core.js').read_text()
    elif name=='compass.js':
        source=source.replace("+' | '+core.division+'/beat'", "+' | '+core.division+'/beat'+(core.safeRest>0?' | RECOVER':'')")
    return source
