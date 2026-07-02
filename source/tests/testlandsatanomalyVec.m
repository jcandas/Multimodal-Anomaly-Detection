% Anomaly detection for GIS data
% Use vectorial observations from Sentinel

%% Methods

% Landsat and Sentinel data
methods.initialization = @initlandsatsentinelVec;
methods.processdata = @processdatafullLandsatSentinelVec;

% Other methods
methods.domaindata = @domaindataVec;
methods.KLeigenspace = @spatialeigenVec;
methods.KLmultilevel = @multilevelHB;
methods.MLtest = @nulltesttransform;
methods.MLtransform = @mltransform;

methods.KLMLplot = @plotHBlandsatVec;

methods.statsprocess = @statsprocess;
methods.hypothesistests = @hypothesistests;


%% Modules

% Initialize parameters
parameters = methods.initialization();

% Load and clean data
[data,parameters] = methods.processdata(methods,parameters);

% Construct domain of test slice
[parameters,data] = methods.domaindata(methods,parameters,data);

% Build KL eigenspace 
parameters = methods.KLeigenspace(methods,parameters,data);

% Create Multilevel Basis
parameters = methods.KLmultilevel(parameters,methods);

% Transfrom input to ML
parameters = methods.MLtransform(parameters);

% Process statistics
parameters = methods.statsprocess(methods,parameters,data);

% Plot transform
parameters = methods.KLMLplot(parameters,data);