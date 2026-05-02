load('landsat_ts_95_08.mat')

ts(ts == -9999) = nan;


sliced = 100;

testsliceR = squeeze(ts(:,:, sliced,4)) / 1300;
testsliceG = squeeze(ts(:,:, sliced,3)) / 1300;
testsliceB = squeeze(ts(:,:, sliced,2)) / 1300;
testsliceEvi = squeeze(ts(:,:, sliced,8));



testsliceR(testsliceR > 1) = nan;
testsliceG(testsliceG > 1) = nan;
testsliceB(testsliceB > 1) = nan;

testsliceColor(:,:,1) = testsliceR;
testsliceColor(:,:,2) = testsliceG;
testsliceColor(:,:,3) = testsliceB;


h = figure(1);
subplot(1,3,1);
imagesc(testsliceColor);
axis square
colorbar

subplot(1,3,2);
imagesc(testsliceEvi);
axis square
colorbar
caxis([0 5]);

subplot(1,3,3);
testsliceEvi(testsliceEvi>3) = nan;
testsliceEvi(testsliceEvi<0) = nan;
imagesc(testsliceEvi);
axis square
colorbar
caxis([0 5]);




x0=0;
y0=0;
width=2100;
height=700;
set(h,'units','points','position',[x0,y0,width,height]) 