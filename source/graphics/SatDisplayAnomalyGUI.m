 function [] = SatDisplayAnomalyGUI(data,parameters);

% Display results from anomaly detection filter
% close all
currentframe = 11;
data.currentframe = currentframe;
data.dias = parameters.data.dias(parameters.data.maxtime + 1 : end);
data.graphics.print = false;

% Setup initial figure
figanomaly = figure(1);
subplot(1,2,1);
imagesc(data.collectresults(:,:,currentframe));
title(['Anomaly Map frame number ', num2str(currentframe), '; day ', num2str(data.dias(currentframe))]);
colormap winter
axis off
axis square
colorbar
caxis([0 1.2]);

subplot(1,2,2);
imagesc(data.colorslides{currentframe});
title(['RGB frame number ', num2str(currentframe), '; day ', num2str(data.dias(currentframe))]);
axis off
axis square
colorbar
caxis([0 1.2]);

% Modify figure
x0=0;
y0=0;
width=1400;
height=700;
set(figanomaly,'units','points','position',[x0,y0,width,height]) 

% Enable data cursor mode
datacursormode on
dcm_obj = datacursormode(figanomaly);
% Set update function
set(dcm_obj,'UpdateFcn',{@myupdatefcn,data})
end
% GUI for displaying Sentinel and Landsat data from the testlandsatanomaly
function output_txt = myupdatefcn(~,event_obj,data)
    % ~            Currently not used (empty)
    % event_obj    Object containing event data structure
    % output_txt   Data cursor text
    pos = get(event_obj, 'Position');
    output_txt = ['(',num2str(pos(1)),',' num2str(pos(2)),')'];
  
    x = pos(1);
    y = pos(2);
    sequencefig = figure(2);
    data.x = x;
    data.y = y;
    
    subplot(2,1,1)
    stem(data.dias, abs(squeeze(data.collectresults(y,x,:))));
    title(['Anomaly sequence, coordinate = ',output_txt],'Interpreter','latex'); 
    xlabel('Day','Interpreter','latex'); 
    ylabel('Intensity','Interpreter','latex'); 
    results = abs(squeeze(data.collectresults(y,x,:)));
    loessplot(data,results,x,y);    
    ylim([0 1.2]); 
         
    subplot(2,1,2);
    stem(data.dias,abs(squeeze(data.rawdata(y,x,:))));
    title(['EVI  sequence, coordinate = ',output_txt],'Interpreter','latex'); 
    xlabel('Day','Interpreter','latex'); 
    ylabel('Intensity','Interpreter','latex'); 
    results = abs(squeeze(data.rawdata(y,x,:)));
    loessplot(data,results,x,y);    
    
    
    if data.graphics.print == true
        print(gcf, '-dpdf', '-bestfit', ['SequenceAnomalyFrame',output_txt,'.pdf']);
    end
    
    
   
    % Enable data cursor mode
    datacursormode on
    dcm_obj_inner = datacursormode(sequencefig);
    % Set update function
    set(dcm_obj_inner,'UpdateFcn',{@innerupdatefcn,data})
  
  
end

function output_txt = innerupdatefcn(~,event_obj,data)
    % ~            Currently not used (empty)
    % event_obj    Object containing event data structure
    % output_txt   Data cursor text
 
  
    pos = get(event_obj, 'Position');
    
  
    x = pos(1);
    y = pos(2);
    output_txt = ['(',num2str(pos(1)),',' num2str(pos(2)),')'];
  
    origx = x;
    ind = (data.dias == x);
    indx = 1 : length(data.dias);
    x = indx(ind);
    
    figanomaly = figure(1);
    subplot(1,2,1);
    imagesc(data.collectresults(:,:,x));
    title(['Anomaly Map frame number ', num2str(x), '; day ', num2str(origx)]);
    colormap winter
    axis off
    axis square
    colorbar
    caxis([0 1.2]);

    subplot(1,2,2);
    %imagesc(data.colorslides{x});
    %axis off
    %axis square
    %colorbar
    %title('RGB Image');
    %caxis([0 1.2]);
    
    image(uint8(255*data.colorslides{x}));
    title(['RGB frame number ', num2str(x), '; day ', num2str(origx)]);
    x1 = data.x;
    y1 = data.y;
    line([x1-1 x1+1 x1+1 x1-1 x1-1],[y1-1 y1-1 y1+1 y1+1 y1-1],'linewidth',3);
    axis off
    axis square
    %colorbar
    %caxis([0 1.2]);

       
    
    x0=0;
    y0=0;
    width=1400;
    height=700;
    set(figanomaly,'units','points','position',[x0,y0,width,height]) 

    if data.graphics.print == true
        h = figure(100);
        image(uint8(255*data.colorslides{x}));
        title(['RGB frame number ', num2str(x), '; day ', num2str(origx)],'Interpreter','latex','FontSize',18);
        x = data.x;
        y = data.y;
        line([x-1 x+1 x+1 x-1 x-1],[y-1 y-1 y+1 y+1 y-1],'linewidth',1);
        axis off
        axis square
        %set(gcf,'PaperPosition',[0 0 7 2]);
        print(gcf, '-dpdf', '-bestfit', ['RGBImageFrame',num2str(origx),'.pdf']);
        close(h);
    end


    
    
     % Enable data cursor mode
    datacursormode on
    dcm_obj_inner = datacursormode(figanomaly);
    % Set update function
    set(dcm_obj_inner,'UpdateFcn',{@myupdatefcn,data})
    
end


