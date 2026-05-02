% Anomaly detection for all the 6 bands of GIS data (Sentinel or Landsat)

%% Methods

% Landsat and Sentinel data
methods.initialization = @initlandsatsentinelVecALL;
methods.processdata = @processdatafullLandsatSentinelVec;


% Other methods
methods.domaindata = @domaindataVec;
methods.KLeigenspace = @landsateigenVec;
methods.KLmultilevel = @multilevelHB;
methods.MLtest = @nulltesttransform;
methods.MLtransform = @mltransform;
methods.KLMLplot = @plotHBlandsatVec;
methods.statsprocess = @statsprocess;
methods.hypothesistests = @hypothesistests;
methods.LandsatProcessAllData = @LandsatProcessAllDataVec;
methods.MLinvtransform = @invmultilevelHBVec;
%% Modules


% Initialize parameters
parameters = methods.initialization();

% Process all the test data
[parameters,data] = methods.LandsatProcessAllData(parameters,methods);

% Save the results
Output = data.landsat.Output;
save('../data/Combined/Vectorial-SentinelProcessed.mat','Output','parameters','-v7.3')

