% Anomaly detection for EVI GIS data

%% Methods

% Initialize data
% methods.initialization = @initlandsat2;
% methods.processdata = @processdatafull;

% Landsat and Sentinel data
methods.initialization = @initlandsatsentinelALL;
methods.processdata = @processdatafullLandsatSentinel;


% Other methods
methods.domaindata = @domaindata;
methods.KLeigenspace = @landsateigen;
methods.KLmultilevel = @multilevelHB;
methods.MLtest = @nulltesttransform;
methods.MLtransform = @mltransform;
methods.KLMLplot = @plotHBlandsat;
methods.statsprocess = @statsprocess;
methods.hypothesistests = @hypothesistests;
methods.LandsatProcessAllData = @LandsatProcessAllData;
methods.MLinvtransform = @invmultilevelHB;
%% Modules

% Initialize parameters
parameters = methods.initialization();

% Process all the test data
[parameters,data] = methods.LandsatProcessAllData(parameters,methods);
A = data.landsat.rawdata(:,:,parameters.data.maxtime + 1 : end, parameters.data.modality);
Output = data.landsat.Output;
Output.rawdata = A;

% Save data
save('../data/Combined/JointProcessed.mat','Output','parameters','-v7.3')


