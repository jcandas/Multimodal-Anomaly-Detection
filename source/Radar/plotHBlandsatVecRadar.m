function parameters = plotHBlandsatVecRadar(parameters,data)

% Upload variables

modality = parameters.data.modality;
dimdata = size(data.landsat.rawdata(:,:,:,modality:end),4);
multileveltree = parameters.ML.multilevetree;
dcoeffs=parameters.ML.Output.Dcoefficients;
ccoeffs=parameters.ML.Output.Ccoefficients;
coeffs=parameters.ML.Output.coefficients;
nodeindex = parameters.ML.Output.nodeindex;
leveltree = [multileveltree{:,5}]';
coord = parameters.KL.coord;
ind = parameters.ML.ind;
datacell = parameters.ML.datacell;
datalevel = parameters.ML.datalevel;
significancedcoeffs = parameters.stats.significancedcoeffs;
testsliceColor = uint8(255 * data.landsat.testslicecolor);
maxtimesliceColor = data.landsat.maxtimeslicecolor;
%testslicedata = squeeze(data.landsat.rawdata(:,:,parameters.data.testdata,modality : end));
testslicedata = data.landsat.rawtestslice;
dias = data.landsat.dias;


tol = parameters.ML.plot.tol;
numlevel = parameters.ML.plot.numlevel;
maxlevel = max(leveltree) - parameters.ML.plot.maxlevel;
numofpoints = size(coord,1);
maxbarslice = 4;
maxbaranomaly = 1.25;

% Visualization
colorscheme = [
    [1 0.5 0.2]
    [30 144 255]/255
    [143 188 143]/255	
 ];
colorindex = ['r';'c';'k';'g';'m';'y'];
dilation = 0.5;
markersize = 0.25;

fprintf("\n");
fprintf("----------------------------- \n");


% Plot RGB last training iamge vs current one -----------------------------

h = figure(1);
subplot_tight(1,2,1,[0.01 0]);
imagesc(maxtimesliceColor);
axis off
axis equal
title('Last training image');

subplot_tight(1,2,2,[0.01 0]);
imagesc(testsliceColor);
axis off
axis equal
title('Testing image');

if parameters.graphics.print == true
    set(gcf,'PaperPosition',[0 0 7 2]);
    print(gcf, '-dpdf', '-bestfit', 'RawImageSecond.pdf');
end



% Plot Anomaly Reconstructions for each band ------------------------------
h = figure(2);
zeroedccoeffs = zeros(size(ccoeffs));
reconstruction = squeeze(invhbtrans(dcoeffs, zeroedccoeffs, multileveltree, ind, ...
    datacell, datalevel, numofpoints, dimdata));

sizes = size(testslicedata);
anomaly = nan(sizes);
lengthimage = size(testsliceColor,1) * size(testsliceColor,2);
for k = 1 : dimdata;
    anomaly((coord(:,2) - 1)*sizes(1) + coord(:,1) + lengthimage * (k - 1)) = reconstruction(:,k);
    anomaly = abs(anomaly);
end

imagebandanomaly(parameters,data,anomaly,testslicedata,testsliceColor,dimdata,dias); 

figcounter = 1;
h = figure(3);
           
% Plot multilevel coefficients --------------------------------------------
for level = maxlevel : -1 : max(maxlevel - numlevel,0) 
    subplot_tight(1,maxlevel + 1,figcounter,[0.04 0]);
    %imagesc(data.landsat.rawtestslice);
    %imagescwithnan(data.landsat.rawtestslice, winter, [1 1 1])
    imagesc(testsliceColor);
    %caxis([0 maxbarslice])
    %colormap winter
    %shading interp
    axis square
    axis off
    axis vis3d
    hold on
    figcounter = figcounter + 1;
    totalval = 0;    
    for n = 1 : length(leveltree)
        if leveltree(n) == level       
            listI = nodeindex(n);
            listI = listI{1};
            val = (norm(dcoeffs{n}))^2;
            if val > tol
                selectcoord = coord(listI,:);
                theta = selectcoord(:,1);
                phi = selectcoord(:,2);
                plot(phi,theta,['.',colorindex(1 + mod(n,5))]);
                hold on;
                plot(mean(phi), mean(theta), '.b', 'MarkerSize', dilation * val);
                text(mean(phi) + markersize * val, mean(theta) - markersize * val,...
                    sprintf("%2.2f",val), 'FontSize', 18);
                if parameters.graphics.figtitle == true
                    title(['level = ',num2str(level)])
                end
            end
            totalval = totalval + val;
        end
    end
    
    relativeerror = sqrt(totalval) / norm(parameters.ML.Output.coefficients);
    fprintf("Total l2 Norm = %f, Relative l2 norm Error = %1.3f,  level = %d \n", sqrt(totalval),...
                relativeerror,level);
    %set(gcf,'PaperPosition',[0 0 7 2]);
    %print(gcf, '-dpdf', '-bestfit', ['ML-Coeff-',num2str(level),'.pdf']);
    %print(h,'-dpdf', '-bestfit','-r150',['ML-Coeff-',num2str(level),'.pdf']);
end


    x0=0;
    y0=0;
    width=2000;
    height=500;
    set(h,'units','points','position',[x0,y0,width,height])
    %set(gcf,'PaperPosition',[0 0 7 2]);
    %print(gcf, '-dpdf', 'CoeffLevels.pdf');

    if parameters.graphics.print == true
        set(gcf,'Units','inches');
        screenposition = get(gcf,'Position');
        set(gcf,...
        'PaperPosition',[0 0 screenposition(3:4)],...
        'PaperSize',[screenposition(3:4)]);
        print -dpdf -bestfit -painters CoeffLevels
    end

    hold off  
    
% Plot significance coefficients    
h = figure(4);
counter = 0;
plotcounter = 1;
for level = maxlevel : -1 : max(maxlevel - numlevel,0)     
    collectsignificance = [];
    for n = 1 : length(leveltree)
        if leveltree(n) == level       
            collectsignificance = [collectsignificance significancedcoeffs{n}];            
                
        end
    end
    %if min(min(collectsignificance)) < 1%parameters.stats.significance
        hs = stem([plotcounter : plotcounter + length(collectsignificance) - 1],...
            collectsignificance, '-o', 'LineWidth',1, ...
            'Color', colorscheme(1 + mod(counter,3),:)); %colorindex(1 + mod(counter,5)));
        hb = get(hs,'Baseline');
        set(hb,'Visible','off')
        set(gca,'yscal','log') 
        ylim([0.0001 1]);
        hold on;    
        counter = counter + 1;
    %end
    
    if parameters.graphics.figtitle == true
    text((2 * plotcounter + length(collectsignificance))/2, 0,'$W$','FontSize', 18);
    end                 
    
    plotcounter = plotcounter + length(collectsignificance);
        
    
    
    
end
xlim([0 plotcounter]);
hs = plot(1 : plotcounter, ones(plotcounter,1) * parameters.stats.significance,...
    '--','LineWidth',2);
set(gca,'yscal','log');

hold off;


if parameters.graphics.figtitle == true
    title('p-values per level')
end     


x0=0;
y0=0;
width=1400;
height=500;
set(h,'units','points','position',[x0,y0,width,height])


    if parameters.graphics.print == true
        set(gcf,'Units','inches');
        screenposition = get(gcf,'Position');
        set(gcf,...
        'PaperPosition',[0 0 screenposition(3:4)],...
        'PaperSize',[screenposition(3:4)]);
        print -dpdf -bestfit -painters Hypothesis
    end







%%


%print -dpdf -bestfit -r600 KLSH-MLCoeff.pdf




