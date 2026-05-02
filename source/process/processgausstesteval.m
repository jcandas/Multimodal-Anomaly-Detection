function [parameters,data] = processgausstesteval(methods,parameters,data);

% Extra domain of the test data

% Form domain of test slice
rawdata = data.landsat.rawdata;

load(parameters.data.test_file)
testslice = imgs(:,:,1);

% Color of testslide
rescaled_img = rescale(testslice, 0, 1);
testsliceR = rescaled_img;
testsliceG = zeros(size(testslice));
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

% Store test images and gaussians
data.test_imgs = imgs;
data.test_gauss = gauss_all;
data.gauss_height = gauss_heights;

% Build table to store results in
maxlevel = parameters.ML.plot.maxlevel;

len = size(imgs,3);
idx = zeros(len,1);
gauss_height = zeros(len,1);

T = table(idx,gauss_height);

for level = 0 : maxlevel
    T.("detect_"+level) = zeros(len,1);
    T.("local_"+level) = zeros(len,1);
end

parameters.test.table = T;