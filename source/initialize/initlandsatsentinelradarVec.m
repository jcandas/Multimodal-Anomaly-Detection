% Initialize landsat anomaly detection
function parameters = initlandsatsentinelradarVec;

% Landsat data parameters
% parameters.data.maxtime = 71;
parameters.data.maxday = 3214;
% parameters.data.fulltestdata = true; 
parameters.data.testdata = 180;


% Radar parameters
parameters.radar.rangeday = 1;


% Evi remove filter
parameters.data.minfilter = -3;
parameters.data.maxfilter =  3;
%parameters.data.maxfilter =  3; 


% Data modality (EVI)
parameters.data.modality = 6;

% For vectorial only
% parameters.data.modality = 7;


% Number of eigenfunctions
parameters.KL.numEigen = 29;

%parameters.KL.saveeigen = false;
%parameters.KL.loadeigen = false;


% Type of data
%parameters.data.type = 0; % Landsat
 parameters.data.type = 1; % Sentinel
%parameters.data.type = 2; % Both

% Patch size
parameters.data.patchsize = 1:150;
parameters.data.patchsizeJ = 50:100;
parameters.data.patchsizeI = 75:125;

% Data file
parameters.data.file = '../data/Combined/recalibratedData_Landsat_Sentinel2.mat';
parameters.data.radarfile = '../data/Combined/Sentinel1Mod.mat';
parameters.data.imagedata = '../data/Combined/recalibratedData_Landsat_Sentinel2.mat';
 

% Ploting parameters
parameters.ML.dimdata = 1;
parameters.ML.plot.tol = 0;
parameters.ML.plot.numlevel = 8;
parameters.ML.plot.maxlevel = 3;
parameters.ML.plot.nodisplay = true;
parameters.graphics.figtitle = true;
parameters.graphics.print = false;


%stats parameters
parameters.stats.significance = 0.01;
