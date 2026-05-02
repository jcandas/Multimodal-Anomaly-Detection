% Extend GIS data to fill in missing days
% Apply kriging method

% Define methods
methods.GIS.extend = @extendkrigingcategory;
methods.GIS.kriging = @krigingpixel;

% Define parameters
parameters.GIS.landsat.file.data.path = '../data/LandSat/2017';
parameters.GIS.landsat.maxday = 366;


% kriging parameters
parameters.kriging.regmodel  = @regpoly0;
parameters.kriging.corrmodel = @correxp;
parameters.kriging.theta = 10;
parameters.kriging.lub = 0.001;
parameters.kriging.upb = 100;

% Perform
parameters = methods.GIS.extend(parameters,methods);




