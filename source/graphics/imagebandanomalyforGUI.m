function imagebandanomalyforGUI(anomaly,dimdata,dias); 

for k = 1 : dimdata
      
    subplot_tight(1,dimdata, k, [0.04 0]);  
    imagesc(anomaly(:,:,k));
    c = colorbar;
    %caxis([0 1]);
    axis off
    axis square    
    title(['Anomaly reconstruction Band ',num2str(k)]);
   
end


