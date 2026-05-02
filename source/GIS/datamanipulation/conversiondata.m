% Extend GIS data into days
% Apply kriging method per pixel

% Define methods
methods.GIS.extend = @extendkriging;
methods.GIS.kriging = @krigingpixel

ingpixel;

% Define parameters
parameters.GIS.landsat.file.data.load = 'rs_data.mat';
parameters.GIS.landsat.file.day  = 'days.mat';
parameters.GIS.landsat.file.data.save = 'rs_full.mat';

% kriging parameters
parameters.kriging.regmodel  = @regpoly0;
parameters.kriging.corrmodel = @correxp;
parameters.kriging.theta = 10;
parameters.kriging.lub = 0.001;
parameters.kriging.upb = 100;

% Perform
parameters = methods.GIS.extend(parameters,methods);




