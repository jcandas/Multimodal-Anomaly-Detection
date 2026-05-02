function [data,parameters] = processdatagaussfillnan(methods,parameters)

% Process and load data
maxtime = parameters.data.maxtime;

% Load data
load(parameters.data.file);

% Data EVI
datos = squeeze(imgs(:,:,1:maxtime));

datos = fillnan3d(datos,3);

reshapedata = reshape(datos,[size(datos,1) * size(datos,2) size(datos,3)]);

% Store Data
data.landsat.reshapedata = reshapedata;
data.landsat.rawdata = imgs;