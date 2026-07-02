% Anomaly detection for GIS data

%% Methods

% Landsat only from initial dataset
% methods.initialization = @initlandsat;
% methods.processdata = @processdata;

% Landsat and Sentinel data
methods.initialization = @initlandsatsentinel;
methods.processdata = @processdatafullLandsatSentinel;


% Other methods
methods.domaindata = @domaindata;
methods.KLeigenspace = @spatialeigen;
methods.KLmultilevel = @multilevelHB;
methods.MLtest = @nulltesttransform;
methods.MLtransform = @mltransform;
methods.KLMLplot = @plotHBlandsat;

methods.statsprocess = @statsprocess;
methods.hypothesistests = @hypothesistests;
%methods.snapshots = @missingsnapshots;



%% Modules

% Initialize parameters
parameters = methods.initialization();

% Load and clean data
[data, parameters] = methods.processdata(methods,parameters);

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
