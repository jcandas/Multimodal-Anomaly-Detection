function parameters = plotHBlandsatResid(parameters,data)

% Upload variables
dimdata = parameters.ML.dimdata;
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
testsliceColor = data.landsat.testslicecolor;
maxtimesliceColor = data.landsat.maxtimeslicecolor;

if isfield(data.landsat,'dias') == true
    dias = data.landsat.dias;
else
    dias(parameters.data.testdata) = parameters.data.testdata;
end

tol = parameters.ML.plot.tol;
numlevel = parameters.ML.plot.numlevel;
maxlevel = max(leveltree) - parameters.ML.plot.maxlevel;
numofpoints = size(coord,1);

maxbarslice = parameters.graphics.maxbarslice;
maxbaranomaly = parameters.graphics.maxbaranomaly;
dilation = parameters.graphics.dilation;
markersize = parameters.graphics.markersize;
normvalrescale = parameters.graphics.normvalrescale;
rawimagestight = parameters.graphics.rawimagestight;
coeffstight = parameters.graphics.coeffstight;



% Visualization
colorscheme = [
    [1 0.5 0.2]
    [30 144 255]/255
    [143 188 143]/255	
 ];
colorindex = ['r';'c';'k';'g';'m';'y'];

fprintf("\n");
fprintf("----------------------------- \n");


h = figure(1);

%imagesc(data.landsat.rawtestslice);
%axis square
%axis off
%colormap winter
%colorbar
%caxis([0 maxbarslice]);

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


%x0=0;
%y0=800;
%width=700;
%height=350;
%set(h,'units','points','position',[x0,y0,width,height]) 

if parameters.graphics.print == true
    set(gcf,'PaperPosition',[0 0 7 2]);
    print(gcf, '-dpdf', '-bestfit', ['RawImageSecond',num2str(dias(parameters.data.testdata)),'.pdf']);
end


h = figure(2);
subplot_tight(1,3,1,[0.04 0]);
imagesc(data.landsat.rawtestslice);
colormap winter
if parameters.graphics.figtitle == true
    title(['Raw Data Slice, Day ',num2str(max(max(...
         data.landsat.rawdata(:,:,parameters.data.testdata,1))))]);
end
axis off
axis square
colorbar
caxis([0 maxbarslice]);
zeroedccoeffs = zeros(size(ccoeffs));
reconstruction = invhbtrans(dcoeffs, zeroedccoeffs, multileveltree, ...
    ind, datacell, datalevel, numofpoints, dimdata);
sizes = size(data.landsat.rawtestslice);
A = nan(sizes);
A((coord(:,2) - 1)*sizes(1) + coord(:,1)) = reconstruction;
A = abs(A);
%A(A < 0.2) = nan;
subplot_tight(1,3,2,[0.04 0]);
imagesc(A);
%imagescwithnan(A,winter,[1 1 1])
%colormap jet
c = colorbar;
caxis([0 maxbaranomaly]);
%c.Limits = [0 2];
%c.LimitsMode = 'manual';

axis off
axis square

% Display cursor mode
%dcm = datacursormode;
%dcm.Enable = 'on';
%dcm.DisplayStyle = 'window';



if parameters.graphics.figtitle == true
    title('Anomaly reconstruction');
end


subplot_tight(1,3,3,[0.04 0]);
imagesc(testsliceColor);
axis off
axis square
colorbar;


    %x0=0;
    %y0=800;
    %width=1100;
    %height=350;
    %set(h,'units','points','position',[x0,y0,width,height]) 
    if parameters.graphics.print == true
        set(gcf,'Units','inches');
        screenposition = get(gcf,'Position');
        set(gcf,...
        'PaperPosition',[0 0 screenposition(3:4)],...
        'PaperSize',[screenposition(3:4)]);
        print(gcf, '-dpdf', '-bestfit', ['SB-OrigRecons-',num2str(dias(parameters.data.testdata)),'.pdf']);
    end  
    
    
figcounter = 1;
h = figure(3);
% Plot multilevel coefficients --------------------------------------------
for level = maxlevel : -1 : max(maxlevel - numlevel,0) 
    subplot_tight(1,maxlevel + 1,figcounter,coeffstight);
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
            val = norm(dcoeffs{n});
            pval = significancedcoeffs{n};
            
                selectcoord = coord(listI,:);
                theta = selectcoord(:,1);
                phi = selectcoord(:,2);
          
                % Cell light transparent plot 
                if level > 0
                    D = [min(phi)-1 min(theta)-1; max(phi) min(theta)-1; max(phi) max(theta); min(phi)-1 max(theta)];
                    hgrid = fill(D(:,1), D(:,2), colorindex(1 + mod(n,5)),'LineStyle','none');
                    hgrid.FaceAlpha = 0.1;
                    hold on;
                end

                % Marker    
                cellgridplot=scatter(mean(phi), mean(theta),dilation * val,'MarkerFaceColor',[0.75 0.75 0.75],...
                    'MarkerEdgeColor',[0.75 0.75 0.75]);

                cellgridplot.MarkerFaceAlpha = .35;
                cellgridplot.MarkerEdgeAlpha = .35;
                
                % Text on each cell

                if pval < tol
                    %text(mean(phi), mean(theta), sprintf("%2.1f", val * normvalrescale),...
                    %    'horizontalalignment', 'center','FontSize', 20,'Interpreter','latex','Color',[1 1 0]);
                    %text(mean(phi), mean(theta) -1 -round(val), sprintf("%0.2f", pval * normvalrescale),...
                    %    'horizontalalignment', 'center','FontSize', 20,'Interpreter','latex','Color',[1 1 0
                    text(mean(phi), mean(theta), sprintf("%0.2f", pval * normvalrescale),...
                        'horizontalalignment', 'center','FontSize', 20,'Interpreter','latex','Color',[1 1 0]);
                end
                if parameters.graphics.figtitle == true
                    title(['$W_{',num2str(level),'}^{',num2str(dias(parameters.data.testdata)), '}$'], ...
                        'Interpreter','latex','FontSize',36)

                    %title(['\textbf{level = ',num2str(level),' Day ', num2str(dias(parameters.data.testdata)), '}'], ...
                    %    'Interpreter','latex','FontSize',24)
                end  %'Day ',num2str(dias(parameters.data.testdata))
            
            totalval = totalval + val^2;
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
    height=600;
    set(h,'units','points','position',[x0,y0,width,height])
    %set(gcf,'PaperPosition',[0 0 7 2]);
    %print(gcf, '-dpdf', 'CoeffLevels.pdf');

    if parameters.graphics.print == true
        set(gcf,'Units','inches');
        screenposition = get(gcf,'Position');
        set(gcf,...
        'PaperPosition',[0 0 screenposition(3:4)],...
        'PaperSize',[screenposition(3:4)]);
        print(gcf, '-dpdf', '-bestfit', ['SB-CoeffLevels-',num2str(dias(parameters.data.testdata)),'.pdf']);
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
        ylim([0.001 1]);
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

    title(['$p$-values per level (day ',num2str(dias(parameters.data.testdata)),')'],...
        'Interpreter', 'latex','FontSize',18);
end     


x0=0;
y0=0;
width=1400;
height=250;
set(h,'units','points','position',[x0,y0,width,height])


    if parameters.graphics.print == true
        set(gcf,'Units','inches');
        screenposition = get(gcf,'Position');
        set(gcf,...
        'PaperPosition',[0 0 screenposition(3:4)],...
        'PaperSize',[screenposition(3:4)]);
        print(gcf, '-dpdf', '-bestfit', ['SB-Hypothesis-',num2str(dias(parameters.data.testdata)),'.pdf']);
    end







%%


%print -dpdf -bestfit -r600 KLSH-MLCoeff.pdf




