function [parameters,data] = domaindatagauss(methods,parameters,data);

% Extra domain of the test data

% Form domain of test slice
rawdata = data.landsat.rawdata;

load(parameters.data.test_file)

img = imgs(:,:,5800);
gauss = gauss_all(:,:,5800);

testslice = img;

% Color of testslide
rescaled_img = rescale(img, 0, 1);
testsliceR = rescaled_img;
testsliceG = zeros(size(img));
testsliceB = 1 - rescaled_img;

testsliceColor(:,:,1) = testsliceR;
testsliceColor(:,:,2) = testsliceG;
testsliceColor(:,:,3) = testsliceB;


% Color of last training slide
rescaled_img = rescale(rawdata(:,:,parameters.data.maxtime), 0, 1);
maxtimesliceR = rescaled_img;
maxtimesliceG = zeros(size(rescaled_img));
maxtimesliceB = 1 - rescaled_img;

maxtimesliceColor(:,:,1) = maxtimesliceR;
maxtimesliceColor(:,:,2) = maxtimesliceG;
maxtimesliceColor(:,:,3) = maxtimesliceB;

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
parameters.ML.plot.gauss = gauss;