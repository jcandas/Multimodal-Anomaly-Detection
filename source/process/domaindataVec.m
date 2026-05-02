function [parameters,data] = domaindataVec(methods,parameters,data);

% Extra domain of the test data

% Form domain of test slice
modality = parameters.data.modality;
rawdata = data.landsat.rawdata;
imagedata = data.landsat.imagedata;

testslice = squeeze(rawdata(:,:, parameters.data.testdata, 1 : modality - 1));
%testslice = squeeze(imagedata(:,:, parameters.data.testdata, 1 : 3));

% Color of testslide
testsliceR = squeeze(imagedata(:,:, parameters.data.testdata,3)) / 1300;
testsliceG = squeeze(imagedata(:,:, parameters.data.testdata,2)) / 1300;
testsliceB = squeeze(imagedata(:,:, parameters.data.testdata,1)) / 1300;

testsliceR(testsliceR > 1) = nan;
testsliceG(testsliceG > 1) = nan;
testsliceB(testsliceB > 1) = nan;

testsliceColor(:,:,1) = testsliceR;
testsliceColor(:,:,2) = testsliceG;
testsliceColor(:,:,3) = testsliceB;


% Color of last training slide
maxtimesliceR = squeeze(imagedata(:,:, parameters.data.maxtime,3)) / 1300;
maxtimesliceG = squeeze(imagedata(:,:, parameters.data.maxtime,2)) / 1300;
maxtimesliceB = squeeze(imagedata(:,:, parameters.data.maxtime,1)) / 1300;

maxtimesliceR(maxtimesliceR > 1) = nan;
maxtimesliceG(maxtimesliceG > 1) = nan;
maxtimesliceB(maxtimesliceB > 1) = nan;

maxtimesliceColor(:,:,1) = maxtimesliceR;
maxtimesliceColor(:,:,2) = maxtimesliceG;
maxtimesliceColor(:,:,3) = maxtimesliceB;

% reshapetestslice = reshape(testslice,[size(testslice,1) * size(testslice,2) size(testslice,3)]);

% Remove coordinate data (check, still not working)
datamask = ~isnan(data.landsat.rawdata(:,:, 1 : parameters.data.maxtime, 1 : modality - 1));
datamask = sum(datamask,3);
datamask = (datamask == 0);
datamask = squeeze(datamask);

testslice(datamask == 1) = nan;


% Coordinates with data
indextestslice = sum(testslice,3);
[I,J] = find(~isnan(indextestslice));
%[In, Jn, Kn] = find(~isnan(testslice));
reshapedtestslice = reshape(testslice, [size(testslice,1) * size(testslice,2) size(testslice,3)]);
val = reshapedtestslice(I + (J-1)* size(testslice,1),:);
% valpos = reshape(valpos,[length(I) size(testslice,2)] );


% Covariance
covariancedata = reshape(data.landsat.reshapedata, [size(data.landsat.reshapedata,1) * ...
    size(data.landsat.reshapedata,2) size(data.landsat.reshapedata,3) size(data.landsat.reshapedata,4)] );
covariancedata = covariancedata(I + (J-1)* size(data.landsat.reshapedata,1),:,:);
data.landsat.covariance = reshape(covariancedata, [size(covariancedata,1) * ...
    size(covariancedata,2) size(covariancedata,3)]);


% Form coordinated for ML transform
data.landsat.coords = [I J];
data.landsat.val = val;


% Store data
data.landsat.rawtestslice = testslice;

% RGB
data.landsat.testslicecolor = testsliceColor;
data.landsat.maxtimeslicecolor = maxtimesliceColor;


% Store copy in parameters to be used for building multilevel basis
parameters.KL.coord = data.landsat.coords;
parameters.ML.input = data.landsat.val;


