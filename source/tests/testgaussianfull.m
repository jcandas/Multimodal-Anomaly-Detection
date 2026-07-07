% Anomaly detection for GIS data

%% Methods

% Data for synthetic gaussian test
methods.initialization = @initgaussiantestfull;
methods.processdata = @processdatagauss;


% Other methods
methods.processtest = @processgausstestfull;
methods.KLeigenspace = @spatialeigen;
methods.KLmultilevel = @multilevelHB;

methods.testloop = @gaussiantestloop;

methods.domaindata = @domaindatagaussfull;
methods.MLtest = @nulltesttransform;
methods.MLtransform = @mltransform;
methods.statsprocess = @statsprocess;
methods.hypothesistests = @hypothesistests;
methods.eval = @evalgaussian;


%% Modules

% Initialize parameters
parameters = methods.initialization();

% Load and clean data
[data, parameters] = methods.processdata(methods,parameters);

% Construct domain of test slice
[parameters,data] = methods.processtest(methods,parameters,data);

% Build KL eigenspace 
parameters = methods.KLeigenspace(methods,parameters,data);

% Create Multilevel Basis
parameters = methods.KLmultilevel(parameters,methods);

% Run test loop over test set
parameters = methods.testloop(methods,parameters,data);