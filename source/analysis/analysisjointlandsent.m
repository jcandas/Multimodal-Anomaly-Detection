% Analyze satellite data. Convert landsat into sentinel

% Load data, only do once
% load('reduced.mat')

close all;
parameters.graphics.print = false;

% Filter out missing data
outputnew(outputnew == 0) = nan;
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

%% Process each band
band = 1;
blueestimate  = bandprocess(outputnew,band,landsatpos,sentpos);
band = 2;
greenestimate  = bandprocess(outputnew,band,landsatpos,sentpos);
band = 3;
redestimate  = bandprocess(outputnew,band,landsatpos,sentpos);


testsliceR = redestimate / 1300;
testsliceG = greenestimate / 1300;
testsliceB = blueestimate / 1300;

testsliceR(testsliceR > 1) = nan;
testsliceG(testsliceG > 1) = nan;
testsliceB(testsliceB > 1) = nan;

testsliceColor(:,:,1) = testsliceR;
testsliceColor(:,:,2) = testsliceG;
testsliceColor(:,:,3) = testsliceB;


if parameters.graphics.print == true
    close all
end

h = figure;
name = 'ReCalibration';
parameters.graphics.h = h;
parameters.graphics.name = name;
subplot_tight(1,3,1,[0.04 0]);
imagesc(testsliceColorLandsat);
title('LandSat');
axis off
subplot_tight(1,3,3,[0.04 0]);
imagesc(testsliceColorSent);
title('Sentinel');
axis off
subplot_tight(1,3,2,[0.04 0]);
imagesc(testsliceColor);
title('Recalibrated Landsat');
axis off

displayoutput(parameters);






