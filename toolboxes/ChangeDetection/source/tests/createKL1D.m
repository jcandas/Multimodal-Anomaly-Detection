% Example of change detection of 1D problem using the multilevel nested functional
% space approach.

%% Methods
methods.initialization = @initKL1D;
methods.KLeigenspace = @KL1D;
methods.KLRealization = @KL1Dcreate;
%methods.KLRealization = @KL1Dcreategauss;

%% Initialize parameters
parameters = methods.initialization();

% Create Eigenvectors of Weiner process on a sphere
% spherical harmonics
parameters = methods.KLeigenspace(parameters);
parameters = methods.KLRealization(parameters);