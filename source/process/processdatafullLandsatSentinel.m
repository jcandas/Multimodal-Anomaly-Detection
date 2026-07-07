function [data,parameters] = processdatafullLandsatSentinel(methods,parameters)

% Process and load data
maxday = parameters.data.maxday;
modality = parameters.data.modality;
patchsize = parameters.data.patchsize;
patchsizeI = parameters.data.patchsizeI;
patchsizeJ = parameters.data.patchsizeJ;

% Load data
load(parameters.data.file);

% Set missing data to Nan
ts(ts == -9999) = nan;

% Set data type
if parameters.data.type == 0 % Landsat only
    landsatonly = (typedata == 0);
    ts = ts(:,:,landsatonly,:);
    dias = dias(landsatonly);
elseif parameters.data.type == 1 % Sentinel only
    sentinelonly = (typedata == 1);
    ts = ts(:,:,sentinelonly,:);
    dias = dias(sentinelonly);
end
% If none of the two then both
% Add dias to the first data sample

[a,b,c] = size(ts(:,:,:,1));
A = dias * ones(1, a*b);
A = A';
A = reshape(A,[a*b c]);
A = reshape(A, [a b c]);
ts = cat(4,A,ts);
clear A;

% Filter EVI
tsfilter = ts;
tsfilter(tsfilter>parameters.data.maxfilter) = nan;
tsfilter(tsfilter<parameters.data.minfilter) = nan;
ts(:,:,:,modality) = tsfilter(:,:,:,modality);

% Select m x m patch
%ts = ts(patchsize,patchsize,:,:);
ts = ts(patchsizeI,patchsizeJ,:,:);


% Find the maximum time slice 
a = (dias >= maxday);
maxtime = min(find(a));

% Data EVI
% datos = squeeze(ts(:,:, timedata,modality));
datos = squeeze(ts(:,:,1 : maxtime, modality));

datos = fillnan3d(datos,3);

reshapedata = reshape(datos,[size(datos,1) * size(datos,2) size(datos,3)]);

% Store Data
data.landsat.reshapedata = reshapedata;
data.landsat.rawdata = ts;
data.landsat.dias = dias;
parameters.data.dias = dias;
parameters.data.maxtime = maxtime;