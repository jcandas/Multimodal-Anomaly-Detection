function [data,parameters] = processdata(methods,parameters)

% Process and load data
maxtime = parameters.data.maxtime;
removedata1 = parameters.data.removedata1;
removedata2 = parameters.data.removedata2;
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

if maxtime < removedata1
    timedata = [1:maxtime];
elseif maxtime >= removedata1 & maxtime <= removedata2
    timedata = [1:(removedata1 -1), (removedata1 + 1) : maxtime];
elseif maxtime > removedata2
    timedata = [1:(removedata1 -1), (removedata1 + 1) : (removedata2 - 1), ...
        (removedata2 + 1)   :   maxtime];
end

% Data EVI
datos = squeeze(ts(:,:, timedata,modality));
%datos = squeeze(ts(:,:,:,modality));
reshapedata = reshape(datos,[size(datos,1) * size(datos,2) size(datos,3)]);

% Store Data
data.landsat.reshapedata = reshapedata;
data.landsat.rawdata = ts;