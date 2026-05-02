% Anomaly detection for GIS data

%% Methods

% Data for synthetic gaussian test
methods.initialization = @initpcatesteval;
methods.processdata = @processdatagaussfillnan;


% Other methods
methods.processtest = @processpcatesteval;
methods.KLeigenspace = @spatialpcaeval;
methods.threshold = @pcathreshold;

methods.statsprocess = @statspca;

methods.eval = @evalpca;


%% Modules

% Initialize parameters
parameters = methods.initialization();

% Load and clean data
[data, parameters] = methods.processdata(methods,parameters);

% Construct domain of test slice
[parameters,data] = methods.processtest(methods,parameters,data);

% Build KL eigenspace 
parameters = methods.KLeigenspace(methods,parameters,data);

% Get test threshold
parameters = methods.threshold(parameters);
    
% Process statistics
parameters = methods.statsprocess(parameters,data);

% Evaluate Gaussian tests
parameters = methods.eval(parameters);