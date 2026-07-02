% Anomaly detection for GIS data

%% Methods

% Data for synthetic gaussian test
methods.initialization = @initgaussiantest;
methods.processdata = @processdatagaussfillnan;


% Other methods
methods.domaindata = @domaindatagauss;
methods.KLeigenspace = @spatialeigen;
methods.KLmultilevel = @multilevelHB2;
methods.MLtest = @nulltesttransform;
methods.MLtransform = @mltransform;
methods.KLMLplot = @plotgaussianResid;

methods.statsprocess = @statsprocessprojnest;
methods.hypothesistests = @hypothesistestsprojnest;


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