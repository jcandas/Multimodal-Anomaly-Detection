function displayoutput(parameters);

name = parameters.graphics.name;
h = parameters.graphics.h;

x0=0;
y0=0;
width=2200;
height=700;
set(h,'units','points','position',[x0,y0,width,height]) 
if parameters.graphics.print == true
    set(gcf,'Units','inches');
    screenposition = get(gcf,'Position');
    set(gcf,...
   'PaperPosition',[0 0 screenposition(3:4)],...
   'PaperSize',[screenposition(3:4)]);
   print('-dpdf','-bestfit','-painters',name);
end  