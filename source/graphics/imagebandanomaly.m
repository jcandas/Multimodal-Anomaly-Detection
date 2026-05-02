function imagebandanomaly(parameters,data,anomaly,testslicedata,testsliceColor,dimdata,dias); 

for k = 1 : dimdata
  
    subplot_tight(dimdata,2, (k-1)*2 + 1, [0.04 0]);  
    imagesc(testslicedata(:,:,k));
    colormap winter
    if parameters.graphics.figtitle == true
        title(['Day ',num2str(dias(parameters.data.testdata))]);
    end
    axis off
    axis square
    colorbar
    maxslicedata = abs(testslicedata(:,:,k));
    maxslicedata = max(maxslicedata(:));
    
    subplot_tight(dimdata,2, (k-1)*2 + 2, [0.04 0]);  
    %imagesc(anomaly(:,:,k)/maxslicedata);
    imagesc(anomaly(:,:,k));
    c = colorbar;
    %caxis([0 1]);
    axis off
    axis square
    
    if parameters.graphics.figtitle == true
        title('Anomaly reconstruction');
    end
    
end


if parameters.graphics.print == true
    set(gcf,'Units','inches');
    screenposition = get(gcf,'Position');
    set(gcf,...
        'PaperPosition',[0 0 screenposition(3:4)],...
        'PaperSize',[screenposition(3:4)]);
    print(gcf, '-dpdf', '-bestfit', ['MB-OrigRecons-',num2str(dias(parameters.data.testdata)),'.pdf']);
end  

