% Convert Sentinel into Landsat form for the first 3 bands.
% Analyze satellite data. Convert sentinel into landsat
% Create EVI for both sentinel and landsat

% Load data, only do once
load('reduced_Landsat_Sentinel2.mat')

close all;
parameters.graphics.print = true;

% Filter out missing data
outputnew(outputnew == 0) = nan;
% outputnew(outputnew(:,:,:,1:3) > 1400) = nan;
% Analyze and recalibrate landsat to sentinel data

% Find non missing data for both
landsat = days(type == 0);
sent   = days(type == 1);
joint = intersect(landsat,sent);


firstdata = (days == joint(2));
ind = find(firstdata);
typeind = type(ind);

landsatpos = ind(typeind == 0);
sentpos    = ind(typeind == 1);


%% Image Landsat and Sentinel
testsliceColorLandsat = imagesatdata(outputnew,landsatpos);
testsliceColorSent = imagesatdata(outputnew,sentpos);

figure;
subplot_tight(1,2,1,[0.04 0]);
imagesc(testsliceColorLandsat);
title('LandSat');
axis off
subplot_tight(1,2,2,[0.04 0]);
imagesc(testsliceColorSent);
title('Sentinel');
axis off


% Calculate EVI
%EVI = 2.5 * (outputnew(:,:,:,4) - outputnew(:,:,:,3)) ./ ...
%(outputnew(:,:,:,4) + 6.0 * outputnew(:,:,:,3) - 7.5 * outputnew(:,:,:,1) + 1.0);
%outputnew(:,:,:,5) = EVI;


%% Process each band
recalibrateddata = outputnew;
for band = 1 : 4
    estimate  = bandprocessconvert(outputnew,type,band,sentpos,landsatpos);
    recalibrateddata(:,:,:,band) = estimate;
end
clear estimate


% EVI = 2.5 * (b4 - b3) / (b4 + 6.0 * b3 - 7.5 * b1 + 1.0)
EVI = 2.5 * (recalibrateddata(:,:,:,4) - recalibrateddata(:,:,:,3)) ./ ...
(recalibrateddata(:,:,:,4) + 6.0 * recalibrateddata(:,:,:,3) - 7.5 * recalibrateddata(:,:,:,1) + 1.0);

% Print out converted data 
% clear outputnew

recalibrateddata = recalibrateddata(:,:,:,1:4);
%%
k = ind(2);
for k = 136 : 145
    %if type(k) == 1
    figure
    subplot_tight(1,2,1,[0.1 0.02]);
    redestimate = recalibrateddata(:,:,k,3);
    greenestimate = recalibrateddata(:,:,k,2);
    blueestimate = recalibrateddata(:,:,k,1);
    
    testsliceR = redestimate / 1300;
    testsliceG = greenestimate / 1300;
    testsliceB = blueestimate / 1300;

    testsliceR(testsliceR > 1) = nan;
    testsliceG(testsliceG > 1) = nan;
    testsliceB(testsliceB > 1) = nan;

    testsliceColor(:,:,1) = testsliceR;
    testsliceColor(:,:,2) = testsliceG;
    testsliceColor(:,:,3) = testsliceB;
    
    imagesc(testsliceColor);
    title(['Slice number = ', num2str(k),' Type = ', num2str(type(k))])
    axis off
    axis square
    colorbar
    
    subplot_tight(1,2,2,[0.1 0.02]);
    imagesc(EVI(:,:,k));
    axis off
    axis square
    colorbar
    caxis([0 4]);
    %end
end

%%
h = figure;
subplot_tight(2,2,1,[0.1 0.02]);
imagesc(EVI(:,:,ind(1))); 
colorbar
axis off
axis square
caxis([0 4])
title('LandSat EVI')
subplot_tight(2,2,2,[0.1 0.02]);
imagesc(EVI(:,:,ind(2)));
title('Sentinel');
colorbar
axis off
axis square
caxis([0 4])

subplot_tight(2,2,3,[0.1 0.02]);
histogram(EVI(:,:,ind(1)))
%colorbar
axis square
%caxis([0 4])
xlim([0 4])
title('LandSat EVI Histogram')


subplot_tight(2,2,4,[0.1 0.02]);
histogram(EVI(:,:,ind(2)))
title('Sentinel EVI Histogram');
%colorbar
axis square
%caxis([0 4])
xlim([0 4])


x0=0;
y0=0;
width=1400;
height=1400;
set(h,'units','points','position',[x0,y0,width,height]) 
if parameters.graphics.print == true
    set(gcf,'Units','inches');
    screenposition = get(gcf,'Position');
    set(gcf,...
   'PaperPosition',[0 0 screenposition(3:4)],...
   'PaperSize',[screenposition(3:4)]);
   print('-dpdf','-bestfit','-painters','EVI-Landsat-Sentinel');
end  



% Add EVI to data
% Add NANs to the first one
% recalibrateddata = cat(4,ones(size(EVI)),recalibrateddata);
recalibrateddata = cat(4,recalibrateddata,EVI);

%%
ts = recalibrateddata;
typedata = type;
dias = days;
save('../data/Combined/recalibratedData_Landsat_Sentinel2.mat','dias','typedata','ts','-v7.3');

%ts = cat(4,outputnew,EVI);
%typedata = type;
%dias = days;
%save('../data/Combined/recalibratedData_Landsat_Sentinel2_full.mat','dias','typedata','ts','-v7.3');



% save('../data/Combined/EVI_.mat','days','type','EVI','-v7.3');







