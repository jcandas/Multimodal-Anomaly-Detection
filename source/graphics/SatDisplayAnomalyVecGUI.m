% GUI for displaying Sentinel and Landsat data from the
% testlandsatanomalyVec
function [] = SatDisplayAnomalyVecGUI(data,parameters);

% Display results from anomaly detection filter
% close all
currentframe = 11;
data.currentframe = currentframe;
data.dias = parameters.data.dias(parameters.data.maxtime + 1 : end);
dimdata = size(data.collectresults,4);
data.graphics.print = false;


% Setup initial figure
figanomalyrgb= figure(1);
image(uint8(255*data.colorslides{currentframe}));
title(['RGB Map frame number ', num2str(currentframe), '; day ', num2str(data.dias(currentframe))]);
axis off
axis square

% Modify figure
x0=0;
y0=0;
width= 700;
height=700;
set(figanomalyrgb,'units','points','position',[x0,y0,width,height]) 

% Enable data cursor mode
 datacursormode on
dcm_obj_rgb = datacursormode(figanomalyrgb);
% Set update function
set(dcm_obj_rgb,'UpdateFcn',{@myupdatefcn,data})

% Load initial set of anomaly maps
figanomaly = figure(2);
imagebandanomalyforGUI(squeeze(data.collectresults(:,:,currentframe,:)),dimdata,data.dias); 

% Modify figure
x0=0;
y0=1300;
width= 2800;
height=400;
set(figanomaly,'units','points','position',[x0,y0,width,height]) 

% Enable data cursor mode
datacursormode on
dcm_obj = datacursormode(figanomaly);
% Set update function
set(dcm_obj,'UpdateFcn',{@myupdatefcn,data})

end


function output_txt = myupdatefcn(~,event_obj,data)
    % ~            Currently not used (empty)
    % event_obj    Object containing event data structure
    % output_txt   Data cursor text
    pos = get(event_obj, 'Position');
    output_txt = ['(',num2str(pos(1)),',' num2str(pos(2)),')'];
  
    x = pos(1);
    y = pos(2);
    sequencefig = figure(3);
    dimdata = size(data.collectresults,4);
    data.x = x;
    data.y = y;
    
    for k = 1 : dimdata
    
        subplot(dimdata,1,k)
        stem(data.dias, abs(squeeze(data.collectresults(y,x,:,k))));
        results = abs(squeeze(data.collectresults(y,x,:,k)));
        loessplot(data,results,x,y);    
        title(['Anomaly sequence, coordinate = ',output_txt,' Band = ', num2str(k)],...
            'FontSize',16,'Interpreter','latex');
        %ylim([0 1.2]); 
        %subplot(2,1,2);
        %stem(data.dias,abs(squeeze(data.rawdata(y,x,:))));
        %title(['EVI  sequence per frame, coordinate = ',output_txt])
    end
    
    % Modify figure
    x0=800;
    y0=0;
    width= 700;
    height=1000;
    set(sequencefig,'units','points','position',[x0,y0,width,height]) 
    
    if data.graphics.print == true
        print(gcf, '-dpdf', '-bestfit', ['SequenceAnomalyFrameVec',output_txt,'.pdf']);
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
    
    dimdata = size(data.collectresults,4);
    x = pos(1);
    y = pos(2);
    output_txt = ['(',num2str(pos(1)),',' num2str(pos(2)),')'];
  
    origx = x;
    ind = (data.dias == x);
    indx = 1 : length(data.dias);
    frame = indx(ind);
    
    
    
    % Setup initial figure
    x = data.x;
    y = data.y;
    figanomalyrgb= figure(1);
    image(uint8(255*data.colorslides{frame}));
    title(['RGB Map frame number ', num2str(frame), '; day ', num2str(data.dias(frame))],'Interpreter','latex','FontSize',18);
    line([x-1 x+1 x+1 x-1 x-1],[y-1 y-1 y+1 y+1 y-1],'linewidth',3);
    axis off
    axis square
    
    % Modify figure
    x0=0;
    y0=0;
    width= 700;
    height=700;
    set(figanomalyrgb,'units','points','position',[x0,y0,width,height]) 
    
    if data.graphics.print == true
          print(gcf, '-dpdf', '-bestfit', ['RGBImageFrameVec',num2str(origx),'.pdf']);
    end
    
    % Enable data cursor mode
     datacursormode on
     dcm_obj_rgb = datacursormode(figanomalyrgb);
    % Set update function
     set(dcm_obj_rgb,'UpdateFcn',{@myupdatefcn,data})
    
    
    % Load initial set of anomaly maps
    figanomaly = figure(2);
    imagebandanomalyforGUI(squeeze(data.collectresults(:,:,frame,:)),dimdata,data.dias); 

    % Modify figure
    x0=0;
    y0=1000;
    width= 2800;
    height=400;
    set(figanomaly,'units','points','position',[x0,y0,width,height])
    
    % Enable data cursor mode
    datacursormode on
    dcm_obj_inner = datacursormode(figanomaly);
    % Set update function
    set(dcm_obj_inner,'UpdateFcn',{@myupdatefcn,data})
    
    


    
    
end
    


