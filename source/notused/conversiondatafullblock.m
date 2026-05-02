% Extend GIS data spatially and temporally

% Define methods
methods.GIS.extendtop = @extendkrigingfulltop;
methods.GIS.extend    = @extendkrigingfullblock;
methods.GIS.kriging   = @krigingfull;


% Define parameters
parameters.GIS.landsat.file.data.load = 'rs_data_red.mat';
parameters.GIS.landsat.file.day  = 'days_red.mat';
parameters.GIS.landsat.file.data.save = 'rs_full_kriging.mat';

% kriging parameters
parameters.kriging.regmodel  = @regpoly0;
parameters.kriging.corrmodel = @correxp;
parameters.kriging.theta = 10;
parameters.kriging.lub = 0.001;
parameters.kriging.upb = 100;
parameters.kriging.timeblock = 10;

% Perform
parameters = methods.GIS.extendtop(parameters,methods);

