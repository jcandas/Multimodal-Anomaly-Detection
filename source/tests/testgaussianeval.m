% Anomaly detection for GIS data

%% Methods

% Data for synthetic gaussian test
methods.initialization = @initgaussiantesteval;
methods.processdata = @processdatagaussfillnan;


% Other methods
methods.processtest = @processgausstesteval;
methods.domaindata = @domaindatagausseval;
methods.KLeigenspace = @spatialeigeneval;
methods.KLmultilevel = @multilevelHB2;
methods.MLtest = @nulltesttransform;
methods.MLtransform = @mltransform;
methods.KLMLplot = @plotgaussianResid;

methods.statsprocess = @statsprocessprojnest;
methods.hypothesistests = @hypothesistestsprojnest;

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

for i = 5799:5800
    % Construct domain of test slice
    [parameters,data] = methods.domaindata(methods,parameters,data,i);
    
    % Transfrom input to ML
    parameters = methods.MLtransform(parameters);
    
    % Process statistics
    parameters = methods.statsprocess(methods,parameters,data);
    
    % Evaluate Gaussian tests
    parameters = methods.eval(parameters,data);
end

writetable(parameters.test.table,"../data/gaussian_test/data100_L0.25_Lp0.25_heights0.0004-0.002_M85_level6.csv")