function [data,parameters] = processdatafullLandsatSentinelVecfillnan(methods,parameters)

% Process and load data
maxday = parameters.data.maxday;
modality = parameters.data.modality;
%patchsize = parameters.data.patchsize;
patchsizeI = parameters.data.patchsizeI;
patchsizeJ = parameters.data.patchsizeJ;

% Load data for imaging
load(parameters.data.imagedata);
ts(ts == -9999) = nan;
ts(ts == 0) = nan;

% Set data type
if parameters.data.type == 0 % Landsat only
    landsatonly = (typedata == 0);
    ts = ts(:,:,landsatonly,:);
elseif parameters.data.type == 1 % Sentinel only
    sentinelonly = (typedata == 1);
    ts = ts(:,:,sentinelonly,:);
end
data.landsat.imagedata = ts(patchsizeI,patchsizeJ,:,1:3);

% Load data
load(parameters.data.file);

% Set missing data to Nan
ts(ts == -9999) = nan;
ts(ts == 0) = nan;


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

%[a,b,c] = size(ts(:,:,:,1));
%A = dias * ones(1, a*b);
%A = A';
%A = reshape(A,[a*b c]);
%A = reshape(A, [a b c]);
%ts = cat(4,A,ts);
%clear A;

% Filter all the data from EVI
tsfilter = ts(:,:,:,modality);
tsfilter(tsfilter>parameters.data.maxfilter) = nan;
tsfilter(tsfilter<parameters.data.minfilter) = nan;
nanindex = isnan(tsfilter);
nanindex = repmat(nanindex,[1 1 1 modality - 1]);
ts = ts(:,:,:, 1 : modality -1);
ts(nanindex) = nan;

% Select m x m patch
ts = ts(patchsizeI,patchsizeJ,:,:);

% Find the maximum time slice 
a = (dias >= maxday);
maxtime = min(find(a));

% Data All Bands
datos = ts(:,:,1 : maxtime, 1 : modality - 1);
datos = permute(datos,[1 2 4 3]);

datos = fillnan4d(datos,3);

%reshapedataAll = reshape(datos,[size(datos,1) * size(datos,2) size(datos,3)]);
%reshapedata = reshape(datos,[size(datos,1) * size(datos,2) * size(datos,3), size(datos,4)]);
reshapedata = datos;

% Store Data
data.landsat.reshapedata = reshapedata;
data.landsat.rawdata = ts;
data.landsat.dias = dias;
parameters.data.dias = dias;
parameters.data.maxtime = maxtime;
