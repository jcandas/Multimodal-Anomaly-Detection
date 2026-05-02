function [parameters,data] = domaindata(methods,parameters,data);

% Extra domain of the test data

% Form domain of test slice
modality = parameters.data.modality;
rawdata = data.landsat.rawdata;
testslice = squeeze(rawdata(:,:, parameters.data.testdata,modality));

% Color of testslide
testsliceR = squeeze(rawdata(:,:, parameters.data.testdata,4)) / 1300;
testsliceG = squeeze(rawdata(:,:, parameters.data.testdata,3)) / 1300;
testsliceB = squeeze(rawdata(:,:, parameters.data.testdata,2)) / 1300;

testsliceR(testsliceR > 1) = nan;
testsliceG(testsliceG > 1) = nan;
testsliceB(testsliceB > 1) = nan;

testsliceColor(:,:,1) = testsliceR;
testsliceColor(:,:,2) = testsliceG;
testsliceColor(:,:,3) = testsliceB;


% Color of last training slide
maxtimesliceR = squeeze(rawdata(:,:, parameters.data.maxtime,4)) / 1300;
maxtimesliceG = squeeze(rawdata(:,:, parameters.data.maxtime,3)) / 1300;
maxtimesliceB = squeeze(rawdata(:,:, parameters.data.maxtime,2)) / 1300;

maxtimesliceR(maxtimesliceR > 1) = nan;
maxtimesliceG(maxtimesliceG > 1) = nan;
maxtimesliceB(maxtimesliceB > 1) = nan;

maxtimesliceColor(:,:,1) = maxtimesliceR;
maxtimesliceColor(:,:,2) = maxtimesliceG;
maxtimesliceColor(:,:,3) = maxtimesliceB;

% reshapetestslice = reshape(testslice,[size(testslice,1) * size(testslice,2) size(testslice,3)]);

% Remove coordinate data (check, still not working)
datamask = ~isnan(data.landsat.rawdata(:,:, 1 : parameters.data.maxtime, modality));
datamask = sum(datamask,3);
datamask = (datamask == 0);
%datamask = double(datamask);
%datamask(datamask == 1) = nan;

% Remove coordinates where no training data exists
% testslice = testslice + datamask;
testslice(datamask == 1) = nan;

% Coordinates with data
[I,J] = find(~isnan(testslice));
valpos = find(~isnan(testslice(:)));

% Form coordinated for ML transform
data.landsat.coords = [I J];
data.landsat.val = testslice(valpos);

% Store data
data.landsat.rawtestslice = testslice;

% RGB
% testslice = squeeze(rawdata(:,:, parameters.data.testdata,modality));
data.landsat.testslicecolor = testsliceColor;
data.landsat.maxtimeslicecolor = maxtimesliceColor;


% Store position of data
data.landsat.pos = valpos;

% Store copy in parameters to be used for building multilevel basis
parameters.KL.coord = data.landsat.coords;
parameters.ML.input = data.landsat.val;