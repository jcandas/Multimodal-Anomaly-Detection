% Example of change detection of 1D problem using the multilevel nested functional
% space approach.

%% Methods
methods.initialization = @initKL2Dtrain;
methods.KLeigenspace = @KLprocess;
methods.KLRealization = @createKL2D;

%% Initialize parameters
parameters = methods.initialization();
parameters = methods.KLeigenspace(parameters);
parameters = methods.KLRealization(parameters);