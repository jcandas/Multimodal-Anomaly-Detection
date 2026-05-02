% Merge EVI Landsat/Sentinel data with radar

% Load data
parameters.data.file = '../data/Combined/recalibratedData_Landsat_Sentinel2.mat';
parameters.data.radarfile = '../data/Combined/Sentinel1Mod.mat';

load(parameters.data.file)
load(parameters.data.radarfile)

% Nearest distance in time (days)
% Set to one day appart at most
rangeday = 1;

%% Search for nearest  
diasradar = squeeze(radaroutput(1,1,:,2));
nearest = rangesearch(dias,diasradar,rangeday);
indsearch = find(~cellfun(@isempty, nearest));
indOneDay = (cellfun(@nnz, nearest) == 1); 
indGreatDay = (cellfun(@nnz, nearest) > 1); 

diasradarMod = diasradar;
diasradarMod(indOneDay) = dias(cell2mat(nearest(indOneDay)));


% [abs(diasradar-diasradarMod) diasradar diasradarMod indOneDay indGreatDay];