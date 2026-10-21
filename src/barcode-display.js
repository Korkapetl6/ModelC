/* Original barcode line layout by Zachary Scholl, MIT; adapted to Max jsui. */
autowatch=0;inlets=1;outlets=0;
mgraphics.init();mgraphics.relative_coords=0;mgraphics.autofill=0;
var rows=[],selection=0,master=0;
function data(){var a=arrayfromargs(arguments);master=a.shift();selection=a.shift();rows=a;mgraphics.redraw();}
function paint(){
 var w=box.rect[2]-box.rect[0],h=box.rect[3]-box.rect[1];
 with(mgraphics){
  save();
  set_source_rgba(0,0,0,1);rectangle(0,0,w,h);fill();scale(w/128,h/64);set_line_width(.7);
  set_source_rgba(.9,.9,.9,1);move_to(8,2);line_to(8+112*master,2);stroke();
  for(var i=0;i<6;i++){
   var o=i*6,y=6+i*9;
   set_source_rgba(i===selection?1:.35,i===selection?1:.35,i===selection?1:.35,1);
   if(rows.length<o+6)continue;
   move_to(8,y);line_to(8+112*rows[o],y);stroke();
   move_to(8,y+1);line_to(8+112*rows[o],y+1);stroke();
   move_to(64,y+2);line_to(64+56*rows[o+1],y+2);stroke();
   move_to(8,y+3);line_to(8+28*Math.abs(rows[o+2]),y+3);stroke();
   move_to(rows[o+2]<0?64:8,y+4);line_to(rows[o+2]<0?120:64,y+4);stroke();
   move_to(8+112*rows[o+3],y+5);line_to(8+112*rows[o+4],y+5);stroke();
  }
  restore();
 }
}
