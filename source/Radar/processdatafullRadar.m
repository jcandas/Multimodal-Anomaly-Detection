function [data,parameters] = processdatafullRadar(methods,parameters,data)


% Join radar data with EVI

% Load variable
patchsize = parameters.data.patchsize;
patchsizeI = parameters.data.patchsizeI;
patchsizeJ = parameters.data.patchsizeJ;
modality  = parameters.data.modality;
ts = data.landsat.rawdata;
maxday = parameters.data.maxday;

% Load Radar data
load(parameters.data.radarfile)

% Nearest distance in time (days)
% Set to one day appart at most
rangeday = parameters.radar.rangeday;

%% Search for nearest  
dias = data.landsat.dias;
diasradar = squeeze(radaroutput(1,1,:,2));
nearest = rangesearch(dias,diasradar,rangeday);
indsearch = find(~cellfun(@isempty, nearest));
indOneDay = (cellfun(@nnz, nearest) == 1); 
indGreatDay = (cellfun(@nnz, nearest) > 1); 

diasradarMod = diasradar;
diasradarMod(indOneDay) = dias(cell2mat(nearest(indOneDay)));

% Extract patch
radaroutput = radaroutput(patchsizeI,patchsizeJ,:,:);


[jointdays,indJDRadar,indJDOptical] = intersect(diasradarMod,dias);

% For joint days observations merge both datasets
opticalJointData = ts(:,:,indJDOptical,:);
radarJointData = radaroutput(:,:,indJDRadar,3:4);
JointData = cat(4,opticalJointData,radarJointData);

% Pad with Nan's non-joint data for Optical and Radar
% Optical
numMod = size(JointData,4);
NonJOPtical = ts;
NonJOPtical(:,:,indJDOptical,:) = [];
NonJOPticaldias = dias;
NonJOPticaldias(indJDOptical) = [];
NanBlock = nan(size(NonJOPtical,1), size(NonJOPtical,2), size(NonJOPtical,3),...
    size(radarJointData,4)); 
NonJOPtical = cat(4,NonJOPtical,NanBlock);

% Radar
NonJRadar = radaroutput(:,:,:,3:4);
NonJRadar(:,:,indJDRadar,:) = [];
NonJRadardias = diasradar;
NonJRadardias(indJDRadar) = [];

NanBlock = nan(size(NonJRadar,1), size(NonJRadar,2), size(NonJRadar,3),...
    size(opticalJointData,4)); 
NonJRadar = cat(4,NanBlock,NonJRadar);

% Join the data
ts = cat(3,JointData, NonJOPtical);
ts = cat(3, ts, NonJRadar);

% Sort days 
totaldays = [jointdays; NonJOPticaldias; NonJRadardias];
[dias,Ind] = sort(totaldays);

% Put everything together
ts = ts(:,:,Ind,:);

% Find the maximum time slice 
a = (dias >= maxday);
maxtime = min(find(a));

% Data All Bands
datos = ts(:,:,1 : maxtime, modality : end);
datos = permute(datos,[1 2 4 3]);
%reshapedataAll = reshape(datos,[size(datos,1) * size(datos,2) size(datos,3)]);
reshapedata = reshape(datos,[size(datos,1) * size(datos,2) * size(datos,3), size(datos,4)]);
reshapedata = datos;

% Store Data
data.landsat.reshapedata = reshapedata;
data.landsat.rawdata = ts;
data.landsat.dias = dias;
parameters.data.dias = dias;
parameters.data.maxtime = maxtime;





