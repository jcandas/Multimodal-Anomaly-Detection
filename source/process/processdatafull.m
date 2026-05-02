function [data,parameters] = processdatafull(methods,parameters)

% Process and load data
maxtime = parameters.data.maxtime;
modality = parameters.data.modality;


% Load data
load(parameters.data.file);

% Set missing data to Nan
ts(ts == -9999) = nan;

% Filter EVI
tsfilter = ts;
tsfilter(tsfilter>parameters.data.maxfilter) = nan;
tsfilter(tsfilter<parameters.data.minfilter) = nan;
ts(:,:,:,modality) = tsfilter(:,:,:,modality);

% Data EVI
%datos = squeeze(ts(:,:, timedata,modality));
datos = squeeze(ts(:,:,1 : maxtime, modality));
reshapedata = reshape(datos,[size(datos,1) * size(datos,2) size(datos,3)]);

% Store Data
data.landsat.reshapedata = reshapedata;
data.landsat.rawdata = ts;