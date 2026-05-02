% Anomaly detection for GIS data
% Use vectorial observations from Sentinel

%% Methods

% Landsat and Sentinel data
% methods.initialization = @initlandsatsentinelVec;
methods.initialization = @initlandsatsentinelVec2;
% methods.processdata = @processdatafullLandsatSentinelVec;
methods.processdata = @processdatafullLandsatSentinelVecfillnan;

% Other methods
methods.domaindata = @domaindataVec;
% methods.KLeigenspace = @landsateigenVec;
methods.KLeigenspace = @spatialeigenVec;
% methods.KLmultilevel = @multilevelHB;
methods.KLmultilevel = @multilevelHB2;
methods.MLtest = @nulltesttransform;
methods.MLtransform = @mltransform;

% methods.KLMLplot = @plotHBlandsatVec;
methods.KLMLplot = @plotHBlandsatVecResid;

% methods.statsprocess = @statsprocess;
% methods.hypothesistests = @hypothesistests;

methods.statsprocess = @statsprocessprojnest;
methods.hypothesistests = @hypothesistestsprojnest;


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